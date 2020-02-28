if( GetLocale() ~= "frFR" ) then return end

local TranqRotate = select(2, ...)

local L = {

    ["LOADED_MESSAGE"] = "TranqRotate chargé, utilisez /tranq pour les options",
    ["TRANQ_WINDOW_HIDDEN"] = "Tranqrotate window hidden. Use /tranq toggle to get it back",

    -- Settings
    ["SETTING_GENERAL"] = "Général",
    ["SETTING_GENERAL_REPORT"] = "Merci de signaler tout bug rencontré sur",
    ["SETTING_GENERAL_DESC"] = "Nouveau : Une fenetre permet maintenant de régler et suivre la rotation\n"..
        "TranqRotate va également et automatiquement chuchoter le chasseur suivant et le backup en cas de raté !\n"..
        "Aucune synchronisation n'est encore en place, chaque chasseur dois régler l'ordre de son coté.",

    --- Announces
    ["SETTING_ANNOUNCES"] = "Annonces",
    ["ENABLE_ANNOUNCES"] = "Activer les annonces",
    ["ENABLE_ANNOUNCES_DESC"] = "Activer / désactiver les annonces",

    ---- Channels
    ["ANNOUNCES_CHANNEL_HEADER"] = "Canal",
    ["MESSAGE_CHANNEL_TYPE"] = "Envoyer les annonces sur",
    ["MESSAGE_CHANNEL_TYPE_DESC"] = "Canal à utiliser pour les annonces",

    ----- Channels types
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
    ["LOCK_WINDOW"] = "Verrouiller la position de la fênetre",
    ["LOCK_WINDOW_DESC"] = "Verrouiller la position de la fênetre",
    ["HIDE_WINDOW_NOT_IN_RAID"] = "Masquer la fenêtre principale hors raid",
    ["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Masquer la fenêtre principale hors raid",
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
