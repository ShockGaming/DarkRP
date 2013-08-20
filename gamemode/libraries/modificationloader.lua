/*---------------------------------------------------------------------------
Disabled defaults
---------------------------------------------------------------------------*/
DarkRP.disabledDefaults = {}
DarkRP.disabledDefaults["modules"] = {
	["afk"]              = true,
	["chatsounds"]       = false,
	["events"]           = false,
	["fpp"]              = false,
	["hitmenu"]          = false,
	["hud"]              = false,
	["hungermod"]        = true,
	["playerscale"]      = false,
	["sleep"]            = false,
	["voterestrictions"] = true,
}

DarkRP.disabledDefaults["agendas"]    = {}
DarkRP.disabledDefaults["ammo"]       = {}
DarkRP.disabledDefaults["doorgroups"] = {}
DarkRP.disabledDefaults["entities"]   = {}
DarkRP.disabledDefaults["groupchat"]  = {}
DarkRP.disabledDefaults["hitmen"]     = {}
DarkRP.disabledDefaults["jobs"]       = {}
DarkRP.disabledDefaults["shipments"]  = {}
DarkRP.disabledDefaults["vehicles"]   = {}

if file.Exists("darkrp_config/disabled_defaults.lua", "LUA") then
	if SERVER then AddCSLuaFile("darkrp_config/disabled_defaults.lua") end
	include("darkrp_config/disabled_defaults.lua")
end

/*---------------------------------------------------------------------------
Config
---------------------------------------------------------------------------*/
if file.Exists("darkrp_config/settings.lua", "LUA") then
	if SERVER then AddCSLuaFile("darkrp_config/settings.lua") end
	include("darkrp_config/settings.lua")
end

/*---------------------------------------------------------------------------
Modules
---------------------------------------------------------------------------*/
local function loadModules()
	local fol = "darkrp_modules/"
	if not file.IsDir("darkrp_modules/", "LUA") then return end

	local files, folders = file.Find(fol .. "*", "LUA")

	for _, folder in SortedPairs(folders, true) do
		if folder == "." or folder == ".." then continue end

		for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
			if SERVER then AddCSLuaFile(fol..folder .. "/" ..File) end

			if File == "sh_interface.lua" then continue end
			include(fol.. folder .. "/" ..File)
		end

		if SERVER then
			for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
				if File == "sv_interface.lua" then continue end
				include(fol.. folder .. "/" ..File)
			end
		end

		for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
			if File == "cl_interface.lua" then continue end
			if SERVER then AddCSLuaFile(fol.. folder .. "/" ..File)
			else include(fol.. folder .. "/" ..File)  end
		end
	end
end

local customFiles = {
	"darkrp_customthings/jobs.lua",
	"darkrp_customthings/shipments.lua",
	"darkrp_customthings/entities.lua",
	"darkrp_customthings/vehicles.lua",
	"darkrp_customthings/ammo.lua",
	"darkrp_customthings/groupchats.lua",
	"darkrp_customthings/agendas.lua", -- has to be run after jobs.lua
	"darkrp_customthings/doorgroups.lua", -- has to be run after jobs.lua
}
local function loadCustomDarkRPItems()
	for _, File in pairs(customFiles) do
		if not file.Exists(File, "LUA") then continue end

		if SERVER then AddCSLuaFile(File) end
		include(File)
	end
end


local function load()
	loadModules()
	loadCustomDarkRPItems()
end
hook.Add("Initialize", "loadDarkRPModules", load)
hook.Add("OnReloaded", "loadDarkRPModules", load)