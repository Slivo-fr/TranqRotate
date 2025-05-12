## Report bugs!

My wow account is unsubbed for more than a year now and I'm getting out of touch with the game. I WILL NOT be able to spot bugs or errors by myself. I still aim to support the addon and keep it running however.

Please report errors/bugs if you find some so I can look into it 

# TranqRotate

This addon is meant to help hunters to setup tranqshot rotation and give them real time feedback about it.

It also allow non-hunter raid leaders to easily manage, report and watch the tranq rotation live. 

This addon will work even if you are the only one using it in your raid. (With some combat log range limitation, see bellow)

![Screenshot](docs/screenshots/screenshot.png "screenshot") ![Screenshot](docs/screenshots/drag.gif "drag and drop gif")  ![Screenshot](docs/screenshots/rotation.gif "rotation gif")

## Feedback

I've set up a small discord server to talk about the project, get feedback and troubleshoot problems : https://discord.gg/bPFyvDe
 
Please report any issue at https://github.com/Slivo-fr/TranqRotate/issues

## Features

- Automatically send messages to notify others player about your tranq success or fail, hopefully you won't have to bother with that crappy macro anymore !
- Display the list of raid hunters
- Display offline and dead status on hunters frames
- Allow player to re-order players between two groups : main rotation and backup
- Synchronize rotation order between addon users
- Allow player to broadcast the configured rotation and backup group to the raid
- Provide a real time visual feedback about the rotation status, even if no one else use the addon in your raid
- Synchronize tranqshot casts to other player using the addon
- Whisper backup hunters (if there is backup) or next rotation hunter if you miss your tranqshot
- Test mode out of raid using arcane shot
- Play a sound when you are next on rotation
- Show an alert and play a sound when you need to use your tranqshot
- Display the tranq cooldown of each hunter
- Display the frenzy cooldown of each boss
- Optional automatic backup call when incapacitated
- Optional automatic timed backup call 
- Prints to chat the reason of a tranq fail (miss or resist)
- Show an indicator on hunters that does not use the addon

## Usage
 
Use `/tranq` for options

You must be in a raid for hunters to get registered and displayed by the addon.

First step is to setup your tranq rotation using drag & drop on hunters, if others hunters use the addon too, changes will be synced. 
You may use the trumpet button to report the rotation in raid chat so others players without the addon can know what you planned. 
Please note the backup group is hidden if empty but you can still drag hunters into it.

You can now just pull the boss and start shooting your tranqshots, TranqRotate will track the rotation and use a purple tranq-like color on the next hunter that should tranq. TranqRotate will play sounds when the previous hunter shot and you are the next, as well as when you have to use your tranqshot.

You can use the reset button in the top bar to reset the rotation status

You may adds the `/tranq backup` command to a macro that you can use when you are unable to tranq and you need some help,
It will whisper all backup hunters the fail message.

The `/tranq check` command allows you to list TranqRotate versions used by others players

## Roadmap

Here is a list of feature I want to implement at some point, no specific order is decided yet.

- Customization of the tranq window, size, textures, colors, fonts...

## Download

Do not use github download button on this page, get the latest release zip file from https://github.com/Slivo-fr/TranqRotate/releases

Also available on [curseforge](https://www.curseforge.com/wow/addons/tranqrotate) and [wago](https://addons.wago.io/addons/tranqrotate)
