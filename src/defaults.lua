local L = TranqRotate.L

function TranqRotate:LoadDefaults()
	self.defaults = {
	    profile = {
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,
	        announceSuccessMessage = L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"],
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
	    },
	}
end
