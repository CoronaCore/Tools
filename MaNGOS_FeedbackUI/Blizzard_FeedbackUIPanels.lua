
--Create panels for the Bug form--
FeedbackUI_SetupPanel{
	name = "InfoPanel",
	labelText = FEEDBACKUIINFOPANELLABEL_TEXT,
	parent = "FeedbackUIBugFrame",
	inherits = "FeedbackPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPLEFT", ["x"] = -2, ["y"] = -28 }, 
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPRIGHT", ["x"] = 2, ["y"] = -28 } },
	size = { ["y"] = 130 },
	Setup = function(obj)
				obj.infoLines = {}
				obj.infoTable = {}
			end,
	event = {"ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA", "PLAYER_LEVEL_UP" },
	Handler = function() if ( event == "PLAYER_LEVEL_UP" ) then 
							for _, line in next, this.infoLines do
								if ( line:GetName():match("Char") ) then 
									local panel = this;
									local genderTable = FEEDBACKUI_GENDERTABLE;
									if ( not panel.infoTable ) then
										panel.infoTable = {}
									end
									panel.infoTable["character"] = "Lvl "..arg1.." "..UnitRace("player").." "..genderTable[UnitSex("player")].." "..UnitClass("player");
									panel.infoTable["level"] = arg1;
									panel.infoTable["race"] = UnitRace("player");
									panel.infoTable["sex"] = genderTable[UnitSex("player")];
									panel.infoTable["class"] = UnitClass("player");
									line.value:SetText(panel.infoTable["character"])
								end
							end
						else
							pcall(this.Show, this) end
						end,	
	Show = 	function(obj) 
				for _, line in next, obj.infoLines do
					if ( line.Update ) then line.Update(line) end
				end	
			end,
	Load = 	function(obj)
				for _, line in next, obj.infoLines do
					if ( line.Load ) then line.Load(line) end
				end
			end }
			
--Lines for the Bug form's info panel--				
FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Version",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMVER_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["version"], parent.infoTable["build"], parent.infoTable["date"] = GetBuildInfo();
				line.value:SetText("WoW " .. parent.infoTable["version"] .. " \[Release\] Build " .. parent.infoTable["build"]);
			end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Realm",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMREALM_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["realm"] = GetRealmName();
				line.value:SetText(parent.infoTable["realm"])
			end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Name",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMNAME_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			if ( not parent.infoTable ) then
				parent.infoTable = {};
			end
			parent.infoTable["name"] = UnitName("player");
			line.value:SetText(parent.infoTable["name"])
		end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Char",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMCHAR_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			local genderTable = FEEDBACKUI_GENDERTABLE;
			if ( not parent.infoTable ) then
				parent.infoTable = {}
			end
			parent.infoTable["character"] = "Lvl "..UnitLevel("player").." "..UnitRace("player").." "..genderTable[UnitSex("player")].." "..UnitClass("player");
			parent.infoTable["level"] = UnitLevel("player");
			parent.infoTable["race"] = UnitRace("player");
			parent.infoTable["sex"] = genderTable[UnitSex("player")];
			parent.infoTable["class"] = UnitClass("player");
			line.value:SetText(parent.infoTable["character"])
		end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Map",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMMAP_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			if ( not parent.infoTable ) then
				parent.infoTable = {}
			end
			
			--Record positioning information with the Map line since there isn't any particular place to do it with the new format.
			local debugStats, parseString
			
			if ( GetDebugStats() ) then 
				debugStats = {}
				parseString="([^%c]+)";
				for line in string.gmatch(GetDebugStats(), parseString) do
					table.insert(debugStats, line)
				end
			else
				debugStats = ""
			end	
			
			if ( debugStats ~= "" ) then 
				parent.infoTable["position"] = string.gsub(debugStats[2], "Player position: ", "");
				parent.infoTable["facing"] = debugStats[3]
				parent.infoTable["object"] = debugStats[4]
				parent.infoTable["chunk"] = debugStats[5]
			end
			
			local x, y = GetPlayerMapPosition("player");
			x = math.floor(x * 100)
			y = math.floor(y * 100)
			parent.infoTable["coords"] = x..", "..y	
			
			local mapCompare = { GetMapContinents() };
			SetMapToCurrentZone();
			parent.infoTable["map"] = mapCompare[GetCurrentMapContinent()];
			line.value:SetText(parent.infoTable["map"])
		end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Zone",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMZONE_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["zone"] = GetRealZoneText();
				line.value:SetText(parent.infoTable["zone"])
			end	
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Area",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMAREA_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["area"] = GetSubZoneText();
				line.value:SetText(parent.infoTable["area"])
			end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUIBugFrameInfoPanel",
	name="Addons",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMADDONS_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				else
					parent.infoTable["addons"] = nil
					parent.infoTable["addonloaded"] = nil
					parent.infoTable["addonsWrap"] = nil
				end
				local addonsList, addonsListCount, wrapCount, tempArray
				
				addonsList = {}
				for i = 1, GetNumAddOns() do
					local infoTable = { GetAddOnInfo(i) };
					table.insert(addonsList, infoTable)
				end
				if ( addonsList == nil ) then addonsList = { "None" } end
								
				addonsListCount = table.maxn(addonsList)
				wrapCount = 1
				
				for i = 1, addonsListCount do
					if not ( parent.infoTable["addons"] ) then
						if ( addonsList[i][4] == 1 ) then
							parent.infoTable["addonsloaded"] = addonsList[i][1]
							parent.infoTable["addonsWrap"] = HIGHLIGHT_FONT_COLOR_CODE..FEEDBACKUILBLADDONSWRAP_TEXT..FONT_COLOR_CODE_CLOSE..addonsList[i][1];					
							wrapCount = 1;
						end
						parent.infoTable["addons"] = addonsList[i][1];
					else
						if ( addonsList[i][4] == 1 ) then
							if not ( parent.infoTable["addonsWrap"] ) then
								parent.infoTable["addonsloaded"] = addonsList[i][1]
								parent.infoTable["addonsWrap"] = HIGHLIGHT_FONT_COLOR_CODE..FEEDBACKUILBLADDONSWRAP_TEXT..FONT_COLOR_CODE_CLOSE..addonsList[i][1];					
								wrapCount = 1;
							elseif ( ( wrapCount / 3) == math.floor( wrapCount / 3 ) ) then
								parent.infoTable["addonsloaded"] = parent.infoTable["addonsloaded"]..", "..addonsList[i][1]
								parent.infoTable["addonsWrap"] = parent.infoTable["addonsWrap"].."\n"..addonsList[i][1];
								wrapCount = wrapCount + 1;
							else
								parent.infoTable["addonsloaded"] = parent.infoTable["addonsloaded"]..", "..addonsList[i][1]
								parent.infoTable["addonsWrap"] = parent.infoTable["addonsWrap"]..", "..addonsList[i][1];
								wrapCount = wrapCount + 1;
							end
						end
						parent.infoTable["addons"] = parent.infoTable["addons"]..", "..addonsList[i][1];
					end	
				end
				
				if ( parent.infoTable["addonsWrap"] ) then
					local blankWidth = line.value:GetWidth();
					line.value:SetText(parent.infoTable["addonsloaded"]);
					if ( line.value:GetStringWidth() > blankWidth - 15) then
						line.value:SetText(FEEDBACKUILBLADDONS_MOUSEOVER);
					end
				end
			end,
	
	Setup = function(line)				
				line:SetScript("OnEnter", 
								function()
									this:SetScript("OnUpdate", 
										function() 
											local x, y = GetCursorPosition();
											x = x / this:GetEffectiveScale();
											y = y / this:GetEffectiveScale();
											local value = getglobal(this:GetName() .. "Value")
											if ( x > (value:GetLeft() + ( value:GetWidth() / this:GetEffectiveScale() ) ) - ( value:GetStringWidth() + 15 ) / this:GetEffectiveScale() ) then
												GameTooltip:SetOwner(this, "ANCHOR_CURSOR"); 
												GameTooltip:SetText(this:GetParent().infoTable["addonsWrap"]) 
											else
												GameTooltip:Hide()
											end
										end)
								end);
				line:SetScript("OnLeave", function() GameTooltip:Hide(); this:SetScript("OnUpdate", nil) end )
			end,
	
	handlers = { 	{ ["type"] = "OnEnter",	["func"] = 	function(line) 
																DEFAULT_CHAT_FRAME:AddMessage("Entered");
																GameTooltip:SetOwner(line, "ANCHOR_CURSOR"); GameTooltip:SetText(line.infoTable["addonsWrap"]);
															end }, 
					{ ["type"] = "OnLeave", ["func"] = 	function() GameTooltip:Hide() end } }
	}
	
FeedbackUI_SetupPanel{
	name = "StatusPanel",
	parent = "FeedbackUIBugFrame",
	inherits = "FeedbackPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentInfoPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = 3 },
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parentInfoPanel", ["relativepoint"] = "TOPRIGHT", ["x"] = 0, ["y"] = 3 } },
	size = { ["y"] = 70 },
	Setup = function(obj)
				-- Create the seperator line that follows the Status panel.
                obj.infoLines = {};
				obj.seperator = CreateFrame("Frame", obj:GetName() .. "Line", obj, "FeedbackLineTemplate");
				obj.seperator:SetPoint("TOPLEFT", obj, "BOTTOMLEFT", 0, -5);
				obj.seperator:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", 0, -5);	
				obj.status = {};
                
			end,
	Show = 	function(panel)
				for _, line in next, panel.infoLines do
					if ( line.Update ) then 
                        line.Update(line, panel) 
                    end
				end	
			end
	}

FeedbackUI_AddInfoLine{
	name = "Where",
	parent = "FeedbackUIBugFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHERE_TEXT,
	Setup = function(line)
				line.type = "where"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}
			
FeedbackUI_AddInfoLine{
	name = "Who",
	parent = "FeedbackUIBugFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHO_TEXT,
	Setup = function(line)
				line.type = "who"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}

FeedbackUI_AddInfoLine{
	name = "Type",
	parent = "FeedbackUIBugFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMTYPE_TEXT,
	Setup = function(line)
				line.type = "type"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}			
					
FeedbackUI_AddInfoLine{
	name = "When",
	parent = "FeedbackUIBugFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHEN_TEXT,
	Setup = function(line)
				line.type = "when"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}	
	
FeedbackUI_SetupPanel{
	name = "StepThroughPanel",
	parent = "FeedbackUIBugFrame",
	inherits = "FeedbackWizardTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentStatusPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = -1 },
				{ ["point"] = "BOTTOMRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "BOTTOMRIGHT", ["x"] = 2, ["y"] = 19 } },
	Setup = function(panel)
				panel.maxbuttons = 1
				panel.scrollResults = {}
				panel.history = {}
				panel.table = FEEDBACKUI_BUGWELCOMETABLE
				
                panel.Localize = 
                    function(panel)
                        if GetLocale() == "esES" or GetLocale() == "frFR" or GetLocale() == "deDE" then
                            panel.buttonWidth = 415
                            panel.buttonHeight = 28
                            panel.input:SetWidth(390)
                    
                            panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
                            panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        else
                            panel.buttonWidth = 325
                            panel.buttonHeight = 28
                            panel.input:SetWidth(307)
                            
            				panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
            				panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        end
                    end
                    
				
				panel.Start = function(panel) panel.Render(panel, panel.startlink) end
				
				panel.Back = 
					function(panel) 
						panel.Render(panel, panel.history[#panel.history]); 
						panel.history[#panel.history] = nil; 
						if ( #panel.history == 0 ) then panel:GetParent().back:Disable() end 
						end
						
				panel.Reset = 	
					function(panel) 
									panel.history = {}; 
									panel:GetParent().back:Disable();
									panel.scrollResults = {};
									panel.scroll.index = nil;
									for index, panelElement in next, panel:GetParent().panels do 
										if ( panelElement.name == "StatusPanel" ) then
											panelElement.status = {}
											for num, line in next, panelElement.infoLines do
												line.value:SetText("")
											end
										end
									end
									panel.table = FEEDBACKUI_BUGWELCOMETABLE; 
									panel.Render(panel) 
								end
								
				panel.Submit = 
					function(panel)
						panel.infoString = "";
						local infoTable = {};
						local bs=FEEDBACKUI_DELIMITER;
						for _, panelElement in next, panel:GetParent().panels do 
							if ( panelElement.name == "StatusPanel" ) then
								for num, line in next, panelElement.infoLines do
									infoTable[line.type] = ( line.value:GetText() or "" )
								end
							elseif ( panelElement.name == "InfoPanel" ) then
								for index, value in next, panelElement.infoTable do
									infoTable[index] = value
								end
							end
						end
						
						for index, field in next, FEEDBACKUI_FIELDS do
							if not ( infoTable[field] ) then
								infoTable[field] = ""
								panel.infoString = panel.infoString .. bs
							else
								panel.infoString = panel.infoString .. string.gsub(infoTable[field],"\n"," ")..bs
							end
						end
						
						inputString = string.gsub(panel.input:GetText(), "\n", " ");
						inputString = string.gsub(inputString, bs, " ");
						panel.infoString = panel.infoString .. inputString;
						ReportBug(panel.infoString);
						UIErrorsFrame:Clear();
						UIErrorsFrame:AddMessage(FEEDBACKUI_CONFIRMATION, 1, 1, .1, 1.0, 5);
						pcall(panel.Reset, panel)
						FeedbackUI:Hide();
					end
				
				panel.UpdateButtons = 
					function(panel) 
						panel.CreateButtons(panel)
					end
										
				panel.Click = 	
					function(panel, element)
						if ( not panel or not element ) then return end;
						table.insert(panel.history, panel.table);
						panel.parent.back:Enable();
                        
						
						if ( element.summary ) then
							for index, panelElement in next, panel:GetParent().panels do
								if ( panelElement.name == "StatusPanel" ) then
									for num, line in next, panelElement.infoLines do
										if ( line.type == element.summary.type ) then
											line.value:SetText(getglobal(element.summary.value));

											panelElement.status[line.type] = getglobal(element.summary.value);
										end
									end
								end
							end
						end
						
						if getglobal(element.link) then
							panel.Render(panel, getglobal(element.link));
						else
							panel.Render(panel, element.link);
						end
						
					end
				
				panel.Render = 	
					function(panel, renderTable)	
					
						-- Reset all the tracking values to their defaults, and hide all the buttons and things that will later be shown.
						panel.scroll:Hide();
						panel.prompt:Hide();
						panel.edit:Hide();
						panel:GetParent().start:Hide();
						panel:GetParent().back:Hide();
						panel:GetParent().reset:Hide();
						panel:GetParent().submit:Hide();
						panel.scroll.thumb:Disable()
						panel.scrollResults = {};
						
						for i = 1, #panel.scroll.buttons do
							panel.scroll.buttons[i]:Hide();
						end
						
						--Make sure we have something to render. If we get the "edit" string, then show the edit box.
						if ( not renderTable ) then 
							renderTable = panel.table 
						elseif ( ( type(renderTable) == "string" )  and ( renderTable == "edit" ) ) then 
							panel.table = renderTable;
							local headerFrame = panel.header:GetParent();
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.header);
							panel.header:SetText(FEEDBACKUI_BUGINPUTHEADER)
							panel.subtext:SetText("")
							panel.input:SetText(FEEDBACKUIBUGFRMINPUTBOX_TEXT)
							panel.input.default = FEEDBACKUIBUGFRMINPUTBOX_TEXT
							panel.scroll:Hide();
							panel:GetParent().back:Show();
							panel:GetParent().reset:Show();
							panel:GetParent().submit:Show();
							panel.edit:Show();
							return;
						else
							panel.table = renderTable 
						end;
											
						if ( renderTable.header == "" and renderTable.subtext ) then
							local headerFrame = panel.header:GetParent();
							panel.header:ClearAllPoints()
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.subtext);
							panel.subtext:SetText("");
						else
							if ( renderTable.header ) then
								local headerFrame = panel.header:GetParent();
								panel.header:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", 8, -6)
								panel.header:SetText(renderTable.header);
							end
							
							if renderTable.subtext then
								panel.subtext:SetText(renderTable.subtext);
							end
						end
						
						local i = 0;
						for ordinal, element in ipairs(renderTable) do
							--Clear downlevel status lines.
							local maxSummary = math.huge
							if ( element.summary ) then
								for index, panelElement in next, panel:GetParent().panels do
									if ( panelElement.name == "StatusPanel" ) then
										for num, line in next, panelElement.infoLines do
											if ( line.type == element.summary.type ) then
												maxSummary = num;
											end
											if ( num >= maxSummary ) then 
												line.value:SetText("") 
												panelElement.status[line.type] = nil;
											elseif ( ( num < maxSummary ) and ( line.value:GetText() == "" or line.value:GetText() == nil ) ) then
                                                panelElement.status[line.type] = "N/A";
                                                line.value:SetText("N/A");
											end
										end
									end
								end
							end

							i = i + 1;
							panel.scrollResults[ordinal] = element;
							if ( element.prompt ) then
								panel.prompt:Show();
								panel:GetParent().start:Show();
								panel.prompt:SetText(element.prompt);
								panel.startlink = getglobal(element.link);
							else											
								panel.scroll:Show();
								panel:GetParent().start:Hide();
								panel:GetParent().back:Show();
								panel:GetParent().reset:Show();
								panel:GetParent().submit:Show();
								if ( panel.scroll.buttons[i] ) then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - ( element.offset * FEEDBACKUI_OFFSETPIXELS ) - 15)
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - 15)
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.scroll.index = 1;
						panel.UpdateScrollButtons(panel);
					end
			
				panel.SetScrollVars = 	
					function(panel)
						-- Calculate values necessary to scroll
						panel.scroll.maxy = (panel.scroll.controls:GetTop() - 5);
						panel.scroll.miny = (panel.scroll.controls:GetBottom() + 13);
						panel.scroll.steprange = panel.scroll.maxy - panel.scroll.miny;
						panel.scroll.numsteps = #panel.scrollResults - #panel.scroll.buttons;
						panel.scroll.stepsize = panel.scroll.steprange / panel.scroll.numsteps;				
					end
			
				panel.ScrollOnUpdate =
					function(panel, elapsed)
						if ( not panel.timer ) then panel.timer = 0 end
						panel.timer = panel.timer + elapsed;
						if ( panel.timer > 0.1 ) then
							panel.SetScrollVars(panel);
							
							
							-- Compensate for UI scaling
							-- yarealy
							local realx, realy = GetCursorPosition();
							x = realx / panel:GetEffectiveScale();
							y = realy / panel:GetEffectiveScale();
							
							-- See where the user is trying to move the thumb to.
							local moveVariable = -(panel.scroll.maxy - y)
													
							if ( moveVariable > 0 ) then
								-- If the user has tried to move the thumb to the top of the track or above it, go to the first result.
								panel.scroll.thumb:ClearAllPoints();
								panel.scroll.thumb:SetPoint("TOP", 0, 0);
								panel.scroll.index = 1;
							elseif ( math.abs(moveVariable) > (panel.scroll.maxy - panel.scroll.miny) ) then
								-- If the user has tried to move the thumb to the bottom of the track or below it, go to the last result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, -(panel.scroll.maxy - panel.scroll.miny))
								panel.scroll.index = ( #panel.scrollResults - #panel.scroll.buttons + 1 )
							else
								-- Otherwise, move the scroll thumb to the appropriate position and go to the appropriate result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, moveVariable);
								
								local tempStep = math.round( (math.abs(moveVariable) / panel.scroll.stepsize ) ) + 1;
								if ( tempStep ~= panel.scroll.index ) then
									-- Determine the target index, and if it's not the current index, then change the index.
									panel.scroll.index = tempStep
								end
							end
							panel.ScrollButtons(panel)							
						end
					end
			
				panel.StartScroll =
					function(panel)
						if ( panel.scroll.thumb:IsEnabled() == 1 ) then
							panel.scroll.update:Show();
						end
					end
					
				panel.StopScroll =
					function(panel)
						panel.scroll.update:Hide()
					end					
			
				panel.UpdateScrollButtons =
					function(panel)
					
						-- Update the position of the scroll thumb
						panel.SetScrollVars(panel);
						if not ( panel.scroll.update:IsVisible() == 1 ) then
							panel.scroll.thumb:ClearAllPoints();
							local moveto = -(panel.scroll.stepsize * ( panel.scroll.index -1))
							if ( moveto > 0 ) then moveto = -moveto end -- Yay crappy failsafes!
							panel.scroll.thumb:SetPoint("TOP", 0, moveto);
						end
						
						-- Enable the up button if appropriate
						if ( panel.scroll.index > 1 ) then
							panel.scroll.upbtn:Enable()
						else
							panel.scroll.upbtn:Disable()
						end
						
						-- Enable the down button if appropriate
						if ( ( panel.scroll.index + #panel.scroll.buttons ) <= #panel.scrollResults ) then
							panel.scroll.downbtn:Enable()
						else
							panel.scroll.downbtn:Disable();
						end
						
						-- Enable the scroll thumb if either the up or down button is enabled.
						if ( ( panel.scroll.upbtn:IsEnabled() == 1 ) or ( panel.scroll.downbtn:IsEnabled() == 1 ) ) then
							panel.scroll.thumb:Enable();
						else
							panel.scroll.thumb:Disable();
						end
					end
			
				panel.MoveScroll = 	
					function(panel, int)
						if ( ( panel.scroll.index + int >= 1 ) and ( ( panel.scroll.index + int ) + #panel.scroll.buttons <= ( #panel.scrollResults + 1 ) ) ) then
							panel.scroll.index = panel.scroll.index + int
						end
						panel.ScrollButtons(panel)						
					end
			
				panel.ScrollButtons = 
					function(panel)
						local i = 0;
						
						for ordinal, element in ipairs(panel.table) do
							if ( ordinal >= panel.scroll.index ) then
								i = i + 1;
								if panel.scroll.buttons[i] then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - ( element.offset * FEEDBACKUI_OFFSETPIXELS ) - 15)
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - 15)
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.UpdateScrollButtons(panel);
					end
			
				panel.CreateButtons = 
					function(panel)
						if ( panel.scroll and panel.scroll.buttons ) then
							local buttoncapacity = ( math.floor(((panel.scroll:GetHeight()) / panel.scroll.buttons[1]:GetHeight())) )
							local numbuttons = #panel.scroll.buttons;
							if numbuttons < buttoncapacity and buttoncapacity > panel.maxbuttons then
								for i = 1, buttoncapacity - numbuttons do
									local newButton = CreateFrame("Button", string.gsub(panel.scroll.buttons[1]:GetName(), "%d+", "") .. (numbuttons + i), panel.scroll, "ScrollElementTemplate")
									newButton:SetPoint("TOPLEFT", panel.scroll.buttons[numbuttons + i - 1], "BOTTOMLEFT", 0, 0)
									newButton:SetWidth(panel.scroll.buttons[1]:GetWidth());
									newButton:SetHeight(panel.scroll.buttons[1]:GetHeight());
									table.insert(panel.scroll.buttons, newButton)
									newButton.index = #panel.scroll.buttons;
								end
								panel.maxbuttons = buttoncapacity;
							end
						else
						end
					end	
					
			end
	}
	
--Create panels for the Suggest form--
FeedbackUI_SetupPanel{
	name = "InfoPanel",
	labelText = FEEDBACKUIINFOPANELLABEL_TEXT,
	parent = "FeedbackUISuggestFrame",
	inherits = "FeedbackPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPLEFT", ["x"] = -2, ["y"] = -28 }, 
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPRIGHT", ["x"] = 2, ["y"] = -28 } },
	size = { ["y"] = 130 },
	Setup = function(obj)
				obj.infoLines = {}
				obj.infoTable = {}
			end,
	event = {"ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA", "PLAYER_LEVEL_UP" },
	Handler = function() if ( event == "PLAYER_LEVEL_UP" ) then 
							for _, line in next, this.infoLines do
								if ( line:GetName():match("Char") ) then 
									local parent = this;
									local genderTable = FEEDBACKUI_GENDERTABLE;
									if ( not parent.infoTable ) then
										parent.infoTable = {}
									end
									parent.infoTable["character"] = "Lvl "..arg1.." "..UnitRace("player").." "..genderTable[UnitSex("player")].." "..UnitClass("player");
									parent.infoTable["level"] = arg1;
									parent.infoTable["race"] = UnitRace("player");
									parent.infoTable["sex"] = genderTable[UnitSex("player")];
									parent.infoTable["class"] = UnitClass("player");
									line.value:SetText(parent.infoTable["character"])
								end
							end
						else
							pcall(this.Show, this) end
						end,	 					
	Show = 	function(obj) 
				for _, line in next, obj.infoLines do
					if ( line.Update ) then line.Update(line) end
				end	
			end,
	Load = 	function(obj)
				for _, line in next, obj.infoLines do
					if ( line.Load ) then line.Load(line) end
				end
			end }

--Lines for the Suggest form's InfoPanel--
FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Version",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMVER_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["version"], parent.infoTable["build"], parent.infoTable["date"] = GetBuildInfo();
				line.value:SetText("WoW " .. parent.infoTable["version"] .. " \[Release\] Build " .. parent.infoTable["build"]);
			end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Realm",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMREALM_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["realm"] = GetRealmName();
				line.value:SetText(parent.infoTable["realm"])
			end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Name",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMNAME_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			if ( not parent.infoTable ) then
				parent.infoTable = {};
			end
			parent.infoTable["name"] = UnitName("player");
			line.value:SetText(parent.infoTable["name"])
		end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Char",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMCHAR_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			local genderTable = FEEDBACKUI_GENDERTABLE;
			if ( not parent.infoTable ) then
				parent.infoTable = {}
			end
			parent.infoTable["character"] = "Lvl "..UnitLevel("player").." "..UnitRace("player").." "..genderTable[UnitSex("player")].." "..UnitClass("player");
			parent.infoTable["level"] = UnitLevel("player");
			parent.infoTable["race"] = UnitRace("player");
			parent.infoTable["sex"] = genderTable[UnitSex("player")];
			parent.infoTable["class"] = UnitClass("player");
			line.value:SetText(parent.infoTable["character"])
		end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Map",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMMAP_TEXT,
	Update = function(line)
			local parent = line:GetParent();
			if ( not parent.infoTable ) then
				parent.infoTable = {}
			end
			
			--Record positioning information with the Map line since there isn't any particular place to do it with the new format.
			local debugStats, parseString
			
			if ( GetDebugStats() ) then 
				debugStats = {}
				parseString="([^%c]+)";
				for line in string.gmatch(GetDebugStats(), parseString) do
					table.insert(debugStats, line)
				end
			else
				debugStats = ""
			end	
			
			if ( debugStats ~= "" ) then 
				parent.infoTable["position"] = string.gsub(debugStats[2], "Player position: ", "");
				parent.infoTable["facing"] = debugStats[3]
				parent.infoTable["object"] = debugStats[4]
				parent.infoTable["chunk"] = debugStats[5]
			end
			
			local x, y = GetPlayerMapPosition("player");
			x = math.floor(x * 100)
			y = math.floor(y * 100)
			parent.infoTable["coords"] = x..", "..y	
			
			local mapCompare = { GetMapContinents() };
			SetMapToCurrentZone();
			parent.infoTable["map"] = mapCompare[GetCurrentMapContinent()];
			line.value:SetText(parent.infoTable["map"])
		end
	}

FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Zone",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMZONE_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["zone"] = GetRealZoneText();
				line.value:SetText(parent.infoTable["zone"])
			end	
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Area",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMAREA_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				end
				parent.infoTable["area"] = GetSubZoneText();
				line.value:SetText(parent.infoTable["area"])
			end
	}
	
FeedbackUI_AddInfoLine{
	parent="FeedbackUISuggestFrameInfoPanel",
	name="Addons",
	inherits="InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMADDONS_TEXT,
	Update = function(line)
				local parent = line:GetParent();
				if ( not parent.infoTable ) then
					parent.infoTable = {}
				else
					parent.infoTable["addons"] = nil
					parent.infoTable["addonloaded"] = nil
					parent.infoTable["addonsWrap"] = nil
				end
				local addonsList, addonsListCount, wrapCount, tempArray
				
				addonsList = {}
				for i = 1, GetNumAddOns() do
					local infoTable = { GetAddOnInfo(i) };
					table.insert(addonsList, infoTable)
				end
				if ( addonsList == nil ) then addonsList = { "None" } end
								
				addonsListCount = table.maxn(addonsList)
				wrapCount = 1
				
				for i = 1, addonsListCount do
					if not ( parent.infoTable["addons"] ) then
						if ( addonsList[i][4] == 1 ) then
							parent.infoTable["addonsloaded"] = addonsList[i][1]
							parent.infoTable["addonsWrap"] = HIGHLIGHT_FONT_COLOR_CODE..FEEDBACKUILBLADDONSWRAP_TEXT..FONT_COLOR_CODE_CLOSE..addonsList[i][1];					
							wrapCount = 1;
						end
						parent.infoTable["addons"] = addonsList[i][1];
					else
						if ( addonsList[i][4] == 1 ) then
							if not ( parent.infoTable["addonsWrap"] ) then
								parent.infoTable["addonsloaded"] = addonsList[i][1]
								parent.infoTable["addonsWrap"] = HIGHLIGHT_FONT_COLOR_CODE..FEEDBACKUILBLADDONSWRAP_TEXT..FONT_COLOR_CODE_CLOSE..addonsList[i][1];					
								wrapCount = 1;
							elseif ( ( wrapCount / 3) == math.floor( wrapCount / 3 ) ) then
								parent.infoTable["addonsloaded"] = parent.infoTable["addonsloaded"]..", "..addonsList[i][1]
								parent.infoTable["addonsWrap"] = parent.infoTable["addonsWrap"].."\n"..addonsList[i][1];
								wrapCount = wrapCount + 1;
							else
								parent.infoTable["addonsloaded"] = parent.infoTable["addonsloaded"]..", "..addonsList[i][1]
								parent.infoTable["addonsWrap"] = parent.infoTable["addonsWrap"]..", "..addonsList[i][1];
								wrapCount = wrapCount + 1;
							end
						end
						parent.infoTable["addons"] = parent.infoTable["addons"]..", "..addonsList[i][1];
					end	
				end
				
				if ( parent.infoTable["addonsWrap"] ) then
					local blankWidth = line.value:GetWidth();
					line.value:SetText(parent.infoTable["addonsloaded"]);
					if ( line.value:GetStringWidth() > blankWidth - 15) then
						line.value:SetText(FEEDBACKUILBLADDONS_MOUSEOVER);
					end
				end
			end,
	
	Setup = function(line)				
				line:SetScript("OnEnter", 
								function()
									this:SetScript("OnUpdate", 
										function() 
											local x, y = GetCursorPosition();
											x = x / this:GetEffectiveScale();
											y = y / this:GetEffectiveScale();
											local value = getglobal(this:GetName() .. "Value")
											if ( x > (value:GetLeft() + ( value:GetWidth() / this:GetEffectiveScale() ) ) - ( value:GetStringWidth() + 15 ) / this:GetEffectiveScale() ) then
												GameTooltip:SetOwner(this, "ANCHOR_CURSOR"); 
												GameTooltip:SetText(this:GetParent().infoTable["addonsWrap"]) 
											else
												GameTooltip:Hide()
											end
										end)
								end);
				line:SetScript("OnLeave", function() GameTooltip:Hide(); this:SetScript("OnUpdate", nil) end )
			end,
	
	handlers = { 	{ ["type"] = "OnEnter",	["func"] = 	function(line) 
																DEFAULT_CHAT_FRAME:AddMessage("Entered");
																GameTooltip:SetOwner(line, "ANCHOR_CURSOR"); GameTooltip:SetText(line.infoTable["addonsWrap"]);
															end }, 
					{ ["type"] = "OnLeave", ["func"] = 	function() GameTooltip:Hide() end } }
	}
			
FeedbackUI_SetupPanel{
	name = "StatusPanel",
	parent = "FeedbackUISuggestFrame",
	inherits = "FeedbackPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentInfoPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = 3 },
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parentInfoPanel", ["relativepoint"] = "TOPRIGHT", ["x"] = 0, ["y"] = 3 } },
	size = { ["y"] = 70 },
	Setup = function(obj)
				-- Create the seperator line that follows the Status panel.
				obj.seperator = CreateFrame("Frame", obj:GetName() .. "Line", obj, "FeedbackLineTemplate");
				obj.seperator:SetPoint("TOPLEFT", obj, "BOTTOMLEFT", 0, -5);
				obj.seperator:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", 0, -5);
				obj.status = {};
                obj.infoLines = {};
			end,
	Show = 	function(panel)
				for _, line in next, panel.infoLines do
					if ( line.Update ) then 
                        line.Update(line, panel)
                    end
				end	
			end
	
	}

FeedbackUI_AddInfoLine{
	name = "Where",
	parent = "FeedbackUISuggestFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHERE_TEXT,
	Setup = function(line)
				line.type = "where"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}
			
FeedbackUI_AddInfoLine{
	name = "Who",
	parent = "FeedbackUISuggestFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHO_TEXT,
	Setup = function(line)
				line.type = "who"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}

FeedbackUI_AddInfoLine{
	name = "Type",
	parent = "FeedbackUISuggestFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMTYPE_TEXT,
	Setup = function(line)
				line.type = "type"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}			
					
FeedbackUI_AddInfoLine{
	name = "When",
	parent = "FeedbackUISuggestFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMWHEN_TEXT,
	Setup = function(line)
				line.type = "when"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}	
				
FeedbackUI_SetupPanel{
	name = "StepThroughPanel",
	parent = "FeedbackUISuggestFrame",
	inherits = "FeedbackWizardTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentStatusPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = -1 },
				{ ["point"] = "BOTTOMRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "BOTTOMRIGHT", ["x"] = 2, ["y"] = 19 } },
	Setup = function (panel)
				panel.maxbuttons = 1
				panel.scrollResults = {}
				panel.history = {}
				panel.table = FEEDBACKUI_SUGGESTWELCOMETABLE
				
                panel.Localize = 
                    function(panel)
                        if GetLocale() == "esES" or GetLocale() == "frFR" or GetLocale() == "deDE" then
                            panel.buttonWidth = 415
                            panel.buttonHeight = 28
                            panel.input:SetWidth(390)
                    
                            panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
                            panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        else
                            panel.buttonWidth = 325
                            panel.buttonHeight = 28
                            panel.input:SetWidth(307)
                            
            				panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
            				panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        end
                    end
				
				panel.Start =   
                    function (panel) 
                        panel.Render(panel, panel.startlink) 
                    end
				
				panel.Back = 
					function (panel) 
						panel.Render(panel, panel.history[#panel.history]); 
						panel.history[#panel.history] = nil; 
						if ( #panel.history == 0 ) then panel:GetParent().back:Disable() end 
					end
						
				panel.Reset = 	
					function (panel) 
                        panel.history = {}; 
                        panel:GetParent().back:Disable();
                        panel.scrollResults = {};
                        panel.scroll.index = nil;
                        for index, panelElement in next, panel:GetParent().panels do 
                            if ( panelElement.name == "StatusPanel" ) then
                                panelElement.status = {}
                                for num, line in next, panelElement.infoLines do
                                    line.value:SetText("")
                                end
                            end
                        end
                        panel.table = FEEDBACKUI_SUGGESTWELCOMETABLE; 
                        panel.Render(panel) 
                    end
								
				panel.Submit = 
					function (panel)
						panel.infoString = "";
						local infoTable = {};
						local bs=FEEDBACKUI_DELIMITER;
						for _, panelElement in next, panel:GetParent().panels do 
							if ( panelElement.name == "StatusPanel" ) then
								for num, line in next, panelElement.infoLines do
									infoTable[line.type] = ( line.value:GetText() or "" )
								end
							elseif ( panelElement.name == "InfoPanel" ) then
								for index, value in next, panelElement.infoTable do
									infoTable[index] = value
								end
							end
						end
						
						for index, field in next, FEEDBACKUI_FIELDS do
							if not ( infoTable[field] ) then
								infoTable[field] = ""
								panel.infoString = panel.infoString .. bs
							else
								panel.infoString = panel.infoString .. string.gsub(infoTable[field],"\n"," ")..bs
							end
						end
						
						inputString = string.gsub(panel.input:GetText(), "\n", " ");
						inputString = string.gsub(inputString, bs, " ");
						panel.infoString = panel.infoString .. inputString;
						ReportSuggestion(panel.infoString);
						UIErrorsFrame:Clear();
						UIErrorsFrame:AddMessage(FEEDBACKUI_CONFIRMATION, 1, 1, .1, 1.0, 5);
						pcall(panel.Reset, panel)
						FeedbackUI:Hide();
					end
				
				panel.UpdateButtons = 
					function (panel) 
						panel.CreateButtons(panel)
					end
										
				panel.Click = 	
					function (panel, element)
						if ( not panel or not element ) then return end;
						table.insert(panel.history, panel.table);
						panel.parent.back:Enable();
						
						if ( element.summary ) then
							for index, panelElement in next, panel:GetParent().panels do
								if ( panelElement.name == "StatusPanel" ) then
									for num, line in next, panelElement.infoLines do
										if ( line.type == element.summary.type ) then
											line.value:SetText(getglobal(element.summary.value));

											panelElement.status[line.type] = getglobal(element.summary.value);
										end
									end
								end
							end
						end
						
						if getglobal(element.link) then
							panel.Render(panel, getglobal(element.link));
						else
							panel.Render(panel, element.link);
						end
						
					end
				
				panel.Render = 	
					function (panel, renderTable)	
					
						-- Reset all the tracking values to their defaults, and hide all the buttons and things that will later be shown.
						panel.scroll:Hide();
						panel.prompt:Hide();
						panel.edit:Hide();
						panel:GetParent().start:Hide();
						panel:GetParent().back:Hide();
						panel:GetParent().reset:Hide();
						panel:GetParent().submit:Hide();
						panel.scroll.thumb:Disable()
						panel.scrollResults = {};
						
						for i = 1, #panel.scroll.buttons do
							panel.scroll.buttons[i]:Hide();
						end
						
						--Make sure we have something to render. If we get the "edit" string, then show the edit box.
						if ( not renderTable ) then 
							renderTable = panel.table 
						elseif ( ( type(renderTable) == "string" )  and ( renderTable == "edit" ) ) then 
							panel.table = renderTable;
							local headerFrame = panel.header:GetParent();
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.header);
							panel.header:SetText(FEEDBACKUI_SUGGESTINPUTHEADER)
							panel.subtext:SetText("")
							panel.input:SetText(FEEDBACKUISUGGESTFRMINPUTBOX_TEXT)
							panel.input.default = FEEDBACKUISUGGESTFRMINPUTBOX_TEXT
							panel.scroll:Hide();
							panel:GetParent().back:Show();
							panel:GetParent().reset:Show();
							panel:GetParent().submit:Show();
							panel.edit:Show();
							return;
						else
							panel.table = renderTable 
						end;
											
						if ( renderTable.header == "" and renderTable.subtext ) then
							local headerFrame = panel.header:GetParent();
							panel.header:ClearAllPoints()
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.subtext);
							panel.subtext:SetText("");
						else
							if ( renderTable.header ) then
								local headerFrame = panel.header:GetParent();
								panel.header:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", 8, -6)
								panel.header:SetText(renderTable.header);
							end
							
							if ( renderTable.subtext ) then
								panel.subtext:SetText(renderTable.subtext);
							end
						end
						
						local i = 0;
						for ordinal, element in ipairs(renderTable) do
							--Clear downlevel status lines, populate uplevel status lines.
							local maxSummary = math.huge
							if ( element.summary ) then
								for index, panelElement in next, panel:GetParent().panels do
									if ( panelElement.name == "StatusPanel" ) then
										for num, line in next, panelElement.infoLines do
											if ( line.type == element.summary.type ) then
												maxSummary = num;
											end
											if ( num >= maxSummary ) then 
												line.value:SetText("") 
												panelElement.status[line.type] = nil;
											elseif ( ( num < maxSummary ) and ( line.value:GetText() == "" or line.value:GetText() == nil ) ) then
                                                panelElement.status[line.type] = "N/A";
                                                line.value:SetText("N/A");
											end
										end
									end
								end
							end

							i = i + 1;
							panel.scrollResults[ordinal] = element;
							if ( element.prompt ) then
								panel.prompt:Show();
								panel:GetParent().start:Show();
								panel.prompt:SetText(element.prompt);
								panel.startlink = getglobal(element.link);
							else											
								panel.scroll:Show();
								panel:GetParent().start:Hide();
								panel:GetParent().back:Show();
								panel:GetParent().reset:Show();
								panel:GetParent().submit:Show();
								if ( panel.scroll.buttons[i] ) then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - ( element.offset * FEEDBACKUI_OFFSETPIXELS ) - 15)
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - 15)
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.scroll.index = 1;
						panel.UpdateScrollButtons(panel);
					end
			
				panel.SetScrollVars = 	
					function(panel)
						-- Calculate values necessary to scroll
						panel.scroll.maxy = (panel.scroll.controls:GetTop() - 5);
						panel.scroll.miny = (panel.scroll.controls:GetBottom() + 13);
						panel.scroll.steprange = panel.scroll.maxy - panel.scroll.miny;
						panel.scroll.numsteps = #panel.scrollResults - #panel.scroll.buttons;
						panel.scroll.stepsize = panel.scroll.steprange / panel.scroll.numsteps;				
					end
			
				panel.ScrollOnUpdate =
					function(panel, elapsed)
						if ( not panel.timer ) then panel.timer = 0 end
						panel.timer = panel.timer + elapsed;
						if ( panel.timer > 0.1 ) then
							panel.SetScrollVars(panel);
							
							
							-- Compensate for UI scaling
							-- yarealy
							local realx, realy = GetCursorPosition();
							x = realx / panel:GetEffectiveScale();
							y = realy / panel:GetEffectiveScale();
							
							-- See where the user is trying to move the thumb to.
							local moveVariable = -(panel.scroll.maxy - y)
													
							if ( moveVariable > 0 ) then
								-- If the user has tried to move the thumb to the top of the track or above it, go to the first result.
								panel.scroll.thumb:ClearAllPoints();
								panel.scroll.thumb:SetPoint("TOP", 0, 0);
								panel.scroll.index = 1;
							elseif ( math.abs(moveVariable) > (panel.scroll.maxy - panel.scroll.miny) ) then
								-- If the user has tried to move the thumb to the bottom of the track or below it, go to the last result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, -(panel.scroll.maxy - panel.scroll.miny))
								panel.scroll.index = ( #panel.scrollResults - #panel.scroll.buttons + 1 )
							else
								-- Otherwise, move the scroll thumb to the appropriate position and go to the appropriate result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, moveVariable);
								
								local tempStep = math.round( (math.abs(moveVariable) / panel.scroll.stepsize ) ) + 1;
								if ( tempStep ~= panel.scroll.index ) then
									-- Determine the target index, and if it's not the current index, then change the index.
									panel.scroll.index = tempStep
								end
							end
							panel.ScrollButtons(panel)							
						end
					end
			
				panel.StartScroll =
					function(panel)
						if ( panel.scroll.thumb:IsEnabled() == 1 ) then
							panel.scroll.update:Show();
						end
					end
					
				panel.StopScroll =
					function(panel)
						panel.scroll.update:Hide()
					end					
			
				panel.UpdateScrollButtons =
					function(panel)
					
						-- Update the position of the scroll thumb
						panel.SetScrollVars(panel);
						if not ( panel.scroll.update:IsVisible() == 1 ) then
							panel.scroll.thumb:ClearAllPoints();
							local moveto = -(panel.scroll.stepsize * ( panel.scroll.index -1))
							if ( moveto > 0 ) then moveto = -moveto end -- Yay crappy failsafes!
							panel.scroll.thumb:SetPoint("TOP", 0, moveto);
						end
						
						-- Enable the up button if appropriate
						if ( panel.scroll.index > 1 ) then
							panel.scroll.upbtn:Enable()
						else
							panel.scroll.upbtn:Disable()
						end
						
						-- Enable the down button if appropriate
						if ( ( panel.scroll.index + #panel.scroll.buttons ) <= #panel.scrollResults ) then
							panel.scroll.downbtn:Enable()
						else
							panel.scroll.downbtn:Disable();
						end
						
						-- Enable the scroll thumb if either the up or down button is enabled.
						if ( ( panel.scroll.upbtn:IsEnabled() == 1 ) or ( panel.scroll.downbtn:IsEnabled() == 1 ) ) then
							panel.scroll.thumb:Enable();
						else
							panel.scroll.thumb:Disable();
						end
					end
			
				panel.MoveScroll = 	
					function(panel, int)
						if ( ( panel.scroll.index + int >= 1 ) and ( ( panel.scroll.index + int ) + #panel.scroll.buttons <= ( #panel.scrollResults + 1 ) ) ) then
							panel.scroll.index = panel.scroll.index + int
						end
						panel.ScrollButtons(panel)						
					end
			
				panel.ScrollButtons = 
					function(panel)
						local i = 0;
						
						for ordinal, element in ipairs(panel.table) do
							if ( ordinal >= panel.scroll.index ) then
								i = i + 1;
								if panel.scroll.buttons[i] then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - ( element.offset * FEEDBACKUI_OFFSETPIXELS ) - 15)
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
                                        panel.scroll.buttons[i].text:SetWidth(panel.buttonWidth - 15)
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.UpdateScrollButtons(panel);
					end
			
				panel.CreateButtons = 
					function(panel)
						if ( panel.scroll and panel.scroll.buttons ) then
							local buttoncapacity = ( math.floor(((panel.scroll:GetHeight()) / panel.scroll.buttons[1]:GetHeight())) )
							local numbuttons = #panel.scroll.buttons;
							if numbuttons < buttoncapacity and buttoncapacity > panel.maxbuttons then
								for i = 1, buttoncapacity - numbuttons do
									local newButton = CreateFrame("Button", string.gsub(panel.scroll.buttons[1]:GetName(), "%d+", "") .. (numbuttons + i), panel.scroll, "ScrollElementTemplate")
									newButton:SetPoint("TOPLEFT", panel.scroll.buttons[numbuttons + i - 1], "BOTTOMLEFT", 0, 0)
									newButton:SetWidth(panel.buttonWidth);
									newButton:SetHeight(panel.buttonHeight);
									table.insert(panel.scroll.buttons, newButton)
									newButton.index = #panel.scroll.buttons;
								end
								panel.maxbuttons = buttoncapacity;
							end
						else
							
						end
					end	
					
			end
	}			
	
--Create panels for the Survey form--
FeedbackUI_SetupPanel{
	name = "SurveysPanel",
	parent = "FeedbackUISurveyFrame",
	inherits = "FeedbackSurveyPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPLEFT", ["x"] = -2, ["y"] = -14 },
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "TOPRIGHT", ["x"] = 2, ["y"] = -14 } },
	size = { ["y"] = 185 },
	event = { "ZONE_CHANGED_NEW_AREA", "VARIABLES_LOADED", "PLAYER_ENTERING_WORLD" },
	Show = 
		function(panel)		
			panel.PopulateTable(panel)
            g_FeedbackUI_feedbackVars["sortdir"] = "dated"; 
            panel.SortResults(panel, "date");
		end,
    Load =
        function(panel)

            if ( not g_FeedbackUI_feedbackVars ) then
                g_FeedbackUI_feedbackVars = {}
                g_FeedbackUI_feedbackVars["alerts"] = true;
            end
            g_FeedbackUI_feedbackVars["lastZone"] = nil;
                    
            if ( not g_FeedbackUI_surveysTable ) then
                g_FeedbackUI_surveysTable = {}
            end
            
            if ( not g_FeedbackUI_feedbackVars["switchedHash"] ) then
                g_FeedbackUI_surveysTable["Quests"] = {};
                g_FeedbackUI_surveysTable["Alerts"] = {};
                g_FeedbackUI_feedbackVars["switchedHash"] = true;
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
            
            if g_FeedbackUI_feedbackVars["alerts"] then
                panel.alertCheck:SetChecked(true)
            else
                panel.alertCheck:SetChecked(false)
            end
           
            panel.SortResults(panel, "date");
            panel.PopulateTable(panel);
            panel.UpdateAlertButtons(panel);
            panel.LoadCategory(panel.ddlCategory);
            UIDropDownMenu_Initialize(panel.ddlCategory, panel.DdlCategory_Initialize);
            panel.LoadStatus(panel.ddlStatus);
            UIDropDownMenu_Initialize(panel.ddlStatus, panel.DdlStatus_Initialize);
            tinsert(panel.tasks, {
                                func = 
                                    function(panel)
                                        panel:UnregisterEvent("QUEST_LOG_UPDATE")
                                        panel.UpdateQuestSurveys(panel);
                                        panel:RegisterEvent("QUEST_LOG_UPDATE")
                                        panel.PopulateTable(panel)
                                    end,
                                args = { panel },
                                exTime = GetTime() + .5 });  
            
        end,
	Handler = 
			function()
				local panel = FeedbackUISurveyFrameSurveysPanel;
                if ( event == "ZONE_CHANGED_NEW_AREA" ) or ( event == "PLAYER_ENTERING_WORLD" ) then                    
                    local currentZone = GetRealZoneText() or ""
                    local zoneFound = false;
                    
                    if ( g_FeedbackUI_feedbackVars["lastZone"] ) then                        
                        local tempSurvey = { ["type"] = "Instances", ["id"] = g_FeedbackUI_feedbackVars["lastZone"], ["name"] = g_FeedbackUI_feedbackVars["lastZone"] }
                        panel.AddSurvey(panel, tempSurvey)
                        panel.PopulateTable(panel);
                        g_FeedbackUI_feedbackVars["lastZone"] = nil;
                        return
                    end
                    
                    if currentZone == "" then return end
                    
                    for i, zname in next, FEEDBACKUI_NONINSTANCEZONES do
                        if ( currentZone == zname ) then
                            zoneFound = true;
                        end
                    end
                    
                    SetMapToCurrentZone();
                    local coords = { GetPlayerMapPosition("player") }
                    if coords[1] > 0 or coords[2] > 0 then
                        zoneFound = true;
                    end
                    
                    if ( not zoneFound ) then   
                        g_FeedbackUI_feedbackVars["lastZone"] = currentZone;
                    end                    
				elseif ( event == "QUEST_LOG_UPDATE" ) then
                    tinsert(panel.tasks, {
                                func = 
                                    function(panel)
                                        panel:UnregisterEvent("QUEST_LOG_UPDATE")
                                        panel.UpdateQuestSurveys(panel);
                                        panel:RegisterEvent("QUEST_LOG_UPDATE")
                                        panel.PopulateTable(panel)
                                    end,
                                args = { panel },
                                exTime = GetTime() + .5 });                                
				end
			end,
    OnUpdate = 
            function(panel, interval)
                panel.timeSinceLast = panel.timeSinceLast + interval;
                if panel.timeSinceLast > panel.UPDATEINTERVAL then
                    
                    for index, task in next, panel.tasks do
                        if ( task.exTime ) and ( GetTime() > task.exTime ) then
                            pcall(task.func, unpack(task.args))
                            tremove(panel.tasks, index);
                        else
                            pcall(task.func, unpack(task.args))
                            tremove(panel.tasks, index);
                        end
                    end
                    panel.timeSinceLast = 0;
                end
            end,
	Setup = 
			function(panel)                 
                if ( not g_FeedbackUI_feedbackVars ) then
                    g_FeedbackUI_feedbackVars = {}
                    g_FeedbackUI_feedbackVars["alerts"] = true;
                end
                g_FeedbackUI_feedbackVars["lastZone"] = nil;
                
                if ( not g_FeedbackUI_surveysTable ) then
                    g_FeedbackUI_surveysTable = {}
                end
            
                if ( not g_FeedbackUI_feedbackVars["switchedHash"] ) then
                    g_FeedbackUI_surveysTable["Quests"] = {};
                    g_FeedbackUI_surveysTable["Alerts"] = {};
                    g_FeedbackUI_feedbackVars["switchedHash"] = true;
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
                
                panel.Localize = 
                    function(panel)
                        if GetLocale() == "esES" or GetLocale() == "frFR" or GetLocale() == "deDE" then
                            panel.buttonWidth = 390
                            panel.buttonHeight = 15
                    
                            panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
                            panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        else
                            panel.buttonWidth = 325
                            panel.buttonHeight = 15
                            
            				panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
            				panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        end
                    end
                
                panel.AddAlert =
                    function (panel, prepSurvey)
                        if ( g_FeedbackUI_feedbackVars["alerts"] ) then
                            if not g_FeedbackUI_surveysTable["Alerts"] then return end;
                            table.insert(g_FeedbackUI_surveysTable["Alerts"], 1, prepSurvey)
                            if g_FeedbackUI_surveysTable["Alerts"][11] then
                                g_FeedbackUI_surveysTable["Alerts"][11] = nil;
                            end
                        end
                        pcall(panel.UpdateAlertButtons, panel)
                    end
                
                panel.CreateAlertButtons =
                    function (panel)
                        if ( panel.alert and panel.alert.buttons ) then
                            local buttonCapacity = C_FEEDBACKUI_MAXALERTS
                            local numButtons = #panel.alert.buttons;
                            if numButtons < buttonCapacity then
                                for i = 1, buttonCapacity - numButtons do
                                    local newButton = CreateFrame("Button", string.gsub(panel.alert.buttons[1]:GetName(), "%d+", "") .. (numButtons + i), panel.alert, "SurveyAlertButtonTemplate")
                                    newButton:SetPoint("TOPLEFT", panel.alert.buttons[numButtons + i - 1], "TOPRIGHT", 2, 0)
                                    newButton:SetWidth(panel.alert.buttons[1]:GetWidth());
                                    newButton:SetHeight(panel.alert.buttons[1]:GetHeight());
                                    table.insert(panel.alert.buttons, newButton)
                                    newButton.index = #panel.alert.buttons;
                                    newButton.panel = panel;
                                    newButton.alert = panel.alert;
                                end
                            end
                        elseif ( not panel.alert ) then
                            panel.alert = CreateFrame(  "Frame", 
                                                        panel:GetName() .. "AlertFrame", 
                                                        UIParent, 
                                                        "SurveyAlertFrameTemplate"
                                                    )
                            panel.alert:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 130);
                            panel.alert:SetWidth("100")
                            panel.alert:SetHeight("100")
                            panel.alert.panel = panel;
                            panel.CreateAlertButtons(panel);
                        end
                    end
                    
                panel.ScrollToAlert = 
                    function (panel, alertIndex)
                        if ( not panel ) or ( not alertIndex ) then return end
                        local targetButton
                        for index, element in ipairs(panel.table) do
                            if ( ( g_FeedbackUI_surveysTable["Alerts"][alertIndex] ) and 
                                  ( element.id == g_FeedbackUI_surveysTable["Alerts"][alertIndex].id ) ) then
                                if ( index <= #panel.scroll.buttons ) then
                                    for num, button in ipairs(panel.scroll.buttons) do
                                        if ( button.element ) and 
                                             ( button.element.id == element.id ) then
                                            targetButton = button;
                                            -- table.remove(g_FeedbackUI_surveysTable["Alerts"], alertIndex)
                                        end
                                    end
                                else
                                    local foundIndex = false
                                    while foundIndex == false do
                                        panel.MoveScroll(panel, 1)
                                        for num, button in ipairs(panel.scroll.buttons) do
                                            if ( button.element ) and 
                                                ( button.element.id == element.id ) then
                                                targetButton = button;
                                                foundIndex = true;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if type(targetButton) == "table" then
                            targetButton:Click();
                            FeedbackUITab3:Click();
                            if not FeedbackUI:IsVisible() then FeedbackUI_Show(); end
                        end
                    end
                    
                panel.UpdateAlertButtons =
                    function (panel)
                        local pulseCounter = 0;
                        for index, button in ipairs(panel.alert.buttons) do
                            button.lines = {};
                            if g_FeedbackUI_surveysTable["Alerts"][index] and g_FeedbackUI_feedbackVars["alerts"] then
                                local element = g_FeedbackUI_surveysTable["Alerts"][index]
                                if ( element.type ) and ( element.type == "Instances" ) then
                                    table.insert(button.lines, { ["left"] = FEEDBACKUI_WHITE .. FEEDBACKUIFEEDBACKFRMTITLE_TEXT .. " " } )
                                    table.insert(button.lines, { ["left"] = element.name } )
                                elseif ( element.type ) and ( element.type == "Quests" ) then
                                    table.insert(button.lines, { ["left"] = FEEDBACKUI_WHITE .. FEEDBACKUIFEEDBACKFRMTITLE_TEXT .. " " } )
                                    table.insert(button.lines, { ["left"] = element.name } )
                                end
                                if ( not button:IsVisible() ) then 
                                    button:Show()              
                                    pulseCounter = pulseCounter + 1;
                                end
                            else
                                button:Hide()
                            end
                        end
                        for i = 1, pulseCounter do
                            SetButtonPulse(panel.alert.buttons[i], 5, 0.5);
                        end
                    end
                    
                panel.AddSurvey =
					function (panel, surveyElement)
						local prepSurvey = {}
						if ( surveyElement.type == "Instances" ) then
							for _, element in ipairs(g_FeedbackUI_surveysTable["Instances"]) do
								if element.id == surveyElement.id then
									return "Survey item exists."
								end
							end
							prepSurvey = { 	["id"] = surveyElement.id, 
											["name"] = surveyElement.name, 
											["added"] = time(), 
                                            ["status"] = "Available", 
                                            ["modified"] = time(),
                                            ["type"] = surveyElement.type
                                        }
							table.insert(g_FeedbackUI_surveysTable["Instances"], prepSurvey)
                            panel.AddAlert(panel, prepSurvey)
						elseif ( surveyElement.type == "Quests" ) then
                            for _, element in ipairs(g_FeedbackUI_surveysTable["Quests"]) do
                                if element.id == surveyElement.id then
                                    return "Survey item exists."
                                end
                            end
                            prepSurvey = {
                                            ["name"] = surveyElement.name, 
                                            ["id"] = surveyElement.id, 
                                            ["objectives"] = surveyElement.objectives, 
                                            ["added"] = time(), 
                                            ["status"] = surveyElement.status, 
                                            ["modified"] = time(),
                                            ["type"] = surveyElement.type
                                        }
                            table.insert(g_FeedbackUI_surveysTable["Quests"], prepSurvey)
                        end
					end	
                                    
                -----------------------------------------------------------------------------------
				-- Update g_FeedbackUI_surveysTable["Quests"] by doing the following:
                --      Add any new quests obtained to the table.
                --      Show surveys for any quests that have been removed from the questlog
				-----------------------------------------------------------------------------------  
                
                panel.UpdateQuestSurveys =
                    function (panel)
                        -- make sure that this will only fire at most every 1 sec
                        if ( not g_FeedbackUI_feedbackVars["lastQuestUpdate"] ) then
                            g_FeedbackUI_feedbackVars["lastQuestUpdate"] = GetTime();
                        else
                            local updateDiff = GetTime() - g_FeedbackUI_feedbackVars["lastQuestUpdate"];
                            
                            if ( updateDiff < 1 ) then
                                return;
                            else
                                g_FeedbackUI_feedbackVars["lastQuestUpdate"] = GetTime();
                            end
                        end
                        
                        local currentQuests = {};
                        local headerStates = {}

                        for i = 1, MAX_QUESTS do
                            local name, _, _, _, collapsed = GetQuestLogTitle(i)
                            if ( collapsed == 1 ) then
                                headerStates[name] = 1;
                            end
                        end
                       
                        ExpandQuestHeader(0);
                       
                        local quests = GetNumQuestLogEntries();
                        local currentSelected = GetQuestLogSelection();
                        
                        for i = 1, quests do
                            local name, _, _, header = GetQuestLogTitle(i)
                            if ( not header ) then
                                local objectives, objectivesHash
                                
                                SelectQuestLogEntry(i)
                                _, objectives = GetQuestLogQuestText()
                                objectives = string.gsub(objectives, "%c", "")
                                objectivesHash = FeedbackUI_HexHash(objectives)
                                table.insert(currentQuests, objectivesHash)
                                
                                local questFound = false;
                                for _, quest in pairs(g_FeedbackUI_surveysTable["Quests"]) do
                                    
                                    if ( quest.id == objectivesHash ) then
                                        questFound = true;
                                    end
                                end
                                
                                if not questFound then
                                    local surveyElement = { ["name"] = name, ["objectives"] = objectives, ["id"] = objectivesHash, ["type"] = "Quests", ["status"] = "Hidden" }
                                    panel.AddSurvey(panel, surveyElement)
                                end
                            end
                        end
                        
                        for index, quest in pairs(g_FeedbackUI_surveysTable["Quests"]) do
                            if ( quest.status == "Hidden" ) then
                                local questFound = false
                                for _, id in pairs(currentQuests) do
                                    if ( id == quest.id ) then
                                        questFound = true;                                         
                                    elseif ( not id ) then
                                        questFound = true;
                                    end
                                end
                                
                                if ( not questFound ) then
                                    g_FeedbackUI_surveysTable["Quests"][index].added = time();
                                    g_FeedbackUI_surveysTable["Quests"][index].status = "Available"
                                    panel.AddAlert(panel, g_FeedbackUI_surveysTable["Quests"][index]);
                                end
                            end
                        end
                        
                        SelectQuestLogEntry(currentSelected);
                        
                        for i = 1, GetNumQuestLogEntries() do
                            local name = GetQuestLogTitle(i)
                            if ( ( name ~= 0 ) and ( headerStates[name] ) )then
                                CollapseQuestHeader(i)
                            end
                        end
                        
                    end
                    
				panel.DateSort = 
					function(element1, element2)
                        if element1.added and element2.added then
                        	if ( g_FeedbackUI_feedbackVars["sortdir"] == "dated" ) then
                        		if ( element1.added > element2.added ) then return true else return false end	
                        	elseif ( g_FeedbackUI_feedbackVars["sortdir"] == "datea" ) then
                        		if ( element1.added < element2.added ) then return true else return false end
                        	else
                        		if ( element1.added > element2.added ) then return true else return false end
                        	end
                        else
                            return true
                        end
					end
					
				panel.NameSort =
					function(element1, element2)
                        if element1.name and element2.name then
                            if ( g_FeedbackUI_feedbackVars["sortdir"] == "named" ) then
                        		if ( string.lower(element1.name) < string.lower(element2.name) ) then return true else return false end
                        	elseif ( g_FeedbackUI_feedbackVars["sortdir"] == "namea" ) then
                        		if ( string.lower(element1.name) > string.lower(element2.name) ) then return true else return false end
                        	else
                        		if ( string.lower(element1.name) < string.lower(element2.name)) then return true else return false end
                        	end
						else
							return true
						end
					end
				
				panel.Sort = 
					function(panel, sortTable, sortType)
						if ( sortType == "name" ) then
							table.sort(sortTable, panel.NameSort)
						else
							table.sort(sortTable, panel.DateSort)
						end
					end
                    						
				panel.SortResults =
					function(panel, sortType)
                        if ( sortType == "date" ) then
                            if not ( g_FeedbackUI_feedbackVars["sortdir"] == "datea" ) or ( g_FeedbackUI_feedbackVars["sortdir"] == "dated" ) then g_FeedbackUI_feedbackVars["sortdir"] = "dated" end		
                            table.sort(g_FeedbackUI_surveysTable["Instances"],panel.DateSort);
                            table.sort(g_FeedbackUI_surveysTable["Quests"],panel.DateSort);
                            if ( g_FeedbackUI_feedbackVars["sortdir"] == "dated" ) then g_FeedbackUI_feedbackVars["sortdir"] = "datea" else g_FeedbackUI_feedbackVars["sortdir"] = "dated" end
                        elseif ( sortType == "name" ) then
                            if not ( g_FeedbackUI_feedbackVars["sortdir"] == "namea" ) or ( g_FeedbackUI_feedbackVars["sortdir"] == "named" ) then g_FeedbackUI_feedbackVars["sortdir"] = "named" end
                            table.sort(g_FeedbackUI_surveysTable["Instances"],panel.NameSort);
                            table.sort(g_FeedbackUI_surveysTable["Quests"],panel.NameSort);
                            if ( g_FeedbackUI_feedbackVars["sortdir"] == "named" ) then g_FeedbackUI_feedbackVars["sortdir"] = "namea" else g_FeedbackUI_feedbackVars["sortdir"] = "named" end
                        end
						
                        panel.PopulateTable(panel)
					end    
								
                panel.ShowTooltip =
                    function (panel, button)
                        local lines = {}
                        local normalColor = {};
						normalColor.r, normalColor.g, normalColor.b, normalColor.a  = GameFontNormal:GetTextColor();
                        
                        -- Tremendous hack, but I'm tired.
                        panel.tooltip:SetOwner(panel, "ANCHOR_RIGHT")
                        panel.tooltip:SetText("Test")
                        panel.tooltip:ClearLines()
                        panel.tooltip:Hide()
                        -- End tremendous hack
                        panel.tooltip:SetOwner(panel, "ANCHOR_RIGHT")
                        
                        if ( button.element.type == "Instances" ) then
                            line = { ["left"] = FEEDBACKUI_SURVEYTOOLTIPINSTANCEHEADER, ["right"] = button.element.name }
                            table.insert(lines, line)
                            line = { ["left"] = FEEDBACKUI_SURVEYTOOLTIPEXPERIENCEDHEADER, ["right"] = date(nil, button.element.added) }
                            table.insert(lines, line)
                            for index, line in ipairs(lines) do
                                panel.tooltip:AddDoubleLine(line["left"], line["right"])
                                getglobal(panel.tooltip:GetName() .. "TextLeft" .. index):SetFontObject("GameFontNormal")
                                getglobal(panel.tooltip:GetName() .. "TextLeft" .. index):SetTextColor(1, 1, 1, 1)
                                getglobal(panel.tooltip:GetName() .. "TextRight" .. index):SetFontObject("GameFontNormal")
                            end
                        elseif ( button.element.type == "Quests" ) then
                            line = { ["left"] = FEEDBACKUI_SURVEYTOOLTIPQUESTHEADER, ["right"] = button.element.name }
                            table.insert(lines, line)
                            line = { ["left"] = FEEDBACKUI_SURVEYTOOLTIPEXPERIENCEDHEADER, ["right"] = date(nil, button.element.added) }
                            table.insert(lines, line)
                            line = { ["left"] = FEEDBACKUI_SURVEYTOOLTIPQUESTOBJECTIVESHEADER, ["right"] = "" }
                            table.insert(lines, line)
                            line = { ["left"] = button.element.objectives, ["right"] = "" }
                            table.insert(lines, line)
                            for index, line in ipairs(lines) do
                                if ( index ~= #lines ) then
                                    panel.tooltip:AddDoubleLine(line["left"], line["right"])
                                    getglobal(panel.tooltip:GetName() .. "TextLeft" .. index):SetFontObject("GameFontNormal")
                                    getglobal(panel.tooltip:GetName() .. "TextLeft" .. index):SetTextColor(1, 1, 1, 1)
                                    getglobal(panel.tooltip:GetName() .. "TextRight" .. index):SetFontObject("GameFontNormal")
                                else
                                
                                    panel.tooltip:AddLine(line["left"], normalColor.r, normalColor.g, normalColor.b, 1)
                                    getglobal(panel.tooltip:GetName() .. "TextLeft" .. index):SetFontObject("GameFontNormal")
                                end
                            end
                        end
                        panel.tooltip:Show()
                        panel.tooltip:ClearAllPoints()
                        panel.tooltip:SetPoint("TOPLEFT", panel, "TOPRIGHT", 10, -26)
                    end

                panel.HideTooltip =
                    function (panel)
                        panel.tooltip:ClearLines()
                        panel.tooltip:Hide()
                    end
                                
				panel.FormatTime = 
					function(timeVar)
						local timeString = ""
						local timeNow = {}
						local timeThen = {}
					
						if ( timeVar == "" ) then
							timeString = "New";
							return timeString;
						else
							timeThen = date("*t", timeVar)
							timeNow = date("*t")
						end
						
                        if FEEDBACKUI_TIMEPREFIX then
                            timeString = FEEDBACKUI_TIMEPREFIX
                        end
                        
						if ( not timeThen or not timeNow ) then
							return "Err"
						end
								
						local monthDiff = timeNow.month - timeThen.month + (12 * (timeNow.year - timeThen.year));
						if ( monthDiff >= 24 ) then
							timeString = timeString .. tostring(math.floor(monthDiff/12)) .. FEEDBACKUI_YEARSAGO
						elseif ( monthDiff > 12 ) then
							timeString = timeString .. "1" .. FEEDBACKUI_YEARAGO
						elseif ( monthDiff > 1 ) then
							timeString = timeString .. monthDiff .. FEEDBACKUI_MONTHSAGO
						else
							local dayDiff = timeNow.day - timeThen.day + (31 * monthDiff)
							if ( dayDiff > 31 ) then
								timeString = timeString .. "1" .. FEEDBACKUI_MONTHAGO
							elseif ( dayDiff > 1 and dayDiff < 31 ) then
								timeString = timeString .. dayDiff .. FEEDBACKUI_DAYSAGO
							else
								local hoursDiff = timeNow.hour - timeThen.hour + (24 * dayDiff)
								if ( hoursDiff > 24 ) then
									timeString = timeString .. "1" .. FEEDBACKUI_DAYAGO
								elseif ( hoursDiff > 1 and hoursDiff < 24 ) then
									timeString = timeString .. hoursDiff .. FEEDBACKUI_HOURSAGO
								else
									local minsDiff = timeNow.min - timeThen.min + (60 * hoursDiff)
									if ( minsDiff > 60 ) then
										timeString = timeString .. "1" .. FEEDBACKUI_HOURAGO
									else
                                        timeString = FEEDBACKUI_NEW
									end
								end
							end
						end
					
						return timeString;
					end
				
				panel.Collapse =
					function(panel, category)
						for num, value in next, panel.categories do
							if category == value then
								table.remove(panel.categories, num);
							end
						end
                        for _, element in pairs(panel.table) do
                            if ( element.header and element.name == category ) then
                                element.expanded = false
                            end
                        end
						panel.Render(panel)
					end
					
				panel.Expand = 
					function(panel, category)
						table.insert(panel.categories, category)
                        for _, element in pairs(panel.table) do
                            if ( element.header and element.name == category ) then
                                element.expanded = true
                            end
                        end
						panel.Render(panel)								
					end
                    
				panel.InsertInstances =
					function(panel)
						local status = ( UIDropDownMenu_GetSelectedValue(getglobal(panel:GetName().."DdlStatus")) or "" )
						table.insert(panel.table, FEEDBACKUI_INSTANCEHEADER);
						
						if ( status == "All" or status == "" ) then
							for _, val in ipairs(g_FeedbackUI_surveysTable["Instances"]) do
								val.type = "Instances"
								table.insert(panel.table, val)
							end
						else
							for _, val in ipairs(g_FeedbackUI_surveysTable["Instances"]) do
								if ( val.status == status ) then
									val.type = "Instances"
									table.insert(panel.table, val)
								end
							end
						end
					end
					
				panel.InsertQuests =
					function(panel)
						local status = ( UIDropDownMenu_GetSelectedValue(getglobal(panel:GetName().."DdlStatus")) or "" )
						table.insert(panel.table, FEEDBACKUI_QUESTHEADER);
						
						if ( status == "All" or status == "" ) then
							for _, val in ipairs(g_FeedbackUI_surveysTable["Quests"]) do
                                if val.status ~= "Hidden" then
    								val.type = "Quests"
    								table.insert(panel.table, val)
                                end
							end
						else
							for _, val in ipairs(g_FeedbackUI_surveysTable["Quests"]) do
								if ( val.status == status ) then
									val.type = "Quests"
									table.insert(panel.table, val)
								end
							end
						end	
					end
				
				panel.PopulateTable =
					function(panel)
						local category = ( 
                            UIDropDownMenu_GetSelectedValue(
                                getglobal(panel:GetName().."DdlCategory")
                            ) 
                            or "" )
						panel.table = {}	
						
						if ( category == "All" or category == "" ) then
							panel.InsertInstances(panel);
							panel.InsertQuests(panel);
						elseif ( category == "Instances" ) then
							panel.InsertInstances(panel);					
						elseif ( category == "Quests" ) then
							panel.InsertQuests(panel);
						end						
						panel.Render(panel);
					end
				
				panel.GetStatusColor =
					function(status)
						for _, value in next, FEEDBACKUI_SURVEYSTATUS do
							if ( value.value == status ) then
								return { ["r"] = value.r, ["g"] = value.g, ["b"] = value.b, ["a"] = value.a }
							end
						end
					end
				
                panel.HighlightButton =
                    function (panel, button)
                        if ( not panel or not button ) then return end;
                        
                        local color = button.highlightColor
                        button.normalColor = button.highlightColor;
						button.text:SetTextColor(color.r, color.g, color.b, color.a);
                        button.rightText:SetTextColor(color.r, color.g, color.b, color.a);
                        color = panel.GetStatusColor(button.element.status)
                        panel.highlight.texture:SetVertexColor(color.r, color.g, color.b)
                        panel.highlight:ClearAllPoints()
                        panel.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 10, 2)
                        panel.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 10, 2)
                        panel.highlight:Show();
                    end
                
                panel.ResetButtons =
                    function (panel)
                        local normalColor = {};
						normalColor.r, normalColor.g, normalColor.b, normalColor.a  = GameFontNormal:GetTextColor();
                        
                        for i = 1, #panel.scroll.buttons do
                            local color = {}
                            if panel.scroll.buttons[i].element then
                                color = panel.GetStatusColor((panel.scroll.buttons[i].element.status or ""));
                            end
                            if not color then color = normalColor end;
                            panel.scroll.buttons[i].normalColor = color;
                            panel.scroll.buttons[i].text:SetTextColor(color.r, color.g, color.b, color.a);
                            panel.scroll.buttons[i].rightText:SetTextColor(color.r, color.g, color.b, color.a);
                        end
                    end
                                  				
				panel.SelectSurvey =
					function (panel, element, button)
						if ( not panel or not element or not button ) then return end;
						if element.id == panel.selectedId then return end;
						panel.selectedId = element.id;	
                        
                        panel.ResetButtons(panel);
                        panel.HighlightButton(panel, button);
                        panel:GetParent().reset:Click();
                        panel:GetParent().skip:Disable();

                        for index, panelElement in next, panel:GetParent().panels do
                            if ( panelElement.name == "StepThroughPanel" ) then
                                if ( element.type == "Instances" ) then
                                    panelElement.table = FEEDBACKUI_INSTANCESDIFFICULTYTABLE
                                    panelElement.startlink = FEEDBACKUI_INSTANCESDIFFICULTYTABLE
                                elseif ( element.type == "Quests" ) then
                                    panelElement.table = FEEDBACKUI_QUESTSCLARITYTABLE
                                    panelElement.startlink = FEEDBACKUI_QUESTSCLARITYTABLE  
                                end
                                panelElement.element = element;
                                panelElement.Render(panelElement)
                                if ( element.status == "Available" ) then
                                    panel:GetParent().skip:Enable();
                                    panel:GetParent().submit:SetText(FEEDBACKUISUBMIT_TEXT);
                                elseif ( element.status == "Completed" ) then
                                    panel:GetParent().submit:SetText(FEEDBACKUIRESUBMIT_TEXT);
                                else
                                    panel:GetParent().submit:SetText(FEEDBACKUISUBMIT_TEXT);
                                end
                            end
                        end
                        
                        for index, alert in next, g_FeedbackUI_surveysTable["Alerts"] do
                            if ( alert.id == element.id ) then
                                table.remove(g_FeedbackUI_surveysTable["Alerts"], index);
                            end
                        end
                        pcall(panel.UpdateAlertButtons, panel)
                        
						if ( element.type == "Instances" ) then                        
							for _, entry in next, g_FeedbackUI_surveysTable["Instances"] do
								if ( entry.id == element.id ) then
									entry.modified = time()
								end
							end
						elseif ( element.type == "Quests" ) then
                            for _, entry in next, g_FeedbackUI_surveysTable["Quests"] do
								if ( entry.id == element.id ) then
									entry.modified = time()
								end
							end
                                    
							--Make the Wizard pane's start table the quest start table, show the Clarity status line, position the other status lines relative to the Clarity status line
						end
					
					end    
				-----------------------------------------------------------------------------------
				-- These are standard scroll methods used by all scroll template children
				-----------------------------------------------------------------------------------
				
				panel.Click = 	
					function (panel, element, button)
						if ( not panel or not element ) then return end;
                        
						if ( element.header == true ) then
							if ( element.expanded == true ) then
								button.btn:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up.blp");
								button.btn:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down.blp");
								button.btn:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled.blp");
								panel.Collapse(panel, element.name)
							else
								button.btn:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up.blp");
								button.btn:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down.blp");
								button.btn:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled.blp");
								panel.Expand(panel, element.name)
							end
						else
							panel.SelectSurvey(panel, element, button)
						end
					end
                    
                panel.MoveScroll = 	
					function (panel, int)
						if ( ( panel.scroll.index + int >= 1 ) and ( ( panel.scroll.index + int ) + #panel.scroll.buttons <= ( #panel.scrollResults + 1 ) ) ) then
							panel.scroll.index = panel.scroll.index + int
						end
						panel.ScrollButtons(panel)						
					end
                    			
				panel.Render = 	
					function (panel)	
						local renderTable = {};
                        local normalColor = {};
						normalColor.r, normalColor.g, normalColor.b, normalColor.a  = GameFontNormal:GetTextColor();
                        
                        --Disable the scroll controls.
                        panel.scroll:Hide();
						panel.scroll.thumb:Disable();
						panel.scrollResults = {};
                        
                        --Hide the button highlight
						panel.highlight:Hide();
                        
                        -- Reset all the buttons to be blank.
						for i = 1, #panel.scroll.buttons do
                            panel.scroll.buttons[i].rightText:SetWidth("75");
							panel.scroll.buttons[i].rightText:SetText("")
                            -- panel.scroll.buttons[i].text:SetText("");
                            -- panel.scroll.buttons[i].text:SetNonSpaceWrap(false);
                            -- panel.scroll.buttons[i].text:ClearAllPoints();
                            -- panel.scroll.buttons[i].text:SetPoint("RIGHT", panel.scroll.buttons[i].rightText, "LEFT");
							panel.scroll.buttons[i].normalColor = normalColor;
							panel.scroll.buttons[i].text:SetTextColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a);
							panel.scroll.buttons[i].rightText:SetTextColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a);							
							panel.scroll.buttons[i]:Hide();
							panel.scroll.buttons[i].btn:Hide();
							panel.scroll.buttons[i].element = nil;
                            panel.scroll.buttons[i].tooltip = nil;
							panel.scroll.buttons[i].selected = false;
						end
						
                        --Populate renderTable based on panel.categories, which is set by the DDLs.
						for ordinal, element in next, panel.table do
							if ( element.header ) then
								table.insert(renderTable, element)
							else
								for _, category in next, panel.categories do
									if ( category == element.type ) then
										table.insert(renderTable, element)
									end
								end
							end
						end
						
                        --Display and customize the buttons based on the contents of renderTable.
						for ordinal, element in ipairs(renderTable) do
                        
                            --Add all results to scrollResults so we can screw through them later.
							panel.scrollResults[ordinal] = element;
							panel.scroll:Show();
                            
                            --Render as many buttons as possible.
							if ( panel.scroll.buttons[ordinal] ) then
                                --If the element is a header, show the Expander buttons and justify text appropriately.
								if ( element.header ) then
									panel.scroll.buttons[ordinal].text:ClearAllPoints();
									panel.scroll.buttons[ordinal].text:SetPoint("TOPLEFT", ( FEEDBACKUI_OFFSETPIXELS ), 0);                                  
                                    if ( element.expanded == true ) or ( element.expanded == nil ) then
                                        element.expanded = true
                                        panel.scroll.buttons[ordinal].btn:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up.blp");
                                        panel.scroll.buttons[ordinal].btn:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down.blp");
                                        panel.scroll.buttons[ordinal].btn:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled.blp");
                                    else
                                    	panel.scroll.buttons[ordinal].btn:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up.blp");
                						panel.scroll.buttons[ordinal].btn:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down.blp");
                						panel.scroll.buttons[ordinal].btn:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled.blp");
                                    end
									panel.scroll.buttons[ordinal].btn:Show();
                                    panel.scroll.buttons[ordinal].element = element;
								else
                                    panel.scroll.buttons[ordinal].element = element;
									panel.scroll.buttons[ordinal].text:ClearAllPoints();
									panel.scroll.buttons[ordinal].text:SetPoint("TOPLEFT", ( FEEDBACKUI_OFFSETPIXELS * 1.5 ), 0);
                                    panel.scroll.buttons[ordinal].tooltip = true;
                                    local friendlyTime;
									if ( element.added ) then
                                        friendlyTime = panel.FormatTime(element.added);
                                    else
                                        friendlyTime = FEEDBACKUI_NEW
                                    end
									panel.scroll.buttons[ordinal].rightText:SetText(friendlyTime);
									local color = panel.GetStatusColor(element.status)
									panel.scroll.buttons[ordinal].normalColor = color;
									panel.scroll.buttons[ordinal].text:SetTextColor(color.r, color.g, color.b, color.a);
									panel.scroll.buttons[ordinal].rightText:SetTextColor(color.r, color.g, color.b, color.a);
								end
								panel.scroll.buttons[ordinal].text:SetText(element.name);
								panel.scroll.buttons[ordinal]:Show();
                                panel.scroll.buttons[ordinal].text:SetPoint("RIGHT", panel.scroll.buttons[ordinal].rightText, "BOTTOMLEFT", -10, 0)
							end
						end
						panel.scroll.index = 1;
                        
                        if panel.selectedId then
                            for i = 1, #panel.scroll.buttons do
                                if ( panel.scroll.buttons[i].element and panel.scroll.buttons[i].element.id ) then
                                    if ( panel.scroll.buttons[i].element.id == panel.selectedId ) then
                                        panel.HighlightButton(panel, panel.scroll.buttons[i])
                                    end
                                end
                            end
                        end    
                        
						panel.UpdateScrollButtons(panel);
					end
				
				panel.SetScrollVars = 	
					function(panel)
						-- Calculate values necessary to scroll
						panel.scroll.maxy = (panel.scroll.controls:GetTop() - 5);
						panel.scroll.miny = (panel.scroll.controls:GetBottom() + 13);
						panel.scroll.steprange = panel.scroll.maxy - panel.scroll.miny;
						panel.scroll.numsteps = #panel.scrollResults - #panel.scroll.buttons;
						panel.scroll.stepsize = panel.scroll.steprange / panel.scroll.numsteps;				
					end
			
				panel.ScrollOnUpdate =
					function(panel, elapsed)
						if ( not panel.timer ) then panel.timer = 0 end
						panel.timer = panel.timer + elapsed;
						if ( panel.timer > 0.1 ) then
							panel.SetScrollVars(panel);
							
							
							-- Compensate for UI scaling
							-- yarealy
							local realx, realy = GetCursorPosition();
							x = realx / panel:GetEffectiveScale();
							y = realy / panel:GetEffectiveScale();
							
							-- See where the user is trying to move the thumb to.
							local moveVariable = -(panel.scroll.maxy - y)
													
							if ( moveVariable > 0 ) then
								-- If the user has tried to move the thumb to the top of the track or above it, go to the first result.
								panel.scroll.thumb:ClearAllPoints();
								panel.scroll.thumb:SetPoint("TOP", 0, 0);
								panel.scroll.index = 1;
							elseif ( math.abs(moveVariable) > (panel.scroll.maxy - panel.scroll.miny) ) then
								-- If the user has tried to move the thumb to the bottom of the track or below it, go to the last result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, -(panel.scroll.maxy - panel.scroll.miny))
								panel.scroll.index = ( #panel.scrollResults - #panel.scroll.buttons + 1 )
							else
								-- Otherwise, move the scroll thumb to the appropriate position and go to the appropriate result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, moveVariable);
								
								local tempStep = math.round( (math.abs(moveVariable) / panel.scroll.stepsize ) ) + 1;
								if ( tempStep ~= panel.scroll.index ) then
									-- Determine the target index, and if it's not the current index, then change the index.
									panel.scroll.index = tempStep
								end
							end
							panel.ScrollButtons(panel)							
						end
					end
			
				panel.StartScroll =
					function(panel)
						if ( panel.scroll.thumb:IsEnabled() == 1 ) then
							panel.scroll.update:Show();
						end
					end
					
				panel.StopScroll =
					function(panel)
						panel.scroll.update:Hide()
					end					
                       
				panel.UpdateScrollButtons =
					function(panel)
					
						-- Update the position of the scroll thumb
						panel.SetScrollVars(panel);
						if not ( panel.scroll.update:IsVisible() == 1 ) then
							panel.scroll.thumb:ClearAllPoints();
							local moveto = -(panel.scroll.stepsize * ( panel.scroll.index -1))
							if ( moveto > 0 ) then moveto = -moveto end -- Yay crappy failsafes!
							panel.scroll.thumb:SetPoint("TOP", 0, moveto);
						end
						
						-- Enable the up button if appropriate
						if ( panel.scroll.index > 1 ) then
							panel.scroll.upbtn:Enable()
						else
							panel.scroll.upbtn:Disable()
						end
						
						-- Enable the down button if appropriate
						if ( ( panel.scroll.index + #panel.scroll.buttons ) <= #panel.scrollResults ) then
							panel.scroll.downbtn:Enable()
						else
							panel.scroll.downbtn:Disable();
						end
						
						-- Enable the scroll thumb if either the up or down button is enabled.
						if ( ( panel.scroll.upbtn:IsEnabled() == 1 ) or ( panel.scroll.downbtn:IsEnabled() == 1 ) ) then
							panel.scroll.thumb:Enable();
						else
							panel.scroll.thumb:Disable();
						end
					end
			
				panel.ScrollButtons = 
					function(panel)
						local i = 0;
                        local renderTable = {};
                        local normalColor = {};
						normalColor.r, normalColor.g, normalColor.b, normalColor.a  = GameFontNormal:GetTextColor();
					
						for ordinal, element in next, panel.table do
							if ( element.header ) then
								table.insert(renderTable, element)
							else
								for _, category in next, panel.categories do
									if ( category == element.type ) then
										table.insert(renderTable, element)
									end
								end
							end
						end
						
                        panel.highlight:Hide()
               			for i = 1, #panel.scroll.buttons do
							panel.scroll.buttons[i].text:SetText("")
							panel.scroll.buttons[i].rightText:SetText("")
							panel.scroll.buttons[i].normalColor = normalColor;
							panel.scroll.buttons[i].text:SetTextColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a);
							panel.scroll.buttons[i].rightText:SetTextColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a);							
							panel.scroll.buttons[i]:Hide();
							panel.scroll.buttons[i].btn:Hide();
							panel.scroll.buttons[i].element = nil;
                            panel.scroll.buttons[i].tooltip = nil;
							panel.scroll.buttons[i].selected = false;
						end
                        
						for ordinal, element in ipairs(renderTable) do
                        	if ( ordinal >= panel.scroll.index ) then
    							i = i + 1;
    							panel.scrollResults[ordinal] = element;
    							panel.scroll:Show();
    							if panel.scroll.buttons[i] then
    								if ( element.header ) then
    									panel.scroll.buttons[i].text:ClearAllPoints();
    									panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( FEEDBACKUI_OFFSETPIXELS ), 0);
                                        if ( element.expanded ) then
                                            panel.scroll.buttons[i].btn:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up.blp");
                                            panel.scroll.buttons[i].btn:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down.blp");
                                            panel.scroll.buttons[i].btn:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled.blp");
                                        else
                                        	panel.scroll.buttons[i].btn:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up.blp");
                    						panel.scroll.buttons[i].btn:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down.blp");
                    						panel.scroll.buttons[i].btn:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled.blp");
                                        end
    									panel.scroll.buttons[i].btn:Show();
                                        panel.scroll.buttons[i].element = element;
    								else
                                        panel.scroll.buttons[i].element = element;
    									panel.scroll.buttons[i].text:ClearAllPoints();
    									panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( FEEDBACKUI_OFFSETPIXELS * 1.5 ), 0);
                                        panel.scroll.buttons[i].tooltip = true;
                                        local friendlyTime;
    									if ( element.added ) then
                                            friendlyTime = panel.FormatTime(element.added);
                                        else
                                            friendlyTime = FEEDBACKUI_NEW
                                        end
    									panel.scroll.buttons[i].rightText:SetText(friendlyTime);
    									local color = panel.GetStatusColor(element.status)
    									panel.scroll.buttons[i].normalColor = color;
    									panel.scroll.buttons[i].text:SetTextColor(color.r, color.g, color.b, color.a);
    									panel.scroll.buttons[i].rightText:SetTextColor(color.r, color.g, color.b, color.a);
    								end
    								panel.scroll.buttons[i].text:SetText(element.name);
    								panel.scroll.buttons[i]:Show();
                                    panel.scroll.buttons[i].text:SetPoint("RIGHT", panel.scroll.buttons[i].rightText, "BOTTOMLEFT", -10, 0)
    							end
                            end
						end

                        if panel.selectedId then
                            for i = 1, #panel.scroll.buttons do
                                if ( panel.scroll.buttons[i].element and panel.scroll.buttons[i].element.id ) then
                                    if ( panel.scroll.buttons[i].element.id == panel.selectedId ) then
                                        panel.HighlightButton(panel, panel.scroll.buttons[i])
                                    end
                                end
                            end
                        end    
                            
						panel.UpdateScrollButtons(panel);
					end
			
				panel.CreateButtons = 
					function(panel)
						if ( panel.scroll and panel.scroll.buttons ) then
							local buttoncapacity = ( math.floor(((panel.scroll:GetHeight()) / panel.scroll.buttons[1]:GetHeight())) )
							local numbuttons = #panel.scroll.buttons;
							if numbuttons < buttoncapacity and buttoncapacity > panel.maxbuttons then
								for i = 1, buttoncapacity - numbuttons do
									local newButton = CreateFrame("Button", string.gsub(panel.scroll.buttons[1]:GetName(), "%d+", "") .. (numbuttons + i), panel.scroll, "ScrollElementTemplate")
									newButton:SetPoint("TOPLEFT", panel.scroll.buttons[numbuttons + i - 1], "BOTTOMLEFT", 0, 0)
									newButton:SetWidth(panel.scroll.buttons[1]:GetWidth());
									newButton:SetHeight(panel.scroll.buttons[1]:GetHeight());
									table.insert(panel.scroll.buttons, newButton)
									newButton.index = #panel.scroll.buttons;
								end
								panel.maxbuttons = buttoncapacity;
							end
						else

						end
					end		
                
                ----------------------------------------------------------------------------------------------------
				-- Code for populating and managing dropdown lists
				----------------------------------------------------------------------------------------------------
							
				panel.LoadCategory = 
					function(ddl)
						ddl.panel.ddlCategory = ddl
						UIDropDownMenu_Initialize(ddl, ddl.panel.DdlCategory_Initialize, nil, 1); 
						UIDropDownMenu_SetAnchor(12,8, ddl, "TOPLEFT", ddl:GetName(), "BOTTOMLEFT"); 
						UIDropDownMenu_SetSelectedValue(ddl, FEEDBACKUI_SURVEYCATEGORIES[ddl.panel.category].value); 
					end

				panel.LoadStatus =
					function(ddl)
						ddl.panel.ddlStatus = ddl
						local value = FEEDBACKUI_SURVEYSTATUS[ddl.panel.status];
						UIDropDownMenu_Initialize(ddl, ddl.panel.DdlStatus_Initialize, nil, 1); 
						UIDropDownMenu_SetAnchor(12,8, ddl, "TOPLEFT", ddl:GetName(), "BOTTOMLEFT"); 
						UIDropDownMenu_SetSelectedValue(ddl, value.value); 
					end
	
				panel.Category_OnClick =
					function()
						local panel = FeedbackUISurveyFrameSurveysPanel;
                        for i, value in next, FEEDBACKUI_SURVEYCATEGORIES do
                            if value.text == this:GetText() then
                                UIDropDownMenu_SetSelectedValue(panel.ddlCategory, value.value)
                            end
                        end
						panel.PopulateTable(panel);
					end
					
				panel.Status_OnClick =
					function()
						local panel = FeedbackUISurveyFrameSurveysPanel;
                        for i, value in next, FEEDBACKUI_SURVEYSTATUS do
                            if value.text == this:GetText() then
                                UIDropDownMenu_SetSelectedValue(panel.ddlStatus, value.value)
                            end
                        end
                        panel.PopulateTable(panel)
					end
			
				panel.DdlCategory_Initialize =
					function()
						local panel = FeedbackUISurveyFrameSurveysPanel;
						for i, value in next, FEEDBACKUI_SURVEYCATEGORIES do
							local info = {};
							info.text = value.text;
							info.value = value.value;
							info.owner = panel.ddlCategory;
							info.func = panel.Category_OnClick;
							UIDropDownMenu_AddButton(info, level);
						end
					end
				
				panel.DdlStatus_Initialize = 
					function()
						local panel = FeedbackUISurveyFrameSurveysPanel;
						for i, value in next, FEEDBACKUI_SURVEYSTATUS do
							local info = {};
							info.text = value.text;
							info.value = value.value;
							info.owner = panel.ddlStatus;
							info.func = panel.Status_OnClick;
							UIDropDownMenu_AddButton(info, level);
						end
					end
                
                -----------------------------------------------------------------------------------
                -- Define all values the panel needs to run functions correctly, then
				-- run the setup functions that were defined earlier in panel.setup.
				-----------------------------------------------------------------------------------
                
                panel.categories = { "Instances", "Quests" };
                panel.category = 1;
                panel.maxbuttons = 1;
                panel.status = 2;
				panel.surveys = {};
                panel.tasks = {};
                panel.timeSinceLast = 0;
                panel.UPDATEINTERVAL = .5;
                
                pcall(panel.Localize, panel);
                

				panel.CreateButtons(panel);
                panel.CreateAlertButtons(panel);
                
			end
}

FeedbackUI_SetupPanel{
	name = "StatusPanel",
	parent = "FeedbackUISurveyFrame",
	inherits = "FeedbackPanelTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentSurveysPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = 3 },
				{ ["point"] = "TOPRIGHT", ["relativeto"] = "$parentSurveysPanel", ["relativepoint"] = "TOPRIGHT", ["x"] = 0, ["y"] = 3 } },
	size = { ["y"] = 70 },
	Setup = function(obj)
				-- Create the seperator line that follows the Status panel.
				obj.seperator = CreateFrame("Frame", obj:GetName() .. "Line", obj, "FeedbackLineTemplate");
				obj.seperator:SetPoint("TOPLEFT", obj, "BOTTOMLEFT", 0, -5);
				obj.seperator:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", 0, -5);
				obj.status = {};
                obj.infoLines = {};
			end,
	Show = 	function(panel)
				for _, line in next, panel.infoLines do
					if ( line.Update ) then 
                        line.Update(line, panel)
                    end
				end	
			end
	
	}
	
FeedbackUI_AddInfoLine{
	name = "Clarity",
	parent = "FeedbackUISurveyFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMCLARITY_TEXT,
	Setup = function(line)
				line.type = "clarity"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}
			
FeedbackUI_AddInfoLine{
	name = "Difficulty",
	parent = "FeedbackUISurveyFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMDIFFICULTY_TEXT,
	Setup = function(line)
				line.type = "difficulty"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}

FeedbackUI_AddInfoLine{
	name = "Reward",
	parent = "FeedbackUISurveyFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMREWARD_TEXT,
	Setup = function(line)
				line.type = "reward"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}			
					
FeedbackUI_AddInfoLine{
	name = "Fun",
	parent = "FeedbackUISurveyFrameStatusPanel",
	inherits = "InfoLineTemplate",
	labelText = FEEDBACKUILBLFRMFUN_TEXT,
	Setup = function(line)
				line.type = "fun"
			end,
	Update = function(line, panel)
				if ( panel.status ) and ( line.type ) then
					line.value:SetText(panel.status[line.type]);
				end			
			end
			}	
			
FeedbackUI_SetupPanel{
	name = "StepThroughPanel",
	parent = "FeedbackUISurveyFrame",
	inherits = "FeedbackWizardTemplate",
	anchors = { { ["point"] = "TOPLEFT", ["relativeto"] = "$parentStatusPanel", ["relativepoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = -1 },
				{ ["point"] = "BOTTOMRIGHT", ["relativeto"] = "$parent", ["relativepoint"] = "BOTTOMRIGHT", ["x"] = 2, ["y"] = 19 } },
	Setup = function(panel)
				panel.maxbuttons = 1
				panel.scrollResults = {}
				panel.history = {}
				panel.table = FEEDBACKUI_SURVEYWELCOMETABLE
				panel.startlink = FEEDBACKUI_SURVEYWELCOMETABLE
								
                panel.Localize = 
                    function(panel)
                        if GetLocale() == "esES" or GetLocale() == "frFR" or GetLocale() == "deDE" then
                            panel.buttonWidth = 415
                            panel.buttonHeight = 26
                            panel.input:SetWidth(390)
                            panel:GetParent().skip:SetWidth(panel:GetParent().skip:GetWidth() + 35);
                    
                            panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
                            panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        else
                            panel.buttonWidth = 325
                            panel.buttonHeight = 26
                            panel.input:SetWidth(307)
                            
            				panel.scroll.buttons[1]:SetWidth(panel.buttonWidth);
            				panel.scroll.buttons[1]:SetHeight(panel.buttonHeight);
                        end
                    end
                
				panel.Back = 
					function(panel) 
						panel.Render(panel, panel.history[#panel.history]); 
						panel.history[#panel.history] = nil; 
						if ( #panel.history == 0 ) then 
                            panel:GetParent().back:Disable() 
                            panel:GetParent().reset:Disable();
                        end 
                    end
						
				panel.Reset = 	
					function(panel) 
                        panel.history = {}; 
                        panel:GetParent().back:Disable();
                        panel:GetParent().reset:Disable();
                        panel.scrollResults = {};
                        panel.scroll.index = nil;
                        for index, panelElement in next, panel:GetParent().panels do 
                            if ( panelElement.name == "StatusPanel" ) then
                                panelElement.status = {}
                                for num, line in next, panelElement.infoLines do
                                    line.value:SetText("")
                                end
                            end
                        end
                        panel.table = panel.startlink; 
                        panel.Render(panel) 
                    end
				
                panel.Skip =
                    function(panel)
                        if ( panel.element.type == "Instances" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Instances"] do
                                if ( value.id == panel.element.id ) then
                                    value.status = "Skipped";
                                end
                            end
                        elseif ( panel.element.type == "Quests" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Quests"] do
                                if ( value.id == panel.element.id ) then
                                    value.status = "Skipped";
                                end
                            end
                        end
                        
                        for _, panelElement in next, panel:GetParent().panels do 
                            if ( panelElement.name == "SurveysPanel" ) then
                                panelElement.selectedId = nil;
                                panelElement.PopulateTable(panelElement);
                                panel:GetParent().back:Disable();
                                panel:GetParent().reset:Disable();
                                panel:GetParent().skip:Disable();
                                panel:GetParent().submit:Disable();
                            end
                        end
                        
                        panel.startlink = FEEDBACKUI_SURVEYWELCOMETABLE;
                        panel.table = FEEDBACKUI_SURVEYWELCOMETABLE;
                        panel.Reset(panel)
                    end
                    
				panel.Submit = 
					function(panel)
						panel.infoString = "";
						local infoTable = {};
						local bs=FEEDBACKUI_DELIMITER;
						for _, panelElement in next, panel:GetParent().panels do 
							if ( panelElement.name == "StatusPanel" ) then
								for num, line in next, panelElement.infoLines do
									infoTable[line.type] = ( line.value:GetText() or "" )
								end
							end
						end
						
						for index, field in next, FEEDBACKUI_FIELDS do
							if not ( infoTable[field] ) then
								infoTable[field] = "";
								panel.infoString = panel.infoString .. bs;
							else
								panel.infoString = panel.infoString .. string.gsub(infoTable[field], "\n", " ") .. bs;
							end
						end
						
                        infoTable["surveyname"] = panel.element.name
                        infoTable["surveyid"] = panel.element.id
                        infoTable["surveyobjectives"] = panel.element.objectives
                        infoTable["surveytype"] = panel.element.type
                        infoTable["surveyobtained"] = date(nil, panel.element.added)
                        infoTable["surveysubmitted"] = date(nil, time())
                        
                        for index, field in next, FEEDBACKUI_SURVEYFIELDS do
                            if not ( infoTable[field] ) then
                                infoTable[field] = "";
                                panel.infoString = panel.infoString .. bs;
                            else
                                panel.infoString = panel.infoString .. string.gsub(infoTable[field], "\n", " ") .. bs;
                            end
                        end
                        
                        inputString = panel.input:GetText();
                        
                        if ( inputString == FEEDBACKUISURVEYFRMINPUTBOX_TEXT ) then
                            inputString = ""
                        end
                        
                        inputString = string.gsub(inputString, "\n", " ");
						inputString = string.gsub(inputString, bs, " ");
						panel.infoString = panel.infoString .. inputString;
						ReportSuggestion(panel.infoString);
						UIErrorsFrame:Clear();
						UIErrorsFrame:AddMessage(FEEDBACKUI_CONFIRMATION, 1, 1, .1, 1.0, 5);
                        
                        if ( panel.element.type == "Instances" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Instances"] do
                                if ( value.id == panel.element.id ) then
                                    value.comments = panel.input:GetText()
                                    value.status = "Completed";
                                    value.completed = time()
                                end
                            end
                        elseif ( panel.element.type == "Quests" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Quests"] do
                                if ( value.id == panel.element.id ) then
                                    value.comments = panel.input:GetText()
                                    value.status = "Completed";
                                    value.completed = time()
                                end
                            end
                        end
                        
                        for _, panelElement in next, panel:GetParent().panels do 
                            if ( panelElement.name == "SurveysPanel" ) then
                                panelElement.selectedId = nil;
                                panelElement.PopulateTable(panelElement);
                                panel:GetParent().back:Disable();
                                panel:GetParent().reset:Disable();
                                panel:GetParent().skip:Disable();
                                panel:GetParent().submit:Disable();
                            end
                        end
                        
                        panel:GetParent().submit:SetText(FEEDBACKUISUBMIT_TEXT);
                        panel.startlink = FEEDBACKUI_SURVEYWELCOMETABLE;
                        panel.table = FEEDBACKUI_SURVEYWELCOMETABLE;                
						pcall(panel.Reset, panel)
						FeedbackUI:Hide();
					end
				
				panel.UpdateButtons = 
					function(panel) 
						panel.CreateButtons(panel)
					end
										
				panel.Click = 	
					function(panel, element)
						if ( not panel or not element ) then return end;
						table.insert(panel.history, panel.table);
						panel.parent.back:Enable();
                        panel.parent.reset:Enable();
						
						if ( element.summary ) then
							for index, panelElement in next, panel:GetParent().panels do
								if ( panelElement.name == "StatusPanel" ) then
									for num, line in next, panelElement.infoLines do
										if ( line.type == element.summary.type ) then
											line.value:SetText(getglobal(element.summary.value));

											panelElement.status[line.type] = getglobal(element.summary.value);
										end
									end
								end
							end
						end
						
						if getglobal(element.link) then
							panel.Render(panel, getglobal(element.link));
						else
							panel.Render(panel, element.link);
						end
						
                        if ( panel.element.type == "Instances" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Instances"] do
                                if ( value.id == panel.element.id ) then
                                    value[element.summary.type] = element.summary
                                end
                            end
                        elseif ( panel.element.type == "Quests" ) then
                            for _, value in next, g_FeedbackUI_surveysTable["Quests"] do
                                if ( value.id == panel.element ) then
                                    value[element.summary.type] = element.summary
                                end
                            end
                        end
                        
					end
				
				panel.Render = 	
					function(panel, renderTable)	
					
						-- Reset all the tracking values to their defaults, and hide all the buttons and things that will later be shown.
						panel.scroll:Hide();
						panel.prompt:Hide();
						panel.edit:Hide();
						panel.scroll.thumb:Disable()
						panel.scrollResults = {};
						
						for i = 1, #panel.scroll.buttons do
							panel.scroll.buttons[i]:Hide();
						end
						
						--Make sure we have something to render. If we get the "edit" string, then show the edit box.
						if ( not renderTable ) then 
							renderTable = panel.table 
						elseif ( ( type(renderTable) == "string" )  and ( renderTable == "edit" ) ) then 
							panel.table = renderTable;
							local headerFrame = panel.header:GetParent();
                            panel.header:ClearAllPoints()
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.header);
							panel.header:SetText(FEEDBACKUI_SURVEYINPUTHEADER)
							panel.subtext:SetText("")
                            panel.input.blankString = nil;
                            if panel.element.comments then
                                panel.input:SetText(panel.element.comments);
                                panel.input.default = nil
                                panel.input:HighlightText(0)
                            else
                                panel.input:SetText(FEEDBACKUISURVEYFRMINPUTBOX_TEXT)
                                panel.input.default = nil
                            end
							panel.scroll:Hide();
							panel:GetParent().back:Show();
							panel:GetParent().skip:Show();
							panel:GetParent().reset:Show();
							panel:GetParent().submit:Show();
							panel.edit:Show();
							return;
						else
							panel.table = renderTable 
						end;
											
						if ( renderTable.header == "" and renderTable.subtext ) then
							local headerFrame = panel.header:GetParent();
							panel.header:ClearAllPoints()
							panel.header:SetPoint("LEFT", headerFrame, "LEFT", 8, 0)
							panel.header:SetText(renderTable.subtext);
							panel.subtext:SetText("");
						else
							if ( renderTable.header ) then
								local headerFrame = panel.header:GetParent();
								panel.header:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", 8, -6)
								panel.header:SetText(renderTable.header);
							end
							
							if renderTable.subtext then
								panel.subtext:SetText(renderTable.subtext);
							end
						end
						
						local i = 0;
						for ordinal, element in ipairs(renderTable) do
							--Clear downlevel status lines.
							local maxSummary = math.huge
							if ( element.summary ) then
								for index, panelElement in next, panel:GetParent().panels do
									if ( panelElement.name == "StatusPanel" ) then
										for num, line in next, panelElement.infoLines do
											if ( line.type == element.summary.type ) then
												maxSummary = num;
											end
											if ( num >= maxSummary ) then 
												line.value:SetText("") 
												panelElement.status[line.type] = nil;
											elseif ( ( num < maxSummary ) and ( line.value:GetText() == "" or line.value:GetText() == nil ) ) then
                                                panelElement.status[line.type] = "N/A";
                                                line.value:SetText("N/A");
											end
										end
									end
								end
							end

							i = i + 1;
							panel.scrollResults[ordinal] = element;
							if ( element.prompt ) then
								panel.prompt:Show();
								panel.prompt:SetText(element.prompt);
								panel.startlink = getglobal(element.link);
							else											
								panel.scroll:Show();
								panel:GetParent().back:Show();
								panel:GetParent().skip:Show();
								panel:GetParent().reset:Show();
								panel:GetParent().submit:Show();
								if panel.scroll.buttons[i] then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.scroll.index = 1;
						panel.UpdateScrollButtons(panel);
					end
			
				panel.SetScrollVars = 	
					function(panel)
						-- Calculate values necessary to scroll
						panel.scroll.maxy = (panel.scroll.controls:GetTop() - 5);
						panel.scroll.miny = (panel.scroll.controls:GetBottom() + 13);
						panel.scroll.steprange = panel.scroll.maxy - panel.scroll.miny;
						panel.scroll.numsteps = #panel.scrollResults - #panel.scroll.buttons;
						panel.scroll.stepsize = panel.scroll.steprange / panel.scroll.numsteps;				
					end
			
				panel.ScrollOnUpdate =
					function(panel, elapsed)
						if ( not panel.timer ) then panel.timer = 0 end
						panel.timer = panel.timer + elapsed;
						if ( panel.timer > 0.1 ) then
							panel.SetScrollVars(panel);
							
							
							-- Compensate for UI scaling
							-- yarealy
							local realx, realy = GetCursorPosition();
							x = realx / panel:GetEffectiveScale();
							y = realy / panel:GetEffectiveScale();
							
							-- See where the user is trying to move the thumb to.
							local moveVariable = -(panel.scroll.maxy - y)
													
							if ( moveVariable > 0 ) then
								-- If the user has tried to move the thumb to the top of the track or above it, go to the first result.
								panel.scroll.thumb:ClearAllPoints();
								panel.scroll.thumb:SetPoint("TOP", 0, 0);
								panel.scroll.index = 1;
							elseif ( math.abs(moveVariable) > (panel.scroll.maxy - panel.scroll.miny) ) then
								-- If the user has tried to move the thumb to the bottom of the track or below it, go to the last result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, -(panel.scroll.maxy - panel.scroll.miny))
								panel.scroll.index = ( #panel.scrollResults - #panel.scroll.buttons + 1 )
							else
								-- Otherwise, move the scroll thumb to the appropriate position and go to the appropriate result.
								panel.scroll.thumb:ClearAllPoints()
								panel.scroll.thumb:SetPoint("TOP", 0, moveVariable);
								
								local tempStep = math.round( (math.abs(moveVariable) / panel.scroll.stepsize ) ) + 1;
								if ( tempStep ~= panel.scroll.index ) then
									-- Determine the target index, and if it's not the current index, then change the index.
									panel.scroll.index = tempStep
								end
							end
							panel.ScrollButtons(panel)							
						end
					end
			
				panel.StartScroll =
					function(panel)
						if ( panel.scroll.thumb:IsEnabled() == 1 ) then
							panel.scroll.update:Show();
						end
					end
					
				panel.StopScroll =
					function(panel)
						panel.scroll.update:Hide()
					end					
			
				panel.UpdateScrollButtons =
					function(panel)
					
						-- Update the position of the scroll thumb
						panel.SetScrollVars(panel);
						if not ( panel.scroll.update:IsVisible() == 1 ) then
							panel.scroll.thumb:ClearAllPoints();
							local moveto = -(panel.scroll.stepsize * ( panel.scroll.index -1))
							if ( moveto > 0 ) then moveto = -moveto end -- Yay crappy failsafes!
							panel.scroll.thumb:SetPoint("TOP", 0, moveto);
						end
						
						-- Enable the up button if appropriate
						if ( panel.scroll.index > 1 ) then
							panel.scroll.upbtn:Enable()
						else
							panel.scroll.upbtn:Disable()
						end
						
						-- Enable the down button if appropriate
						if ( ( panel.scroll.index + #panel.scroll.buttons ) <= #panel.scrollResults ) then
							panel.scroll.downbtn:Enable()
						else
							panel.scroll.downbtn:Disable();
						end
						
						-- Enable the scroll thumb if either the up or down button is enabled.
						if ( ( panel.scroll.upbtn:IsEnabled() == 1 ) or ( panel.scroll.downbtn:IsEnabled() == 1 ) ) then
							panel.scroll.thumb:Enable();
						else
							panel.scroll.thumb:Disable();
						end
					end
			
				panel.MoveScroll = 	
					function(panel, int)
						if ( ( panel.scroll.index + int >= 1 ) and ( ( panel.scroll.index + int ) + #panel.scroll.buttons <= ( #panel.scrollResults + 1 ) ) ) then
							panel.scroll.index = panel.scroll.index + int
						end
						panel.ScrollButtons(panel)						
					end
			
				panel.ScrollButtons = 
					function(panel)
						local i = 0;
						
						for ordinal, element in ipairs(panel.table) do
							if ( ordinal >= panel.scroll.index ) then
								i = i + 1;
								if panel.scroll.buttons[i] then
									if ( element.offset ) then
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", ( element.offset * FEEDBACKUI_OFFSETPIXELS ), 0);
									else
										panel.scroll.buttons[i].text:ClearAllPoints();
										panel.scroll.buttons[i].text:SetPoint("TOPLEFT", 0, 0);
									end
									panel.scroll.buttons[i].element = element;
									panel.scroll.buttons[i].text:SetText(element.index);
									panel.scroll.buttons[i]:Show();
								end
							end
						end
						panel.UpdateScrollButtons(panel);
					end
			
				panel.CreateButtons = 
					function(panel)
						if ( panel.scroll and panel.scroll.buttons ) then
							local buttoncapacity = ( math.floor(((panel.scroll:GetHeight()) / panel.scroll.buttons[1]:GetHeight())) )
							local numbuttons = #panel.scroll.buttons;
							if numbuttons < buttoncapacity and buttoncapacity > panel.maxbuttons then
								for i = 1, buttoncapacity - numbuttons do
									local newButton = CreateFrame("Button", string.gsub(panel.scroll.buttons[1]:GetName(), "%d+", "") .. (numbuttons + i), panel.scroll, "ScrollElementTemplate")
									newButton:SetPoint("TOPLEFT", panel.scroll.buttons[numbuttons + i - 1], "BOTTOMLEFT", 0, 0)
									newButton:SetWidth(panel.scroll.buttons[1]:GetWidth());
									newButton:SetHeight(panel.scroll.buttons[1]:GetHeight());
									table.insert(panel.scroll.buttons, newButton)
									newButton.index = #panel.scroll.buttons;
								end
								panel.maxbuttons = buttoncapacity;
							end
						else

						end
					end	
					
			end
	}		
