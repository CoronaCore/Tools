--FeedbackUI version 2.0

--Global tables
feedbackFrames = {};

--Constants
C_FEEDBACKUI_MAXALERTS = 10
FEEDBACKUI_OFFSETPIXELS = 20
FEEDBACKUI_DELIMITER = "|"
FEEDBACKUI_FIELDS = { "version", 
						"build", 
						"date", 
						"realm", 
						"name",  
						"level",
						"race",
						"sex",
						"class",
						"map", 
						"zone", 
						"area", 
						"position", 
						"facing", 
						"object", 
						"chunk", 
						"coords", 
						"addons", 
						"addonsloaded", 
						"who",
						"where",
						"when",
						"type" }
                        
FEEDBACKUI_SURVEYFIELDS = { "spacer",
                            "surveyname",
                            "surveyid",
                            "surveyobjectives",
                            "surveytype",
                            "surveyobtained",
                            "surveysubmitted",
                            "clarity",
                            "difficulty",
                            "reward",
                            "fun" }

-- Local variables
local lastZone = "" -- Track which zone the player was last in. This allows us to fire events when players leave an instance.						
						
function FeedbackUI_OnLoad()
	--Take over WoW's original slash commands for Bug and Suggest.
	SlashCmdList["BUG"] = FeedbackUI_SlashBug;
	SlashCmdList["SUGGEST"] = FeedbackUI_SlashSuggest;
	
	-- Localize settings!
	FeedbackUI_Localize()
	
	--Set up the tabs using the CharacterFrame template.
	PanelTemplates_SetNumTabs(this, 3);
	FeedbackUI.selectedTab = 1;
	PanelTemplates_UpdateTabs(this);
	
	--Run the OnLoad functions for registered panels in registered frames.

end

function FeedbackUI_OnEvent()
    if ( event == "ADDON_LOADED" and arg1 == "Blizzard_FeedbackUI" ) then 
        if ( not g_FeedbackUI_feedbackVars ) then
            g_FeedbackUI_feedbackVars = {}
            g_FeedbackUI_feedbackVars["alerts"] = true;
        end
        g_FeedbackUI_feedbackVars["lastZone"] = nil;
                
        if ( not g_FeedbackUI_surveysTable ) then
            g_FeedbackUI_surveysTable = {}
        end
        
        if ( not g_FeedbackUI_surveysTable["Quests"] ) then
            g_FeedbackUI_surveysTable["Quests"] = {};
        end
        
        if ( not g_FeedbackUI_surveysTable["Instances"] ) then
            g_FeedbackUI_surveysTable["Instances"] = {};
        end
        
        if ( not g_FeedbackUI_surveysTable["Alerts"] ) then
            g_FeedbackUI_surveysTable["Alerts"] = {};
        end
        
        for _, frame in pairs(feedbackFrames) do
            if frame.panels then
                for _, panel in pairs(frame.panels) do
                    if panel.Localize then
                        pcall(panel.Localize, panel)
                    end
                    if panel.load then
                        pcall(panel.load, panel)
                    end
                end
            end
        end
    end

end

function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num  * mult + 0.5) / mult
end

function FeedbackUI_Show()
	if FeedbackUI:IsVisible() then
		FeedbackUI:Hide()
	else
		FeedbackUI:Show()
		FeedbackUI:Raise()
		for index, frame in pairs(feedbackFrames) do
			if frame:IsVisible() then
				if frame.panels then
					for num, panel in pairs(frame.panels) do
						pcall(panel.show, panel);
					end
				end
			end
		end
	end
end

function msg(arg) 
	if type(arg) == "string" then
		DEFAULT_CHAT_FRAME:AddMessage(arg)
	else
		DEFAULT_CHAT_FRAME:AddMessage(tostring(arg))
	end
end

function FeedbackUI_SlashBug()
	if not ( FeedbackUI.selectedTab == 1 ) then 
		FeedbackUITab1:Click();
		if not ( FeedbackUI:IsVisible() ) then 
			FeedbackUI_Show(); 
		end
	else
		FeedbackUI_Show();
	end
end

--Display the suggestion form  when /suggest is typed.
function FeedbackUI_SlashSuggest()
	if not ( FeedbackUI.selectedTab == 2 ) then 
		FeedbackUITab2:Click();
		if not ( FeedbackUI:IsVisible() ) then 
			FeedbackUI_Show(); 
		end
	else
		FeedbackUI_Show();
	end
end

function FeedbackUI_SetupPanel(panel)
	local panelFrame = CreateFrame("Frame", panel.parent .. panel.name, getglobal(panel.parent), panel.inherits);
	panelFrame.name = panel.name;
	panelFrame.parent = getglobal(panel.parent);
	
	if panel.labelText then
		panelFrame.label = getglobal(panelFrame:GetName() .. "Label");
		panelFrame.label:SetText(panel.labelText);
	end
	
	if panel.anchors then
		for _, anchor in next, panel.anchors do
			panelFrame:SetPoint(anchor.point, anchor.relativeto, anchor.relativepoint, anchor.x, anchor.y)
		end
	end
	
	if panel.size then
		if panel.size.x then
			panelFrame:SetWidth(panel.size.x)
		end
		if panel.size.y then
			panelFrame:SetHeight(panel.size.y)
		end
	end	
	
	panelFrame.load = panel.load
	panelFrame.show = panel.show
	
	if panel.setup then
		panel.setup(panelFrame)
	end
	
	if panel.event then
		for _, event in pairs(panel.event) do
			panelFrame:RegisterEvent(event)
		end
		panelFrame.handler = panel.handler
		panelFrame:SetScript("OnEvent", panelFrame.handler)
	end
	
	if ( not panelFrame.parent.panels ) then
		panelFrame.parent.panels = {}
		tinsert(panelFrame.parent.panels, panelFrame)			
	else
		tinsert(panelFrame.parent.panels, panelFrame)
	end

end

function FeedbackUI_AddInfoLine(line)
	local lineFrame = CreateFrame("Frame", line.parent .. line.name, getglobal(line.parent), line.inherits);
	
	lineFrame.parent = getglobal(line.parent);
	lineFrame.value = getglobal(lineFrame:GetName() .. "Value");
	
	if line.labelText then
		lineFrame.label = getglobal(lineFrame:GetName() .. "Label")
		lineFrame.label:SetText(line.labelText)
	end
	
	if line.update then
		lineFrame.update = line.update
	end
	
	if ( not lineFrame.parent.infoLines ) then
		lineFrame.parent.infoLines = {}
	end
	table.insert(lineFrame.parent.infoLines, lineFrame)
	
	if line.setup then
		line.setup(lineFrame);
	end
	
	if ( #lineFrame.parent.infoLines == 1 ) then
		lineFrame:SetPoint("TOPLEFT", lineFrame.parent:GetName(), "TOPLEFT", 3, -8)
	else
		lineFrame:SetPoint("TOPLEFT", lineFrame.parent.infoLines[table.maxn(lineFrame.parent.infoLines)-1]:GetName(), "BOTTOMLEFT", 0, -2)
	end
	lineFrame:SetWidth(lineFrame.parent:GetWidth() - 8)
end

---------------------------------------------------------------------------------------------------
-- Create a unique hash from a string. Based on MD5
---------------------------------------------------------------------------------------------------

function FeedbackUI_HexHash(message)
    local _, digest = FeedbackUI_Hash(message);
    
    for i = 1, 4 do
        digest[i] = ConvertToHex(tonumber(digest[i]))
    end    
	return table.concat(digest, ""), digest
end

function ConvertToHex(number)
    number = tonumber(number)
    local b, k, out, i, d = 16, "0123456789ABCDEF", "", 0
    while number > 0 do
        i = i + 1
        number, d = math.floor(number/b), math.fmod(number, b)+1
        out = string.sub(k,d,d) .. out
    end
    return out
end

function FeedbackUI_Hash(message)
	r = {}
	k = {}
    local digest = {};

	for i = 0, 3 do
		r[0+(i*4)] = 7;
		r[1+(i*4)] = 12;
		r[2+(i*4)] = 17;
		r[3+(i*4)] = 22;
		r[16+(i*4)] = 5;
		r[17+(i*4)] = 9;
		r[18+(i*4)] = 14;
		r[19+(i*4)] = 20;
		r[32+(i*4)] = 4;
		r[33+(i*4)] = 11;
		r[34+(i*4)] = 16;
		r[35+(i*4)] = 23;
		r[48+(i*4)] = 6;
		r[49+(i*4)] = 10;
		r[50+(i*4)] = 15;
		r[51+(i*4)] = 21;
	end
	
	for i = 0, 63 do
		k[i] = math.floor(math.abs(math.sin(i + 1)) * 2^32);
	end
	
	local h0 = 1732584193;
	local h1 = 4023233417;
	local h2 = 2562383102;
	local h3 = 271733878;
	
	message = ConvertToBits(message)	
    message = string.reverse(message) .. "1"
	
    while math.fmod(#message, 512) ~= 448 do
        message = message .. "0"     
    end
    
    message = message .. Make64Bits(#message);  
    
    for i = 1, strlen(message), 512 do
        local chunk = string.sub(message, i, i+512);
        local w = {};
		
        for i = 0, 15 do
            w[i] = string.sub(chunk, 1+(32*(i)), (32*(i+1)))
        end

        local f, g;               
        local a = h0;
        local b = h1;
        local c = h2;
        local d = h3;
        
        for i = 0, 63 do
            if 0 <= i and i <= 15 then
                f = bit.bxor(d, bit.band(b, bit.bxor(c, d)))
                g = i
            elseif 16 <= i and i <= 31 then
                f = bit.bxor(c, bit.band(d, bit.bxor(b, c)))
                g = math.fmod((5*i + 1), 16)
            elseif 32 <= i and i <= 47 then
                f = bit.bxor(b, bit.bxor(c, d))
                g = math.fmod((3*i + 5), 16)
            elseif 48 <= i and i <= 63 then
                f = bit.bxor(c, bit.bor(b, bit.bnot(d)))
                g = math.fmod((7*i), 16)
            end
            
            local temp = d;
            d = c;
            c = b;
            local x = (a + f + k[i] + MakeInt32(w[g]));
            b = (bit.lshift(x, r[i]) + b)
            a = temp;
        end
        
        h0 = h0 + a
        h1 = h1 + b
        h2 = h2 + c
        h3 = h3 + d
	end
	digest = { h0, h1, h2 ,h3 }
    return table.concat(digest, ""), digest;
end

function ConvertToBits(message)
	local bits = ""
	local output = {}
	for i = 1, strlen(message) do
		local byte = string.byte(string.sub(message,i,i))
		bits = MakeBig8Bits(byte)
        table.insert(output, bits)
	end
	return table.concat(output, "")
end

function MakeInt32 (bitArray)
	-- Makes a 32 ( or smaller) LittleEndian bitArray into a byte
    local newInt = 0;
    
    if ( strlen(bitArray) > 32 ) then 
        -- We don't handle more than 32 bits with this function
        return -1 
    elseif ( strlen(bitArray) < 32 ) then
        -- If we get less than 32 bits, pad the bitArray.
        while strlen(bitArray) < 32 do
            bitArray = "0" .. bitArray
        end
    end
	
	for i = 0, 31 do
		if ( string.sub(bitArray, i+1, i+1) == "1" ) then
			newInt = newInt + 2^i
		end
	end
    
    return newInt
end

function Make64Bits (byte)
	-- Makes a byte 64 bits LittleEndian
	local bitarray = {}
    
    for i = 63, 0, -1 do
        if math.fmod(byte, 2^i) ~= byte then
            byte = math.fmod(byte, 2^i)
            bitarray[i + 1] = 1
        else
            bitarray[i + 1] = 0
        end
    end
    return table.concat(bitarray, "")
end 
   
function Make32Bits (byte)
	-- Makes a byte 32 bits LittleEndian
	local bitarray = {}
    
    for i = 31, 0, -1 do
        if math.fmod(byte, 2^i) ~= byte then
            byte = math.fmod(byte, 2^i)
            bitarray[i + 1] = 1
        else
            bitarray[i + 1] = 0
        end
    end
    return table.concat(bitarray, "")
end

function MakeBig8Bits (byte)
	-- Makes a byte 8Bits BigEndian
	local bitarray = {}
    
    for i = 7, 0, -1 do
        if math.fmod(byte, 2^i) ~= byte then
            byte     = math.fmod(byte, 2^i)
            bitarray[8-i] = 1
        else
            bitarray[8-i] = 0
        end
    end
    return table.concat(bitarray, "")
end
