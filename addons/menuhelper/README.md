# MenuHelper

Addon to execute menu chains via a input command

Combine this with Multisend for easy mule navigation!s

## /menu {A:int} {B:int} {C:int} {D:int} {E:int} ....

Hits enter on currently selected NPC, then will execute menu entries A, B, C, D... etc.

For example:

/menu 1 5 2 3

Will hit enter on currently selected npc, then select menu option 1, then 5, then 2, then 3, through the series of menus

Note: Menu indexes are 1 based, not 0, so the first menu option (the top one) is 1, then 2, then 3, etc.

## /printmenu

Prints out the current menu entry you are selected, which can be helpful for quickly figuring out your currently selected menu option

## /setmenu {A:int}

Sets your current menu index to A, 1 based index, not 0. So the first menu option is 1, then 2, then 3, etc.

## Notes

For menus that start you off on the bottom entry and you have to move your selector up to hit "yes", for example a lot of teleports start you on option 2 "No", and option 1 is "Yes", do note that "Yes" is still Index 1 for the use of /menu and /setmenu, even though the menu didnt start you on Index 1.