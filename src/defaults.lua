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
			lock = false,
			hideNotInRaid = false,
			enableNextToTranqSound = true,
			enableTranqNowSound = true,
			tranqNowSound = 'alarm1',
			doNotShowWindowOnRaidJoin = false,
			showWindowWhenTargetingBoss = false,
			showFrenzyCooldownProgress = true,
	    },
	}
end
