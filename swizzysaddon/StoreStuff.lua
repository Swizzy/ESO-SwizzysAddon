function WF_SW_SwizzyAddon.SellJunk()
	if WF_SW_SwizzyAddon.AutoSellJunk["Enabled"] and HasAnyJunk(BAG_BACKPACK) then -- Check if the feature is enabled, and if we have junk items...
		local _, numBagSlots = GetBagInfo(BAG_BACKPACK) -- Get equipment total
		for slotId = 0,  numBagSlots do -- Loop items to manually sell each junk item...
			if IsItemJunk(BAG_BACKPACK, slotId) then -- Check if it's junk or not
				local _, stackCount, sellPrice = GetItemInfo(BAG_BACKPACK, slotId) -- Get item information (quantity and price)
				sellPrice = sellPrice * stackCount;
				local name = WF_SW_SwizzyAddon_GetItemLink(BAG_BACKPACK, slotId) -- Get item name
				SellInventoryItem(BAG_BACKPACK, slotId, stackCount) -- Sell it!
				if WF_SW_SwizzyAddon.AutoSellJunk["SoldItem"] then -- Check if we shall print each sold item
					if sellPrice > 0 then -- Check if the price of the sold item(s) is not 0
						CHAT_SYSTEM:AddMessage("Sold [ " .. name .. " ] for |cFFFFFF" .. sellPrice .. "|r Gold")
					else -- Item value is 0!
						CHAT_SYSTEM:AddMessage("Sold [ " .. name .. " ]")
					end -- End check for value
				end -- End of checking if we shall print each sold item
				WF_SW_SwizzyAddonVars.TotalJunkSold = WF_SW_SwizzyAddonVars.TotalJunkSold + stackCount -- Update sold items count...
				WF_SW_SwizzyAddonVars.TotalJunkGold = WF_SW_SwizzyAddonVars.TotalJunkGold + sellPrice -- Update sold items value...
			end 
		end -- End of loop
		if WF_SW_SwizzyAddon.AutoSellJunk["TotalSold"] then -- Check if we should mention total sold...
			if WF_SW_SwizzyAddonVars.TotalJunkSold > 0 then -- Check if we sold any items
				if WF_SW_SwizzyAddonVars.TotalJunkGold > 0 then -- Check if the price of the sold items is not 0
					CHAT_SYSTEM:AddMessage("Sold |cFFFFFF" .. WF_SW_SwizzyAddonVars.TotalJunkSold .. "|r items for a total of |cFFFFFF" .. WF_SW_SwizzyAddonVars.TotalJunkGold .. "|r gold coins")
				else -- Item value is 0!
					CHAT_SYSTEM:AddMessage("Sold |cFFFFFF" .. WF_SW_SwizzyAddonVars.TotalJunkSold .. "|r items")
				end
			end
		end
	end
end

local function RepairWornGear()
	WF_SW_SwizzyAddonVars.RepairsCost = 0
	local _, bagSlots = GetBagInfo(BAG_WORN)
	for slotIndex = 0, bagSlots do 
		local condition = GetItemCondition(bagId, slotIndex)
		if condition < 100 then
			local _, stackCount = GetItemInfo(bagId, slotIndex)
			if stackCount > 0 then
				local repairCost = GetItemRepairCost(bagId, slotIndex)
				if repairCost > 0 then
					if WF_SW_SwizzyAddon.AutoRepair["Notify"] then
						local name = WF_SW_SwizzyAddon_GetItemLink(bagId, slotIndex)
					end
					WF_SW_SwizzyAddonVars.RepairsCost = WF_SW_SwizzyAddonVars.RepairsCost + repairCost;
					RepairItem(bagId, slotIndex)
				end
			end
		end
	end
end

local function RepairBackPackGear()
	local _, bagSlots = GetBagInfo(BAG_BACKPACK)
	for slotIndex = 0, bagSlots do
		local condition = GetItemCondition(bagId, slotIndex)
		if condition < 100 then
			local _, stackCount = GetItemInfo(bagId, slotIndex)
			if stackCount > 0 then
				local repairCost = GetItemRepairCost(bagId, slotIndex)
				if repairCost > 0 then
					WF_SW_SwizzyAddonVars.RepairsCost = WF_SW_SwizzyAddonVars.RepairsCost + repairCost;
					RepairItem(bagId, slotIndex)
				end
			end
		end
	end
end

function WF_SW_SwizzyAddon.RepairGear()
	if WF_SW_SwizzyAddon.AutoRepair["Enabled"] then
		WF_SW_SwizzyAddonVars.RepairsCost = GetRepairAllCost()
		if WF_SW_SwizzyAddon.AutoRepair["EquippedOnly"] then
			RepairWornGear()
			if WF_SW_SwizzyAddonVars.RepairsCost > 0 then 
				CHAT_SYSTEM:AddMessage("All Equipped Items Repaired. Costs: |cFFFFFF" .. WF_SW_SwizzyAddonVars.RepairsCost .. "|r Gold")
			end
		elseif WF_SW_SwizzyAddonVars.RepairsCost > 0 then
			if (not WF_SW_SwizzyAddon.AutoRepair["Notify"]) then
				RepairAll()
			else
				RepairWornGear()
				RepairBackPackGear()
			end				
			CHAT_SYSTEM:AddMessage("All Items Repaired. Costs: |cFFFFFF" .. WF_SW_SwizzyAddonVars.RepairsCost .. "|r Gold")
		end
	end
end

function WF_SW_SwizzyAddon.SoldNotifications()
	WF_SW_SwizzyAddonVars.SpentGold = WF_SW_SwizzyAddonVars.SpentGold + WF_SW_SwizzyAddonVars.RepairsCost;
	if WF_SW_SwizzyAddon.StoreSettings["TotalSold"] then
		if WF_SW_SwizzyAddonVars.SoldGold > 0 then
			CHAT_SYSTEM:AddMessage("You've sold items worth a total of "..WF_SW_SwizzyAddonVars.SoldGold.." Gold")
		end
	end
	if WF_SW_SwizzyAddon.StoreSettings["TotalBought"] then
		if WF_SW_SwizzyAddonVars.SpentGold > 0 then
			CHAT_SYSTEM:AddMessage("You've bought items worth a total of "..WF_SW_SwizzyAddonVars.SpentGold.." Gold")
		end
	end
	if WF_SW_SwizzyAddon.StoreSettings["TotalAll"] then
		local value = WF_SW_SwizzyAddonVars.SoldGold - WF_SW_SwizzyAddonVars.SpentGold;
		if value ~= 0 then
			if value < 0 then
				local neg = -1; -- can't do " value * -1 " >_<
				value = value * neg; -- We want a positive value!
				CHAT_SYSTEM:AddMessage("Your total transactions cost you "..value.." Gold")
			else
				CHAT_SYSTEM:AddMessage("Your total transactions got you "..value.." Gold") 
			end
		end
	end
end