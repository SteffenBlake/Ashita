# Button Broadcasting

Pretty simple script that enables basic button broadcasting, requires the Multisend plugin loaded

Multisend: https://git.ashitaxi.com/Plugins/MultiSend

Based off of: https://www.ffera.com/forums/viewtopic.php?t=151

# How to install

Just copy this buttons folder to your /Ashita/Scripts/ folder, then add:

`/exec buttons/bindings`

To your Default script

# How to use

Numpad buttons will get remapped to instead broadcast common menu buttons you may use.

WinKey+NUMPAD4 > Left

WinKey+NUMPAD8 > Up

WinKey+NUMPAD6 > Right

WinKey+NUMPAD2 > Down

WinKey+NUMPAD0 > Enter (Use this one for menus, but use the NUMPAD5 version below for interacting with an NPC)

WinKey+NUMPAD+ > Target npc (Might need to tap this twice sometimes)

WinKey+NUMPAD* > Assist leader (I find this one is more accurate)

WinKey+NUMLOCK > Escape

WinKey+NUMPAD5 > Staggered Enter hits. Will broadcast the Enter keypress in 0.2 second breaks to each party member, ending in main last. This one should be used when interacting with an NPC, since multiple clients interacting with an NPC at the exact same time often causes some of the clients to fail at this. Use the faster NUMPAD0 version for navigating menus.

WinKey+NUMPADENTER / NUMPADENTER > Blocked (to prevent accidently hitting it and messing up menu synch between leader/alts)

# Keep in mind:

Feel free to rebind these, but keep the key reason I have bound these in mind:

If you try and do these same bindings but to the same button functionality (IE Bind Shift+Enter to broadcast Enter), it can often times double click the button and mess your synch up and double tap.

To have maximum success, I specifically chose to bind unused buttons that dont have menu functionality, to the menu functionality, to prevent the keybindings from accidently tripping over themselves.

Furthermore, we specifically want to bind to WinKey, because if you bind to any of NUMPAD2/4/6/8 (Without Ctrl/Shift/Alt/Etc), it prevents you from using Left/Up/Right/Down in the chatlog. We specifically choose WinKey because Ctrl/Alt are used for Macros, and Shift can sometimes fail for Left/Right/Up/Down

tl;dr: Dont try and bind Shift+Up to broadcast Up, or Ctrl+Enter to broadcast Enter, etc etc. It can fail sometimes.

Also: The `/wait .1` is important, not doing it can rarely cause the button up event to not fire and leave the button perma held down.