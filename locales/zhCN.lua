if( GetLocale() ~= "zhCN" ) then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate 已加载, 输入 /tranq 进入设置",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate 窗口隐藏. 输入 /tranq toggle 显示窗口",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "Please report any issue at",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate now synchronize hunters list and tranqshot with other users\n",

    --- Announces
    ["SETTING_ANNOUNCES"] = "通告",
    ["ENABLE_ANNOUNCES"] = "启用通告",
    ["ENABLE_ANNOUNCES_DESC"] = "启用 / 禁用通告",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "通告频道",
    ["MESSAGE_CHANNEL_TYPE"] = "发送到",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "你想发送到哪个频道",
    ["MESSAGE_CHANNEL_NAME"] = "频道名或玩家名",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "自定义设置要发送消息的玩家或频道的名称",

    ----- Channels types
    ["CHANNEL_WHISPER"] = "私聊",
    ["CHANNEL_CHANNEL"] = "频道",
    ["CHANNEL_RAID_WARNING"] = "团队警报",
    ["CHANNEL_SAY"] = "说",
    ["CHANNEL_YELL"] = "大喊",
    ["CHANNEL_PARTY"] = "队伍",
    ["CHANNEL_RAID"] = "团队",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "通告信息",
    ["SUCCESS_MESSAGE_LABEL"] = "施放成功通告信息",
    ["FAIL_MESSAGE_LABEL"] = "施放失败通告信息",
    ["FAIL_WHISPER_LABEL"] = "失败的私聊消息",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "已对 %s 施放了宁神射击!",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! 对 %s 宁神失败!!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "宁神失败 !! 赶紧宁神!!",

    --- Rotation
    ["LOCK_WINDOW"] = "锁定窗口",
    ["LOCK_WINDOW_DESC"] = "锁定窗口",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "不在团队时隐藏窗口",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "不在团队时隐藏窗口",
    ["WINDOW_LOCKED"] = "TranqRotate: 窗口已隐藏",
    ["WINDOW_UNLOCKED"] = "TranqRotate: 窗口已锁定",

    --- Profiles
    ["SETTING_PROFILES"] = "配置",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "猎人宁神设置",
    ["BROADCAST_ROTATION_PREFIX"] = "循环",
    ["BROADCAST_BACKUP_PREFIX"] = "备份",
}

TranqRotate.L = L
