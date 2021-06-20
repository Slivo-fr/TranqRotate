TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate loaded, type /tranq for options",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate window hidden. Use /tranq toggle to get it back",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "Please report any issue at",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate will now play a sound when you need to shoot your tranqshot ! There are also few more display options to make the addon less intrusive.",

    ["LOCK_WINDOW"] = "Lock window",
    ["LOCK_WINDOW_DESC"] = "Lock window",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Hide the window when not in a raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Hide the window when not in a raid",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Do not show window when joining a raid",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Check this if you don't want the window to show up each time you join a raid",
    ["SHOW_WHEN_TARGETING_BOSS"] = "Show window when you target a tranq-able boss",
    ["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Show window when you target a tranq-able boss",
    ["WINDOW_LOCKED"] = "TranqRotate: Window locked",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Window unlocked",

    --- Player names formatting options
    ["PLAYER_NAME_FORMAT"] = "Player names format",
    ["PLAYER_NAME_FORMAT_DESC"] = "On connected realms, players from other servers will have a the server suffix hidden by default. If you ever get two hunter with the exact same name, adjust this setting to your needs",
    ["PLAYER_NAME_ONLY_OPTION_LABEL"] = "Playername",
    ["SHORTENED_SUFFIX_OPTION_LABEL"] = "Playername-Ser",
    ["FULL_NAME_OPTION_LABEL"] = "Playername-Server",

    ["TEST_MODE_HEADER"] = "Test mode",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "Toggle testing mode",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "While testing mode is enabled, arcane shot will be registered as a tranqshot\n" ..
        "Testing mode will last 10 minutes unless you toggle it off",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "Arcane shot testing mode enabled for 10 minutes",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "Arcane shot testing mode disabled",

    ["FEATURES_HEADER"] = "Optionals features",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN"] = "Display frenzy cooldown progress bar",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN_DESC"] = "A thin progress bar just under the title bar will show the progress",
    ["DISPLAY_BLIND_ICON"] = "Show an icon for hunter without TranqRotate",
    ["DISPLAY_BLIND_ICON_DESC"] = "Adds a blind icon on the hunter frame to indicate he's not using the addon. This means he will not be aware of the rotate unless you communicate with him and his tranqshot won't be synced if he's far from every other TranqRotate user.",
    ["DISPLAY_BLIND_ICON_TOOLTIP"] = "Show the blind icon tooltip",
    ["DISPLAY_BLIND_ICON_TOOLTIP_DESC"] = "You can disable this options to disable the tooltip while still having the icon",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED"] = "Enable automatic backup alert when incapacitated",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED_DESC"] = "TranqRotate will check for your debuffs when you should actually tranq and will call for backup if you are incapacitated for longer than the defined delay",
    ["INCAPACITATED_DELAY_THRESHOLD"] = "Incapacitated alert threshold",
    ["INCAPACITATED_DELAY_THRESHOLD_DESC"] = "If you are incapacitated for longer than the configured delay, TranqRotate will automatically call for backup",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT"] = "Enable timed automatic backup alert",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT_DESC"] = "TranqRotate will call for backup if the boss is on frenzy for a defined delay and you should have been tranqing it",
    ["TIMED_DELAY_THRESHOLD"] = "Timed alert threshold",
    ["TIMED_DELAY_THRESHOLD_DESC"] = "TranqRotate will automatically call for backup if you do not tranq within the configured threshold",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Announces",
    ["ENABLE_ANNOUNCES"] = "Enable announces",
    ["ENABLE_ANNOUNCES_DESC"] = "Enable / disable the announcement.",
    ["YELL_SAY_DISABLED_OPEN_WORLD"] = "(Yell and say channels does not work in open world, but will inside your raids)",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Announce channel",
    ["MESSAGE_CHANNEL_TYPE"] = "Send messages to",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Channel you want to send messages",
    ["MESSAGE_CHANNEL_NAME"] = "Channel name",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Set the name of the target channel",

    ----- Channels types
    ["CHANNEL_CHANNEL"] = "Channel",
    ["CHANNEL_RAID_WARNING"] = "Raid Warning",
    ["CHANNEL_SAY"] = "Say",
    ["CHANNEL_YELL"] = "Yell",
    ["CHANNEL_PARTY"] = "Party",
    ["CHANNEL_RAID"] = "Raid",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Announce messages",
    ["BOSS_SUCCESS_MESSAGE_LABEL"] = "Successful announce message on boss (%s will be replaced by next hunter name)",
    ["TRASH_SUCCESS_MESSAGE_LABEL"] = "Successful announce message on trash (%s will be replaced by target name)",
    ["FAIL_MESSAGE_LABEL"] = "Fail announce message",
    ["FAIL_WHISPER_LABEL"] = "Fail whisper message",
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Message whispered when you cannot tranq or call for backup",

    ['DEFAULT_BOSS_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done, %s is next!",
    ['DEFAULT_TRASH_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done on %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TRANQSHOT FAILED ON %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TRANQSHOT MISSED ! TRANQ NOW !",
    ['DEFAULT_UNABLE_TO_TRANQ_MESSAGE'] = "I'M UNABLE TO TRANQ ! TRANQ NOW !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "USE TRANQSHOT NOW !",

    ["BROADCAST_MESSAGE_HEADER"] = "Rotation setup text broadcast",
    ["USE_MULTILINE_ROTATION_REPORT"] = "Use multiline for main rotation when reporting",
    ["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Check this option if you want more comprehensible order display",

    --- Sounds
    ["SETTING_SOUNDS"] = "Sounds",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Play a sound when you are the next to shoot",
    ["ENABLE_TRANQ_NOW_SOUND"] = "Play a sound when you have to shoot your tranq",
    ["TRANQ_NOW_SOUND_CHOICE"] = "Select the sound you want to use for the 'tranq now' alert",
    ["DBM_SOUND_WARNING"] = "DBM is playing the 'flag taken' sound on each frenzy, it may prevent you from earing gentle sounds from TranqRotate. I would either suggest to pick a strong sound or disable DBM frenzy sound.",

    --- Profiles
    ["SETTING_PROFILES"] = "Profiles",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",

    -- Blind icon tooltip
    ["TOOLTIP_PLAYER_WITHOUT_ADDON"] = "This player does not use TranqRotate",
    ["TOOLTIP_MAY_RUN_OUDATED_VERSION"] = "Or runs an outdated version below 1.6.0",
    ["TOOLTIP_DISABLE_SETTINGS"] = "(You can disable this icon and/or this tooltip in the settings)",

    -- Available update
    ["UPDATE_AVAILABLE"] = "A new TranqRotate version is available, update to get latest features",
    ["BREAKING_UPDATE_AVAILABLE"] = "A new BREAKING TranqRotate update is available, you MUST update AS SOON AS possible! TranqRotate may not work properly with up-to-date version users.",

    -- Rotation reset
    ["RESET_UNAUTHORIZED"] = "You must be raid assist to reset the rotation",

    -- Comms chat messages
    ["COMMS_SENT_BACKUP_REQUEST"] = "Sending backup request to %s",
    ["COMMS_RECEIVED_NEW_ROTATION"] = "Received new rotation configuration from %s",
    ["COMMS_RECEIVED_BACKUP_REQUEST"] = "%s asked for backup !",
    ["COMMS_RECEIVED_RESET_BROADCAST"] = "%s has reset the rotation.",
}

TranqRotate.L = L
