local TranqRotate = select(2, ...)

TranqRotate.colors = {
    ['green'] = CreateColor(0.67, 0.83, 0.45),
    ['darkGreen'] = CreateColor(0.1, 0.4, 0.1),
    ['blue'] = CreateColor(0.3, 0.3, 0.7),
    ['red'] = CreateColor(0.7, 0.3, 0.3),
    ['gray'] = CreateColor(0.3, 0.3, 0.3),
    ['purple'] = CreateColor(0.71,0.45,0.75),
    ['white'] = CreateColor(1,1,1)
}

TranqRotate.constants = {
    ['hunterFrameHeight'] = 20,
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
    },

    ['printPrefix'] = 'TranqRotate - '
}
