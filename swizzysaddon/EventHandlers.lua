function SwizzyAddon.SingleItemUpdateHandler(_, bagId, slotId, isNewItem)
	if SwizzyAddon.Settings.MarkTrashJunk["Enabled"] then
		if bagId == BAG_BACKPACK and isNewItem then
			if GetItemType(bagId, slotId) == ITEMTYPE_TRASH then
				SetItemIsJunk(bagId, slotId, true)
				CHAT_SYSTEM:AddMessage("Marked [ " .. SwizzyAddon.GetItemLink(bagId, slotId) ..  " ] as Junk!")
			end
		end
	end
end

function SwizzyAddon.BankOpenHandler(_, _, isManual)
	if isManual then
		return
	end
	if SwizzyAddon.Settings.RestackBackPackToBank["Enabled"] then
		ClearCursor()
		SwizzyAddon.RestackBackPack
		SwizzyAddon.RestackBank()
		SwizzyAddon.RestackBackPackToBank
	end
end

function SwizzyAddon.StoreOpenHandler()
	SwizzyAddon.ResetStoreVars()
	if SwizzyAddon.Settings.SellJunk["Enabled"] then
		SwizzyAddon.SellJunk()
	end
end

function SwizzyAddon.StoreBuyReceiptHandler(_, _, _, _, money)
	SwizzyAddon.HandleBuyReceipt(money)
end

function SwizzyAddon.StoreBuyBackReceiptHandler(_, _, _, money)
	SwizzyAddon.HandleBuyBackReceipt(money)
end

function SwizzyAddon.StoreSellReceiptHandler(_, _, _, money)
	SwizzyAddon.HandleSellReceipt(money)
end

function SwizzyAddon.StoreCloseHandler()
	SwizzyAddon.TransactionDisplay()
end

function SwizzyAddon.OnUpdateHandler()
	if SwizzyAddon.Settings.ChatBG["Enabled"]
		if SwizzyAddon.Settings.ChatBG["Hide"]
			ZO_ChatWindowBg:SetAlpha(0)
		else
			ZO_ChatWindowBg:SetAlpha(1)
		end
	end
end

function SwizzyAddon.RegisterEvents()
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, SingleItemUpdateHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_OPEN_BANK, BankOpenHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_OPEN_STORE, StoreOpenHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_BUY_RECEIPT, StoreBuyReceiptHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_BUYBACK_RECEIPT, StoreBuyBackReceiptHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_SELL_RECEIPT, StoreSellReceiptHandler)
	EVENT_MANAGER:RegisterForEvent(SwizzyAddon.AddonID, EVENT_CLOSE_STORE, StoreCloseHandler)
end