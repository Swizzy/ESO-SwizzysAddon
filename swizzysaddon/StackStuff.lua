local bags = {}

local function stackItem(src, target, quantity)
	ClearCursor()
	if CallSecureProtected("PickupInventoryItem", src.bag, src.slot, quantity) then
		return CallSecureProtected("PlaceInInventory", target.bag, target.slot)
	end
	ClearCursor()
	return false
end

local function stackAndMoveItem(src, target, maxStack)
	local quantity = math.min(maxStack - target.stack, src.stack)
	if (quantity > 0) then
		if stackItem(src, target, quantity) then
			src.stack = src.stack - quantity
			target.stack = target.stack + quantity
		end
	end
end

local function loopItems(src, target, maxStack)
	table.sort(target, function(s1, s2) return s1.stack > s2.stack; end)
	table.sort(src, function(s1, s2) return s1.stack < s2.stack; end)
	for _, srcItem in ipairs(src) do
		if srcItem.stack > 0 and srcItem.stack < maxStack then
			for _, targetItem in ipairs(target) do
				if targetItem.stack > 0 and targetItem.stack < maxStack then
					if srcItem.bag ~= targetItem.bag and srcItem.slot ~= targetItem.slot then
						stackAndMoveItem(srcItem, targetItem, maxStack)
						-- Not sure if these are actually required, we'll see ;)
						table.sort(target, function(s1, s2) return s1.stack > s2.stack; end)
						table.sort(src, function(s1, s2) return s1.stack < s2.stack; end)
					end
				end
			end
		end
	end
end

local function stackAndMoveItems(srcBag, targetBag)
	for _, item do
		local src = bagItem[srcBag]
		local target = bagItem[targetBag]
		loopitems(src, target, item.maxStack)
	end
end

local function IndexBag(bag, reset)
	if reset ~= nil and reset then
		bags = {}
	end
	local _, bagSlots = GetBagInfo(bag)
	for slot = 0, bagSlots do
		local stack, maxStack = GetSlotStackSize(bag, slot)
		local itemName = GetItemName(bag, slot)
		if (stack > 0 and itemName ~= nil) then
			local bagItem = bags[itemName] or {}
			bagItem[BAG_BANK] = bagItem[BAG_BANK] or {}
			bagItem[BAG_BACKPACK] = bagItem[BAG_BACKPACK] or {}
			bagItem.maxStack = maxStack
			bagItem.name = itemName
			table.insert(bagItem[bag], { bag = bag, slot = slot, stack = stack})
			bags[itemName] = bagItem
		end
	end
end

local function IndexBankAndBackpack()
	IndexBag(BAG_BANK, true)
	IndexBag(BAG_BACKPACK)
end

function SwizzyAddon.RestackBank()
	IndexBag(BAG_BANK, true)
	stackAndMoveItems(BAG_BANK, BAG_BANK)
end

function SwizzyAddon.RestackBackPack()
	IndexBag(BAG_BACKPACK, true)
	stackAndMoveItems(BAG_BACKPACK, BAG_BACKPACK)
end

function SwizzyAddon.RestackBackPackToBank()
	IndexBankAndBackpack()
	stackAndMoveItems(BAG_BACKPACK, BAG_BANK)
end