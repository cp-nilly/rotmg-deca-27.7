﻿package kabam.rotmg.startup.model.impl
{
    import kabam.rotmg.startup.model.api.StartupDelegate;
    import org.swiftsuspenders.Injector;
    import org.osflash.signals.Signal;
    import kabam.lib.tasks.DispatchSignalTask;
    import kabam.lib.tasks.Task;

    public class SignalTaskDelegate implements StartupDelegate 
    {

        public var injector:Injector;
        public var signalClass:Class;
        public var priority:int;


        public function getPriority():int
        {
            return (this.priority);
        }

        public function make():Task
        {
            var _local1:Signal = this.injector.getInstance(this.signalClass);
            return (new DispatchSignalTask(_local1));
        }


    }
}

