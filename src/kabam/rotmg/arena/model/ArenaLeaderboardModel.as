﻿package kabam.rotmg.arena.model
{
    import __AS3__.vec.Vector;
    import kabam.rotmg.text.model.TextKey;
    import __AS3__.vec.*;

    public class ArenaLeaderboardModel 
    {

        public static const FILTERS:Vector.<ArenaLeaderboardFilter> = Vector.<ArenaLeaderboardFilter>([new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_ALLTIME, "alltime"), new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_WEEKLY, "weekly"), new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_YOURRANK, "personal")]);


        public function clearFilters():void
        {
            var _local1:ArenaLeaderboardFilter;
            for each (_local1 in FILTERS)
            {
                _local1.clearEntries();
            };
        }


    }
}

