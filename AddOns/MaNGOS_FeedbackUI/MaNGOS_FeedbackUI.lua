---------------------------------------------------------------------------------------------------
--
-- Copyright Blizzard Entertainment 2002-2007
--
-- Blizzard_FeedbackUI Version 2.3.3
--
-- Provides WoW players with a user interface for submitting bugs, suggestions, and other feedback.
---------------------------------------------------------------------------------------------------

--Constants
C_FEEDBACKUI_MAXALERTS = 10;
C_FEEDBACKUI_UPDATEINTERVAL = .75;
FEEDBACKUI_OFFSETPIXELS = 20;
FEEDBACKUI_DELIMITER = "|";

FEEDBACKUI_FIELDS = {
	[0] = "feedbacktype",
	[1] = "version",
	[2] = "build",
	[3] = "date",
	[4] = "realm",
	[5] = "locale",
	[6] = "name",
	[7] = "level",
	[8] = "race",
	[9] = "sex",
	[10] = "class",
	[11] = "map",
	[12] = "zone",
	[13] = "area",
	[14] = "position",
	[15] = "facing",
	[16] = "speed",
	[17] = "chunk",
	[18] = "coords",
	[19] = "addonsloaded",
	[20] = "addonsdisabled",
	[21] = "talents",
	[22] = "equipment",
	[23] = "who",
	[24] = "where",
	[25] = "when",
	[26] = "type",	
	[27] = "surveyname",
	[38] = "surveyid",
	[29] = "surveyobjective",
	[30] = "surveytype",
	[31] = "surveyobtained",
	[32] = "surveysubmitted",
	[33] = "category1",
	[34] = "category2",
	[35] = "category3",
	[36] = "category4",
	[37] = "combats",
	[38] = "deaths",
	[39] = "averagelength",
	[40] = "videooptions",
	[41] = "text",
	[42] = "soundoptions",
	[43] = "objectname",
};                    
						
FEEDBACKUI_CVARS = {
	["Video"] = {
		-- Display
		[1] = { name = "gxResolution", bits = 32, varType = "Value", splitDelimiter = "x" },
		[2] = { name = "gxRefresh", bits = 8, varType = "Value" },
		[3] = { name = "gxColorBits", bits = 2, varType = "Index", values = {16, 24, 32} },
		[4] = { name = "gxDepthBits", bits = 2, varType = "Index", values = {16, 24, 32} },
		[5] = { name = "gxMultisample", bits = 2, varType = "Index", values = {1, 2, 4, 8} },
		[6] = { name = "gxWindow", bits = 1, varType = "Bit" },
		[7] = { name = "gxMaximize", bits = 1, varType = "Bit" },
		[8] = { name = "useUiScale", bits = 1, varType = "Bit" },
		[9] = { name = "uiScale", bits = 6, varType = "Index", rate = 0.01, minVal = 0.64, maxVal = 1.00 },
		[10] = { name = "Dummy", bits = 1, varType = "Bit" },
		
		-- World Appearance
		[11] = { name = "farclip", bits = 4, varType = "Index", rate = 60, minVal = 177, maxVal = 777 },
		[12] = { name = "SmallCull", bits = 2, varType = "Index", values = {0.07, 0.04, 0.01} },
		[13] = { name = "shadowLevel", bits = 1, varType = "Bit" },
		[14] = { name = "baseMip", bits = 1, varType = "Bit" },
		[15] = { name = "anisotropic", bits = 4, varType = "Index", values = {1, 2, 4, 8, 16} },
		[16] = { name = "spellEffectLevel", bits = 2, varType = "Bit" },
		[17] = { name = "weatherDensity", bits = 2, varType = "Bit" },
		[18] = { name = "shadowlod", bits = 1, varType = "Bit" },
		[19] = { name = "lod", bits = 1, varType = "Bit" },

		-- Brightness
		[20] = { name = "DesktopGamma", bits = 1, varType = "Bit" },
		[21] = { name = "gamma", bits = 4, varType = "Index", rate = 0.1, minVal = 0.5, maxVal = 1.5 },
		[22] = { name = "Dummy", bits = 1, varType = "Bit" },

		-- Shaders
		[23] = { name = "pixelShaders", bits = 1, varType = "Bit" },
		[24] = { name = "specular", bits = 1, varType = "Bit" },
		[25] = { name = "ffxGlow", bits = 1, varType = "Bit" },
		[26] = { name = "ffxDeath", bits = 1, varType = "Bit" },
		[27] = { name = "M2UseShaders", bits = 1, varType = "Bit" },
		[28] = { name = "M2UsePixelShaders", bits = 1, varType = "Bit" },
		[29] = { name = "useWeatherShaders", bits = 1, varType = "Bit" },
		[30] = { name = "Dummy", bits = 1, varType = "Bit" },

		-- Misc.
		[31] = { name = "trilinear", bits = 1, varType = "Bit" },
		[32] = { name = "gxVSync", bits = 1, varType = "Bit" },
		[33] = { name = "gxTripleBuffer", bits = 1, varType = "Bit" },
		[34] = { name = "movieSubtitle", bits = 1, varType = "Bit" },
		[35] = { name = "gxCursor", bits = 1, varType = "Bit" },
		[36] = { name = "gxFixLag", bits = 1, varType = "Bit" },
		
	},
	["Sound"] = {
		-- Sound Playback
		[1] = { name = "Sound_EnableAllSound", bits = 1, varType = "Bit" },
		[2] = { name = "Sound_EnableSFX", bits = 1, varType = "Bit" },
		[3] = { name = "Sound_EnableErrorSpeech", bits = 1, varType = "Bit" },
		[4] = { name = "Sound_EnableEmoteSounds", bits = 1, varType = "Bit" },
		[5] = { name = "Sound_EnableMusic", bits = 1, varType = "Bit" },
		[6] = { name = "Sound_ZoneMusicNoDelay", bits = 1, varType = "Bit" },
		[7] = { name = "Sound_EnableAmbience", bits = 1, varType = "Bit" },
		[8] = { name = "Sound_ListenerAtCharacter", bits = 1, varType = "Bit" },
		
		[9] = { name = "Sound_EnableSoundWhenGameIsInBG", bits = 1, varType = "Bit" },
		[10] = { name = "Sound_NumChannels", bits = 3, varType = "Index", values = {16, 32, 64, 128} },
		[11] = { name = "Sound_EnableReverb", bits = 1, varType = "Bit" },
		[12] = { name = "Dummy", bits = 3, varType = "Bit" },

		[13] = { name = "Sound_MasterVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		[14] = { name = "Sound_SFXVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		
		[15] = { name = "Sound_MusicVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		[16] = { name = "Sound_AmbienceVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },

		-- Voice
		[17] = { name = "EnableVoiceChat", bits = 1, varType = "Bit" },
		[18] = { name = "EnableMicrophone", bits = 1, varType = "Bit" },
		[19] = { name = "VoiceChatMode", bits = 1, varType = "Bit" },
		[20] = { name = "PUSHTOTALK_SOUND", var = true, bits = 1, varType = "Bit" },
		[21] = { name = "Dummy", bits = 4, varType = "Bit" },
		
		[22] = { name = "VoiceActivationSensitivity", bits = 6, varType = "Index", rate = 0.02, minVal = 0, maxVal = 1 },
		[23] = { name = "Dummy", bits = 2, varType = "Bit" },
		
		[24] = { name = "InboundChatVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		[25] = { name = "Dummy", bits = 4, varType = "Bit" },

		[26] = { name = "OutboundChatVolume", bits = 4, varType = "Index", rate = 0.5, minVal = 0.25, maxVal = 2.5 },
		[27] = { name = "ChatSoundVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		
		[28] = { name = "ChatMusicVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		[29] = { name = "ChatAmbienceVolume", bits = 4, varType = "Index", rate = 0.1, minVal = 0, maxVal = 1 },
		
		[30] = { name = "PushToTalkButton", varType = "String" },
		[31] = { name = "Sound_OutputDriverName", varType = "String" },
		[32] = { name = "Sound_VoiceChatInputDriverName", varType = "String" },
		[33] = { name = "Sound_VoiceChatOutputDriverName", varType = "String" },
	},
}
						
FEEDBACKUI_SURVEYFIELDS = {  }

FEEDBACKUI_PVPFIELDS = {  }
                            
--Global Variables
feedbackFrames = {};     
g_FeedbackUI_feedbackVars = {};
g_FeedbackUI_feedbackVars.PVPStats = {};
g_FeedbackUI_feedbackVars.PVPStats["combats"] = 0;
g_FeedbackUI_feedbackVars.PVPStats["deaths"] = 0;
g_FeedbackUI_feedbackVars.PVPStats["averagelength"] = 0;

g_FeedbackUI_mouseBinding = {};
g_FeedbackUI_dropdownMenus = {};

--Local Variables
local feedbackUpdateInterval = 0;
local waitTable = {};

--Tables for hijacking Item tooltips
local tooltips = {
	ItemRefTooltip,
	GameTooltip, 
    ShoppingTooltip1,
	ShoppingTooltip2 }
    
local methods = {
	"SetHyperlink",
	"SetBagItem",
	"SetInventoryItem",
	"SetLootItem",
	"SetLootRollItem",
	"SetQuestItem",
	"SetQuestLogItem",
	"SetMerchantItem",
    "SetAuctionSellItem",
    "SetCraftItem",
    "SetMerchantCostItem",
    "SetAuctionItem",
    "SetInboxItem",
    "SetSendMailItem",
    "SetTradeTargetItem",
    "SetTradePlayerItem",
    "SetTradeSkillItem",
	"SetTrainerService",
}

		
function FeedbackUI_OnLoad ()
	--Take over WoW's original slash commands for Bug and Suggest.
    if ( not ( SLASH_BUG1 ) or not ( SLASH_SUGGEST1 ) ) then
        SLASH_BUG1 = "/bug"
        SLASH_SUGGEST1 = "/suggest"
    end
    SLASH_SURVEY1 = "/survey"
    
	SlashCmdList["BUG"] = FeedbackUI_SlashBug;
	SlashCmdList["SUGGEST"] = FeedbackUI_SlashSuggest;
	SlashCmdList["SURVEY"] = FeedbackUI_SlashSurvey;
    
	-- Localize settings!
	FeedbackUI_Localize()
    FeedbackUI:RegisterEvent("VARIABLES_LOADED");
    
	
	--Set up the tabs using the CharacterFrame template.
	PanelTemplates_SetNumTabs(this, 4);
	FeedbackUI.selectedTab = 4;
	PanelTemplates_UpdateTabs(this);
	
	--Setup Frames for mouse clicks
	FeedbackUI_RegisterFramesForClicks();
end

function FeedbackUI_MouseOptions_OnClick ()
	g_FeedbackUI_mouseBinding.modifierValue = g_FeedbackUI_dropdownMenus.modifierKey:GetSelectedValue();
	g_FeedbackUI_mouseBinding.buttonValue = g_FeedbackUI_dropdownMenus.mouseButton:GetSelectedValue();
	
	SetModifiedClick("GENERATEFEEDBACK", g_FeedbackUI_mouseBinding.modifierValue .. "-" .. g_FeedbackUI_mouseBinding.buttonValue);
	SaveBindings(GetCurrentBindingSet()); 
end

function FeedbackUI_BuildTooltipLine(tooltip)
	_, _, modifier, button = string.find(GetModifiedClick("GENERATEFEEDBACK"), "(.+)%-(.+)");
	for i, value in next, FEEDBACKUI_MODIFIERKEYS do
		if (value.value == modifier) then
			modifier = value.text;
		end
    end
	for i, value in next, FEEDBACKUI_MOUSEBUTTONS do
		if (value.value == button) then
			button = value.text;
		end
    end
	
	return string.format(tooltip, modifier, button);
end

function FeedbackUI_OnEvent ()
    if ( event == "ADDON_LOADED" and type(arg1) == "string" and string.match(arg1, "FeedbackUI") ) then 
        for _, frame in pairs(feedbackFrames) do
            if frame.panels then
                for _, panel in pairs(frame.panels) do
                    if panel.Localize then
                        panel.Localize(panel);
                    end
                    if panel.Load then
                        panel.Load(panel);
                    end
                end
            end
        end
        
        for _, tooltip in pairs(tooltips) do
    		for _, method in ipairs(methods) do
    			pcall(hooksecurefunc, tooltip, method, FeedbackUI_ItemTooltip);
    		end
    	end
                
        --I don't mind saying I hate doing this immensely.
        FeedbackUI:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
        FeedbackUI_FixContainerPortrait();
        
        --Hook all click events, everywhere~!
        WorldFrame:SetScript("OnMouseUp", FeedbackUI_WorldFrame_OnClick);
        
        --Yay for PVP
        FeedbackUI:RegisterEvent("PLAYER_LEAVE_COMBAT");
        FeedbackUI:RegisterEvent("PLAYER_REGEN_ENABLED");
        FeedbackUI:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
        FeedbackUI:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
        FeedbackUI:RegisterEvent("PLAYER_DEAD");
        FeedbackUI:RegisterEvent("UNIT_COMBAT");
    elseif ( event == "ADDON_LOADED" and arg1 == "Blizzard_AuctionUI" ) then
        FeedbackUI_AuctionFrameSetup();
    elseif ( event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" ) then
        FeedbackUI_InspectFrameSetup();
    elseif ( event == "ADDON_LOADED" and arg1 == "Blizzard_TradeSkillUI" ) then		
        FeedbackUI_TradeSkillFrameSetup();
	elseif ( event == "ADDON_LOADED" and arg1 == "Blizzard_TrainerUI" ) then
		ClassTrainerSkillIcon:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    elseif ( event == "VARIABLES_LOADED" ) then
        if ( not g_FeedbackUI_feedbackVars.PVPStats ) then
            g_FeedbackUI_feedbackVars.PVPStats = {}
            g_FeedbackUI_feedbackVars.PVPStats["combats"] = 0;
            g_FeedbackUI_feedbackVars.PVPStats["deaths"] = 0;
            g_FeedbackUI_feedbackVars.PVPStats["averagelength"] = 0;
        end
        
        if g_FeedbackUI_feedbackVars["verbose"] == nil then
            g_FeedbackUI_feedbackVars["verbose"] = true;
        end
        
        g_FeedbackUI_feedbackVars.PVP = false;
        FeedbackUI_SetupTargets();
        tinsert(waitTable, { func=function() FeedbackUI_SendPVPData() end, exTime = GetTime() + 2 });
		
		-- Init drop downs
		if ( not g_FeedbackUI_dropdownMenus.mouseButton ) then
			g_FeedbackUI_dropdownMenus.mouseButton = BQAE_DropDown:Init("FeedbackUI_MouseButtonDropDown", FeedbackUIWelcomeFrameClickOptions, "+");
			g_FeedbackUI_dropdownMenus.mouseButton:SetPoint("TOPRIGHT", FeedbackUIWelcomeFrameClickOptions, "TOPRIGHT", -12, -2);
			for i, value in next, FEEDBACKUI_MOUSEBUTTONS do
				g_FeedbackUI_dropdownMenus.mouseButton:AddButton(value.text, value.value, FeedbackUI_MouseOptions_OnClick);
			end
			g_FeedbackUI_dropdownMenus.mouseButton:SetWidth(105);
			
			if ( g_FeedbackUI_mouseBinding.buttonValue ) then
				g_FeedbackUI_dropdownMenus.mouseButton:SetSelectedValue(g_FeedbackUI_mouseBinding.buttonValue);
			else
				g_FeedbackUI_dropdownMenus.mouseButton:SetSelectedIndex(1);
			end
		end
		
		if ( not g_FeedbackUI_dropdownMenus.modifierKey ) then
			g_FeedbackUI_dropdownMenus.modifierKey = BQAE_DropDown:Init("FeedbackUI_ModifierKeyDropDown", FeedbackUIWelcomeFrameClickOptions, FEEDBACKUI_MODIFIERKEY);
			g_FeedbackUI_dropdownMenus.modifierKey:SetPoint("RIGHT", g_FeedbackUI_dropdownMenus.mouseButton:GetFrame(), "LEFT", -24, 0);
			for i, value in next, FEEDBACKUI_MODIFIERKEYS do
				g_FeedbackUI_dropdownMenus.modifierKey:AddButton(value.text, value.value, FeedbackUI_MouseOptions_OnClick);
			end
			g_FeedbackUI_dropdownMenus.modifierKey:SetWidth(105);
			
			if ( g_FeedbackUI_mouseBinding.modifierValue ) then
				g_FeedbackUI_dropdownMenus.modifierKey:SetSelectedValue(g_FeedbackUI_mouseBinding.modifierValue);
			else
				g_FeedbackUI_dropdownMenus.modifierKey:SetSelectedIndex(1);
			end
		end
		
    elseif ( event == "UPDATE_MOUSEOVER_UNIT" ) then
        if ( UnitIsPlayer("mouseover") ) then
            FeedbackUI.currentMouseover = nil;
        else
            FeedbackUI.currentMouseover = UnitName("mouseover");
            FeedbackUI_SpawnTooltip();
        end
    elseif (
               ( (   event == "UNIT_COMBAT" 
                    and arg1 == "target" 
                    and arg2 == "WOUND" 
                    and UnitIsPlayer("target") 
                    and not ( UnitFactionGroup("player") == UnitFactionGroup("target") )
                ) 
            or
                (   (   event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS" 
                        or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" 
                    ) 
                    and string.find(string.lower(arg1), string.lower(YOU) ) 
                ) )
            and UnitAffectingCombat("player") 
            and not g_FeedbackUI_feedbackVars.PVP
            ) then
        g_FeedbackUI_feedbackVars.PVP = true;
        g_FeedbackUI_feedbackVars.PVPStats["combats"] = g_FeedbackUI_feedbackVars.PVPStats["combats"] + 1;
        g_FeedbackUI_feedbackVars.PVPStart = GetTime();
    elseif ( ( event == "PLAYER_LEAVE_COMBAT" or event == "PLAYER_REGEN_ENABLED" ) and g_FeedbackUI_feedbackVars.PVP ) then
        local combats = g_FeedbackUI_feedbackVars.PVPStats["combats"] - 1;
        local average = g_FeedbackUI_feedbackVars.PVPStats["averagelength"] * combats;
        average = tonumber(average + math.ceil(GetTime() - ( g_FeedbackUI_feedbackVars.PVPStart or GetTime() ))) or 0;
        g_FeedbackUI_feedbackVars.PVPStats["averagelength"] = math.floor(average / ( combats + 1 ));
        
        tinsert(waitTable, { func = function () g_FeedbackUI_feedbackVars.PVP = false end, exTime = GetTime() + 2 } );
    elseif ( event == "PLAYER_DEAD" and g_FeedbackUI_feedbackVars.PVP ) then       
        g_FeedbackUI_feedbackVars.PVP = false;
        g_FeedbackUI_feedbackVars.PVPStats["deaths"] = g_FeedbackUI_feedbackVars.PVPStats["deaths"] + 1
    end
end

function FeedbackUI_RegisterFramesForClicks ()
	for i = 1, 10 do getglobal("QuestLogItem" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	for i = 1, 10 do getglobal("QuestDetailItem" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	for i = 1, 10 do getglobal("QuestRewardItem" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	CharacterAmmoSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	for i = 1, 7 do getglobal("TradePlayerItem" .. i .. "ItemButton"):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	for i = 1, 7 do getglobal("TradeRecipientItem" .. i .. "ItemButton"):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	for i = 1, 7 do getglobal("BankFrameBag" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	for i = 1, 13 do getglobal("ContainerFrame" .. i .. "PortraitButton"):RegisterForClicks("LeftButtonUp", "RightButtonUp"); end
	
	MinimapZoneTextButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	AzerothButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	OutlandButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function FeedbackUI_InspectFrameSetup ()
	InspectHeadSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectNeckSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectShoulderSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectBackSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectChestSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectShirtSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectTabardSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectWristSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectHandsSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectWaistSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectLegsSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectFeetSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectFinger0Slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectFinger1Slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectTrinket0Slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectTrinket1Slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectMainHandSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectSecondaryHandSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	InspectRangedSlot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function FeedbackUI_AuctionFrameSetup ()
	for i = 1, 8 do
		getglobal("BrowseButton" .. i .. "Item"):RegisterForClicks("LeftButtonUp", "RightButtonUp");
		getglobal("BidButton" .. i .. "Item"):RegisterForClicks("LeftButtonUp", "RightButtonUp");
		getglobal("AuctionsButton" .. i .. "Item"):RegisterForClicks("LeftButtonUp", "RightButtonUp");
	end
end

function FeedbackUI_TradeSkillFrameSetup ()
	for i = 1, 8 do 
		getglobal("TradeSkillSkill" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp");
		getglobal("TradeSkillReagent" .. i):RegisterForClicks("LeftButtonUp", "RightButtonUp");
	end
	
	TradeSkillSkillIcon:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function FeedbackUI_SendPVPData ()
    if g_FeedbackUI_feedbackVars.PVPStats["combats"] == 0 then return; end
    
    FeedbackUIBugFrameInfoPanel.OnShow(FeedbackUIBugFrameInfoPanel);
    local infoString = "";
    
    FeedbackUIBugFrameInfoPanel.infoTable["feedbacktype"] = 3;
    for index, field in next, FEEDBACKUI_FIELDS do
        if g_FeedbackUI_feedbackVars.PVPStats[field] then
            FeedbackUIBugFrameInfoPanel.infoTable[field] = g_FeedbackUI_feedbackVars.PVPStats[field];
			infoString = infoString .. "<" .. index .. ">" .. string.gsub(FeedbackUIBugFrameInfoPanel.infoTable[field], "\n", " ") .. "</" .. index ..">";
            --infoString = infoString .. string.gsub(FeedbackUIBugFrameInfoPanel.infoTable[field], "\n", " ") .. FEEDBACKUI_DELIMITER;
        elseif not ( FeedbackUIBugFrameInfoPanel.infoTable[field] ) then
            FeedbackUIBugFrameInfoPanel.infoTable[field] = "";
            --infoString = infoString .. FEEDBACKUI_DELIMITER;
        else
			infoString = infoString .. "<" .. index .. ">" .. string.gsub(FeedbackUIBugFrameInfoPanel.infoTable[field], "\n", " "):gsub(FEEDBACKUI_DELIMITER, " ") .. "</" .. index .. ">";
           -- infoString = infoString .. string.gsub(FeedbackUIBugFrameInfoPanel.infoTable[field], "\n", " "):gsub(FEEDBACKUI_DELIMITER, " ") .. FEEDBACKUI_DELIMITER;
        end
    end
    
    ReportSuggestion(infoString);
    UIErrorsFrame:Clear();
    
    g_FeedbackUI_feedbackVars.PVPStats = {}
    g_FeedbackUI_feedbackVars.PVPStats["combats"] = 0;
    g_FeedbackUI_feedbackVars.PVPStats["deaths"] = 0;
    g_FeedbackUI_feedbackVars.PVPStats["averagelength"] = 0;
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
    elseif ( #waitTable > 0 ) then
        for index, entry in next, waitTable do
            if ( entry.exTime < GetTime() ) then
                entry.func();
                waitTable[index] = nil;
            end
        end
    end
end

function math.round (num, idp)
  return math.floor(num  * 10^(idp or 0) + 0.5) / 10^(idp or 0)
end

function ConvertToHex(decimal)
	if (not decimal) then return; end
	
	local out = "";
	local hex = "0123456789ABCDEF";
	local index = 0;
	local d;
	
    while decimal > 0 do
        index = index + 1;
        decimal, d = floor(decimal / 16), mod(decimal, 16) + 1;
        out = string.sub(hex, d, d) .. out;
    end
	
	
	for i = 1, strlen(out) do
		if (mod(strlen(out), 2) ~= 0) then
			out = "0" .. out;
		end
	end
	
	if (strlen(out) == 0) then
		out = "00";
	end
    return out;
end

function FeedbackUI_BuildSettingsString(category)
	if (not category) then return; end
	if (not FEEDBACKUI_CVARS[category]) then return; end
	
	local dataString = "";
	local bitOffset = 8;
	local byte = 0;
	local hexLength;
	local value = nil;
	local varFunc, varError;
			
	for _, variable in ipairs(FEEDBACKUI_CVARS[category]) do
		
		if ( pcall(GetCVar, variable.name) ) then
			value = GetCVar(variable.name);
		else
			if ( variable.varType == "String" ) then
				value = "";
			else
				value = 0;
			end
		end
			
			
		if ( variable.var ) then
			varFunc = assert(loadstring("return " .. variable.name));
			value, varError = varFunc();
			if ( not varError ) then
				if ( not value ) then
					value = 0;
				end
				bitOffset = bitOffset - variable.bits;
				byte = byte + bit.lshift(value, bitOffset);
			end
		elseif ( variable.varType == "String" ) then
			dataString = dataString .. "," .. gsub(value, ",", " ");
		elseif ( variable.varType == "Value" ) then 
			if ( variable.splitDelimiter ) then
				local _, _, a, b = string.find(value, "(.*)" .. variable.splitDelimiter .. "(.*)");
				-- if ( a and b ) then
					hexLength = variable.bits / 8;
					dataString = dataString .. string.format("%0" .. hexLength .. "X", (a or 0)) .. string.format("%0" .. hexLength .. "X", (b or 0));
				-- end
			else
				hexLength = variable.bits / 4;
				dataString = dataString .. string.format("%0" .. hexLength .. "X", value);
			end
		elseif ( variable.varType == "Index" ) then
			bitOffset = bitOffset - variable.bits;
					
			if ( not variable.values ) then
				local cVar = string.format("%.2f", value);
				if ( tonumber(cVar) > variable.maxVal ) then cVar = variable.maxVal; end
				local index = (cVar - variable.minVal) / variable.rate;
				byte = byte + bit.lshift(index, bitOffset);
			else
				local index = nil;
				for i, val in ipairs(variable.values) do
					if ( tonumber(value) == val ) then
						byte = byte + bit.lshift(i - 1, bitOffset);
					end
				end
			end
		elseif ( variable.varType == "Bit" ) then
			bitOffset = bitOffset - variable.bits;
					
			if ( variable.name == "Dummy" ) then
				byte = byte + bit.lshift(0, bitOffset);
			else
				byte = byte + bit.lshift(value, bitOffset);
			end
		end
				
		if (bitOffset <= 0) then
			dataString = dataString .. string.format("%02X", byte);

			bitOffset = 8;
			byte = 0;
		end
	end
	
	return dataString;
end

function FeedbackUI_Hide ()
    for index, frame in pairs(feedbackFrames) do
        if frame.panels then
            for num, panel in pairs(frame.panels) do
                if ( panel.OnHide ) then
                    panel.OnHide(panel);
                end
            end
        end
    end
    collectgarbage("collect");
end

function FeedbackUI_Show ()
	if FeedbackUI:IsVisible() then
        FeedbackUI:Hide()
	else
		FeedbackUI:Show()
		FeedbackUI:Raise()
	end
end

function FeedbackUI_RefreshPanels ()
    -- for index, frame in pairs(feedbackFrames) do
        -- if frame.panels then
            -- for num,panel in pairs(frame.panels) do
                -- if ( panel.OnShow ) then
                    -- panel.OnShow(panel);
                -- end
            -- end
        -- end
    -- end
end

function msg (arg) 
	if type(arg) == "string" then
		DEFAULT_CHAT_FRAME:AddMessage(arg)
	else
		DEFAULT_CHAT_FRAME:AddMessage(tostring(arg))
	end
end

--Display the bug form when /bug is typed.
function FeedbackUI_SlashBug (buttonPress)    
    for index, frame in pairs(feedbackFrames) do
        if frame.panels then
            for num, panel in pairs(frame.panels) do
                if ( panel.OnHide ) then
                    panel.OnHide(panel);
                end
            end
        end
    end
    
    for _, panel in pairs(FeedbackUIBugFrame.panels) do
        if ( panel.OnShow ) then
            panel.OnShow(panel);
        end
    end
    
    
    FeedbackUI_SetupEntryForms(FeedbackUIBugFrame, buttonPress);

    if ( not buttonPress ) then
        FEEDBACKUI_TYPETABLE = FEEDBACKUI_GENERICTYPETABLE; 
        FeedbackUIBugFrame.stepThroughPanel.table = FEEDBACKUI_WHERETABLE;
        FeedbackUIBugFrame.stepThroughPanel.startlink = FEEDBACKUI_WHERETABLE;
        FeedbackUIBugFrame.stepThroughPanel.Render(FeedbackUIBugFrame.stepThroughPanel);
    end
    
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
function FeedbackUI_SlashSuggest (buttonPress)    
    for index, frame in pairs(feedbackFrames) do
        if frame.panels then
            for num, panel in pairs(frame.panels) do
                if ( panel.OnHide ) then
                    panel.OnHide(panel);
                end
            end
        end
    end
    
    for _, panel in pairs(FeedbackUISuggestFrame.panels) do
        if ( panel.OnShow ) then
            panel.OnShow(panel);
        end
    end
    
    FeedbackUI_SetupEntryForms(FeedbackUISuggestFrame, buttonPress);
    
    if ( not buttonPress ) then
        FEEDBACKUI_TYPETABLE = FEEDBACKUI_GENERICTYPETABLE; 
        FeedbackUISuggestFrame.stepThroughPanel.table = FEEDBACKUI_WHERETABLE;
        FeedbackUISuggestFrame.stepThroughPanel.startlink = FEEDBACKUI_WHERETABLE;
        FeedbackUISuggestFrame.stepThroughPanel.Render(FeedbackUISuggestFrame.stepThroughPanel);
    end
    
	if not ( FeedbackUI.selectedTab == 2 ) then 
		FeedbackUITab2:Click();
		if not ( FeedbackUI:IsVisible() ) then 
			FeedbackUI_Show(); 
		end
	else
		FeedbackUI_Show();
	end
end

--Display the survey form  when /survey is typed.
function FeedbackUI_SlashSurvey (buttonPress)
    local panel = FeedbackUISurveyFrameSurveysPanel;
    
    for index, frame in pairs(feedbackFrames) do
        if frame.panels then
            for num, panel in pairs(frame.panels) do
                if ( panel.OnHide ) then
                    panel.OnHide(panel);
                end
            end
        end
    end
    
    for _, panel in pairs(FeedbackUISurveyFrame.panels) do
        if ( panel.OnShow ) then
            panel.OnShow(panel);
        end
    end
    
	if ( ( buttonPress == true ) and FeedbackUI.focus ) then
        
        local survey, index, found = panel.AddSurvey(panel, FeedbackUI.focus);
        
        if type(survey) == "table" then
            if ( survey.status and ( survey.status == "Hidden" ) ) then
                g_FeedbackUI_surveysTable[survey.type][index].status = "Available";
            elseif ( survey.status ) then
				FeedbackUISurveyFrameSurveysPanel.ddlStatus:SetSelectedValue(survey.status);
            end
        end
        
        panel.Expand(panel, FeedbackUI.focus.type)
		FeedbackUISurveyFrameSurveysPanel.ddlCategory:SetSelectedValue("All");
        
        panel.table = {};
        panel.PopulateTable(panel)
        panel.ScrollToSurvey(panel, FeedbackUI.focus);
        return;
    end
	
	FeedbackUISurveyFrameSurveysPanel.ddlStatus:SetSelectedValue("Available");
	FeedbackUISurveyFrameSurveysPanel.ddlCategory:SetSelectedValue("All");

    for _, entry in pairs(panel.categories) do
        panel.Expand(panel, entry);
    end
    panel.table = {};
    panel.PopulateTable(panel)
    
    if not ( FeedbackUI.selectedTab == 3 ) then 
		FeedbackUITab3:Click();
		if not ( FeedbackUI:IsVisible() ) then 
			FeedbackUI_Show(); 
		end
	else
		FeedbackUI_Show();
	end
end

--Creates all the panels that go inside the frames.
function FeedbackUI_SetupPanel (panel)
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
	
	panelFrame.Load = panel.Load;
	panelFrame.OnShow = panel.OnShow;
    panelFrame.OnHide = panel.OnHide;
    panelFrame.OnUpdate = panel.OnUpdate;
	
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

--Creates InfoLines that go inside some of the panels.
function FeedbackUI_AddInfoLine (line)
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
    
    local c;
    for i = 1, #str do
        c = string.byte(str, i);
        hash = bit.bxor(hash, bit.lshift(hash, 5) + bit.rshift(hash, 2) + c);
    end
    
    return format("%08x", hash);
end

--Make sure the right-click config menu accurately represents current settings
function FeedbackUI_OptionsInit()
    for _, button in ipairs(FEEDBACKUI_OPTIONSBUTTONS) do
        if ( button.text == FEEDBACKUILBLSURVEYALERTSCHECK_TEXT ) then
            button.checked = g_FeedbackUI_feedbackVars["alerts"];
        else
            button.checked = g_FeedbackUI_feedbackVars["verbose"];
        end
        button.func = FeedbackUI_OptionsClick;
        UIDropDownMenu_AddButton(button);
    end
end

--Handle clicking on an option in the configuration menu
function FeedbackUI_OptionsClick(...)
    if ( this.value == FEEDBACKUILBLSURVEYALERTSCHECK_TEXT ) then
        g_FeedbackUI_feedbackVars["alerts"] = not g_FeedbackUI_feedbackVars["alerts"];
        FeedbackUISurveyFrameSurveysPanel.UpdateAlertButtons(FeedbackUISurveyFrameSurveysPanel);
    elseif ( this.value == FEEDBACKUISHOWCUES_TEXT ) then
        g_FeedbackUI_feedbackVars["verbose"] = not g_FeedbackUI_feedbackVars["verbose"];
    end
end

--Make a nice long string that represents items in the player's inventory.
function FeedbackUI_GetInventoryInfo ()
    local inventoryTable = {};
    
    local partLink;
    for i = 1, 23 do 
        if ( not GetInventoryItemLink("player", i) ) then
            inventoryTable[i] = "0:0:0:0:0";
        else
            partLink = string.match(GetInventoryItemLink("player", i), ":([%d]+:[%d]+:[%d]+:[%d]+:[%d]+):");
            inventoryTable[i] = partLink;
        end
    end
    
    return table.concat(inventoryTable, "/");
end

---------------------------------------------------------------------------------------------------
-- Functions for managing the display of the Welcome portal.
---------------------------------------------------------------------------------------------------

--Setup the welcome portal to display the object or a generic welcome message.
function FeedbackUI_SetupWelcome (objectName, allowSurvey)
    if ( allowSurvey == nil ) then
        allowSurvey = true;
    end
    FeedbackUIWelcomeFrameBannerTargetName:SetFontObject("GameFontNormalLarge");
    if ( not objectName ) then
        FeedbackUI.focus = nil;
        g_FeedbackUI_feedbackVars["focusid"] = nil;
        FeedbackUIWelcomeFrameBannerText:SetText(FEEDBACKUI_GENERALWELCOME)
        FeedbackUIWelcomeFrameBugsDescription:SetText(FEEDBACKUI_WELCOMEBUGTEXT)
        FeedbackUIWelcomeFrameSuggestionsDescription:SetText(FEEDBACKUI_WELCOMESUGGESTTEXT)
        FeedbackUIWelcomeFrameBannerTargetName:SetText("");
        FeedbackUI_EnableSurvey();
    elseif ( objectName and not allowSurvey ) then
        FeedbackUIWelcomeFrameBannerText:SetText(FEEDBACKUI_SPECIFICWELCOME);
        FeedbackUIWelcomeFrameBannerTargetName:SetText(objectName);
        
        FeedbackUI_DisableSurvey(objectName);
    else
        FeedbackUIWelcomeFrameBannerText:SetText(FEEDBACKUI_SPECIFICWELCOME);
        FeedbackUIWelcomeFrameBannerTargetName:SetText(objectName);
        FeedbackUI_EnableSurvey();
    end
    if ( FeedbackUIWelcomeFrameBannerTargetName:GetWidth() > FeedbackUI:GetWidth() - 75 ) then
        FeedbackUIWelcomeFrameBannerTargetName:SetFontObject("GameFontNormal");
    end
end

--Enable the survey options in the welcome portal
function FeedbackUI_EnableSurvey ()
    local font, vertex = NORMAL_FONT_COLOR, FEEDBACKUI_SURVEYCOLOR;
    local r, g, b, a = font.r, font.g, font.b, font.a;
    local vr, vg, vb, va = vertex.r, vertex.g, vertex.b, vertex.a;
    FeedbackUIWelcomeFrameSurveysDescription:SetText(string.format(FEEDBACKUI_WELCOMESURVEYTEXT));
    FeedbackUIWelcomeFrameSurveysBtn:Enable();
	FeedbackUIWelcomeFrameSurveysBtnLeft:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
	FeedbackUIWelcomeFrameSurveysBtnMiddle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
	FeedbackUIWelcomeFrameSurveysBtnRight:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");    
    FeedbackUIWelcomeFrameSurveysTint:SetVertexColor(vr, vg, vb, va);
    FeedbackUIWelcomeFrameSurveysLabel:SetTextColor(r, g, b, a);
    FeedbackUIWelcomeFrameSurveysIcon:SetTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Survey");
end

--Disable the survey options in the welcome portal. We do this for junk items.
function FeedbackUI_DisableSurvey (objectName)
    local font, vertex = GRAY_FONT_COLOR, FEEDBACKUI_DISABLEDCOLOR;
    local r, g, b, a = font.r, font.g, font.b, font.a;
    local vr, vg, vb, va = vertex.r, vertex.g, vertex.b, vertex.a;
    FeedbackUIWelcomeFrameSurveysDescription:SetText(FEEDBACKUI_WELCOMESURVEYDISABLED);
    FeedbackUIWelcomeFrameSurveysBtn:Disable();
    FeedbackUIWelcomeFrameSurveysBtnLeft:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
    FeedbackUIWelcomeFrameSurveysBtnMiddle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
    FeedbackUIWelcomeFrameSurveysBtnRight:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");    
    FeedbackUIWelcomeFrameSurveysTint:SetVertexColor(vr, vg, vb, va);
    FeedbackUIWelcomeFrameSurveysLabel:SetTextColor(r, g, b, a);
    FeedbackUIWelcomeFrameSurveysIcon:SetTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Survey-Disabled");
end

--Configure the actual panels so that they display the appropriate starting options.
function FeedbackUI_SetupEntryForms (frame, buttonPress)
    if ( not frame ) then
        return;
    end
    
    if ( frame.statusPanel.infoLines[5] ) then
        frame.statusPanel.infoLines[3] = frame.statusPanel.infoLines[5];
        frame.statusPanel.infoLines[5] = nil;
    end
    
    if ( buttonPress and FeedbackUI.focus ) then
        g_FeedbackUI_feedbackVars["focusid"] = FeedbackUI.focus.id
        if ( FeedbackUI.focus.type == "Items" ) then
            frame.statusPanel.status["where"] = FEEDBACKUI_EVERYWHERE;
            frame.statusPanel.statusValue["where"] = 1;
            frame.statusPanel.status["who"] = FEEDBACKUI_WHONA;
            frame.statusPanel.statusValue["who"] = 0;
            FEEDBACKUI_TYPETABLE = FEEDBACKUI_ITEMSTYPETABLE;
            frame.stepThroughPanel.table = FEEDBACKUI_ITEMSTYPETABLE
            frame.stepThroughPanel.Render(frame.stepThroughPanel);
        elseif ( FeedbackUI.focus.type == "Quests" ) then
            FEEDBACKUI_TYPETABLE = FEEDBACKUI_QUESTSTYPETABLE;
            frame.stepThroughPanel.table = FEEDBACKUI_AREATABLE;
            frame.stepThroughPanel.startlink = FEEDBACKUI_AREATABLE;
            frame.stepThroughPanel.Render(frame.stepThroughPanel);
        elseif ( FeedbackUI.focus.type == "Mobs" ) then
            local whereText = GetRealZoneText();
            local whereVal = nil
            for _, entry in ipairs(FEEDBACKUI_AREATABLE) do
                if ( entry.summary and entry.summary.text and string.match(string.lower((getglobal(entry.summary.text) or "")), string.lower(whereText)) )then
                    whereText = getglobal(entry.summary.text)
                    whereVal = entry.summary.value
                end
            end
            frame.statusPanel.status["where"] = whereText
            frame.statusPanel.statusValue["where"] = whereVal or 1;
            if ( FeedbackUI.focus.friendly ) then
                frame.statusPanel.status["who"] = FEEDBACKUI_FRIENDLYCREATURE;
                frame.statusPanel.statusValue["who"] = 7
            else
                frame.statusPanel.status["who"] = FEEDBACKUI_ENEMYCREATURE;
                frame.statusPanel.statusValue["who"] = 6
            end
            
            FEEDBACKUI_TYPETABLE = FEEDBACKUI_SPAWNSTYPETABLE;
            frame.stepThroughPanel.table = FEEDBACKUI_SPAWNSTYPETABLE;
            frame.stepThroughPanel.startlink = FEEDBACKUI_SPAWNSTYPETABLE;
            frame.stepThroughPanel.Render(frame.stepThroughPanel);
        elseif ( FeedbackUI.focus.type == "Areas" ) then
            local whereText = FeedbackUI.focus.name;
            local whereVal = nil
            for _, entry in ipairs(FEEDBACKUI_AREATABLE) do
                if ( entry.summary and entry.summary.text and string.match(string.lower((getglobal(entry.summary.text) or "")), string.lower(whereText)) ) then
                    whereText = getglobal(entry.summary.text)
                    whereVal = entry.summary.value
                end
            end
            frame.statusPanel.status["where"] = whereText;
            frame.statusPanel.statusValue["where"] = whereVal or 1;
            frame.statusPanel.status["who"] = FEEDBACKUI_WHONA;
            frame.statusPanel.statusValue["who"] = 0;
            FEEDBACKUI_TYPETABLE = FEEDBACKUI_AREASTYPETABLE;
            frame.stepThroughPanel.table = FEEDBACKUI_AREASTYPETABLE;
            frame.stepThroughPanel.startlink = FEEDBACKUI_AREASTYPETABLE;
            frame.stepThroughPanel.Render(frame.stepThroughPanel);
        elseif ( FeedbackUI.focus.type == "Voice" ) then
            frame.statusPanel.status["where"] = FEEDBACKUI_EVERYWHERE;
            frame.statusPanel.statusValue["where"] = 1;
            frame.statusPanel.status["who"] = FEEDBACKUI_WHONA;
            frame.statusPanel.statusValue["who"] = 0;
            FEEDBACKUI_TYPETABLE = FEEDBACKUI_VOICECHATTABLE;
            frame.stepThroughPanel.table = FEEDBACKUI_VOICECHATTABLE;
            frame.stepThroughPanel.startlink = FEEDBACKUI_VOICECHATTABLE;
            frame.stepThroughPanel.Render(frame.stepThroughPanel);
            frame.statusPanel.status["when"] = FEEDBACKUI_REPRODUCABLE;
            frame.statusPanel.statusValue["when"] = 4;
            frame.statusPanel.infoLines[5] = frame.statusPanel.infoLines[3];
            frame.statusPanel.infoLines[3] = nil;
        end
    elseif ( buttonPress == true ) then
        FEEDBACKUI_TYPETABLE = FEEDBACKUI_GENERICTYPETABLE; 
        frame.stepThroughPanel.table = FEEDBACKUI_WHERETABLE;
        frame.stepThroughPanel.startlink = FEEDBACKUI_WHERETABLE;
        frame.stepThroughPanel.Render(frame.stepThroughPanel);
    else
        FEEDBACKUI_TYPETABLE = FEEDBACKUI_GENERICTYPETABLE;
    end
end

--Make an item FeedbackUI's "focus" (what feedback is being left on) and show the welcome frame.
function FeedbackUI_SetupItem (link)    
    --Farm information out ot item, set FeedbackUI's focus, and open it up to the initial menu.
    if ( not link ) then return end;
    local itemName, _, iRarity, _, _, itemType = GetItemInfo(link);
    local itemID = string.match(link,":([%d]+):");
    local allowSurvey = false;
    
    for _, iType in pairs(FEEDBACKUI_ITEMTARGETS) do
        if ( itemType == iType ) then
            allowSurvey = true;
        end
    end
    
    --Yay for hacks! Mounts are Misc. Junk, but we want feedback, so...
    if ( itemType == FEEDBACKUI_MISCTYPE and IsUsableItem(itemID) and iRarity > 3 ) then
        allowSurvey = true;
    end
    
    
    FeedbackUI.focus = { ["type"] = "Items", ["name"] = itemName, ["id"] = itemID, ["modified"] = time(), ["added"] = time() };
    FeedbackUI_SetupWelcome(itemName, allowSurvey);
    FeedbackUITab4:Click();
    if ( not FeedbackUI:IsVisible() ) then
        FeedbackUI_Show();
    end
end

---------------------------------------------------------------------------------------------------
-- Allow users to give feedback on quests in their quest logs.
---------------------------------------------------------------------------------------------------

--Make a quest FeedbackUI's "focus" and show the welcome frame.
function FeedbackUI_SetupQuest (text, objectives)
    if ( not FeedbackUI_QuestsEnabled() ) then
        return;
    end
    
    local questID = FeedbackUI_HexHash(string.gsub(objectives, "%c", ""));
    
    FeedbackUI_ReindexQuests();
    
    local index = g_FeedbackUI_surveysTable["Quests"]["Index"][questID]
    
    FeedbackUI.focus = g_FeedbackUI_surveysTable["Quests"][index];
    if ( not FeedbackUI.focus ) then 

    else
        FeedbackUI_SetupWelcome(FeedbackUI.focus.name);
        FeedbackUITab4:Click();
        if not ( FeedbackUI:IsVisible() ) then
            FeedbackUI_Show();
        end
    end
end

--Place a feedback cue at the bottom of item tooltips.
function FeedbackUI_ItemTooltip (tooltip, x, y)
    if ( not g_FeedbackUI_feedbackVars["verbose"] ) then
        return;
    end

    local itemLink, name;
    local font = FEEDBACKUI_BLUE_COLOR;
    local r, g, b = font.r, font.g, font.b;
    name = this:GetName();

    if ( ( tooltip == ShoppingTooltip1 ) or ( tooltip == ShoppingTooltip2 ) ) then
        local item = getglobal (tooltip:GetName().."TextLeft2"):GetText()
		if ( item ) then
            _, itemLink = GetItemInfo(item) 
        end
    elseif ( x and string.match(x, "item:") ) then
        itemLink = x;
    elseif ( x and y ) then
		if ( ( string.match(name, "^ContainerFrame") or string.match(name, "^GameTooltip") )  and ( type(x) ~= "string" ) and x ~= KEYRING_CONTAINER ) then
			itemLink = GetContainerItemLink(x, y)
		elseif ( string.match(name, "^Quest") ) then
			itemLink = ( GetQuestItemLink(x, y) or GetQuestLogItemLink(x, y) );
        elseif ( x == "list" ) or ( x == "bidder" ) or ( x == "owner" ) then
            itemLink = GetAuctionItemLink(x, y);
		elseif ( type(x) == "string" ) then
			itemLink = GetInventoryItemLink(x, y);
        elseif ( string.match(name, "^TradeSkillReagent") ) then
            itemLink = GetTradeSkillReagentItemLink(x, y);            
		end
	elseif ( x ) then
		if ( string.match(name, "^GameTooltip") ) then
			itemLink = GetMerchantItemLink(x);
		elseif ( string.match(name, "^MerchantItem") ) then
			itemLink = GetMerchantItemLink(x);
		elseif ( string.match(name, "^LootButton") ) then
			itemLink = GetLootSlotLink(x);
		elseif ( string.match(name, "^GroupLootFrame") ) then
			itemLink = GetLootRollItemLink(x);
        elseif ( string.match(name, "^TradePlayer" ) ) then
            itemLink = GetTradePlayerItemLink(x);
        elseif ( string.match(name, "^TradeRecipient" ) ) then
            itemLink = GetTradeTargetItemLink(x);
        elseif ( string.match(name, "^TradeSkillSkill") ) then
            itemLink = GetTradeSkillItemLink(x);
		elseif ( string.match(name, "^ClassTrainerSkillIcon") ) then
			itemLink = GetTrainerServiceItemLink(x);
		end
	end
    
    if ( not itemLink ) then
        return;
    end
	
    tooltip:AddLine(FeedbackUI_BuildTooltipLine(FEEDBACKUI_TOOLTIP_MESSAGE), r, g, b);
    tooltip:AddTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Blizzard-Tooltip");
    
    tooltip:Show();

    if ( tooltip == ItemRefTooltip ) then
        tooltip.link = itemLink;
        
        FeedbackUIItemRefCue.found = false;
	local line;
        for i = 2, tooltip:NumLines() do 
            line = getglobal(tooltip:GetName() .. "TextLeft" .. i);
			--if (string.find(line:GetText(), FEEDBACKUI_TOOLTIP_POSTMESSAGE)) then 
            if ( line:GetText() == FEEDBACKUI_TOOLTIP_MESSAGE ) then
                FeedbackUIItemRefCue.found = true;
                FeedbackUIItemRefCue:SetParent(tooltip);
                FeedbackUIItemRefCue:ClearAllPoints();
                FeedbackUIItemRefCue:SetPoint("TOPLEFT", line, "TOPLEFT", -16, 2);
                FeedbackUIItemRefCue:SetPoint("BOTTOMRIGHT", line, "BOTTOMRIGHT", 16, -4);
                FeedbackUIItemRefCue:Show();
                break;
            end
        end
    end
end

--Display the FeedbackUI tooltip line for spawns.
function FeedbackUI_SpawnTooltip ()
    if ( ( not g_FeedbackUI_feedbackVars["verbose"] ) or ( not UnitName("mouseover") ) ) then
        return;
    end
    
    local font = FEEDBACKUI_BLUE_COLOR;
    local r, g, b = font.r, font.g, font.b;
    
    GameTooltip:AddLine(FeedbackUI_BuildTooltipLine(FEEDBACKUI_TOOLTIP_MESSAGE), r, g, b);
    GameTooltip:AddTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Blizzard-Tooltip");
    GameTooltip:Show();
end

---------------------------------------------------------------------------------------------------
-- Allow users to give feedback on equipable items
---------------------------------------------------------------------------------------------------

local oldCharacterAmmoSlot_OnClick = CharacterAmmoSlot:GetScript("OnClick");
function FeedbackUI_CharacterAmmoSlot_OnClick (button)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        if ( GetInventoryItemLink("player", this:GetID() ) ) then
            FeedbackUI_SetupItem(GetInventoryItemLink("player", this:GetID()))
        end
    else
        oldCharacterAmmoSlot_OnClick(button);
    end
end
CharacterAmmoSlot:SetScript("OnClick", function() FeedbackUI_CharacterAmmoSlot_OnClick(arg1) end);

local oldSetItemRef = SetItemRef;
function FeedbackUI_SetItemRef (link, text, button)
    --Hooks and replaces the click handler for clicking on item links.
    if ( IsModifiedClick("GENERATEFEEDBACK") and string.match((link or text), ":[%d]+:") ) then
		local modifier, mouseButton = strsplit("-", GetModifiedClick("GENERATEFEEDBACK"));
		if ( ( mouseButton == "BUTTON1" ) and ( button == "LeftButton" ) ) or
			( ( mouseButton == "BUTTON2" ) and ( button == "RightButton" ) ) then
			FeedbackUI_SetupItem(text);
		end
    else
        oldSetItemRef(link, text, button);
    end
end
SetItemRef = FeedbackUI_SetItemRef;

function FeedbackUI_HandleModifiedItemClick (link)
	if (IsModifiedClick("GENERATEFEEDBACK")) then
		if (link) then
			local target = this:GetName();
			if (string.find(target, "TradeSkill")) then
				_, _, tradeSkillID = string.find(target, "TradeSkillSkill(%d+)");
				if (tradeSkillID) then 
					TradeSkillFrame_SetSelection(this:GetID());
					TradeSkillFrame_Update();
					link = GetTradeSkillItemLink(TradeSkillFrame.selectedSkill);
				end
			end

			FeedbackUI_SetupItem(link);
		end
	end
end
hooksecurefunc("HandleModifiedItemClick", FeedbackUI_HandleModifiedItemClick);

local oldBankFrameItemButtonBag_OnClick = BankFrameItemButtonBag_OnClick;
function FeedbackUI_BankFrameItemButtonBag_OnClick (button)
	if (IsModifiedClick("GENERATEFEEDBACK")) then
        FeedbackUI_SetupItem(GetInventoryItemLink("player", this:GetInventorySlot()));
    end
    oldBankFrameItemButtonBag_OnClick(button);
end
BankFrameItemButtonBag_OnClick = FeedbackUI_BankFrameItemButtonBag_OnClick;

function FeedbackUI_FixContainerPortrait ()
    for i = 1, 13 do 
		getglobal("ContainerFrame" .. i .. "PortraitButton"):SetScript("OnClick", function() FeedbackUI_HandleModifiedContainerClick(arg1) end)
    end
end

function FeedbackUI_BagSlotButton_OnModifiedClick ()
	if (IsModifiedClick("GENERATEFEEDBACK")) then
		FeedbackUI_SetupItem(GetInventoryItemLink("player", this:GetID()));
	end
end
hooksecurefunc("BagSlotButton_OnModifiedClick", FeedbackUI_BagSlotButton_OnModifiedClick);

function FeedbackUI_HandleModifiedContainerClick(button)
	if (IsModifiedClick("GENERATEFEEDBACK")) then
		if (this:GetID() > 0) then
			FeedbackUI_SetupItem(GetInventoryItemLink("player", ContainerIDToInventoryID(this:GetID())));
		end
	end
end

function FeedbackUI_QuestLogTitleButton_OnClick (button)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        local _, _, _, _, header = GetQuestLogTitle(this:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame));

        if ( not header ) then
            FeedbackUI_SetupQuest(GetQuestLogQuestText(this:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame)));
        end
    end
end
hooksecurefunc("QuestLogTitleButton_OnClick", FeedbackUI_QuestLogTitleButton_OnClick);

---------------------------------------------------------------------------------------------------
-- Allow users to give feedback on everything displayed by the map.
---------------------------------------------------------------------------------------------------

local oldWorldMapButton_OnClick = WorldMapButton_OnClick;
function FeedbackUI_WorldMapButton_OnClick (mouseButton, button, subZoneText)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        local currentContinent, continentTable, zoneTable = GetCurrentMapContinent(), { GetMapContinents() }, { GetMapZones(GetCurrentMapContinent()) };
        local labelText = WorldMapFrameAreaLabel:GetText();
        
        --Hack around "Under Attack" areas and other POIs on world maps.
        if ( FEEDBACKUI_NONINSTANCEZONES[WorldMapFrameAreaDescription:GetText()] ) then
            labelText = WorldMapFrameAreaDescription:GetText();
        end
        
        local areaName = ( subZoneText or labelText or zoneTable[GetCurrentMapZone()] or continentTable[currentContinent] );
        local zoneName = "";
        if ( areaName == subZoneText ) then 
            zoneName = GetRealZoneText()
        else
            zoneName = zoneTable[GetCurrentMapZone()]
        end
        
        local areaFound, summaryText = false;
        for _, entry in ipairs(FEEDBACKUI_AREATABLE) do
            summaryText = getglobal(entry.summary.text)
            if ( areaName and summaryText and string.match(summaryText, areaName) ) then
                areaFound = true;
            end
        end
        
        if ( areaName == zoneName or areaFound) then 
            zoneName = continentTable[currentContinent]
        end
        
        if ( areaName == zoneName ) then
            zoneName = nil;
            -- zoneName = "";
        end
        
        for _, entry in pairs(FEEDBACKUI_POITABLE) do
            if ( entry.name == areaName ) then
                zoneName=string.match(entry.zone, FEEDBACKUI_POIMASK) or entry.zone
            end
        end
        
        if ( zoneName ) then
            zoneName = ", " .. zoneName;
        end
        
        zoneName = zoneName or "";
        
        if ( ( not areaName ) and ( currentContinent == 0 ) ) then
            areaName = "Azeroth";
        elseif ( not areaName ) then
            --This pretty much only ever happens on the Cosmic map.
            return;
        end
        
        FeedbackUI.focus = { ["type"] = "Areas", ["modified"] = time(), ["added"] = time(), ["name"] = ( areaName .. zoneName ), ["id"] = ( areaName .. zoneName ) };
        FeedbackUI_SetupWelcome(areaName .. zoneName, allowSurvey);
        
        if ( WorldMapFrame:IsVisible() ) then
            ToggleWorldMap();
        end
        FeedbackUITab4:Click();
        
        if ( not FeedbackUI:IsVisible() ) then
            FeedbackUI_Show();
        end
    else
        oldWorldMapButton_OnClick(mouseButton, button);
    end
end
WorldMapButton_OnClick = FeedbackUI_WorldMapButton_OnClick;

local oldAzerothButton_OnClick = AzerothButton:GetScript("OnClick");
local oldOutlandButton_OnClick = OutlandButton:GetScript("OnClick");
function FeedbackUI_AzerothButton_OnClick (...)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        FeedbackUI.focus = { ["type"] = "Areas", ["modified"] = time(), ["added"] = time(), ["name"] = FEEDBACKUI_AZEROTH, ["id"] = FEEDBACKUI_AZEROTH };
        FeedbackUI_SetupWelcome(FEEDBACKUI_AZEROTH, allowSurvey);
        
        if ( WorldMapFrame:IsVisible() ) then
            ToggleWorldMap();
        end
        FeedbackUITab4:Click();
        
        if ( not FeedbackUI:IsVisible() ) then
            FeedbackUI_Show();
        end        
    else
        oldAzerothButton_OnClick(...)
    end
end

function FeedbackUI_OutlandButton_OnClick (...)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        FeedbackUI.focus = { ["type"] = "Areas", ["modified"] = time(), ["added"] = time(), ["name"] = FEEDBACKUI_OUTLANDS, ["id"] = FEEDBACKUI_OUTLANDS };
        FeedbackUI_SetupWelcome(FEEDBACKUI_OUTLANDS, allowSurvey);
        
        if ( WorldMapFrame:IsVisible() ) then
            ToggleWorldMap();
        end
        FeedbackUITab4:Click();
        
        if ( not FeedbackUI:IsVisible() ) then
            FeedbackUI_Show();
        end
    else
		oldOutlandButton_OnClick(...)
    end
end

AzerothButton:SetScript("OnClick", FeedbackUI_AzerothButton_OnClick);
OutlandButton:SetScript("OnClick", FeedbackUI_OutlandButton_OnClick);

---------------------------------------------------------------------------------------------------
-- Allow users to give feedback by alt left clicking on spawns
---------------------------------------------------------------------------------------------------

function FeedbackUI_SetupSpawn (spawnName)
    local reactionType;
    
    if ( not spawnName ) then
        if ( ( UnitExists("mouseover") ) and not ( UnitIsPlayer("mouseover") ) ) then
            spawnName = UnitName("mouseover");
            reactionType = UnitIsFriend("player", "mouseover");
        else
            return;
        end
    end
    
    if ( not reactionType ) then
        reactionType = false;
    end
    
    local name, zone, id = spawnName, ( GetRealZoneText() or "" ), "";
    
    
    if ( zone ) then
        id = zone .. " " .. name;
        name = name .. ", " .. zone;
    end
    
    FeedbackUI.focus = { ["name"] = spawnName, ["zone"] = zone, ["id"] = id, ["added"] = time(), ["modified"] = time(), ["type"] = "Mobs", ["friendly"] = reactionType }
    FeedbackUI_SetupWelcome(name);
    
    FeedbackUITab4:Click();
    if ( not FeedbackUI:IsVisible() ) then
        FeedbackUI_Show();
    end
end

function FeedbackUI_WorldFrame_OnClick ()
    if ( not IsModifiedClick("GENERATEFEEDBACK") ) then
        return;
    end
    tinsert(waitTable, { func = function() FeedbackUI_SetupSpawn() end, exTime = 0 }) ;
end

---------------------------------------------------------------------------------------------------
-- Functions for inserting various Feedback cues.
---------------------------------------------------------------------------------------------------

function FeedbackUI_QuestLog_UpdateQuestDetails ()
    --Insert a feedback cue into the Quest Log, between objectives and description.
    if ( not g_FeedbackUI_feedbackVars["verbose"] and FeedbackUI_QuestsEnabled() ) then
        FeedbackUIQuestLogTip:Hide();
        return;
    else
        FeedbackUIQuestLogTip:Show();
    end
    
--~     local numObjectives = GetNumQuestLeaderBoards()
	if ( QuestLogRequiredMoneyText:IsVisible() ) then
		FeedbackUIQuestLogTip:SetPoint("TOPLEFT", "QuestLogRequiredMoneyText", "BOTTOMLEFT", 5, -10); 
    elseif ( GetNumQuestLeaderBoards() > 0 and not QuestLogSuggestedGroupNum:IsVisible() ) then
        FeedbackUIQuestLogTip:SetPoint("TOPLEFT", "QuestLogObjective" .. GetNumQuestLeaderBoards(), "BOTTOMLEFT", 5, -10);
	 elseif ( QuestLogSuggestedGroupNum:IsVisible() ) then 
        FeedbackUIQuestLogTip:SetPoint("TOPLEFT", "QuestLogSuggestedGroupNum", "BOTTOMLEFT", 5, -10);
    else
        FeedbackUIQuestLogTip:SetPoint("TOPLEFT", "QuestLogObjectivesText", "BOTTOMLEFT", 5, -10);
    end
    QuestLogDescriptionTitle:SetPoint("TOPLEFT", FeedbackUIQuestLogTip, "BOTTOMLEFT", -5, -10);
	
	FeedbackUIQuestLogTipLabel:SetText(FeedbackUI_BuildTooltipLine(FEEDBACKUI_TOOLTIP_MESSAGE));
end
hooksecurefunc("QuestLog_UpdateQuestDetails", FeedbackUI_QuestLog_UpdateQuestDetails);

function FeedbackUI_WorldMapFrame_OnShow ()
    --Place a feedback cue in the world map frame.
    if ( not g_FeedbackUI_feedbackVars["verbose"] ) then
        FeedbackUIMapTip:Hide();
        return;
    end
	
	FeedbackUIMapTipLabel:SetText(FeedbackUI_BuildTooltipLine(FEEDBACKUI_MAP_MESSAGE));
    FeedbackUIMapTip:Show();
end

do
    --Play nice with other addons, or no desert. =P
    if ( WorldMapFrame ) then
        local oldFunc = WorldMapFrame:GetScript("OnShow")
        if ( oldFunc ) then
            oldWorldMapFrame_OnShow = oldFunc;
            WorldMapFrame:SetScript("OnShow", function() FeedbackUI_WorldMapFrame_OnShow(); oldWorldMapFrame_OnShow() end);
        else
            WorldMapFrame:SetScript("OnShow", FeedbackUI_WorldMapFrame_OnShow);
        end
    end
end

function FeedbackUI_ReindexQuests ()
    for i, entry in ipairs(g_FeedbackUI_surveysTable["Quests"]) do
        g_FeedbackUI_surveysTable["Quests"]["Index"][entry.id] = i;
    end
end

local oldMinimapZoneTextButton_OnEnter = MinimapZoneTextButton:GetScript("OnEnter");

function FeedbackUI_MinimapZoneTextButton_OnEnter (...)
    local font = FEEDBACKUI_BLUE_COLOR;
    local r, g, b = font.r, font.g, font.b;
    oldMinimapZoneTextButton_OnEnter(...);

    GameTooltip:AddLine(FeedbackUI_BuildTooltipLine(FEEDBACKUI_TOOLTIP_MESSAGE), r, g, b);
    GameTooltip:AddTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Blizzard-Tooltip");
    GameTooltip:Show();
end
MinimapZoneTextButton:SetScript("OnEnter", FeedbackUI_MinimapZoneTextButton_OnEnter);

function FeedbackUI_MinimapZoneTextButton_OnClick (button)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        FeedbackUI_WorldMapButton_OnClick ( button, nil, GetMinimapZoneText() )
    end
end
MinimapZoneTextButton:SetScript("OnClick", function() FeedbackUI_MinimapZoneTextButton_OnClick(arg1) end);

function FeedbackUI_QuestsEnabled ()
    return true;
    --Disables quests for non-Windows clients. This was here to resolve an issue with bit.bxor on Macintoshes
    -- return IsWindowsClient();
end

---------------------------------------------------------------------------------------------------
-- VoiceChat hooks, cues, and related functions
---------------------------------------------------------------------------------------------------

do
    if ( MiniMapVoiceChatFrame ) then
        local script = MiniMapVoiceChatFrame:GetScript("OnEnter")
        MiniMapVoiceChatFrame:SetScript("OnEnter", function() pcall(script) FeedbackUI_DisplayVoiceChatTooltip() end);
        script = MiniMapVoiceChatFrame:GetScript("OnLeave");
        MiniMapVoiceChatFrame:SetScript("OnLeave", function() pcall(script) GameTooltip:Hide(); end);
    end
end

local VoiceChatFrame_OnClick = MiniMapVoiceChatFrame:GetScript("OnClick");
function FeedbackUI_MiniMapVoiceChatFrame_OnClick (...)
    if ( IsModifiedClick("GENERATEFEEDBACK") ) then
        FeedbackUI_SetupVoiceChat ()
    else
        VoiceChatFrame_OnClick(...);
    end
end
MiniMapVoiceChatFrame:SetScript("OnClick", FeedbackUI_MiniMapVoiceChatFrame_OnClick);

function FeedbackUI_SetupVoiceChat ()
    FeedbackUI.focus = { ["type"] = "Voice", ["name"] = "Voice Chat", ["id"] = "Voice Chat", ["modified"] = time(), ["added"] = time() }
    FeedbackUI_SetupWelcome(FEEDBACKUI_VOICECHAT, false);
    if ( not FeedbackUI:IsVisible() ) then
        FeedbackUI_Show();
    end
end

function FeedbackUI_DisplayVoiceChatTooltip ()
    if ( not g_FeedbackUI_feedbackVars["verbose"] ) then
        return;
    end

    local font = FEEDBACKUI_BLUE_COLOR;
    local r, g, b = font.r, font.g, font.b;
    
    if ( not GameTooltip:IsVisible() ) then
        GameTooltip:SetOwner(this, "CURSOR");
        GameTooltip:AddLine(FEEDBACKUI_VOICECHATTOOLTIP);
        
    end
    
    
    GameTooltip:AddLine(FeedbackUI_BuildTooltipLine(FEEDBACKUI_TOOLTIP_MESSAGE), r, g, b);
    GameTooltip:AddTexture("Interface\\AddOns\\MaNGOS_FeedbackUI\\UI-Icon-Blizzard-Tooltip");
    GameTooltip:Show();
end

local x, y, centerY, centerX
function FeedbackUI_MoveButton ()
    centerY, centerX = ( Minimap:GetTop() - ( ( Minimap:GetTop() - Minimap:GetBottom() ) / 2 ) ), ( Minimap:GetLeft() + ( ( Minimap:GetRight() - Minimap:GetLeft() ) / 2 ) )
    x, y = GetCursorPosition();
    x, y = x / FeedbackUIButton:GetEffectiveScale(), y / FeedbackUIButton:GetEffectiveScale();
    x, y = -( centerX - x ), -( centerY - y );
    centerX, centerY = math.abs(x), math.abs(y);
    centerX, centerY = (centerX / sqrt((centerX * centerX) + (centerY * centerY))) * 76, (centerY / sqrt((centerX * centerX) + (centerY * centerY))) * 76;
    
    if ( x < 0 ) then
        centerX = -centerX;
    end
    
    if ( y < 0 ) then
        centerY = -centerY;
    end
    
    FeedbackUIButton:ClearAllPoints();
    FeedbackUIButton:SetPoint("CENTER", centerX, centerY);
    FeedbackUIButton:SetUserPlaced(true);
end

