if (GetLocale() ~= "frFR") then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate chargé, utilisez /tranq pour les options",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate window hidden. Use /tranq toggle to get it back",

    -- Settings
    ["SETTING_GENERAL"] = "Général",
    ["SETTING_GENERAL_REPORT"] = "Merci de signaler tout bug rencontré sur",
    ["SETTING_GENERAL_DESC"] = "Nouveau : TranqRotate synchronize maintenant la liste et les tirs tranquillisants",

    ["LOCK_WINDOW"] = "Verrouiller la position de la fênetre",
    ["LOCK_WINDOW_DESC"] = "Verrouiller la position de la fênetre",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Masquer la fenêtre principale hors raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Masquer la fenêtre principale hors raid",
    ["WINDOW_LOCKED"] = "TranqRotate: Fenêtre verrouillée",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Fenêtre déverrouillée",

    ["TEST_MODE_HEADER"] = "Test mode",
    ["ENABLE_ARCANE_SHOT_TESTING"] = "Activer/désactiver le mode test",
    ["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "Tant que le mode de test est activé, arcane shot sera considéré comme un tir tranquilisant\n" ..
        "Le mode de test durera 10 minutes ou jusqu'a désactivation",
    ["ARCANE_SHOT_TESTING_ENABLED"] = "Test mode activé pour 10 minutes",
    ["ARCANE_SHOT_TESTING_DISABLED"] = "Test mode désactivé",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Annonces",
    ["ENABLE_ANNOUNCES"] = "Activer les annonces",
    ["ENABLE_ANNOUNCES_DESC"] = "Activer / désactiver les annonces",

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

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Tir tranquillisant fait sur %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TIR TRANQUILLISANT RATE SUR %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TIR TRANQUILISANT RATE ! TRANQ MAINTENANT !",

    ["BROADCAST_MESSAGE_HEADER"] = "Diffusion de la configuration de la rotation",

    --- Sounds
    ["SETTING_SOUNDS"] = "Sons",
    ["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Jouer un son lorsque vous êtes le prochain à devoir tranq",

    --- Profiles
    ["SETTING_PROFILES"] = "Profils",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",
}

TranqRotate.L = L
