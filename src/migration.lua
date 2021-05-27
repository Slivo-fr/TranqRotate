-- Runs migrations on the current profile based on the currentMigration value
function TranqRotate:migrateProfile()

    if (TranqRotate.db.profile.currentMigration == nil) then
        TranqRotate.db.profile.currentMigration = 0
    end

    if (TranqRotate.db.profile.currentMigration < #TranqRotate.migrations) then
        for i = TranqRotate.db.profile.currentMigration + 1, #TranqRotate.migrations, 1 do
            TranqRotate.migrations[i]()
            TranqRotate.db.profile.currentMigration = i
        end
    end
end

TranqRotate.migrations = {
    -- 1.6.0
    function()
        -- Those are old, badly named key
        TranqRotate.db.profile.enableTimedBackupAlertValue = nil
        TranqRotate.db.profile.timedBackupAlertValueDelay = nil
    end,
    -- 1.8.0
    function()
        -- This is an old key
        TranqRotate.db.profile.announceSuccessMessage = nil
    end,
}
