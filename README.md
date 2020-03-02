# TranqRotate

This addon is meant to help hunters to setup tranqshot rotation and give them real time visual feedback about it.

**Using player channel as annoucement target does not work as blizzard restricted the addon messaging capacities on those. Option will be removed at some point.**

![Screenshot](docs/screenshots/screenshot.png "ui") ![Screenshot](docs/screenshots/drag.gif "ui")  ![Screenshot](docs/screenshots/rotation.gif "ui")

## Feedback

I'm looking for feedback ! I've set up a small discord server to get in touch : https://discord.gg/bPFyvDe
 
Please report any issue using github issues : https://github.com/Slivo-fr/TranqRotate/issues

## Features

- Automatically send messages to notify others player about your tranq success or fail, hopefully you won't have to bother with that crappy macro anymore !
- Display the list of raid hunters
- Allow player to re-order players between two groups : main rotation and backup
- Synchronize rotation order between player using the addon
- Whisper backup hunters (if there is backup) or next rotation hunter if you miss your tranqshot
- Provide a real time visual feedback about the rotation status, even if no one else use the addon in your raid
- Synchronize tranqshot cast to other player using the addon
- Allow player to broadcast the configured rotation and backup group to the raid
- Display offline and dead status on hunters frames

## Usage
 
Use `/tranq` for options

You must be in a raid for hunters to get registered and displayed by the addon.

First step is to set your tranq order using drag & drop on hunters, if other hunter use the addon too, changes will be synced. 
You may use the trumpet button to get it written in raid chat so others players can know what you planned. 
Please note the backup group is hidden if empty but you can still drag hunters into it.

You can now just pull the boss and start shooting your tranqshots, TranqRotate will track the rotation and use a purple tranq-like color on the next hunter that should tranq.

**warning** : if all of your hunters does not use the addon, make sure someone with the addon stay within 45m range of hunters without the addon or you won't be able to detected their tranqshot. MC and AQ40 tranq encounters may lead to range issues. 

Once boss has died (or you wiped), just use the reset button in the top bar to reset the rotation state.
The reset button is also able to resync raid hunters and rotation setup if you need.

You may adds the `/tranq backup` command to a macro that you can use when you are unable to tranq and you need some help,
it will whisper all backup hunters the fail message

## Roadmap

Here is a list of feature I want to implement at some point, no specific order is decided yet.

- Display of every hunter tranqhot cooldowns
- Adds RL/Raid assist handling to restrict rotation groups changes
- Automatic handling of death and disconnection of hunters on the rotation group (swap with a backup, send an alert about it)
- Use raid symbols to mark hunters that need to tranq, or that need to backup a failed tranqshot
- Automatic reset of rotation when raid wipe or boss die
- Encounter detection and frenzy cooldown progress bar

## Download

Do not use github download button on this page, get the latest release zip file from https://github.com/Slivo-fr/TranqRotate/releases

Also available here https://www.curseforge.com/wow/addons/tranqrotate and there https://wowclassicui.com/fr/addons/tranqrotate

## Credits

I've been learning and using some code of https://github.com/Aviana/YaHT to build this first codebase. Thanks for his work.

Many thanks to the wow addon discord members that helped me a lot too.
