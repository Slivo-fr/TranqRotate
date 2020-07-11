if (GetLocale() ~= "zhTW") then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate 已加載, 輸入 /tranq 進入設定",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate 窗口隱藏. 輸入 /tranq toggle 顯示窗口",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "請報告問題: ",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate now display hunters cooldowns and play a sound when it's your turn! There's also a new test mode\n",

    ["LOCK_WINDOW"] = "鎖定窗口",
    ["LOCK_WINDOW_DESC"] = "鎖定窗口",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "不在團隊時隱藏窗口",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "不在團隊時隱藏窗口",
    ["WINDOW_LOCKED"] = "TranqRotate: 窗口已隱藏",
    ["WINDOW_UNLOCKED"] = "TranqRotate: 窗口已鎖定",

    ["TEST_MODE_HEADER"] = "測試模式",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "切換測試模式",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "當測試模式啟用時, 秘法射擊將註冊為寧神射擊\n" ..
        "測試模式將持續10分鐘, 除非妳提前關閉它",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "奧術射擊測試模式已啟用, 持續10分鐘",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "奧術射擊測試模式已禁用",

    --- Announces
    ["SETTING_ANNOUNCES"] = "通告",
    ["ENABLE_ANNOUNCES"] = "啟用通告",
    ["ENABLE_ANNOUNCES_DESC"] = "啟用 / 禁用通告",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "通告頻道",
    ["MESSAGE_CHANNEL_TYPE"] = "發送到",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "你想發送到哪個頻道",
    ["MESSAGE_CHANNEL_NAME"] = "頻道名或玩家名",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "設置目標頻道的名稱",

    ----- Channels types
    ["CHANNEL_CHANNEL"] = "頻道",
    ["CHANNEL_RAID_WARNING"] = "團隊警告",
    ["CHANNEL_SAY"] = "說",
    ["CHANNEL_YELL"] = "大喊",
    ["CHANNEL_PARTY"] = "小隊",
    ["CHANNEL_RAID"] = "團隊",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "通告資訊",
    ["SUCCESS_MESSAGE_LABEL"] = "施放成功通告資訊",
    ["FAIL_MESSAGE_LABEL"] = "施放失敗通告資訊",
    ["FAIL_WHISPER_LABEL"] = "施放失敗私聊資訊",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "已對 %s 施放了寧神射擊!",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! 對 %s 寧神失敗!!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "寧神失敗 !! 趕緊補寧神!!",

    ["BROADCAST_MESSAGE_HEADER"] = "循環順序廣播頻道選擇",

    --- Sounds
    ["SETTING_SOUNDS"] = "音效",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "當下壹個寧神射擊是妳時，播放音效",

    --- Profiles
    ["SETTING_PROFILES"] = "設定檔",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "獵人寧神順序",
    ["BROADCAST_ROTATION_PREFIX"] = "循環",
    ["BROADCAST_BACKUP_PREFIX"] = "替補",
}

TranqRotate.L = L
