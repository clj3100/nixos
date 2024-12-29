{ ... }:
{
    services.snapper = {
        snapshotInterval = "hourly";
        cleanupInterval = "1h";
        configs.home = {
            SUBVOLUME = "/home";
            FSTYPE = "btrfs";

            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;

            TIMELINE_LIMIT_HOURLY = "12";
            TIMELINE_LIMIT_DAILY = "7";
            TIMELINE_LIMIT_WEEKLY = "0";
            TIMELINE_LIMIT_MONTHLY = "0";
            TIMELINE_LIMIT_YEARLY = "0";
        };
    };
}