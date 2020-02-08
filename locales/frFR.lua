if( GetLocale() ~= "frFR" ) then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate chargé, utilisez /tranq pour les options",

    -- Settings
    ["SETTING_GENERAL"] = "Général",
    ["SETTING_GENERAL_REPORT"] = "Merci de signaler tout bug rencontré sur",
    ["SETTING_GENERAL_DESC"] = "Cette première version permet uniquement des annonces automatique pour le tir tranquillisant\n"..
        "D'autres fonctionnalités sont prévues, permettant entre autre un affichage temps réel de la rotation et des cooldowns",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Annonces",
    ["ENABLE_ANNOUNCES"] = "Activer les annonces",
    ["ENABLE_ANNOUNCES_DESC"] = "Activer / désactiver les annonces",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Canal",
    ["MESSAGE_CHANNEL_TYPE"] = "Envoyer les annonces sur",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Canal à utiliser pour les annonces",
    ["MESSAGE_CHANNEL_NAME"] = "Nom du canal ou du joueur",
    ["MESSAGE_CHANNEL_NAME_DESC"] = "Nom du canal ou du  à utiliser",

    ----- Channels types
    ["CHANNEL_WHISPER"] = "Chuchoter ",
    ["CHANNEL_CHANNEL"] = "Canal",
    ["CHANNEL_RAID_WARNING"] = "Avertissement raid",
    ["CHANNEL_SAY"] = "Dire",
    ["CHANNEL_YELL"] = "Crier",
    ["CHANNEL_PARTY"] = "Groupe",
    ["CHANNEL_RAID"] = "Raid",

    ---- Messages
    ["ANNOUNCES_MESSAGE_HEADER"] = "Messages",
    ["SUCCESS_MESSAGE_LABEL"] = "Message de réussite",
    ["FAIL_MESSAGE_LABEL"] = "Message d'échec",
    ["FAIL_WHISPER_LABEL"] = "Message d'échec cdhuchoté",

    ['DEFAULT_SUCCESS_ANNOUNCE_MESSAGE'] = "Tir tranquillisant fait sur %s",
    ['DEFAULT_FAIL_ANNOUNCE_MESSAGE'] = "!!! TIR TRANQUILLISANT RATE SUR %s !!!",
    ['DEFAULT_FAIL_WHISPER_MESSAGE'] = "TIR TRANQUILISANT RATE ! TRANQ MAINTENANT !",

    --- Rotation
    ["SETTING_ROTATION"] = "Rotation",
    ["LOCK_WINDOW"] = "Verrouiller la position de la fênetre",
    ["LOCK_WINDOW_DESC"] = "Verrouiller la position de la fênetre",
    ["WINDOW_LOCKED"] = "TranqRotate: Fenêtre verrouillée",
    ["WINDOW_UNLOCKED"] = "TranqRotate: Fenêtre déverrouillée",

    --- Profiles
    ["SETTING_PROFILES"] = "Profils",

    --- Raid broadcast messages
    ["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup",
    ["BROADCAST_ROTATION_PREFIX"] = "Rotation",
    ["BROADCAST_BACKUP_PREFIX"] = "Backup",
}

TranqRotate.L = L
