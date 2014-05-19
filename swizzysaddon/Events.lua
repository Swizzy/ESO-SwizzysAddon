function SwizzyAddon.SingleItemUpdateHandler(eventCode, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
	if SwizzyAddon.Settings.MarkTrashJunk["Enabled"] then -- Check if the marktTrash as junk feature is enabled
		if bagId == BAG_BACKPACK and isNewItem then -- Check that we are in the bag and that the item is new (we don't want to change existing stuff!)
			if GetItemType(bagId, slotId) == ITEMTYPE_TRASH then -- Check if item is "Trash", meaning useless stuff that is meant only for selling
				SetItemIsJunk(bagId, slotId, true) -- Set item as junk
				CHAT_SYSTEM:AddMessage("Marked [ " .. SwizzyAddon.GetItemLink(bagId, slotId) ..  " ] as Junk!")
			end
		end
	end
end