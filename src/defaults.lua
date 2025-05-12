local L = TranqRotate.L

function TranqRotate:LoadDefaults()
	self.defaults = {
	    profile = {
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,
			announceBossSuccessMessage = L["DEFAULT_BOSS_SUCCESS_ANNOUNCE_MESSAGE"],
			announceTrashSuccessMessage = L["DEFAULT_TRASH_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceFailMessage = L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"],
			whisperFailMessage = L["DEFAULT_FAIL_WHISPER_MESSAGE"],
			unableToTranqMessage = L["DEFAULT_UNABLE_TO_TRANQ_MESSAGE"],
			lock = false,
			hideNotInRaid = false,
			enableNextToTranqSound = true,
			enableTranqNowSound = true,
			tranqNowSound = 'alarm1',
			doNotShowWindowOnRaidJoin = false,
			showWindowWhenTargetingBoss = false,
			showFrenzyCooldownProgress = true,
			enableIncapacitatedBackupAlert = true,
			incapacitatedDelay = 2,
			enableTimedBackupAlert = false,
			timedBackupAlertDelay = 3,
			showIconOnHunterWithoutTranqRotate = true,
			showBlindIconTooltip = true,
			playerNameFormatting = TranqRotate.constants.playerNameFormats.PLAYER_NAME_ONLY,
			enableDebugOutput = false,
	    },
	}
end
