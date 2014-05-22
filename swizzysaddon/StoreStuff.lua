local storeVars = { }

function SwizzyAddon.ResetStoreVars()
	storeVars.Junk = 0
	storeVars.Sold = 0
	storeVars.Buy = 0
	storeVars.BuyBack = 0
	storeVars.Repairs = 0
	storeVars.FailedRepairs = 0
end

function SwizzyAddon.SellJunk()
	local JunkCount = 0
	local _, numSlots = GetBagInfo(BAG_BACKPACK)
	for slot = 0, numSlots do
		if IsItemJunk(BAG_BACKPACK, slot) then
			local _, stackCount, sellPrice = GetItemInfo(BAG_BACKPACK, slot)
			sellPrice = sellPrice * stackCount
			local name = SwizzyAddon.GetItemLink(BAG_BACKPACK, slot)
			SellInventoryItem(BAG_BACKPACK, slot, stackCount)
			if SwizzyAddon.Settings.SellJunk["Notify"] then
				if sellPrice > 0 then
					CHAT_SYSTEM:AddMessage("Sold [ " .. name .. " ] for |cFFFFFF" .. sellPrice .. "|r Gold")
				else
					CHAT_SYSTEM:AddMessage("Sold [ " .. name .. " ]")
				end
			end
			JunkCount = JunkCount + stackCount
			storeVars.Junk = storeVars.Junk + sellPrice
		end
	end
	if SwizzyAddon.Settings.SellJunk["NotifyAll"] and JunkCount > 0 then
		if storeVars.Junk > 0 then
			CHAT_SYSTEM:AddMessage("Sold |cFFFFFF" .. JunkCount .. "|r junk items for a total of |cFFFFFF" .. storeVars.Junk .. "|r Gold")
		else
			CHAT_SYSTEM:AddMessage("Sold |cFFFFFF" .. JunkCount .. "|r junk items")
		end
	end
end

local function RepairGear(bag, notify, notifyFail)
	local _, numSlots = GetBagInfo(bag)
	for slot = 0, numSlots do
		local _, stack = GetItemInfo(bag, slot)
		if stack > 0 and GetItemCondition(bag, slot) < 100 then
			local costs = GetItemRepairCost(bag, slot)
			if costs > 0 then
				if costs < GetCurrentMoney() then
					RepairItem(bag, slot)
					storeVars.Repairs = storeVars.Repairs + costs
					if notify then
						local name = SwizzyAddon.GetItemLink(bag, slot)
						CHAT_SYSTEM:AddMessage("Repaired [ " .. name .. " ] for |cFFFFFF" .. costs .. "|r Gold")
					end
				else
					if notifyFail then
						local name = SwizzyAddon.GetItemLink(bag, slot)
						CHAT_SYSTEM:AddMessage("|cFF0000Failed to Repair [ " .. name .. "|cFF0000 ] for |cFFFFFF" .. costs .. "|cFF0000 You need |cFFFFFF" .. costs - GetCurrentMoney() .. "|cFF0000 more Gold")
					end
					storeVars.FailedRepairs = storeVars.FailedRepairs + costs
				end
			end
		end
	end
end

function SwizzyAddon.RepairWornGear()
	SwizzyAddon.RepairGear(BAG_WORN, SwizzyAddon.Settings.Repair["NotifyEach"], SwizzyAddon.Settings.Repair["NotifyFailed"])
	if storeVars.FailedRepairs == 0 and storeVars.Repairs > 0 then
		CHAT_SYSTEM:AddMessage("Repaired all worn gear for |cFFFFFF" .. storeVars.Repairs .. "|r Gold")
	elseif storeVars.FailedRepairs > 0 and storeVars.Repairs > 0 then
		CHAT_SYSTEM:AddMessage("Repaired Some worn gear for |cFFFFFF" .. storeVars.Repairs .. "|r, Costs to repair the rest: |cFFFFFF" .. storeVars.FailedRepairs .. "|r Gold")
	elseif storeVars.FailedRepairs > 0 and storeVars.Repairs == 0 then
		CHAT_SYSTEM:AddMessage("|cFF0000Failed to repair worn gear! Gold required: |cFFFFFF" .. storeVars.FailedRepairs .. "|r")
	end
end

function SwizzyAddon.RepairAllGear()
	SwizzyAddon.RepairGear(BAG_WORN, SwizzyAddon.Settings.Repair["NotifyEach"], SwizzyAddon.Settings.Repair["NotifyFailed"])
	SwizzyAddon.RepairGear(BAG_BACKPACK, SwizzyAddon.Settings.Repair["NotifyEach"], SwizzyAddon.Settings.Repair["NotifyFailed"])
	if storeVars.FailedRepairs == 0 and storeVars.Repairs > 0 then
		CHAT_SYSTEM:AddMessage("Repaired all of your gear for |cFFFFFF" .. storeVars.Repairs .. "|r Gold")
	elseif storeVars.FailedRepairs > 0 and storeVars.Repairs > 0 then
		CHAT_SYSTEM:AddMessage("Repaired Some of your gear for |cFFFFFF" .. storeVars.Repairs .. "|r, Costs to repair the rest: |cFFFFFF" .. storeVars.FailedRepairs .. "|r Gold")
	elseif storeVars.FailedRepairs > 0 and storeVars.Repairs == 0 then
		CHAT_SYSTEM:AddMessage("|cFF0000Failed to repair your gear! Gold required: |cFFFFFF" .. storeVars.FailedRepairs .. "|r")
	end
end

function SwizzyAddon.HandleBuyReceipt(money)
	storeVars.Buy = storeVars.Buy + money
end

function SwizzyAddon.HandleBuyBackReceipt(money)
	storeVars.BuyBack = storeVars.BuyBack + money
end

function SwizzyAddon.HandleSellReceipt(money)
	storeVars.Sold = storeVars.Sold + money
end

function SwizzyAddon.TransactionDisplay()
	local spent = storeVars.Buy + storeVars.BuyBack + storevars.Repairs
	local earned = storeVars.Junk + storevars.Sold
	if SwizzyAddon.Settings.Transactions["Sold"] and earned > 0 then
		CHAT_SYSTEM:AddMessage("|c008000You've earned a total of |cFFFFFF".. earned .."|c008000 Gold")
	end
	if SwizzyAddon.Settings.Transactions["Spent"] and spent > 0 then
		CHAT_SYSTEM:AddMessage("|cFF0000You've spent a total of |cFFFFFF".. spent .." Gold")
	end
	if SwizzyAddon.Settings.Transactions["Total"] then
		if earned > spent and earned > 0 then
			CHAT_SYSTEM:AddMessage("|c008000Your total transactions earned you a total of |cFFFFFF".. earned - spent .."|c008000 Gold")
		elseif spent > 0 then
			CHAT_SYSTEM:AddMessage("|cFF0000Your total transactions cost you a total of |cFFFFFF".. spent - earned .."|cFF0000 Gold")
		end
	end
end