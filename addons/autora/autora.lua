--[[
* Ashita - Copyright (c) 2014 - 2017 atom0s [atom0s@live.com]
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

_addon.author   = 'Shinzaku, tweaked by Soralin';
_addon.name     = 'AutoRA';
_addon.version  = '1.0.1';

require 'common'

local running = true;
local tpHaltThreshold = 1000;
local resumeOnWS = true;

ashita.register_event('incoming_packet', function(id, size, data)
    if (id == 0x028) then
		local cat = ashita.bits.unpack_be(data, 0x0A, 2, 4);
		-- Ranged attack
		if (cat == 2 and running) then
			ashita.timer.once(1.2, Fire);
		end;
		-- Weaponskill
		if (cat == 3 and running and resumeOnWS) then
			ashita.timer.once(2.4, Fire);
		end;
	end;
	
    return false;
end);

function Fire()
	local currentTp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentTP(0);
	if (currentTp < tpHaltThreshold) then
		AshitaCore:GetChatManager():QueueCommand('/ra', 1);
	end
end;

function PrintHelp(cmd, help)
    -- Loop and print the help commands..
    for k, v in pairs(help) do
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Syntax:\30\02 ' .. v[1] .. '\30\71 ' .. v[2]);
    end
end

ashita.register_event('command', function(cmd, nType)
    local args = cmd:args();
	
	if (args[1] ~= '/autora' and args[1] ~= '/ar') then
		return false;
	end

	print(tpHaltThreshold);

	if (#args >= 2) then
		if (args[2] == 'start') then
			running = true;
			print("Starting AutoRa!")
			return true;
		end
	
		if (args[2] == 'stop') then
			running = false;
			print("Stopping AutoRa!")
			return true;
		end

		if (args[2] == 'tp' and #args == 3) then
			haltontp = tonumber(args[3]);
			print("TP Halt value set to: " .. tpHaltThreshold);
			return true;
		end

		if (args[2] == 'ws') then
			if (#args >= 3) then
				if (args[2] == 'on') then
					resumeOnWS = true;
				elseif (args[2] == 'off') then
					resumeOnWS = false;
				end
			else
				resumeOnWS = not resumeOnWS;
			end
			if (resumeOnWS) then
				print("Resume after WS enabled")
			else
				print("Resume after WS disabled")
			end

			return true;
		end
	end
	
	PrintHelp('/autora|/ar', {
		{'/[/autora|/ar] start', ' - starts AutoRA (Will start autoshooting after your first shot)'},
		{'/[/autora|/ar] stop', ' - stops AutoRA (Will stop shooting for you)'},
		{'/[/autora|/ar] tp #', ' - sets the TP threshold to pause shooting at'},
		{'/[/autora|/ar] ws [on|off]', ' - sets "Resume after WS" mode on/off, toggles if not specified'},
	});

    return true;
end);