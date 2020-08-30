if (GetLocale() ~= "ruRU") then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate загружен, введите /tranq для настроки",
    ["TRANQ_WINDOW_HIDDEN"] = "Окно Tranqrotate скрыто. Использайте /tranq toggle чтобы вернуть его",

    -- Settings
    ["SETTING_GENERAL"] = "Главный",
    ["SETTING_GENERAL_REPORT"] = "Пожалуйста, сообщите о любой проблеме на",
    ["SETTING_GENERAL_DESC"] = "New : TranqRotate will now play a sound when you need to shoot your tranqshot ! There are also few more display options to make the addon less intrusive.",

    ["LOCK_WINDOW"] = "Заблокировать окно",
    ["LOCK_WINDOW_DESC"] = "Заблокировать окно",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Скрыть окно, когда вы не в рейде",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Скрыть окно, когда вы не в рейде",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Do not show window when joining a raid",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Check this if you don't want the window to show up each time you join a raid",
    ["SHOW_WHEN_TARGETING_BOSS"] = "Show window when you target a tranq-able boss",
    ["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Show window when you target a tranq-able boss",
    ["WINDOW_LOCKED"] = "TranqRotate: Окно заблокировано",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Окно разблокировано",

    ["TEST_MODE_HEADER"] = "Режим тестирования",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "Преключатель режима тестирования",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "Пока включен режим тестирования, Чародейский выстрела будет регистрироватьс как Усмиряющий выстрел\n" ..
        "Режим тестирования будет длиться 10 минут, если вы не выключите его",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "Режим тестирования Чародейского выстрела включён на 10 минут",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "Режим тестирования Чародейского выстрела отключён",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Оповещения",
    ["ENABLE_ANNOUNCES"] = "Включить оповещения",
    ["ENABLE_ANNOUNCES_DESC"] = "Включить / отключить оповещения.",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Канал оповещения",
    ["MESSAGE_CHANNEL_TYPE"] = "Отправлять сообщения в",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Канал в который вы хотите отправлять сообщения",
    ["MESSAGE_CHANNEL_NAME"] = "Название канала",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Установите название канала",

    ----- Channels types
    ["CHANNEL_CHANNEL"] = "Канал",
    ["CHANNEL_RAID_WARNING"] = "Оповещение рейда",
    ["CHANNEL_SAY"] = "Сказать",
    ["CHANNEL_YELL"] = "Крикнуть",
    ["CHANNEL_PARTY"] = "Группа",
    ["CHANNEL_RAID"] = "Рейд",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Сообщения для оповещения",
    ["SUCCESS_MESSAGE_LABEL"] = "Сообщение для оповещения при успехе",
    ["FAIL_MESSAGE_LABEL"] = "Сообщение для оповещения при неудаче",
    ["FAIL_WHISPER_LABEL"] = "Сообщение шёпота при неудаче",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Усмиряющий выстрел применён на %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! УСМИРЯЮЩИЙ ВЫСТРЕЛ НЕУДАЧЕН НА %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "УСМИРЯЮЩИЙ ВЫСТРЕЛ НЕУДАЧЕН ! УСМИРИТЕ СЕЙЧАС !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "USE TRANQSHOT NOW !",

    ["BROADCAST_MESSAGE_HEADER"] = "Настройка оповещения для текста ротации",
    ["USE_MULTILINE_ROTATION_REPORT"] = "Use multiline for main rotation when reporting",
    ["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Check this option if you want more comprehensible order display",

    --- Sounds
    ["SETTING_SOUNDS"] = "Звук",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Воспроизводить звук, когда ваш выстрел следующий",
    ["ENABLE_TRANQ_NOW_SOUND"] = "Play a sound when you have to shoot your tranq",
    ["TRANQ_NOW_SOUND_CHOICE"] = "Select the sound you want to use for the 'tranq now' alert",
    ["DBM_SOUND_WARNING"] = "DBM is playing the 'flag taken' sound on each frenzy, it may prevent you from earing gentle sounds from TranqRotate. I would either suggest to pick a strong sound or disable DBM frenzy sound.",

    --- Profiles
    ["SETTING_PROFILES"] = "Профили",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Настрйки Усмиряющего выстрела охотников",
    ["BROADCAST_ROTATION_PREFIX"] = "Ротация",
    ["BROADCAST_BACKUP_PREFIX"] = "Подстраховка",
}

TranqRotate.L = L
