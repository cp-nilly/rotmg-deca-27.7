package kabam.rotmg.startup.model.impl
{
    import kabam.lib.tasks.Task;
    import kabam.rotmg.startup.model.api.StartupDelegate;

    import robotlegs.bender.framework.api.IInjector;

    public class TaskDelegate implements StartupDelegate
    {
        public var injector:IInjector;
        public var taskClass:Class;
        public var priority:int;

        public function getPriority():int
        {
            return (this.priority);
        }

        public function make():Task
        {
            return (this.injector.getInstance(this.taskClass));
        }
    }
}

