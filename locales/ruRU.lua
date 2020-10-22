if (GetLocale() ~= "ruRU") then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate загружен, введите /tranq для настройки",
    ["TRANQ_WINDOW_HIDDEN"] = "Окно TranqRotate скрыто. Введите /tranq toggle для отображения",

    -- Settings
    ["SETTING_GENERAL"] = "Общие",
    ["SETTING_GENERAL_REPORT"] = "Пожалуйста о всех ошибках сообщайте на",
    ["SETTING_GENERAL_DESC"] = "Новое: Теперь TranqRotate проигрывает звук когда подходит ваша очередь! Добавлено несколько настроек отображения, чтобы сделать аддон менее навязчивым.",

    ["LOCK_WINDOW"] = "Закрепить окно",
    ["LOCK_WINDOW_DESC"] = "Препятствует перемещению окна с помощью мыши",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Показывать окно только в рейде",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Окно будет отображаться только в рейдовой группе",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Не показывать окно во время присоединения к рейду",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Выберите если вы не хотите видеть окно каждый раз когда присоединяетесь к рейду",
    ["SHOW_WHEN_TARGETING_BOSS"] = "Показывать окно только если ваша цель может быть усмирена",
    ["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Показывать окно только если ваша цель может быть усмирена",
    ["WINDOW_LOCKED"] = "TranqRotate: Окно закреплено",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Окно откреплено",

    ["TEST_MODE_HEADER"] = "Тестовый режим",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "Тестовый режим",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "В режиме тестирования, Чародейский выстрел будет использоваться вместо Усмиряющего выстрела\n" ..
        "Режим тестирования работает 10 минут или до отключения",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "Тестовый режим включен на 10 минут",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "Тестовый режим выключен",

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
    ["SETTING_ANNOUNCES"] = "Оповещения",
    ["ENABLE_ANNOUNCES"] = "Включить оповещения",
    ["ENABLE_ANNOUNCES_DESC"] = "Включить / отключить оповещения",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Канал оповещений",
    ["MESSAGE_CHANNEL_TYPE"] = "Канал чата",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Канал для отправки оповещений",
    ["MESSAGE_CHANNEL_NAME"] = "Имя канала",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Установить имя канала для оповещений",

    ----- Channels types
    ["CHANNEL_CHANNEL"] = "Канал",
    ["CHANNEL_RAID_WARNING"] = "Объявления рейду",
    ["CHANNEL_SAY"] = "Сказать",
    ["CHANNEL_YELL"] = "Крик",
    ["CHANNEL_PARTY"] = "Группа",
    ["CHANNEL_RAID"] = "Рейд",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Сообщения оповещений",
    ["SUCCESS_MESSAGE_LABEL"] = "При успехе сообщить",
    ["FAIL_MESSAGE_LABEL"] = "При промахе сообщить",
    ["FAIL_WHISPER_LABEL"] = "При промахе шепнуть запасным",
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Message whispered when you cannot tranq or call for backup",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Усмиряющий выстрел в %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! Усмиряющий выстрел промах в %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "!!! Усмиряющий выстрел промах !!! ! СТРЕЛЯЙ СЕЙЧАС !",
    ['DEFAULT_UNABLE_TO_TRANQ_MESSAGE'] = "I'M UNABLE TO TRANQ ! TRANQ NOW !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "СТРЕЛЯЙ СЕЙЧАС !",

    ["BROADCAST_MESSAGE_HEADER"] = "Объявление очередности",
    ["USE_MULTILINE_ROTATION_REPORT"] = "Использовать многострочный вывод при объявлении очередности",
    ["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Выберите для более понятного порядка отображения очередности",

    --- Sounds
    ["SETTING_SOUNDS"] = "Звуки",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Проигрывать звук когда подходит ваша очередь",
    ["ENABLE_TRANQ_NOW_SOUND"] = "Проигрывать звук когда пора использовать Усмиряющий выстрел",
    ["TRANQ_NOW_SOUND_CHOICE"] = "Выберите звук для Усмиряющего выстрела",
    ["DBM_SOUND_WARNING"] = "DBM проигрывает звук для каждого Бешенства, из-за этого вы можете не устышать оповещение от TranqRotate. Рекомендуется выбрать хорошо различимый звук для TranqRotate или отключить оповещение от DBM",

    --- Profiles
    ["SETTING_PROFILES"] = "Профили",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Очередность Усмиряющего выстрела",
    ["BROADCAST_ROTATION_PREFIX"] = "Очередность",
    ["BROADCAST_BACKUP_PREFIX"] = "Запасные",
}

TranqRotate.L = L
