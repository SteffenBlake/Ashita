# Runic

Simple addon for maintaining Rune Fencer Runes

## /runic auto [on|off]

Directly sets runic mode to be on or off. Leave On/Off blank to toggle between the two.

## /runic (Ignis|Flabra|Etc)

Queues up a Rune on the roster, up to 3. Once 3/3 runes are set, further runes set will replace the oldest one

## /runic exec

For use in manual mode, will execute the next rune to match your queue, in case you dont want it to use runes automatically.

## Example usage

/runic Ignis
/runic Ignis
/runic Flabra

(This sets our rune ensamble to be 2x Ignis Runes and 1x Flabra)

/runic exec
/runic exec
/runic exec
(This will execute Ignis, then Ignis, then Flabra)

(If a rune gets removed or wears off, /runic exec will replace it.)

Alternatively:

/runic auto on

Will make the program automatically replace runes as they wear off or get consumed, if you like that sort of thing.