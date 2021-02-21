# JackOfAllTrades

Automatically adjusts your green champion bar loadout depending on what you are attempting to achieve and restores back your old CP setup when you are done.

# Meticulous Dissasmebly
Whenever you interact with a crafting station that supports Meticulous Dissasmebly it will automatically be slotted onto your champion bar.
Allowing you to refine materials with the buff always active.

# Treasure Hunter
Whenever you lockpick a chest it will automatically equip the Treasure Hunter skill.
Ensuring your chests are always of the highest quality

# Gifted Rider & War Mount
Whenever you mount it will automatically equip the Gifted Rider & War Mount skills if you have them unlocked.

# Professional Upkeep
Whenever you interact with a merchant it will automatically equip Professional Upkeep, allowing you to always get the lowest repair cost on your gear.

This addon will not respec your champion points, and will not charge you 3000 gold etc.
It will only equip the skills if you have enough points into them already.
It is intended to be a seamless quality of life improvement, not a CP respec addon.

If anyone has time to test this addon or can provide me with any thoughts, additions, or improvements I would be very grateful.

Many thanks

Update v 1.1
If you run the addon on the live server it will not cause any errors. It simply will not register any events or try to call anything from the CP 2.0 System.
Update v 1.2
Fixed the undefined variable in the AddonLoaded function, thank you Votan!
Update v 1.3
Rewrote CP assigning functions to use an object-oriented paradigm. Should help in the future
Separated Events and Skill functions into separate files to keep things clean.
Update v 1.4
Added settings menu allowing you to customize when and how warnings will be shown if you do not have enough CP points allocated into the skill to slot it.
Added support for localization.
Update v 1.5
When we are unable to slot CP points into a node, due to being in combat etc. We will attempt to slot the node again once combat ends.
Will remember which skill should be set back afer a reload UI!
If you reload UI whilst in combat with it will slot your original CP back after combat ends after the reload UI ends, this took more effort than it is probably worth.
Added method of finding names, discipline data automatically.
Improved localization support
