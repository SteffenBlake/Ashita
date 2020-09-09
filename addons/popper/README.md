# Popper

Simple addon to simplify pop items for ???s or any other NPC in the game.

# Dependencies

Requires the loading and usage of Lolwutt's Bellhop plugin
https://docs.ashitaxi.com/plugins/bellhop/

## /pop "Item-Name" # "Item Name" #

Registers "Item-Name" as the pop for the currently targeted NPC, with associated numbers of trade values, and simultaneously "pops" it (trades that item)

Example: `/pop "Snow God Core" 1 "Sisyphus Fragment" 1 "H.Q. Marid Hide" 1

## /pop "Item-Name"

Shorthand for single item trades, synonymous with `/pop "Item-Name" 1`

## /pop

Trades the registered pop item for an NPC.

## /pop [save|load]

Saves/Loads the current configuration to/from the settings file (Useful for multiboxing)

## /pop autosave

Toggles Autosave functionality on/off. When enabled, popper will automatically save newly registered pops or config changes, useful for multiboxing

Disabled by default

## Examples

Save "Sp.Dial Key" for goblin mystery boxes!

Save abyssea pop items for their respective "???"s

Save "Silver Voucher" for Greyson

Save "Copper Voucher" for your RoE NPCs.

Register your millioncorns for Melyon

Etc etc