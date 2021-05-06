if (GetLocale() ~= "zhTW") then return end

TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate 已加載, 輸入 /tranq 進入設定",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate 窗口隱藏. 輸入 /tranq toggle 顯示窗口",

    -- Settings
    ["SETTING_GENERAL"] = "General",
    ["SETTING_GENERAL_REPORT"] = "請報告問題: ",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate will now play a sound when you need to shoot your tranqshot ! There are also few more display options to make the addon less intrusive.",

    ["LOCK_WINDOW"] = "鎖定窗口",
    ["LOCK_WINDOW_DESC"] = "鎖定窗口",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "不在團隊時隱藏窗口",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "不在團隊時隱藏窗口",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "加入團隊時隱藏窗口",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "如果您不想每次加入團隊時都顯示窗口，請選中此選項",
    ["SHOW_WHEN_TARGETING_BOSS"] = "當妳的目標是壹個可寧神的Boss時，顯示窗口",
    ["SHOW_WHEN_TARGETING_BOSS_DESC"] = "當妳的目標是壹個可寧神的Boss時，顯示窗口",
    ["WINDOW_LOCKED"] = "TranqRotate: 窗口已隱藏",
    ["WINDOW_UNLOCKED"] = "TranqRotate: 窗口已鎖定",

    ["TEST_MODE_HEADER"] = "測試模式",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "切換測試模式",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "當測試模式啟用時, 秘法射擊將註冊為寧神射擊\n" ..
        "測試模式將持續10分鐘, 除非妳提前關閉它",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "奧術射擊測試模式已啟用, 持續10分鐘",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "奧術射擊測試模式已禁用",

    ["FEATURES_HEADER"] = "Optionals features",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN"] = "Display frenzy cooldown progress bar",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN_DESC"] = "A thin progress bar just under the title bar will show the progress",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED"] = "Enable automatic backup alert when incapacitated",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED_DESC"] = "TranqRotate will check for your debuffs when you should actually tranq and will call for backup if you are incapacitated for longer than the defined delay",
    ["INCAPACITATED_DELAY_THRESHOLD"] = "Incapacitated alert threshold",
    ["INCAPACITATED_DELAY_THRESHOLD_DESC"] = "If you are incapacitated for longer than the configured delay, TranqRotate will automatically call for backup",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT"] = "Enable timed automatic backup alert",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT_DESC"] = "TranqRotate will call for backup if the boss is on frenzy for a defined delay and you should have been tranqing it",
    ["TIMED_DELAY_THRESHOLD"] = "Timed alert threshold",
    ["TIMED_DELAY_THRESHOLD_DESC"] = "TranqRotate will automatically call for backup if you do not tranq within the configured threshold",

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
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Message whispered when you cannot tranq or call for backup",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "已對 %s 施放了寧神射擊!",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! 對 %s 寧神失敗!!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "寧神失敗 !! 趕緊補寧神!!",
    ['DEFAULT_UNABLE_TO_TRANQ_MESSAGE'] = "I'M UNABLE TO TRANQ ! TRANQ NOW !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "立即使用寧神 !!",

    ["BROADCAST_MESSAGE_HEADER"] = "循環順序廣播頻道選擇",
    ["USE_MULTILINE_ROTATION_REPORT"] = "連續多行發送寧神通告",
    ["USE_MULTILINE_ROTATION_REPORT_DESC"] = "如果您想要更易於理解的順序顯示，請選中此選項",

    --- Sounds
    ["SETTING_SOUNDS"] = "音效",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "當下壹個寧神射擊是您時，播放提示音",
    ["ENABLE_TRANQ_NOW_SOUND"] = "當您需要立即寧神射擊時，播放提示音",
    ["TRANQ_NOW_SOUND_CHOICE"] = "選擇要用於“寧神射擊”提示的聲音",
    ["DBM_SOUND_WARNING"] = "DBM在瘋狂時播放的'flag taken'提示音，可能導致您無法聽到TranqRotate的提示音。建議選擇壹個響亮的提示音，或者在DBM中禁用瘋狂的警告。",

    --- Profiles
    ["SETTING_PROFILES"] = "設定檔",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "獵人寧神順序",
    ["BROADCAST_ROTATION_PREFIX"] = "循環",
    ["BROADCAST_BACKUP_PREFIX"] = "替補",
}

TranqRotate.L = L
