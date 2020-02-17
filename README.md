# TranqRotate

This addon is meant to help hunters to setup tranqshot rotation and give them real time visual feedback about it.

**TranqRotate DOES NOT synchronize anything with other hunters (yet), even if they use the addon too. 
Considering this fact and the Blizzard 45m combat log limit, I would advice to not have your hunters spread too much until sync is added.**

This addon is still in a (stable) beta state, a stable release should come soon.

## Feedback

I'm looking for feedback ! Feel free to contact me ingame (Slivo@Sulfuron).
 
Please report any issue using github issues : https://github.com/Slivo-fr/TranqRotate/issues

## Features

- Automatically send messages to notify others player about your tranq success or fail, hopefully you won't have to bother with that crappy macro anymore !
- Display the list of raid hunters
- Allow player to re-order players between two groups : main rotation and backup.
- Whisper the next hunter on the rotation as well as all backup hunters if you miss your tranqshot
- Provide a real time visual feedback about the rotation status, even if no one else use the addon in your raid
- Allow player to broadcast the configured rotation and backup group to the raid
- Display offline and dead status on hunters frames

## Usage
 
Use `/tranq` for options

You must be in a raid for hunters to get registered and displayed by the addon.

First step is to set your tranq order using drag & drop on hunters. 
You may use the trumpet button to get it written in raid chat so others hunters can know what you planned (And set their TranqRotate order if they use it). 
Please note the backup group is hidden if empty but you can still drag hunters into it.

You can now just pull the boss and start shooting your tranqshots, TranqRotate will track the rotation and use a purple tranq-like color on the next hunter that should tranq.

Once boss has died (or you wiped), just use the reset button in the top bar to reset the rotation state

## Roadmap

Here is a list of feature I want to implement at some point, no specific order is decided yet.

- Display of every hunter tranqhot cooldowns
- Data sync between all users, allowing raid leader or raid assistant to setup the rotation for everyone
- Automatic handling of death and disconnection of hunters on the rotation group (swap with a backup, send an alert about it)
- Use raid symbols to mark hunters that need to tranq, or that need to backup a failed tranqshot
- Automatic reset of rotation when raid wipe or boss die
- Encounter detection and frenzy cooldown progress bar
- Handling of battleground raids

## Download

Do not use github download button on this page, get the latest release zip file from https://github.com/Slivo-fr/TranqRotate/releases

Also available here https://www.curseforge.com/wow/addons/tranqrotate and there https://wowclassicui.com/fr/addons/tranqrotate

## Credits

I've been learning and using some code of https://github.com/Aviana/YaHT to build this first codebase. Thanks for his work.

Many thanks to the wow addon discord members that helped me a lot too.
