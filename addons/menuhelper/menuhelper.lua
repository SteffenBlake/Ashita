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
_addon.name     = 'MenuHelper';
_addon.version  = '1.0.0';

require 'common'
require 'timer'

local function GetMenuPointer() 
	local menuPattern =  '8B480C85C974??8B510885D274??3B05';
	local menu1 = ashita.memory.findpattern('FFXiMain.dll', 0, menuPattern, 16, 0);
	if (menu1 == 0) then
		return 0;
	end
	local menu2 = ashita.memory.read_int32(menu1);
	if (menu2 == 0) then
		return 0;
	end
	local menuPtr = ashita.memory.read_int32(menu2);

	return menuPtr;
end

local function MenuIsOpen()
	return GetMenuPointer() ~= 0;
end

local function GetMenuIndex() 
	return ashita.memory.read_uint16(GetMenuPointer() + 0x4C);
end

local function SetMenuIndex(index) 
	if (not MenuIsOpen()) then
		return;
	end
	local trueIndex = 0;
	local count = GetMenuItemsCount();

	if (index < 0)  then
		trueIndex = index + 1 + count;
		if (trueIndex < 1) then
			trueIndex = 1;
		end
		print ("/echo " .. trueIndex);
	elseif (index > count) then
		trueIndex = count;
	else
		trueIndex = index;
	end

	return ashita.memory.write_uint16(GetMenuPointer() + 0x4C, index);
end

function GetMenuItemsCount() 
	return ashita.memory.read_uint16(GetMenuPointer() + 0x58);
end

function PrintMenu() 
	if (not MenuIsOpen()) then
		print("No menu found.");
	end

	print("Menu -- Index:" .. GetMenuIndex() .. " Count:" .. GetMenuItemsCount());
end

function ExecuteMenu(args, step)
	if (not MenuIsOpen()) then
		ashita.timer.once(0.1, ExecuteMenu, args, step);
	end
	if (#args < step) then
		return;
	end
	SetMenuIndex(tonumber(args[step]));
	ashita.timer.once(0.1, PressMenu, args, step);
end

function PressMenu(args, step)
	AshitaCore:GetChatManager():QueueCommand('/sendkey return down', 1);
	ashita.timer.once(0.1, ReleaseMenu, args, step);
end

function ReleaseMenu(args, step)
	AshitaCore:GetChatManager():QueueCommand('/sendkey return up', 1);
	ashita.timer.once(0.1, ExecuteMenu, args, step+1);
end

----------------------------------------------------------------------------------------------------
-- func: command -- Code adapted from drawdistance.
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)

	-- Get the arguments of the command..
	local args = command:args();
	
	if (args[1] == '/printmenu') then
		ashita.timer.once(0.5, PrintMenu);
		return true;
	end

	if (args[1] == '/setmenu') then
		local index = tonumber(args[2]);
		ashita.timer.once(0.5, SetMenuIndex, index);
		return true;
	end

	if (args[1] == '/menu') then
		ashita.timer.once(0.1, PressMenu, args, 1);
		return true;
	end

	return false;
end);