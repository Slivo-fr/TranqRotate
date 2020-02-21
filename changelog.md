## TranqRotate Changelog

#### v1.2.0

- Main window don't show up in battleground anymore
- Fix potential bug in rotation when backup hunter use tranq
- Adds `/tranq backup` command to manually alert backup if required (use that with a macro)
- Remove turn to tranq from a hunter that dies and set it to the following in rotation

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
- Adds znTW locale
