local defaultMenu = "|cDCDC22Swizzy|r Settings"

WF_SW_MakeSettingsMenuItems = function()
	WF_SettingsMenu.AddNewSettingsPanel(defaultMenu) -- Create the system menu first
	WF_SettingsMenu.AddHeader("Store & Bank Settings", defaultMenu)
	
	WF_SettingsMenu.AddCheckbox("Enable Auto Banker", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoBanker["Enabled"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoBanker["Enabled"] = val
	end, nil, nil, defaultMenu)
	
	-- Transaction Stuff
	WF_SettingsMenu.AddCheckbox("Enable Total Sold Notifications", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.StoreSettings["TotalSold"] )
	end, function(val)
		WF_SW_SwizzyAddon.StoreSettings["TotalSold"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox("Enable Total Bought Notifications", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.StoreSettings["TotalBought"] )
	end, function(val)
		WF_SW_SwizzyAddon.StoreSettings["TotalBought"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox("Enable Total Transactions Notifications", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.StoreSettings["TotalAll"] )
	end, function(val)
		WF_SW_SwizzyAddon.StoreSettings["TotalAll"] = val
	end, nil, nil, defaultMenu)
	
	-- Sell Junk
	WF_SettingsMenu.AddCheckbox("Enable Automatic Sell Junk", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoSellJunk["Enabled"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoSellJunk["Enabled"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox(" - Enable Sold Item Notifications", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoSellJunk["SoldItem"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoSellJunk["SoldItem"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox(" - Enable Total Sold Junk Notifications", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoSellJunk["TotalSold"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoSellJunk["TotalSold"] = val
	end, nil, nil, defaultMenu)
	
	-- Gear Repairs
	WF_SettingsMenu.AddCheckbox("Enable Automatic Repair", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoRepair["Enabled"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoRepair["Enabled"] = val
	end, nil, nil, defaultMenu)			
	WF_SettingsMenu.AddCheckbox(" - Only Worn Gear", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoRepair["EquippedOnly"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoRepair["EquippedOnly"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox(" - Show each repaired item (and costs)", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.AutoRepair["Notify"] )
	end, function(val)
		WF_SW_SwizzyAddon.AutoRepair["Notify"] = val
	end, nil, nil, defaultMenu)
	
	-- General Settings
	WF_SettingsMenu.AddHeader("General Settings", defaultMenu)
	
	-- Automatic Trash Marking
	WF_SettingsMenu.AddCheckbox("Enable Automatic Junk Marking (Trash)", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.MarkJunk["Enabled"] )
	end, function(val)
		WF_SW_SwizzyAddon.MarkJunk["Enabled"] = val
	end, nil, nil, defaultMenu)
	
	-- Chat Background Modder
	WF_SettingsMenu.AddCheckbox("Enable Chat Background Modder", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.BackGroundMod["Enabled"] )
	end, function(val)
		WF_SW_SwizzyAddon.BackGroundMod["Enabled"] = val
	end, nil, nil, defaultMenu)
	WF_SettingsMenu.AddCheckbox(" - Hide Chat Background", nil, function() 
		return WF_GetOrDefault( true, WF_SW_SwizzyAddon.BackGroundMod["HideBG"] )
	end, function(val)
		WF_SW_SwizzyAddon.BackGroundMod["HideBG"] = val
	end, nil, nil, defaultMenu)
	
	-- Add new stuff here...
end

WF_SW_MakeSettingsVariables = function()
	if SwizzysAddon == nil then SwizzysAddon = {} end -- global to all chars
	-- Mark junk settings
	WF_SW_SwizzyAddon.MarkJunk = ZO_SavedVars:New("SwizzysAddonSettings", 2, "MarkJunk", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.MarkJunk["Enabled"] == nil then WF_SW_SwizzyAddon.MarkJunk["Enabled"] = WF_GetOrDefault(false)	end
	
	-- Store Settings
	WF_SW_SwizzyAddon.StoreSettings = ZO_SavedVars:New("SwizzysAddonSettings", 2, "StoreSettings", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.StoreSettings["TotalSold"] == nil then WF_SW_SwizzyAddon.StoreSettings["TotalSold"] = false end
	if WF_SW_SwizzyAddon.StoreSettings["TotalBought"] == nil then WF_SW_SwizzyAddon.StoreSettings["TotalBought"] = false end
	if WF_SW_SwizzyAddon.StoreSettings["TotalAll"] == nil then WF_SW_SwizzyAddon.StoreSettings["TotalAll"] = false end
	
	-- Repair gear settings
	WF_SW_SwizzyAddon.AutoRepair = ZO_SavedVars:New("SwizzysAddonSettings", 2, "AutoRepair", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.AutoRepair["Enabled"] == nil then WF_SW_SwizzyAddon.AutoRepair["Enabled"] = false end
	if WF_SW_SwizzyAddon.AutoRepair["EquippedOnly"] == nil then WF_SW_SwizzyAddon.AutoRepair["EquippedOnly"] = true end
	if WF_SW_SwizzyAddon.AutoRepair["Notify"] == nil then WF_SW_SwizzyAddon.AutoRepair["Notify"] = false end
	
	-- Sell junk settings
	WF_SW_SwizzyAddon.AutoSellJunk = ZO_SavedVars:New("SwizzysAddonSettings", 2, "AutoSellJunk", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.AutoSellJunk["Enabled"] == nil then WF_SW_SwizzyAddon.AutoSellJunk["Enabled"] = false end
	if WF_SW_SwizzyAddon.AutoSellJunk["TotalSold"] == nil then WF_SW_SwizzyAddon.AutoSellJunk["TotalSold"] = true end
	if WF_SW_SwizzyAddon.AutoSellJunk["SoldItem"] == nil then WF_SW_SwizzyAddon.AutoSellJunk["SoldItem"] = true end
	
	-- Chat Background
	WF_SW_SwizzyAddon.BackGroundMod = ZO_SavedVars:New("SwizzysAddonSettings", 2, "BackGroundMod", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.BackGroundMod["Enabled"] == nil then WF_SW_SwizzyAddon.BackGroundMod["Enabled"] = false end
	if WF_SW_SwizzyAddon.BackGroundMod["HideBG"] == nil then WF_SW_SwizzyAddon.BackGroundMod["HideBG"] = false end
	
	-- AutoBanker
	WF_SW_SwizzyAddon.AutoBanker = ZO_SavedVars:New("SwizzysAddonSettings", 2, "AutoBanker", {}, "Settings") or {}
	if WF_SW_SwizzyAddon.AutoBanker["Enabled"] == nil then WF_SW_SwizzyAddon.AutoBanker["Enabled"] = true end
end