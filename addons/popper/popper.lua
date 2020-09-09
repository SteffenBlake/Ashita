--[[
* Ashita - Copyright (c) 2014 - 2016 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'Soralin';
_addon.name     = 'Popper';
_addon.version  = '1.1.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config = {
	AutoSave = false;
};
local popper_config = default_config;

local DebugMode = false;

function ToggleDebugMode()
	DebugMode = not DebugMode;
	if (DebugMode) then
		PrintAddon("Debug mode enabled.");
	else
		PrintAddon("Debug mode disabled.");
	end
end

function PrintAddon(text)
	print("Popper: " .. text);
end

function PrintDebug(text)
	if (DebugMode) then
		print("Popper debug: " .. text);
	end
end

function ToggleAutoSave()
	popper_config.AutoSave = not popper_config.AutoSave;
	if (popper_config.AutoSave) then
		PrintAddon("Auto Save enabled.");
		SaveSettings();
	else
		PrintAddon("Auto Save disabled.");
	end
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
	LoadSettings();
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    SaveSettings();
end);

function LoadSettings()
	popper_config = ashita.settings.load_merged(_addon.path .. 'settings/settings.json', popper_config);
	PrintAddon("Settings loaded!");
	
	if (popper_config.AutoSave == nil) then
		popper_config.AutoSave = false;
	end

	-- Check if the config needs to update from 1.0.0 format to 1.1.0
	for k, v in pairs(popper_config) do
		if (type(v) == "table") then
			return;
		end

		if (type(v) == "string") then
			popper_config[k] = { };
			popper_config[k][v] = 1;
		end
	end

	PrintAddon("Detected 1.0.0 settings file, patching up to 1.1.0 format.");
	SaveSettings();
	PrintAddon("1.1.0 settings patch complete!");
end

function SaveSettings()
	local data = ashita.settings.JSON:encode_pretty(popper_config);
    local f = io.open(_addon.path .. 'settings/settings.json', 'w');
	f:write(data);
    f:close();
end

function PrintHelp()
	PrintAddon("/pop -- Trades registered items for a targeted npc");
	PrintAddon("/pop \"Item Name\" # \"Item Name\" # ... etc -- Registers a trade for a targetted NPC, then performs the trade");
	PrintAddon("/pop [save|load] -- Saves/Loads the current configuration, useful for multiboxing");
	PrintAddon("/pop autosave -- Toggles autosave functionality. When enabled, will automatically save new registrations.");
end

----------------------------------------------------------------------------------------------------
-- func: command -- Code adapted from drawdistance.
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
	local args = command:args();
	
	if (args[1] ~= '/pop') then
		return false;
	end

	if (#args == 1) then
		Execute();
		return true;
	end

	if (#args == 2) then
		if (args[2] == "debug") then
			ToggleDebugMode();
			return true;
		elseif (args[2] == "autosave") then
			ToggleAutoSave();
			return true;
		elseif (args[2] == "save") then
			SaveSettings();
			return true;
		elseif (args[2] == "load") then
			LoadSettings();
			return true;
		elseif (args[2] == "help") then
			PrintHelp();
			return true;
		else
			args = {args[1], args[2], 1};
		end
	end

	-- Even number of args is invalid input
	if (#args % 2 == 0) then
		PrintAddon("Unrecognized input!");
		PrintDebug("Arg Count: " .. #args);
		PrintHelp();
		return true;
	end

	RegisterPop(args);
	Execute();
    return true;
end);

-- Target identity consists of "<ZoneId>-<TargetIndex>"
function GetTargetIdentity() 
	local zoneId = AshitaCore:GetDataManager():GetParty():GetMemberZone(0);

	local target = ashita.ffxi.targets.get_target('t');
    if (target == nil or target.Name == '' or target.TargetIndex == 0) then
		PrintAddon('No target found');
		return true;
	end

	local targetId = target.TargetIndex;
	local targetIdentity = zoneId .. '-' .. targetId;

	return targetIdentity;
end

function RegisterPop(args)
	local targetIdentity = GetTargetIdentity();

	-- Create empty storage object
	popper_config[targetIdentity] = {};

	-- Save each of the ("Item Name", #) arg pairs to the object
	for i=2, #args, 2 do
		popper_config[targetIdentity][args[i]] = args[i+1];
	end

	if (popper_config.AutoSave) then
		SaveSettings();
	end

	PrintAddon("Pop registered! Now popping")
	PrintDebug('Registered pops for target: '.. targetIdentity)
end

function Execute()
	local command = '/trade ';
	local targetIdentity = GetTargetIdentity();

	if (popper_config[targetIdentity] == nil) then
		PrintAddon('No registered item(s) for this target.');
		PrintDebug("TargetIdentity: " .. targetIdentity);
		PrintAddon('Use /pop \"<itemName>\" # \"<itemName>\" # ... etc, to register a pop');
		return true;
	end

	-- Build the command out of the config
	for item, count in pairs(popper_config[targetIdentity]) do
		command = command .. '"' .. item .. '" ' .. count;
	end

	command = command .. " <t>";

	PrintDebug("Executing: ".. command);
	AshitaCore:GetChatManager():QueueCommand(command, 1);
end