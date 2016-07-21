package kabam.rotmg.arena.control
{
    import robotlegs.bender.bundles.mvcs.Command;
    import kabam.rotmg.arena.model.CurrentArenaRunModel;

    public class ClearCurrentRunCommand extends Command 
    {

        [Inject]
        public var currentRunModel:CurrentArenaRunModel;


        override public function execute():void
        {
            this.currentRunModel.clear();
        }


    }
}

