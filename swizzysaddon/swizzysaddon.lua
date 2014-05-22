--[[
  * Swizzy's Addon
  * Author: Swizzy <swizzy@xeupd.com>
  * Special Thanks To: Zenimax Online Studios & Bethesda for The Elder Scrolls Online
]]--

SwizzyAddon = {}
SwizzyAddon.name = "Swizzy's Addon"
SwizzyAddon.AddonID = "swizzysaddon"
SwizzyAddon.versionString = "v1.0.0"
SwizzyAddon.Initalized = false

function SwizzyAddon.Initialize( eventCode, AddonName )
	-- Only set up for SwizzyAddon and only if it's not already initalized
	if AddonName ~= SwizzyAddon.name or SwizzyAddon.Initalized then
		return
	end
	-- Create or load our settings storage
	SwizzyAddon.Settings = ZO_SavedVars:NewAccountWide("SwizzysAddonSettings", SwizzyAddon.versionString, nil, SwizzyAddon.Defaults)
	-- Create our settings menu one second after the addon has been initalized...
	zo_callLater(SwizzyAddon.SetupSettingsMenu, 1000)

	SLASH_COMMANDS["/leave"] = LeaveGroup()
	SLASH_COMMANDS["/coords"] = PrintCoords
	CHAT_SYSTEM:AddMessage("|cDCDC22"..SwizzyAddon.AddonName.."|r "..SwizzyAddon.versionString.." Loaded!")
	SwizzyAddon.Initalized = true
end

-- Hook initialization onto the ADD_ON_LOADED event
EVENT_MANAGER:RegisterForEvent( SwizzyAddon.name, EVENT_ADD_ON_LOADED, SwizzyAddon.Initialize )

--[[ LOCAL PROGRAMMING ]]--

local function PrintCoords(x, y)
	CHAT_SYSTEM:AddMessage(string.format("X: %f Y: %f", x, y))
end

local function ShowCoords(text)
	local x, y = GetMapPlayerPosition("player")
	if text == "" then
		PrintCoords(x, y)
	elseif text == "show" then
		--CoordsDisplay.Hidden(false)
	elseif text == "hide" then
		--CoordsDisplay.Hidden(true)
	end
end

local function LeaveGroup()
	if IsUnitGrouped("player") then
		GroupLeave()
	end
end

function SwizzyAddon.GetItemLink(bagId, slotId)
	return GetItemLink(bagId, slotId):gsub("%^%a+","")
end