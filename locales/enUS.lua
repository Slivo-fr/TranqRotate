local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate loaded, type /tranq for options",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate window hidden. Use /tranq toggle to get it back",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "Please report any issue at",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate now has a window allowing hunters to track rotation status\n"..
        "It still automatically announce tranq or miss and now whispers next and backup when you miss\n"..
        "It doesn't sync rotation order between hunters yet, you have to manually set the correct groups and order.",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Announces",
    ["ENABLE_ANNOUNCES"] = "Enable announces",
    ["ENABLE_ANNOUNCES_DESC"] = "Enable / disable the announcement.",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Announce channel",
    ["MESSAGE_CHANNEL_TYPE"] = "Send messages to",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Channel you want to send messages",

    ----- Channels types
    ["CHANNEL_RAID_WARNING"] = "Raid Warning",
    ["CHANNEL_SAY"] = "Say",
    ["CHANNEL_YELL"] = "Yell",
    ["CHANNEL_PARTY"] = "Party",
    ["CHANNEL_RAID"] = "Raid",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Announce messages",
    ["SUCCESS_MESSAGE_LABEL"] = "Successful announce message",
    ["FAIL_MESSAGE_LABEL"] = "Fail announce message",
    ["FAIL_WHISPER_LABEL"] = "Fail whisper message",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done on %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TRANQSHOT FAILED ON %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TRANQSHOT FAILED ! TRANQ NOW !",

    --- Rotation
    ["LOCK_WINDOW"] = "Lock window",
    ["LOCK_WINDOW_DESC"] = "Lock window",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Hide the window when not in a raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Hide the window when not in a raid",
    ["WINDOW_LOCKED"] = "TranqRotate: Window locked",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Window unlocked",

    --- Profiles
    ["SETTING_PROFILES"] = "Profiles",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",
}

TranqRotate.L = L
