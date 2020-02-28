if( GetLocale() ~= "zhCN" ) then return end

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
    ["ENABLE_ANNOUNCES"] = "启用通告",
    ["ENABLE_ANNOUNCES_DESC"] = "启用 / 禁用通告",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "通告频道",
    ["MESSAGE_CHANNEL_TYPE"] = "发送到",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "你想发送到哪个频道",

    ----- Channels types
    ["CHANNEL_RAID_WARNING"] = "团队警报",
    ["CHANNEL_SAY"] = "说",
    ["CHANNEL_YELL"] = "大喊",
    ["CHANNEL_PARTY"] = "队伍",
    ["CHANNEL_RAID"] = "团队",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "通告信息",
    ["SUCCESS_MESSAGE_LABEL"] = "施放成功通告信息",
    ["FAIL_MESSAGE_LABEL"] = "施放失败通告信息",
    ["FAIL_WHISPER_LABEL"] = "Fail whisper message",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "已对 %s 施放了宁神射击!",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! 对 %s 宁神失败!!!",
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
