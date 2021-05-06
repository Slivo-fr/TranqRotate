if (GetLocale() ~= "frFR") then return end

TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate chargé, utilisez /tranq pour les options",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate window hidden. Use /tranq toggle to get it back",

    -- Settings
    ["SETTING_GENERAL"] = "Général",
    ["SETTING_GENERAL_REPORT"] = "Merci de signaler tout bug rencontré sur",
    ["SETTING_GENERAL_DESC"] = "Nouveau : TranqRotate peut maintenant jouer un son pour vous avertir quand vous devez tranq ! Plusieurs optiosn d'affichage ont été ajoutée pour rendre l'addon moins intrusif",

    ["LOCK_WINDOW"] = "Verrouiller la position de la fênetre",
    ["LOCK_WINDOW_DESC"] = "Verrouiller la position de la fênetre",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Masquer la fenêtre principale hors raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Masquer la fenêtre principale hors raid",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Ne pas afficher la fenêtre principale lorsque vous rejoignez un raid",
    ["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Ne pas afficher la fenêtre principale lorsque vous rejoignez un raid",
    ["SHOW_WHEN_TARGETING_BOSS"] = "Afficher la fenêtre principale lorsque vous ciblez un boss tranquilisable",
    ["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Afficher la fenêtre principale lorsque vous ciblez un boss tranquilisable",
    ["WINDOW_LOCKED"] = "TranqRotate: Fenêtre verrouillée",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Fenêtre déverrouillée",

    ["TEST_MODE_HEADER"] = "Test mode",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "Activer/désactiver le mode test",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "Tant que le mode de test est activé, arcane shot sera considéré comme un tir tranquilisant\n" ..
        "Le mode de test durera 10 minutes ou jusqu'a désactivation",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "Test mode activé pour 10 minutes",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "Test mode désactivé",

    ["FEATURES_HEADER"] = "Fonctionnalités optionnelles",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN"] = "Afficher le cooldown de frénésie des boss",
    ["DISPLAY_BOSS_FRENZY_COOLDOWN_DESC"] = "Une fine barre de progression, juste sous la barre de titre, indiquera le cooldown de la frénésie",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED"] = "Activer l'alerte automatique en cas d'incapacité",
    ["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED_DESC"] = "TranqRotate alertera automatiquement le backup si un debuff vous empeche de tranq pendant un temps supérieur au délai configuré",
    ["INCAPACITATED_DELAY_THRESHOLD"] = "Délai pour l'alerte d'incapacité",
    ["INCAPACITATED_DELAY_THRESHOLD_DESC"] = "Si un débuff vous empêche de tranq pour un temps supérieur à celui configuré au moment ou vous devez tranq, une alerte est envoyée au backup",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT"] = "Activer l'alerte automatique chronométrée ",
    ["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT_DESC"] = "TranqRotate enverra automatiquement une alerte au backup si vous ne tirez pas votre tir tranquilisant avant le délai configuré",
    ["TIMED_DELAY_THRESHOLD"] = "Délai pour l'alerte chronométrée",
    ["TIMED_DELAY_THRESHOLD_DESC"] = "Si vous ne tirez pas votre tir tranquilisant avant ce délai, une alerte sera envoyée au backup",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Annonces",
    ["ENABLE_ANNOUNCES"] = "Activer les annonces",
    ["ENABLE_ANNOUNCES_DESC"] = "Activer / désactiver les annonces",
    ["YELL_SAY_DISABLED_OPEN_WORLD"] = "(Les canaux dire et crier ne fonctionnent pas hors instance)",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Canal",
    ["MESSAGE_CHANNEL_TYPE"] = "Canal",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Canal à utiliser pour les annonces",
    ["MESSAGE_CHANNEL_NAME"] = "Nom du canal",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Nom du canal à utiliser",

    ----- Channels types
    ["CHANNEL_CHANNEL"] = "Channel",
    ["CHANNEL_RAID_WARNING"] = "Avertissement raid",
    ["CHANNEL_SAY"] = "Dire",
    ["CHANNEL_YELL"] = "Crier",
    ["CHANNEL_PARTY"] = "Groupe",
    ["CHANNEL_RAID"] = "Raid",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Annonces de tir tranquilisant",
    ["SUCCESS_MESSAGE_LABEL"] = "Message de réussite",
    ["FAIL_MESSAGE_LABEL"] = "Message d'échec",
    ["FAIL_WHISPER_LABEL"] = "Message d'échec chuchoté",
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Message chuchoté quand vous ne pouvez pas tranq ou que vous demandez un backup",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Tir tranquillisant fait sur %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TIR TRANQUILLISANT RATE SUR %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TIR TRANQUILISANT RATE ! TRANQ MAINTENANT !",
    ['DEFAULT_UNABLE_TO_TRANQ_MESSAGE'] = "JE NE PEUX PAS TRANQ ! TRANQ MAINTENANT !",

    ['TRANQ_NOW_LOCAL_ALERT_MESSAGE'] = "TRANQ MAINTENANT !",

    ["BROADCAST_MESSAGE_HEADER"] = "Rapport de la configuration de la rotation",
    ["USE_MULTILINE_ROTATION_REPORT"] = "Utiliser plusieurs lignes pour la rotation principale",
    ["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Chaque chasseur de la rotation apparaitra sur une ligne numérotée",

    --- Sounds
    ["SETTING_SOUNDS"] = "Sons",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Jouer un son lorsque vous êtes le prochain à devoir tranq",
    ["ENABLE_TRANQ_NOW_SOUND"] = "Jouer un son au moment ou vous devez tranq",
    ["TRANQ_NOW_SOUND_CHOICE"] = "Son à jouer au moment ou vous devez tranq",
    ["DBM_SOUND_WARNING"] = "DBM joue le son de capture de drapeau à chaque frénésie, cela pourrait couvrir un son trop doux. Je suggère de choisir un son assez marquant ou de désactiver les alertes de frénésie DBM si vous choisissez un son plus doux.",

    --- Profiles
    ["SETTING_PROFILES"] = "Profils",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",
}

TranqRotate.L = L
