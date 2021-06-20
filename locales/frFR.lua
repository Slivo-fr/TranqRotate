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

    --- Player names formatting options
    ["PLAYER_NAME_FORMAT"] = "Format des noms des joueurs",
    ["PLAYER_NAME_FORMAT_DESC"] = "Le suffixe serveur des joueurs appartement à d'autre serveurs sont masqué par défaut. Si par malchance deux chasseur ont exactement le même nom, vous pouvez ajuster ce paramètre",
    ["PLAYER_NAME_ONLY_OPTION_LABEL"] = "Nomdujoueur",
    ["SHORTENED_SUFFIX_OPTION_LABEL"] = "Nomdujoueur-Ser",
    ["FULL_NAME_OPTION_LABEL"] = "Nomdujoueur-Serveur",

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
    ["DISPLAY_BLIND_ICON"] = "Afficher une icone pour les chasseurs qui n'utilisent pas TranqRotate",
    ["DISPLAY_BLIND_ICON_DESC"] = "Ajoute une icone \"aveugle\" sur le chasseur pour indiquer qu'il n'utilise pas l'addon. Cela signifie qu'il ne connaitra pas la rotation affichée à moins de lui communiquer, ses tir tranquilisants ne seront également pas synchronisés si le joueur se retrouve loin des utilisateurs de l'addons",
    ["DISPLAY_BLIND_ICON_TOOLTIP"] = "Afficher l'infobulle pour l'icone \"aveugle\"",
    ["DISPLAY_BLIND_ICON_TOOLTIP_DESC"] = "En désactivant cette option vous désactivez l'infobulle tout en conservant l'icone",
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
    ["BOSS_SUCCESS_MESSAGE_LABEL"] = "Message de réussite sur boss (%s est le nom du prochain chasseur)",
    ["TRASH_SUCCESS_MESSAGE_LABEL"] = "Message de réussite sur trash (%s est le nom de la cible)",
    ["FAIL_MESSAGE_LABEL"] = "Message d'échec",
    ["FAIL_WHISPER_LABEL"] = "Message d'échec chuchoté",
    ["UNABLE_TO_TRANQ_MESSAGE_LABEL"] = "Message chuchoté quand vous ne pouvez pas tranq ou que vous demandez un backup",

    ['DEFAULT_BOSS_SUCCESS_ANNOUNCE_MESSAGE'] = "Tir tranquillisant fait, %s est le suivant!",
    ['DEFAULT_TRASH_SUCCESS_ANNOUNCE_MESSAGE'] = "Tir tranquillisant fait sur %s",
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

    -- Blind icon tooltip
    ["TOOLTIP_PLAYER_WITHOUT_ADDON"] = "Ce joueur n'utilise pas TranqRotate",
    ["TOOLTIP_MAY_RUN_OUDATED_VERSION"] = "Ou possède une version obsolète inférieure à 1.6.0",
    ["TOOLTIP_DISABLE_SETTINGS"] = "(Il est possible de désactiver l'icone et/ou l'infobulle dans les options)",

    -- Available update
    ["UPDATE_AVAILABLE"] = "Une nouvelle version est disponible, faites la mise à jour pour profiter des derniers ajouts",
    ["BREAKING_UPDATE_AVAILABLE"] = "Une nouvelle version MAJEURE est disponible, vous DEVEZ faire la mise à jour le plus rapidement possible! Votre version pourrait ne pas fonctionner correctement avec celle des utilisateurs disposant de la mise à jour.",

    -- Rotation reset
    ["RESET_UNAUTHORIZED"] = "Vous devez être assistant raid pour réinitialiser la rotation",

    -- Comms chat messages
    ["COMMS_SENT_BACKUP_REQUEST"] = "Envoi d'une demande de backup à %s",
    ["COMMS_RECEIVED_NEW_ROTATION"] = "Nouvelle rotation reçue de %s",
    ["COMMS_RECEIVED_BACKUP_REQUEST"] = "%s demande un backup !",
    ["COMMS_RECEIVED_RESET_BROADCAST"] = "%s à réinitialisé la rotation",

    -- Failed tranq printed messages
    ["PRINT_FAILED_TRANQ_MISS"] = "%s a raté son tranqshot!",
    ["PRINT_FAILED_TRANQ_RESIST"] = "Le tranqshot de %s a été résisté!",
    ["PRINT_FAILED_TRANQ_MISS_OR_RESIST"] = "Le tranqshot de %s a raté ou a été résisté!",
}

TranqRotate.L = L
