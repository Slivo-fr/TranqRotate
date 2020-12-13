local TranqRotate = select(2, ...)

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
    ['hunterFrameHeight'] = 22,
    ['hunterFrameSpacing'] = 4,
    ['titleBarHeight'] = 18,
    ['mainFrameWidth'] = 130,
    ['rotationFramesBaseHeight'] = 20,

    ['commsPrefix'] = 'tranqrotate',
    ['commsChannel'] = 'RAID',

    ['commsTypes'] = {
        ['tranqshotDone'] = 'tranqshot-done',
        ['syncOrder'] = 'sync-order',
        ['syncRequest'] = 'sync-request',
        ['backupRequest'] = 'backup-request',
    },

    ['printPrefix'] = 'TranqRotate - ',
    ['duplicateTranqshotDelayThreshold'] = 10,

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
            ['frenzy'] = 19451,
            ['cooldown'] = 18,
        },
        [11981] = { -- flamegor
            ['frenzy'] = 23342,
            ['cooldown'] = 9,
        },
        [14020] = { -- chromaggus
            ['frenzy'] = 23342,
            ['cooldown'] = 16,
        },
        [15509] = { -- huhuran
            ['frenzy'] = 19451,
            ['cooldown'] = 13,
        },
        [15932] = { -- gluth
            ['frenzy'] = 19451,
            ['cooldown'] = 10,
        },
    },

    ["incapacitatingDebuffs"] = {
        19408, -- Magmadar fear
        23171, -- Chromaggus Bronze affliction stun
        23311, -- Chromaggus Time lapse
    },
}
