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
						name = "TranqRotate v" .. TranqRotate.version .. " by Slivo\n",
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
					baseVersion = {
						name = L['SETTING_GENERAL_DESC'],
						type = "description",
						width = "full",
						order = 3,
					},
                    -- @todo : find a way to space widget properly
					spacer4 = {
						name = ' ',
						type = "description",
						width = "full",
						order = 4,
					},
                    lock = {
                        name = L["LOCK_WINDOW"],
                        desc = L["LOCK_WINDOW_DESC"],
                        type = "toggle",
                        order = 5,
                        width = "double",
                    },
                    hideNotInRaid = {
                        name = L["HIDE_WINDOW_NOT_IN_RAID"],
                        desc = L["HIDE_WINDOW_NOT_IN_RAID_DESC"],
                        type = "toggle",
                        order = 6,
                        width = "double",
                    },
                    doNotShowWindowOnRaidJoin = {
                        name = L["DO_NOT_SHOW_WHEN_JOINING_RAID"],
                        desc = L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"],
                        type = "toggle",
                        order = 7,
                        width = "double",
                    },
                    showWindowWhenTargetingBoss = {
                        name = L["SHOW_WHEN_TARGETING_BOSS"],
                        desc = L["SHOW_WHEN_TARGETING_BOSS_DESC"],
                        type = "toggle",
                        order = 8,
                        width = "double",
                    },
                    testHeader = {
                        name = L["TEST_MODE_HEADER"],
                        type = "header",
                        order = 10,
                    },
                    ToggleArcaneShotTestingDesc = {
                        name = L['ENABLE_ARCANE_SHOT_TESTING_DESC'],
                        type = "description",
                        width = "full",
                        order = 11,
                    },
                    spacer12 = {
                        name = ' ',
                        type = "description",
                        width = "full",
                        order = 12,
                    },
                    ToggleArcaneShotTesting = {
                        name = L["ENABLE_ARCANE_SHOT_TESTING"],
                        type = "execute",
                        order = 13,
                        func = function() TranqRotate.toggleArcaneShotTesting() end
                    }
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
                    announceSuccessMessage = {
                        name = L["SUCCESS_MESSAGE_LABEL"],
                        type = "input",
                        order = 23,
                        width = "double",
                    },
                    announceFailMessage = {
                        name = L["FAIL_MESSAGE_LABEL"],
                        type = "input",
                        order = 24,
                        width = "double",
                    },
                    whisperFailMessage = {
                        name = L["FAIL_WHISPER_LABEL"],
                        type = "input",
                        order = 25,
                        width = "double",
                    },
                    setupBroadcastHeader = {
                        name = L["BROADCAST_MESSAGE_HEADER"],
                        type = "header",
                        order = 30,
                    },
                    setupBroadcastChannelType = {
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
                        hidden = function() return not (TranqRotate.db.profile.setupBroadcastChannelType == "CHANNEL") end,
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
                        width = "double",
                    },
                    enableTranqNowSound = {
                        name = L["ENABLE_TRANQ_NOW_SOUND"],
                        desc = L["ENABLE_TRANQ_NOW_SOUND"],
                        type = "toggle",
                        order = 2,
                        width = "double",
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

