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
_addon.name     = 'Runic';
_addon.version  = '1.0.0';

require 'common'
require 'ffxi.recast'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config = {
	AutoRune = false
};
local runic_config = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Attempt to load the configuration..
    runic_config = ashita.settings.load_merged(_addon.path .. 'settings/settings.json', runic_config);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Attempt to save the configuration..
    ashita.settings.save(_addon.path .. 'settings/settings.json', runic_config);
end);

local buffIcons = {
	ignis = 523,
	gelus = 524,
	flabra = 525,
	tellus = 526,
	sulpor = 527,
	unda = 528,
	lux = 529,
	tenebrae = 530,
};

local buffs = {};

----------------------------------------------------------------------------------------------------
-- func: command -- Code adapted from drawdistance.
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)

	-- Get the arguments of the command..
	local args = command:args();
	
	if (args[1] ~= '/runic') then
		return false;
	end

	if (args[2] == nil) then
		return printBuffs();
	end

	local cmd = string.lower(args[2]);

	if(cmd == "help") then 
		print("/runic <RuneName> -- Adds <RuneName> to the roster");
		print("/runic exec -- Will attempt to execute the next missing rune, if there is one.");
		print("/runic auto <on/off> -- Enables/Disables/Toggles automic Rune Execution");
		return true;
	end

	if(cmd == "exec") then 
		return ExecuteRunes();
	end

	if(cmd == "auto") then 
		if (args[3] == nil) then
			runic_config.AutoRune = not runic_config.AutoRune;
			return printAuto();
		end
		local setting = string.lower(args[3]);
		if (setting == "on") then
			runic_config.AutoRune = true;
			return printAuto();
		end
		if (setting == "off") then
			runic_config.AutoRune = false;
			return printAuto();
		end
		print ("Unrecognized 'auto' input, please use 'On' or 'Off'");
	end

	if(buffIcons[cmd] == nil) then
		print("Unrecognized buff choice '" .. cmd .. "'");
		return false;
	end

	table.insert(buffs, cmd);
	if (#buffs > 3) then
		table.remove(buffs, 1);
	end

    return printBuffs();
	end
);

function printAuto()
	if (runic_config.AutoRune) then
		print ("AutoMode: On");
		return true;
	end

	print ("AutoMode: Off");
	return true;
end

function printBuffs()
	local selectedBuffs = getSelectedBuffs();

	local outMsg = "Runes:";
	for selectedBuff, buffCount in pairs(selectedBuffs) do
		outMsg = outMsg .. " " .. selectedBuff .. ":" .. buffCount;
	end

	print(outMsg);
	return true;
end

ashita.register_event('render', function()
	if(runic_config.AutoRune) then
		ExecuteRunes();
	end
end);

function getSelectedBuffs()
	local selectedBuffs = {};
	for n,selectedBuff in ipairs(buffs) do
		if (selectedBuffs[selectedBuff] == nil) then
			selectedBuffs[selectedBuff] = 0;
		end
		selectedBuffs[selectedBuff] = selectedBuffs[selectedBuff]+1;
	end

	return selectedBuffs;
end

local runeEnchantmentId = 92;
function ExecuteRunes() 
	if (#buffs == 0) then
		return true;
	end

	for n=0, 31 do
		local recastId = ashita.ffxi.recast.get_ability_id_from_index(n);
        local recastTimer = ashita.ffxi.recast.get_ability_recast_by_index(n); 
		
		if(recastId == runeEnchantmentId and recastTimer > 0) then
			-- Rune Enchantment JA is on cooldown
			return true;
		end
	end

	local currentIcons = {};

	for n, icon in ipairs(AshitaCore:GetDataManager():GetPlayer():GetStatusIcons()) do
		if (currentIcons[icon] == nil) then
			currentIcons[icon] = 0;
		end
		currentIcons[icon] = currentIcons[icon] +1;
	end

	local selectedBuffs = getSelectedBuffs();

	for buff, buffCount in pairs(selectedBuffs) do
		if (currentIcons[buffIcons[buff]] == nill) then
			return ExecuteRune(buff);
		end
		if (currentIcons[buffIcons[buff]] < buffCount) then
			return ExecuteRune(buff);
		end
	end

	return true;
end

function ExecuteRune(runeName) 
	local command = "/ja " .. runeName;
	AshitaCore:GetChatManager():QueueCommand(command, 1);
	return true;
end