if( GetLocale() ~= "zhTW" ) then return end

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
    ["SETTING_ANNOUNCES"] = "通告",
    ["ENABLE_ANNOUNCES"] = "啟用通告",
    ["ENABLE_ANNOUNCES_DESC"] = "啟用 / 禁用通告",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "通告頻道",
    ["MESSAGE_CHANNEL_TYPE"] = "發送到",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "你想發送到哪個頻道",

    ----- Channels types
    ["CHANNEL_RAID_WARNING"] = "團隊警報",
    ["CHANNEL_SAY"] = "說",
    ["CHANNEL_YELL"] = "大喊",
    ["CHANNEL_PARTY"] = "隊伍",
    ["CHANNEL_RAID"] = "團隊",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "通告資訊",
    ["SUCCESS_MESSAGE_LABEL"] = "施放成功通告資訊",
    ["FAIL_MESSAGE_LABEL"] = "施放失敗通告資訊",
    ["FAIL_WHISPER_LABEL"] = "Fail whisper message",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "已對 %s 施放了寧神射擊!",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! 對 %s 寧神失敗!!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TRANQSHOT FAILED ! TRANQ NOW !",

    --- Rotation
    ["LOCK_WINDOW"] = "Lock window",
    ["LOCK_WINDOW_DESC"] = "Lock window",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Hide the window when not in a raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Hide the window when not in a raid",
    ["WINDOW_LOCKED"] = "TranqRotate: Window locked",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Window unlocked",

    --- Profiles
    ["SETTING_PROFILES"] = "配置",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",
}

TranqRotate.L = L
