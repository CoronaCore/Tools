

BQAE_DISPLAYDELAY = 3.5;
BQAE_DROPDOWN_WIDTH = 143;
BQAE_DROPDOWN_HEIGHT = 30;

BQAE_DROPDOWN_BUTTONWIDTH = 119;
BQAE_DROPDOWN_BUTTONHEIGHT = 18;

BQAE_DROPDOWN_EXPANDARROW_WIDTH = 24;
BQAE_DROPDOWN_EXPANDARROW_HEIGHT = 24;

BQAE_DROPDOWN_DEFAULT_NOSELECTION = "None";

BQAE_DropDown = {};

function BQAE_DropDown:Init(frame, parent, label, width)
	local dropdown = {};
	
	setmetatable(dropdown, self);
    self.__index=self;
	
	dropdown.name = frame;
	dropdown.parent = (parent or UIParent)
	dropdown.buttons = {};
	dropdown.selected = nil;
	
	dropdown.set_ListDisplayDelay = BQAE_DISPLAYDELAY;
	dropdown.set_DefaultNoSelect = BQAE_DROPDOWN_DEFAULT_NOSELECTION;
	dropdown.set_UseNoSelect = false;
	
	dropdown:SetupFrame();
	dropdown:SetupListFrame();
	
	dropdown:SetLabel(label);
	dropdown:SetWidth(width or BQAE_DROPDOWN_WIDTH);

	return dropdown;
end

function BQAE_DropDown:SetupFrame()
	self.frame = CreateFrame("Frame", self.name, self.parent);
	-- self.frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
							-- edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
							-- tile = true, tileSize = 16, edgeSize = 16, 
							-- insets = { left = 5, right = 5, top = 5, bottom = 5 }});
							
	self.frame:SetWidth(BQAE_DROPDOWN_BUTTONWIDTH + BQAE_DROPDOWN_EXPANDARROW_WIDTH);
	self.frame:SetHeight(BQAE_DROPDOWN_EXPANDARROW_HEIGHT);
	
	self.frame.leftTexture = self.frame:CreateTexture();
	self.frame.leftTexture:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame");
	self.frame.leftTexture:SetPoint("TOPLEFT", -16, 19);
	self.frame.leftTexture:SetWidth(25);
	self.frame.leftTexture:SetHeight(64);
	self.frame.leftTexture:SetTexCoord(0, 0.1953125, 0, 1);
	
	self.frame.middleTexture = self.frame:CreateTexture();
	self.frame.middleTexture:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame");
	self.frame.middleTexture:SetPoint("LEFT", self.frame.leftTexture, "RIGHT");
	self.frame.middleTexture:SetWidth(125);
	self.frame.middleTexture:SetHeight(64);
	self.frame.middleTexture:SetTexCoord(0.1953125, 0.8046875, 0, 1);
	
	self.frame.rightTexture = self.frame:CreateTexture();
	self.frame.rightTexture:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame");
	self.frame.rightTexture:SetPoint("LEFT", self.frame.middleTexture, "RIGHT");
	self.frame.rightTexture:SetWidth(25);
	self.frame.rightTexture:SetHeight(64);
	self.frame.rightTexture:SetTexCoord(0.8046875, 1, 0, 1);
	
	self.frame.button = CreateFrame("Button", string.format("%s%s", self.name, "Button"), self.frame);
	self.frame.button:SetPoint("RIGHT");
	self.frame.button:SetWidth(BQAE_DROPDOWN_EXPANDARROW_WIDTH);
	self.frame.button:SetHeight(BQAE_DROPDOWN_EXPANDARROW_HEIGHT);
	self.frame.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
	self.frame.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
	self.frame.button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled");
	self.frame.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight");
	
	self.frame.text = self.frame:CreateFontString(nil, "OVERLAY");
    self.frame.text:SetPoint("LEFT", 8, 0)
    self.frame.text:SetPoint("RIGHT", self.frame.button, "LEFT", -4, 0)
    self.frame.text:SetHeight(16);
    self.frame.text:SetJustifyH("RIGHT")
    self.frame.text:SetJustifyV("CENTER")
    self.frame.text:SetFontObject("GameFontHighlightSmall");
	
	self.label = self.frame:CreateFontString(nil, "OVERLAY");
	self.label:SetFontObject("GameFontNormal");
	self.label:SetHeight(16);
	self.label:SetJustifyH("RIGHT");
	self.label:SetJustifyV("CENTER");
	self.label:SetPoint("RIGHT", self.frame, "LEFT", -8, 0);
	
	if ( self.set_UseNoSelect ) then
		self.frame.text:SetText(self.set_DefaultNoSelect);
	end
	
	
	self.frame.button:SetScript("OnClick", 
		function() 
			if ( self.list:IsVisible() ) then
				self.list:Hide();
			else
				self.list:Show();
			end
			PlaySound("igMainMenuOptionCheckBoxOn");
		end);
	
end


function BQAE_DropDown:SetupListFrame()
	self.list = CreateFrame("Frame", string.format("%s%s", self.name, "List"), self.frame);
	self.list.name = string.format("%s%s", self.name, "List");
    self.list:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
							edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
							tile = true, tileSize = 16, edgeSize = 16, 
							insets = { left = 5, right = 5, top = 5, bottom = 5 }});
	self.list:SetBackdropColor(0.0, 0.0, 0.0);
	self.list:SetFrameStrata("TOOLTIP");
	self.list:SetClampedToScreen(true);
	self.list:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT", 0, 4);
	self.list:SetPoint("TOPRIGHT", self.frame, "BOTTOMRIGHT", 0, 4);
	self.list:SetHeight(0);
	self.list:Hide();
	
	self.list:SetScript("OnShow",
				function() 
					this:SetScript("OnUpdate", 
						function ()
							local mouseFrame = GetMouseFocus();
							if ( mouseFrame ) then
								if ( mouseFrame.GetParent and mouseFrame:GetParent() == self.list ) then
									self.showDelay = nil;
								else
									self.showDelay = (self.showDelay or (GetTime() + self.set_ListDisplayDelay));
								end
							end
							if ( self.showDelay and self.showDelay <= GetTime() ) then
								self.showDelay = nil;
								self.list:Hide();
								self.frame:SetScript("OnUpdate", nil);
							end
						end);
				end);
	self.list:SetScript("OnHide",
				function()
					self.showDelay = nil;
					this:SetScript("OnUpdate", nil);
				end);
	
end

-- BQAE_DropDown:AddButton(text, func [, icon])
-- BQAE_DropDown:AddButton(text, value, func [, icon])
function BQAE_DropDown:AddButton(text, value, func, icon)
	if ( type(value) == "function" ) then
		icon = func;
		func = value;
		value = text;
	end

	local button = getglobal(string.format("%s%s%d", self.list.name, "Button", #self.buttons + 1));
	if ( not button ) then
		button = CreateFrame("Button", string.format("%s%s%d", self.list.name, "Button", (#self.buttons + 1)), self.list);
	end

	button:SetWidth(BQAE_DROPDOWN_BUTTONWIDTH);
	button:SetHeight(BQAE_DROPDOWN_BUTTONHEIGHT);
	button.text = button:CreateFontString(nil, "OVERLAY");
	button.text:SetFontObject("GameFontHighlightSmall");
    button.text:SetPoint("LEFT", 18, 0)
    button.text:SetPoint("RIGHT")
    button.text:SetHeight(16);
    button.text:SetJustifyH("LEFT")
    button.text:SetJustifyV("CENTER")
	--button.text = getglobal(button:GetName() .. "Text");
	button.text:SetText(text);
	button.value = value;
	button.func = func;
	button.checked = false;
	
	button.icon = button:CreateTexture();
	button.icon:SetTexture(icon or "Interface\\Buttons\\UI-CheckBox-Check");
	button.icon:SetWidth(18);
	button.icon:SetHeight(18);
	button.icon:SetPoint("LEFT", button)
	button.icon:Hide();
	
	button.highlight = button:CreateTexture();
	button.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	button.highlight:SetBlendMode("ADD");
	button.highlight:SetAlpha("0.6");
	button.highlight:SetAllPoints(button);
	button.highlight:Hide();

	button:SetScript("OnEnter",
					function ()
						this.highlight:Show();
					end);
	
	button:SetScript("OnLeave",
					function ()
						this.highlight:Hide();
					end);
	
	button:SetScript("OnClick", 
					function ()
						if ( not this.checked ) then
							if ( self.selected ) then
								self.selected.checked = false;
								self.selected.icon:Hide();
							end
							self.selected = this;
							
							self.selected.checked = true;
							self.selected.icon:Show();
							self.frame.text:SetText(self.selected.text:GetText());
							if ( self.selected.func ) then
								self.selected.func();
							end
							self.list:Hide();
						else
							if ( self.set_UseNoSelect ) then
								this.checked = false;
								this.icon:Hide();
								if ( this.func ) then
									this.func();
								end
								self.selected = nil;
								self.frame.text:SetText(self.set_DefaultNoSelect);
							end
							self.list:Hide();
						end
					end);
	
	local lastButton;
	if ( #self.buttons == 0 ) then
		button:SetPoint("TOPLEFT", self.list, "TOPLEFT", 4, -8);
		button:SetPoint("TOPRIGHT", self.list, "TOPRIGHT", -4, -8);
	else
		lastButton = self.buttons[#self.buttons];
		button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT");
		button:SetPoint("TOPRIGHT", lastButton, "BOTTOMRIGHT");
	end
	tinsert(self.buttons, button);

	self.list:SetHeight(#self.buttons * BQAE_DROPDOWN_BUTTONHEIGHT + 16);
end

function BQAE_DropDown:RemoveButton(index)
	if ( index > #self.buttons ) then return; end
	
	local priorButton, proceedingbutton;
	if ( index ~= #self.buttons ) then
		self.buttons[#self.buttons + 1]:SetPoint("TOP", self.buttons[#self.buttons - 1], "BOTTOM");
	end
	self.buttons[index]:Hide();
	tremove(self.buttons, index);
end

function BQAE_DropDown:SetDefaultNoSelect(text)
	self.set_DefaultNoSelect = text;
end

function BQAE_DropDown:SetSelectedIndex(index)
	assert(index, "BQAE_DropDown:SetSelectedIndex() called without an index.");

	if ( self.selected ) then
		self.selected.checked = false;
		self.selected.icon:Hide()
	end
	if ( self.buttons[index] ) then
		self.selected = self.buttons[index];
		self.frame.text:SetText(self.selected.text:GetText());
		return true;
	end
end

function BQAE_DropDown:SetSelectedValue(value)
	assert(value, "BQAE_DropDown:SetSelectedValue() called without a value.");
	
	for i, button in next, self.buttons do
		if ( button.value == value ) then
			if ( self.selected ) then
				self.selected.checked = false;
				self.selected.icon:Hide();
			end
			
			self.selected = self.buttons[i];
			self.selected.checked = true;
			self.selected.icon:Show();
			self.frame.text:SetText(button.text:GetText());
			return true;
		end
	end
end

function BQAE_DropDown:GetSelected()
	return self.selected;
end

function BQAE_DropDown:GetSelectedValue()
	if ( self.selected ) then
		return self.selected.value;
	end
end

function BQAE_DropDown:SetLabel(text)
	self.label:SetText(text);
end

function BQAE_DropDown:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
	self.frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs);
end

function BQAE_DropDown:SetWidth(width)
	assert(width, "BQAE_DropDown:SetWidth() called without a specified width.");
	
	self.frame.middleTexture:SetWidth(width - 18);
	self.frame:SetWidth(width);
	
	for index, button in next, self.buttons do
		button:SetWidth(width - 16);
	end
end

function BQAE_DropDown:SetHeight(height)
	assert(height, "BQAE_DropDown:SetHeight() called without a specified height.");
	
	self.frame:SetHeight(height);
end

function BQAE_DropDown:GetFrame()
	return self.frame;
end

function BQAE_DropDown:Hide()
	self.frame:Hide();
end

function BQAE_DropDown:Show()
	self.frame:Show();
end
