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
_addon.version  = '1.0.0';

require 'common'
require 'ffxi.targets'

----------------------------------------------------------------------------------------------------
-- Configurations
----------------------------------------------------------------------------------------------------
local default_config = {};
local popper_config = default_config;

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Attempt to load the configuration..
    popper_config = ashita.settings.load_merged(_addon.path .. 'settings/settings.json', popper_config);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Attempt to save the configuration..
    ashita.settings.save(_addon.path .. 'settings/settings.json', popper_config);
end);

----------------------------------------------------------------------------------------------------
-- func: command -- Code adapted from drawdistance.
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)

	-- Get the arguments of the command..
	local args = command:args();
	
	if (args[1] ~= '/pop') then
		return false;
	end

	local target = ashita.ffxi.targets.get_target('t');
    if (target == nil or target.Name == '' or target.TargetIndex == 0) then
		print('No target found');
		return true;
	end

	local zoneId = AshitaCore:GetDataManager():GetParty():GetMemberZone(0);
	local targetId = target.TargetIndex;

	local targetIdentity = zoneId .. '-' .. targetId;

	if (args[2] ~= nil) then
		popper_config[targetIdentity] = args[2];
		print('Registered pop "'..args[2]..'" for target: '.. targetIdentity)
	end

	if (popper_config[targetIdentity] == nil) then
		print('No registered item for target: '.. targetIdentity);
		print ('Use /pop \"<itemName>\" to register a pop');
		return true;
	end

	local command = '/item "' .. popper_config[targetIdentity] .. '" <t>';

	AshitaCore:GetChatManager():QueueCommand(command, 1);

    return true;
	end
);