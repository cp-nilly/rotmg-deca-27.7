package kabam.rotmg.external.command
{
    import kabam.lib.tasks.DispatchSignalTask;
    import kabam.lib.tasks.TaskMonitor;
    import kabam.lib.tasks.TaskSequence;
    import kabam.rotmg.external.service.RequestPlayerCreditsTask;

    import robotlegs.bender.bundles.mvcs.Command;
    import robotlegs.bender.framework.api.IInjector;

    public class RequestPlayerCreditsCommand extends Command
    {
        [Inject]
        public var taskMonitor:TaskMonitor;
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var requestPlayerCreditsComplete:RequestPlayerCreditsCompleteSignal;

        override public function execute():void
        {
            var _local1:TaskSequence = new TaskSequence();
            _local1.add(this.injector.getInstance(RequestPlayerCreditsTask));
            _local1.add(new DispatchSignalTask(this.requestPlayerCreditsComplete));
            this.taskMonitor.add(_local1);
            _local1.start();
        }
    }
}

