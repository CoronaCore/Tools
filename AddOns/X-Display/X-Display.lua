if( DEFAULT_CHAT_FRAME ) then
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00X-Display!|r");
end

WOW_GetActionTexture = GetActionTexture;

function GetActionTexture(actionSlot)

	local texture = WOW_GetActionTexture(actionSlot);
	if( texture and string.find(texture,"INV_Misc_QuestionMark") ) then
		local type, id, subType = GetActionInfo(actionSlot);
		
		if(type and string.find(type, "item")) then
			local itemid = 0;
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
			itemEquipLoc, itemTexture = GetItemInfo(id);

			if( id ) then
				_, _, itemid = string.find(id, "Hitem:(%d+):");
				texture = itemTexture;
			end
			

		end
		
	end
	
	return texture;
end

WOW_GetContainerItemInfo = GetContainerItemInfo;

function GetContainerItemInfo(index, id)

local texture, itemCount, locked, quality, readable;
texture, itemCount, locked, quality, readable = WOW_GetContainerItemInfo(index, id);

if( texture and string.find(texture,"INV_Misc_QuestionMark") ) then
	local itemlink = GetContainerItemLink(index, id);
	local itemid = 0;

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
	itemEquipLoc, itemTexture = GetItemInfo(itemlink);

	if( itemlink ) then
		_, _, itemid = string.find(itemlink, "Hitem:(%d+):");
		texture = itemTexture;
	end
end

return texture, itemCount, locked, quality, readable;

end

WOW_GetInventoryItemTexture = GetInventoryItemTexture;

function GetInventoryItemTexture(unit, id)

local texture  = WOW_GetInventoryItemTexture(unit, id);

if( texture == nil ) then
	local itemLink = GetInventoryItemLink(unit, id);
	
	if(itemLink) then
		local itemid = 0;
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
		itemEquipLoc, itemTexture = GetItemInfo(itemLink);
		
		_, _, itemid = string.find(itemLink, "Hitem:(%d+):");
		texture = itemTexture;
	end
end

return texture;

end

function MyAddOn_OnEvent(this, event)
	
	if (event == "ITEM_LOCK_CHANGED") then
		local type, itemid, itemlink  = GetCursorInfo();
		
			if(type and type == "item") then
				
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemTexture = GetItemInfo(itemid);
				
				SetCursor("CAST_CURSOR");
		end
	end
		
	if (event == "ACTIONBAR_SLOT_CHANGED") then
		local type, itemid, itemlink  = GetCursorInfo();
		
			if(type and type == "item") then
				
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemTexture = GetItemInfo(itemid);
				DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Correction - Item on cursor:|r " ..itemName);
				SetCursor("CAST_CURSOR");
		end
		
	end
end

local frame = CreateFrame("Frame", "MyAddOnFrame");
frame:SetScript("OnEvent", MyAddOn_OnEvent);
frame:RegisterEvent("ITEM_LOCK_CHANGED");
frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
