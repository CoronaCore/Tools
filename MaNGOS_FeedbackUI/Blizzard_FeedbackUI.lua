---------------------------------------------------------------------------------------------------
--
-- Copyright Blizzard Entertainment 2002-2006
--
-- Blizzard_FeedbackUI Version 2.0.1
--
-- Provides WoW players with a user interface for submitting bugs, suggestions, and other feedback.
---------------------------------------------------------------------------------------------------

--Constants
C_FEEDBACKUI_MAXALERTS = 10;
C_FEEDBACKUI_UPDATEINTERVAL = .75;
FEEDBACKUI_OFFSETPIXELS = 20;
FEEDBACKUI_DELIMITER = "|";
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
                            
--Global Variables
feedbackFrames = {};     

--Local Variables
local feedbackUpdateInterval = 0;                       
		
function FeedbackUI_OnLoad ()
	--Take over WoW's original slash commands for Bug and Suggest.
	SlashCmdList["BUG"] = FeedbackUI_SlashBug;
	SlashCmdList["SUGGEST"] = FeedbackUI_SlashSuggest;
	
	-- Localize settings!
	FeedbackUI_Localize()
	
	--Set up the tabs using the CharacterFrame template.
	PanelTemplates_SetNumTabs(this, 3);
	FeedbackUI.selectedTab = 1;
	PanelTemplates_UpdateTabs(this);
end

function FeedbackUI_OnEvent ()
    if ( event == "ADDON_LOADED" and arg1 == "Blizzard_FeedbackUI" ) then 
        for _, frame in pairs(feedbackFrames) do
            if frame.panels then
                for _, panel in pairs(frame.panels) do
                    if panel.Localize then
                        pcall(panel.Localize, panel)
                    end
                    if panel.Load then
                        pcall(panel.Load, panel)
                    end
                end
            end
        end
    end
end

function FeedbackUI_OnUpdate (interval)
    feedbackUpdateInterval = feedbackUpdateInterval + interval;
    if ( feedbackUpdateInterval > C_FEEDBACKUI_UPDATEINTERVAL ) then
        for _, frame in pairs(feedbackFrames) do
            if frame.panels then
                for _, panel in pairs(frame.panels) do
                    if panel.OnUpdate then
                        panel.OnUpdate(panel, C_FEEDBACKUI_UPDATEINTERVAL)
                    end
                end
            end
        end
        feedbackUpdateInterval = 0;
    end
end

function math.round (num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num  * mult + 0.5) / mult
end

function FeedbackUI_Show ()
	if FeedbackUI:IsVisible() then
		FeedbackUI:Hide()
	else
		FeedbackUI:Show()
		FeedbackUI:Raise()
		for index, frame in pairs(feedbackFrames) do
			if frame:IsVisible() then
				if frame.panels then
					for num, panel in pairs(frame.panels) do
						pcall(panel.Show, panel);
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
	
	panelFrame.Load = panel.Load
	panelFrame.Show = panel.Show
    panelFrame.OnUpdate = panel.OnUpdate
	
	if panel.Setup then
		panel.Setup(panelFrame)
	end
	
	if panel.event then
		for _, event in pairs(panel.event) do
			panelFrame:RegisterEvent(event)
		end
		panelFrame.Handler = panel.Handler
		panelFrame:SetScript("OnEvent", panelFrame.Handler)
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
	
	if line.Update then
		lineFrame.Update = line.Update
	end
	
	if ( not lineFrame.parent.infoLines ) then
		lineFrame.parent.infoLines = {}
	end
	table.insert(lineFrame.parent.infoLines, lineFrame)
	
	if line.Setup then
		line.Setup(lineFrame);
	end
	
	if ( #lineFrame.parent.infoLines == 1 ) then
		lineFrame:SetPoint("TOPLEFT", lineFrame.parent:GetName(), "TOPLEFT", 3, -8)
	else
		lineFrame:SetPoint("TOPLEFT", lineFrame.parent.infoLines[table.maxn(lineFrame.parent.infoLines)-1]:GetName(), "BOTTOMLEFT", 0, -2)
	end
	lineFrame:SetWidth(lineFrame.parent:GetWidth() - 8)
end

---------------------------------------------------------------------------------------------------
-- Create a unique hash from a string.
---------------------------------------------------------------------------------------------------

--[[
-- based on dbj2 algorithm
function FeedbackUI_HexHash (str)
    local hash = 5381;
    
    for i = 1, #str do
        local c = string.byte(str, i);
        hash = (bit.lshift(hash, 5) + hash) + c;
    end
    
    return format("%08x", hash);
end
]]

-- similar to lua's hashing algorithm
function FeedbackUI_HexHash (str)
    local hash = 5381;
    
    for i = 1, #str do
        local c = string.byte(str, i);
        hash = bit.bxor(hash, bit.lshift(hash, 5) + bit.rshift(hash, 2) + c);
    end
    
    return format("%08x", hash);
end








