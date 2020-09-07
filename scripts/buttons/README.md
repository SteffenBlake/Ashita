# Button Broadcasting

Pretty simple script that enables basic button broadcasting, requires the Multisend plugin loaded

Multisend: https://git.ashitaxi.com/Plugins/MultiSend

# How to install

Just copy this buttons folder to your /Ashita/Scripts/ folder, then add:

`/exec buttons/bindings`

To your Default script

# How to use

Numpad buttons will get remapped to instead broadcast common menu buttons you may use.

NUMPAD4 > Left

NUMPAD8 > Up

NUMPAD6 > Right

NUMPAD2 > Down

NUMPAD0 > Enter

NUMPAD+ > Target npc (Might need to tap this twice sometimes)

NUMPAD* > Assist leader

NUMLOCK > Escape

NUMPADENTER > Blocked (to prevent accidently hitting it and messing up menu synch between leader/alts)

# Keep in mind:

Feel free to rebind these, but keep the key reason I have bound these in mind:

If you try and do these same bindings but to the same button functionality (IE Bind Shift+Enter to broadcast Enter), it can often times double click the button and mess your synch up and double tap.

To have maximum success, I specifically chose to bind unused buttons that dont have menu functionality, to the menu functionality, to prevent the keybindings from accidently tripping over themselves.

tl;dr: Dont try and bind Shift+Up to broadcast Up, or Ctrl+Enter to broadcast Enter, etc etc. It can fail sometimes.

Also: The `/wait .1` is important, not doing it can rarely cause the button up event to not fire and leave the button perma held down.
