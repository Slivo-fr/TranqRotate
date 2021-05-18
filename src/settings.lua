local Addon = select(1, ...)

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local L = TranqRotate.L

function TranqRotate:CreateConfig()

	local function get(info)
		return TranqRotate.db.profile[info[#info]]
	end

	local function set(info, value)
		TranqRotate.db.profile[info[#info]] = value
        TranqRotate:applySettings()
	end

	local options = {
		name = "TranqRotate",
		type = "group",
		get = get,
		set = set,
		icon = "",
		args = {
            general = {
                name = L['SETTING_GENERAL'],
                type = "group",
                order = 1,
                args = {
					descriptionText = {
						name = "TranqRotate v" .. TranqRotate.version .. " by Slivo-Sulfuron\n",
						type = "description",
						width = "full",
						order = 1,
					},
					repoLink = {
						name = L['SETTING_GENERAL_REPORT'] .. " https://github.com/Slivo-fr/TranqRotate\n",
						type = "description",
						width = "full",
						order = 2,
					},
                    -- @todo : find a way to space widget properly
					--spacer3 = {
					--	name = ' ',
					--	type = "description",
					--	width = "full",
					--	order = 3,
					--},
					--baseVersion = {
					--	name = L['SETTING_GENERAL_DESC'],
					--	type = "description",
					--	width = "full",
					--	order = 4,
					--},
                    -- @todo : find a way to space widget properly
					spacer4 = {
						name = ' ',
						type = "description",
						width = "full",
						order = 5,
					},
                    lock = {
                        name = L["LOCK_WINDOW"],
                        desc = L["LOCK_WINDOW_DESC"],
                        type = "toggle",
                        order = 6,
                        width = "double",
                    },
                    hideNotInRaid = {
                        name = L["HIDE_WINDOW_NOT_IN_RAID"],
                        desc = L["HIDE_WINDOW_NOT_IN_RAID_DESC"],
                        type = "toggle",
                        order = 7,
                        width = "double",
                    },
                    doNotShowWindowOnRaidJoin = {
                        name = L["DO_NOT_SHOW_WHEN_JOINING_RAID"],
                        desc = L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"],
                        type = "toggle",
                        order = 8,
                        width = "full",
                    },
                    showWindowWhenTargetingBoss = {
                        name = L["SHOW_WHEN_TARGETING_BOSS"],
                        desc = L["SHOW_WHEN_TARGETING_BOSS_DESC"],
                        type = "toggle",
                        order = 9,
                        width = "full",
                    },
                    testHeader = {
                        name = L["TEST_MODE_HEADER"],
                        type = "header",
                        order = 30,
                    },
                    ToggleArcaneShotTestingDesc = {
                        name = L['ENABLE_ARCANE_SHOT_TESTING_DESC'],
                        type = "description",
                        width = "full",
                        order = 31,
                    },
                    spacer12 = {
                        name = ' ',
                        type = "description",
                        width = "full",
                        order = 32,
                    },
                    ToggleArcaneShotTesting = {
                        name = L["ENABLE_ARCANE_SHOT_TESTING"],
                        type = "execute",
                        order = 33,
                        func = function() TranqRotate.toggleArcaneShotTesting() end
                    },
                    featuresHeader = {
                        name = L["FEATURES_HEADER"],
                        type = "header",
                        order = 50,
                    },
                    showFrenzyCooldownProgress = {
                        name = L["DISPLAY_BOSS_FRENZY_COOLDOWN"],
                        desc = L["DISPLAY_BOSS_FRENZY_COOLDOWN_DESC"],
                        type = "toggle",
                        order = 51,
                        width = "full",
                        set = function(info, value)
                            set(info, value)
                            if (not value) then TranqRotate:resetFrenzyFrame() end
                        end
                    },
                    showIconOnHunterWithoutTranqRotate = {
                        name = L["DISPLAY_BLIND_ICON"],
                        desc = L["DISPLAY_BLIND_ICON_DESC"],
                        type = "toggle",
                        order = 52,
                        width = "full",
                        set = function(info, value) set(info,value) TranqRotate:refreshBlindIcons() end
                    },
                    showBlindIconTooltip = {
                        name = L["DISPLAY_BLIND_ICON_TOOLTIP"],
                        desc = L["DISPLAY_BLIND_ICON_TOOLTIP_DESC"],
                        type = "toggle",
                        order = 53,
                        width = "full",
                    },
                    enableIncapacitatedBackupAlert = {
                        name = L["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED"],
                        desc = L["ENABLE_AUTOMATIC_BACKUP_ALERT_WHEN_INCAPACITATED_DESC"],
                        type = "toggle",
                        order = 54,
                        width = "double",
                    },
                    incapacitatedDelay = {
                        name = L["INCAPACITATED_DELAY_THRESHOLD"],
                        desc = L["INCAPACITATED_DELAY_THRESHOLD_DESC"],
                        type = "range",
                        order = 55,
                        width = "normal",
                        min = 1,
                        max = 6,
                        step = 0.1,
                    },
                    enableTimedBackupAlert = {
                        name = L["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT"],
                        desc = L["ENABLE_AUTOMATIC_TIMED_BACKUP_ALERT_DESC"],
                        type = "toggle",
                        order = 56,
                        width = "double",
                    },
                    timedBackupAlertDelay = {
                        name = L["TIMED_DELAY_THRESHOLD"],
                        desc = L["TIMED_DELAY_THRESHOLD_DESC"],
                        type = "range",
                        order = 57,
                        width = "normal",
                        min = 1,
                        max = 6,
                        step = 0.1,
                    },
                }
            },
            announces = {
                name = L['SETTING_ANNOUNCES'],
                type = "group",
                order = 2,
                args = {
                    enableAnnounces = {
                        name = L["ENABLE_ANNOUNCES"],
                        desc = L["ENABLE_ANNOUNCES_DESC"],
                        type = "toggle",
                        order = 1,
                        width = "double",
                    },
                    announceHeader = {
                        name = L["ANNOUNCES_MESSAGE_HEADER"],
                        type = "header",
                        order = 20,
                    },
                    channelType = {
                        name = L["MESSAGE_CHANNEL_TYPE"],
                        desc = L["MESSAGE_CHANNEL_TYPE_DESC"],
                        type = "select",
                        order = 21,
                        values = {
                            ["RAID_WARNING"] = L["CHANNEL_RAID_WARNING"],
                            ["SAY"] = L["CHANNEL_SAY"],
                            ["YELL"] = L["CHANNEL_YELL"],
                            ["PARTY"] = L["CHANNEL_PARTY"],
                            ["RAID"] = L["CHANNEL_RAID"]
                        },
                    },
                    spacer22 = {
                        name = ' ',
                        type = "description",
                        width = "normal",
                        order = 22,
                    },
                    announceBossSuccessMessage = {
                        name = L["BOSS_SUCCESS_MESSAGE_LABEL"],
                        type = "input",
                        order = 23,
                        width = "double",
                    },
                    announceTrashSuccessMessage = {
                        name = L["TRASH_SUCCESS_MESSAGE_LABEL"],
                        type = "input",
                        order = 24,
                        width = "double",
                    },
                    announceFailMessage = {
                        name = L["FAIL_MESSAGE_LABEL"],
                        type = "input",
                        order = 25,
                        width = "double",
                    },
                    whisperFailMessage = {
                        name = L["FAIL_WHISPER_LABEL"],
                        type = "input",
                        order = 26,
                        width = "double",
                    },
                    unableToTranqMessage = {
                        name = L["UNABLE_TO_TRANQ_MESSAGE_LABEL"],
                        type = "input",
                        order = 27,
                        width = "double",
                    },
                    setupBroadcastHeader = {
                        name = L["BROADCAST_MESSAGE_HEADER"],
                        type = "header",
                        order = 30,
                    },
                    rotationReportChannelType = {
                        name = L["MESSAGE_CHANNEL_TYPE"],
                        type = "select",
                        order = 31,
                        values = {
                            ["CHANNEL"] = L["CHANNEL_CHANNEL"],
                            ["RAID_WARNING"] = L["CHANNEL_RAID_WARNING"],
                            ["SAY"] = L["CHANNEL_SAY"],
                            ["YELL"] = L["CHANNEL_YELL"],
                            ["PARTY"] = L["CHANNEL_PARTY"],
                            ["RAID"] = L["CHANNEL_RAID"]
                        },
                        set = function(info, value) set(info,value) LibStub("AceConfigRegistry-3.0", true):NotifyChange("TranqRotate") end
                    },
                    setupBroadcastTargetChannel = {
                        name = L["MESSAGE_CHANNEL_NAME"],
                        desc = L["MESSAGE_CHANNEL_NAME_DESC"],
                        type = "input",
                        order = 32,
                        hidden = function() return not (TranqRotate.db.profile.rotationReportChannelType == "CHANNEL") end,
                    },
                    useMultilineRotationReport = {
                        name = L["USE_MULTILINE_ROTATION_REPORT"],
                        desc = L["USE_MULTILINE_ROTATION_REPORT_DESC"],
                        type = "toggle",
                        order = 40,
                        width = "full",
                    },
                }
            },
            sounds = {
                name = L['SETTING_SOUNDS'],
                type = "group",
                order = 3,
                args = {
                    enableNextToTranqSound = {
                        name = L["ENABLE_NEXT_TO_TRANQ_SOUND"],
                        desc = L["ENABLE_NEXT_TO_TRANQ_SOUND"],
                        type = "toggle",
                        order = 1,
                        width = "full",
                    },
                    enableTranqNowSound = {
                        name = L["ENABLE_TRANQ_NOW_SOUND"],
                        desc = L["ENABLE_TRANQ_NOW_SOUND"],
                        type = "toggle",
                        order = 2,
                        width = "full",
                    },
                    tranqNowSound = {
                        name = L["TRANQ_NOW_SOUND_CHOICE"],
                        desc = L["TRANQ_NOW_SOUND_CHOICE"],
                        type = "select",
                        style = "dropdown",
                        order = 3,
                        values = TranqRotate.constants.tranqNowSounds,
                        set = function(info, value)
                            set(info, value)
                            PlaySoundFile(TranqRotate.constants.sounds.alarms[value])
                        end
                    },
                    baseVersion = {
                        name = L['DBM_SOUND_WARNING'],
                        type = "description",
                        width = "full",
                        order = 4,
                    },
                }
            }
        }
	}

    AceConfigRegistry:RegisterOptionsTable(Addon, options, true)
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    AceConfigDialog:AddToBlizOptions(Addon, nil, nil, "general")
    AceConfigDialog:AddToBlizOptions(Addon, L['SETTING_ANNOUNCES'], Addon, "announces")
    AceConfigDialog:AddToBlizOptions(Addon, L["SETTING_PROFILES"], Addon, "profile")

    AceConfigDialog:SetDefaultSize(Addon, 895, 570)

end

