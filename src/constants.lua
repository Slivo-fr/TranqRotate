TranqRotate.colors = {
    ['green'] = CreateColor(0.67, 0.83, 0.45),
    ['darkGreen'] = CreateColor(0.1, 0.4, 0.1),
    ['blue'] = CreateColor(0.3, 0.3, 0.7),
    ['red'] = CreateColor(0.7, 0.3, 0.3),
    ['gray'] = CreateColor(0.3, 0.3, 0.3),
    ['purple'] = CreateColor(0.71,0.45,0.75),
    ['white'] = CreateColor(1,1,1),
}

TranqRotate.constants = {
    ['tranqShotSpellId'] = 19801,
    ['arcaneShotSpellId'] = 14287,

    ['hunterFrameHeight'] = 22,
    ['hunterFrameSpacing'] = 4,
    ['titleBarHeight'] = 18,
    ['mainFrameWidth'] = 130,
    ['rotationFramesBaseHeight'] = 20,

    ['minimumKnownWorkingVersion'] = '2.2.6',
    ['commsPrefix'] = 'tranqrotate',
    ['commsChannel'] = 'RAID',

    ['commsTypes'] = {
        ['tranqshotDone'] = 'tranqshot-done',
        ['syncOrder'] = 'sync-order',
        ['syncRequest'] = 'sync-request',
        ['backupRequest'] = 'backup-request',
        ['reset'] = 'reset',
    },

    ['printPrefix'] = 'TranqRotate - ',
    ['duplicateTranqshotDelayThreshold'] = 10,
    ['duplicateFailedTranqshotDelayThreshold'] = 10,

    ['minimumCooldownElapsedForEligibility'] = 10,

    ['sounds'] = {
        ['nextToTranq'] = 'Interface\\AddOns\\TranqRotate\\sounds\\ding.ogg',
        ['alarms'] = {
            ['alarm1'] = 'Interface\\AddOns\\TranqRotate\\sounds\\alarm.ogg',
            ['alarm2'] = 'Interface\\AddOns\\TranqRotate\\sounds\\alarm2.ogg',
            ['alarm3'] = 'Interface\\AddOns\\TranqRotate\\sounds\\alarm3.ogg',
            ['alarm4'] = 'Interface\\AddOns\\TranqRotate\\sounds\\alarm4.ogg',
            ['flagtaken'] = 'Sound\\Spells\\PVPFlagTaken.ogg',
        }
    },

    ['tranqNowSounds'] = {
        ['alarm1'] = 'Loud BUZZ',
        ['alarm2'] = 'Gentle beeplip',
        ['alarm3'] = 'Gentle dong',
        ['alarm4'] = 'Light bipbip',
        ['flagtaken'] = 'Flag Taken (DBM)',
    },

    ['bosses'] = {
        [11982] = { -- magmadar
            ['frenzyId'] = 19451,
            ['cooldown'] = 18,
        },
        [11981] = { -- flamegor
            ['frenzyId'] = 23342,
            ['cooldown'] = 9,
        },
        [14020] = { -- chromaggus
            ['frenzyId'] = 23128,
            ['cooldown'] = 16,
        },
        [15509] = { -- huhuran
            ['frenzyId'] = 26051,
            ['cooldown'] = 13,
        },
        [15932] = { -- gluth
            ['frenzyId'] = 28371,
            ['cooldown'] = 10,
        },
    },

    ["incapacitatingDebuffs"] = {
        19408, -- Magmadar fear
        461125, -- Magmadar fear SOD ?
        23171, -- Chromaggus Bronze affliction stun
        23310, -- Chromaggus Time lapse
        23311, -- Chromaggus Time lapse
        23312, -- Chromaggus Time lapse
        29685, -- Gluth fear
    },

    ["playerNameFormats"] = {
        ["SHORT"] = "SHORT",
        ["PLAYER_NAME_ONLY"] = "PLAYER_NAME",
        ["FULL_NAME"] = "FULL_NAME",
    }
}
