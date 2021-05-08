function TranqRotate:migrateProfile()

    if (TranqRotate.db.profile.currentMigration == nil) then
        TranqRotate.db.profile.currentMigration = 0
    end

    for i = TranqRotate.db.profile.currentMigration + 1, #TranqRotate.migrations, 1 do
        TranqRotate.migrations[i]()
    end
end

TranqRotate.migrations = {
    -- 1.6.0
    function()
        -- Those are old, badly named key
        TranqRotate.db.profile.enableTimedBackupAlertValue = nil
        TranqRotate.db.profile.timedBackupAlertValueDelay = nil
    end,
}
