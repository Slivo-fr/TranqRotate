local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate loaded, type /tranq for settings",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "Please report any issue at",
    ["SETTING_GENERAL_DESC"] = "This first version will only allow you to get automatic tranq annouce messages\n"..
        "I'm planning to add more features giving visual feedback about tranqshot rotation",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Announces",
    ["ENABLE_ANNOUNCES"] = "Enable announces",
    ["ENABLE_ANNOUNCES_DESC"] = "Enable / disable the announcement.",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Announce channel",
    ["MESSAGE_CHANNEL_TYPE"] = "Send messages to",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Channel you want to send messages",
    ["MESSAGE_CHANNEL_NAME"] = "Name of channel or player",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Set the name of the player or channel you want to send messages",

    ----- Channels types
    ["CHANNEL_WHISPER"] = "Whisper",
    ["CHANNEL_CHANNEL"] = "Channel",
    ["CHANNEL_RAID_WARNING"] = "Raid Warning",
    ["CHANNEL_SAY"] = "Say",
    ["CHANNEL_YELL"] = "Yell",
    ["CHANNEL_PARTY"] = "Party",
    ["CHANNEL_RAID"] = "Raid",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Announce messages",
    ["SUCCESS_MESSAGE_LABEL"] = "Successful announce message",
    ["FAIL_MESSAGE_LABEL"] = "Fail announce message",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done on %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TRANQSHOT FAILED ON %s !!!",

    --- Profiles
    ["SETTING_PROFILES"] = "Profiles"
}

TranqRotate.L = L
