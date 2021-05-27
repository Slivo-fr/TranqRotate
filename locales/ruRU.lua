if (GetLocale() ~= "ruRU") then return end

TranqRotate = select(2, ...)

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

    ["FEATURES_HEADER"] = "Дополнительные возможности",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN"] = "Показывть полоску перезарядки бешенства",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN_DESC"] = "Тонкая полоса прямо под строкой заголовка будет показывать прогресс перезарядки",
    ["DISPLAY_BLIND_ICON"] = "Показывать иконку для охотника без TranqRotate",
    ["DISPLAY_BLIND_ICON_DESC"] = "Добавляет значок в рамку охотника, показывабщий, что он не использует аддон. Это означает, что он не будет знать о ротации, если вы не сообщите ему, и его Усмеряющий выстрел не будет синхронизирован, если он находится далеко от всех остальных пользователей TranqRotate.",
    ["DISPLAY_BLIND_ICON_TOOLTIP"] = "Показать всплывающую подсказку для значка",
    ["DISPLAY_BLIND_ICON_TOOLTIP_DESC"] = "При отключить этого параметра, отключается всплывающая потказка для значка, при этом зам значок все еще отображается",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED"] = "Включить автоматическое оповещение запасным при неспособности",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED_DESC"] = "TranqRotate проверит ваши дебаффы, и когда вы должны будите использовать Усмиряющий выстрел, а вы не сможете его применить в отведенную очередность, он оповестит запасных",
    ["INCAPACITATED_DELAY_THRESHOLD"] = "Порог оповещения о неспособности",
    ["INCAPACITATED_DELAY_THRESHOLD_DESC"] = "Если вы потеряете способность выполнить действие дольше установленной задержки, TranqRotate автоматически оповестит запасных",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT"] = "Включить время автоматического оповещения запасных",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT_DESC"] = "TranqRotate оповестит запасных, если босс находится в бешенсте в течение оппределенного времени, а вы должны были усмирять его",
    ["TIMED_DELAY_THRESHOLD"] = "Время порого для оповещения",
    ["TIMED_DELAY_THRESHOLD_DESC"] = "TranqRotate автоматически оповестит запасных, если вы не произвели успирение в установленный порог",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Оповещения",
    ["ENABLE_ANNOUNCES"] = "Включить оповещения",
    ["ENABLE_ANNOUNCES_DESC"] = "Включить / отключить оповещения",
    ["YELL_SAY_DISABLED_OPEN_WORLD"] = "(Каналы Крикнуть и Сказать работают внутри ваших рейдов, но не в открытом мире)",

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
    ["BOSS_SUCCESS_MESSAGE_LABEL"] = "Successful announce message on boss (%s will be replaced by next hunter name)",
    ["TRASH_SUCCESS_MESSAGE_LABEL"] = "Successful announce message on trash (%s will be replaced by target name)",
    ["FAIL_MESSAGE_LABEL"] = "При промахе сообщить",
    ["FAIL_WHISPER_LABEL"] = "При промахе шепнуть запасным",
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Сообщение шепота, когда вы не можете произвести усирение или оповестить запасных",

    ['DEFAULT_BOSS_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done, %s is next!",
    ['DEFAULT_TRASH_SUCCESS_ANNOUNCE_MESSAGE'] = "Tranqshot done on %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! Усмиряющий выстрел промахнулся в %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "!!! Усмиряющий выстрел промахнулся !!! ! УСМИРЯЙ СЕЙЧАС !",
    ['DEFAULT_UNABLE_TO_TRANQ_MESSAGE'] = "Я НЕ МОГУ УСМИРИТЬ ! УСМИРЯЙ СЕЙЧАС !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "УСМИРЯЙ СЕЙЧАС !",

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

    --- Blind icon tooltip
    ["TOOLTIP_PLAYER_WITHOUT_ADDON"] = "Этот игрок не использует TranqRotate",
    ["TOOLTIP_MAY_RUN_OUDATED_VERSION"] = "Или используется версия ниже 1.6.0",
    ["TOOLTIP_DISABLE_SETTINGS"] = "(Вы можете отключить этот значок и/или эту подсказку в настройках)",

    --- Available update
    ["UPDATE_AVAILABLE"] = "A new TranqRotate version is available, update to get latest features",
    ["BREAKING_UPDATE_AVAILABLE"] = "A new BREAKING TranqRotate update is available, you MUST update AS SOON AS possible! TranqRotate may not work properly with up-to-date version users.",
}

TranqRotate.L = L
