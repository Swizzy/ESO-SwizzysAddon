--[[
  * Swizzy's Addon
  * Supported by: Wykkyd
  * Author: Swizzy <swizzy@xeupd.com>
  * Special Thanks To: Zenimax Online Studios & Bethesda for The Elder Scrolls Online
]]--

WF_SW_SwizzyAddonVars = {} -- Saved variables
WF_SW_SwizzyAddon = {}
WF_SW_SwizzyAddon.__index = WF_SW_SwizzyAddon
WF_SW_SwizzyAddon.AddonID = "swizzysaddon"

local LAM = LibStub("LibAddonMenu-1.0")

--[[ LOCAL PROGRAMMING ]]--

local PrintCoords = function()
	SetMapToPlayerLocation() -- Make sure we get the accurate location
	local x, y = GetMapPlayerPosition("player")
	CHAT_SYSTEM:AddMessage(string.format("X: %f Y: %f", x, y))
end

local LeaveGroup = function()
	if IsUnitGrouped("player") then
		GroupLeave()
	end
end

function WF_SW_SwizzyAddon_GetItemLink(bagId, slotId)
	return GetItemLink(bagId, slotId):gsub("%^%a+","")
end

WF_SW_SwizzyAddon.Ready, WF_SW_SwizzyAddon.AddonName, WF_SW_SwizzyAddon.AddonAbbrev, WF_SW_SwizzyAddon.AddonVersion, WF_SW_SwizzyAddon.AddonDescr = WF_RegisterFactory( 
	WF_SW_SwizzyAddon.AddonID, 
	{
		AddonID = WF_SW_SwizzyAddon.AddonID,
		AddonName = "Swizzy's Addon",
		AddonAbbrev = "SwizzysAddon",
		Author = "Swizzy",
		AddonVersion = "1.0.0.0",
		StartUp = function()
			WF_SW_MakeSettingsMenuItems() -- Make the Settings menu items
			--[[ SLASH COMMAND REGISTRATIONS HERE ]]--
			wykkydsFramework.Commands.Add("coords", PrintCoords)
			wykkydsFramework.Commands.Add("groupleave", LeaveGroup)
			wykkydsFramework.Commands.Add("leavegroup", LeaveGroup)
			wykkydsFramework.Commands.Add("leave", LeaveGroup)
			--[[ UPDATE TIC & EVENT REGISTRATIONS HERE ]]--			
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(eventCode, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
				if WF_SW_SwizzyAddon.MarkJunk["Enabled"] then -- Check if the feature is enabled
					if bagId == BAG_BACKPACK and isNewItem then -- Check that we are in the bag and that the item is new (we don't want to change existing stuff!)
						if GetItemType(bagId, slotId) == ITEMTYPE_TRASH then -- Check if item is "Trash", meaning useless stuff that is meant only for selling
							SetItemIsJunk(bagId, slotId, true) -- Set item as junk
							CHAT_SYSTEM:AddMessage("Marked [ " .. WF_SW_SwizzyAddon_GetItemLink(bagId, slotId) ..  " ] as Junk!")
						end
					end
				end
			end)
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_OPEN_STORE, function()
				WF_SW_SwizzyAddonVars.TotalJunkSold = 0 -- Reset sold junk count
				WF_SW_SwizzyAddonVars.TotalJunkGold = 0 -- Reset sold junk value
				WF_SW_SwizzyAddonVars.SoldGold = 0 -- Reset sold gold value
				WF_SW_SwizzyAddonVars.SpentGold = 0 -- Reset spent gold value
				WF_SW_SwizzyAddonVars.RepairsCost = 0 -- Reset Repairs Costs
				WF_SW_SwizzyAddon.SellJunk()
				WF_SW_SwizzyAddon.RepairGear()
			end)
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_SELL_RECEIPT, function(...)
				--WF_SW_SwizzyAddonVars.Sold = { ... }
				_,name,quantity,money = ...;
				WF_SW_SwizzyAddonVars.SoldGold = WF_SW_SwizzyAddonVars.SoldGold + money;
			end)
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_BUY_RECEIPT , function(...)
				--WF_SW_SwizzyAddonVars.Bought = { ... }
				_,name,_,quantity,money = ...;
				WF_SW_SwizzyAddonVars.SpentGold = WF_SW_SwizzyAddonVars.SpentGold + money;
			end)
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_BUYBACK_RECEIPT, function(...)
				--WF_SW_SwizzyAddonVars.BuyBack = { ... }
				_,name,quantity,money = ...;
				WF_SW_SwizzyAddonVars.SpentGold = WF_SW_SwizzyAddonVars.SpentGold + money;
			end)
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_CLOSE_STORE , function()
				WF_SW_SwizzyAddon.SoldNotifications()
			end)			
			EVENT_MANAGER:RegisterForEvent(WF_SW_SwizzyAddon.AddonID, EVENT_OPEN_BANK, WF_SW_SwizzyAddon.HandleOpenBank)
			WF_Tic("SwizzyChatBGMod")
			WF_Tic("SwizzyChatBGMod", function() SwizzyChatBGMod(); end)
		end,
		SavedVariables = function()
			WF_SW_MakeSettingsVariables()
		end,
	}
)

SwizzyChatBGMod = function()
	if WF_SW_SwizzyAddon.BackGroundMod["Enabled"] then
		if WF_SW_SwizzyAddon.BackGroundMod["HideBG"] then
			if _G["wykkydsChatFrameBackPanel"] ~= nil then
				_G["wykkydsChatFrameBackPanel"]:SetHidden(true)
				_G["wykkydsChatFrameBackPanel"].bg:SetHidden(true)
			end
			ZO_ChatWindowBg:SetAlpha(0)
		else
			if _G["wykkydsChatFrameBackPanel"] ~= nil then
				_G["wykkydsChatFrameBackPanel"]:SetHidden(false)
				_G["wykkydsChatFrameBackPanel"].bg:SetHidden(false)
			end
			ZO_ChatWindowBg:SetAlpha(1)
		end
	end
end
--[[ NON-LOCAL PROGRAMMING ]]--