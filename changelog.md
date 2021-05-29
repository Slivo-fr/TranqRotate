## TranqRotate Changelog

#### v2.0.0

- Fix connected realms sync issues - **BREAKING CHANGES**

#### v1.8.0

- Adds different announces messages for boss and trash (Boss announces can call next player, trash announces can call target)
- Adds raid marker symbol to chat tranq announces
- Adds "available update" chat notifications
- Removes server suffix from hunter names on era connected realms

#### v1.7.0

- Adds an icon on hunter not using the addon (You can disable it in the settings)
- Adds `/tranq test` command to toggle the test mode
- Improves and fix player addon version checks

#### v1.6.1

- Update ace3 libs for TBC prepatch
- Fix few minor issues with test mode
- Fix a lua error using `/tranq check` with non hunter users

#### v1.6.0

- Improves miss and resist tranqshot handling (no more duplicate announces or whispers)
- Adds gluth fear to handled list of incapacitating debuffs
- Adds `/tranq check` command to display the version other users have installed
- Adds printing of fail to chat window
- Fix timed alert feature that never worked (forgot to call it :D), changed default value to disabled
- Fix an ui error when trying to send announces on say/yell channel in open world (test mode)
- Fix windows hiding unexpectedly when changing settings

#### v1.5.1

- Handles the new dispel resistance mechanic
- Fix a bad nil check in comms
- Fix a logic issue in hunter list cleaning function 

#### v1.5.0

- Restricted ordering tranq rotation to raid leader, raid assists and hunters
- Added a frenzy cooldown progress bar under the title bar
- Added configurable optional timed backup alert
- Added configurable optional incapacitated backup alert
- Fix font for koKR player names
- Fix main window showing up when login in while already in a raid with option to mask window enabled

#### v1.4.0

- TranqRotate now play a sound when you need to tranq (You can disable it in the settings)
- Added an option to not show up the window each time you join a raid
- Added an option to have the window show up when you target a tranq-able boss
- Rotation will now reset when you kill the boss
- Adds an option to report the main rotation on multiple lines
- Adds a `report` slash command to print the rotation to the configured channel

#### v1.3.0

- Adds arcane shot test mode
- Adds sound when user is the next to tranq (Added setting toggle to switch if off)
- Adds some logic to rotation, TranqRotate will skip a hunter if it's tranq ability isn't ready
- Update zhCN & zhTW locales, thanks to LeePich
- Adds raid check and update display when player leave combat
- Fix rotation logic with dead or offline players
- Adds hunters tranq cooldown display
- Use a font that support unicode character for asian player names

#### v1.2.0

- Main window don't show up in battleground anymore
- Fix potential bug in rotation when backup hunter use tranq
- Adds `/tranq backup` command to manually alert backup if required (use that with a macro)
- Remove turn to tranq from a hunter that dies and set it to the following in rotation
- Adds hunter list and tranqshot synchronization
- Adds resync and raid refresh feature to the reset button

#### v1.1.0

- Adds TranqRotate window
- Adds raid hunters detection
- Adds rotation handling
- Adds main window position change using drag & drop
- Adds main window position lock setting
- Adds hunter death and disconnection display on hunter frames
- Adds hunter group and order change using drag & drop
- Adds lock/unlock slash command option
- Adds toggle slash command option
- Adds "broadcast rotation setup to raid chat"
- Adds rotation reset button to re-initialize betweeen/after pulls
- Adds whisper message to next hunter and all backup hunters when you miss
- Adds close button to top bar
- Adds option to hide main window when not in a raid

- Change base slash command to display available options
- Change slash command settings to `/tranq settings`

- Splits code in multiple files
- Moves all lua files to src/
- Use first target change event to update raid status if player login while already in raid
- Updates game interface version to 11303

#### v1.0.1

- Fix missing libs in toc file

#### v1.0.0

- Adds slash command
- Adds settings
- Adds base combat log handling
- Adds automatic success and fail tranqshot messages
- Adds frFR locale
- Adds znTW locale
- Adds zhCN locale
