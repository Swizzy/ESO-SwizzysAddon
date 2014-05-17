local function stackItem(fromBag, fromSlot, toBag, toSlot, quantity, name)
    ClearCursor()
    local result = CallSecureProtected("PickupInventoryItem", fromBag, fromSlot, quantity)
    if (result) then
        result = CallSecureProtected("PlaceInInventory", toBag, toSlot)
    end
    ClearCursor()
    return result
end

local function insertItem(itemTable, bag, slot, stack)
    local item = {}
    item.bag = bag
    item.slot = slot
    item.stack = stack
    table.insert(itemTable, item)
end

local function moveItem(fromItem, toItem, maxStack, itemName)
    local quantity = math.min(maxStack - toItem.stack, fromItem.stack)
    if (quantity > 0) then
        result = stackItem(fromItem.bag, fromItem.slot, toItem.bag, toItem.slot, quantity, itemName)
        if (result) then
            fromItem.stack = fromItem.stack - quantity
            toItem.stack = toItem.stack + quantity
        end
    end
end

local function sortStack (first, second)
    return first.stack > second.stack
end

local function reverseStack (first, second)
    return first.stack < second.stack
end

local function loopItems(fromItems, toItems, maxStack, itemName)
    table.sort(toItems, sortStack)
    table.sort(fromItems, reverseStack)
    for fromIndex, fromItem in ipairs(fromItems) do
        if (fromItem.stack > 0 and fromItem.stack < maxStack) then
            for toIndex, toItem in ipairs(toItems) do
                if(toItem.stack > 0 and toItem.stack < maxStack) then
                    if (not (fromItem.bag == toItem.bag and fromItem.slot == toItem.slot)) then
                        moveItem(fromItem, toItem, maxStack, itemName)
                        table.sort(toItems, sortStack)
                        table.sort(fromItems, reverseStack)
                    end
                end
            end
        end
    end
end

local function moveItems(bags, fromBag, toBag)
    for itemName, bagItem in pairs(bags) do
        local fromItems = bagItem[fromBag]
        local toItems = bagItem[toBag]
        loopItems(fromItems, toItems, bagItem.maxStack, itemName)
    end
end

function WF_SW_SwizzyAddon.HandleOpenBank(eventCode, addOnName, isManual)
	if WF_SW_SwizzyAddon.AutoBanker["Enabled"] then
		local maxBags = GetMaxBags()
		local bags = {}

		if (not isManual) then
			ClearCursor()
		end

		for bag = 1, maxBags do
			local bagIcon, bagSlots = GetBagInfo(bag)
			for slot = 0, bagSlots do
				local stack, maxStack = GetSlotStackSize(bag, slot)
				local itemName = GetItemName(bag, slot)
				if (stack > 0 and itemName ~= nil) then
					local bagItem = bags[itemName] or {}
					bagItem[BAG_BANK] = bagItem[BAG_BANK] or {}
					bagItem[BAG_BACKPACK] = bagItem[BAG_BACKPACK] or {}
					bagItem.maxStack = maxStack
					bagItem.name = itemName
					local itemTable = bagItem[bag]
					insertItem(itemTable, bag, slot, stack)
					bags[itemName] = bagItem
				end
			end
		end
		
		if (not isManual) then
			moveItems(bags, BAG_BACKPACK, BAG_BACKPACK)
			moveItems(bags, BAG_BANK, BAG_BANK)
			moveItems(bags, BAG_BACKPACK, BAG_BANK)
		end
	end
end