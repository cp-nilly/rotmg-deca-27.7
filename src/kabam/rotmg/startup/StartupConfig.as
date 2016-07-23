package kabam.rotmg.startup
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import kabam.rotmg.startup.control.StartupSequence;
    import kabam.rotmg.startup.control.StartupSignal;
    import kabam.rotmg.startup.control.StartupCommand;

    public class StartupConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;
        [Inject]
        public var commandMap:ISignalCommandMap;


        public function configure():void
        {
            this.injector.map(StartupSequence).asSingleton();
            this.commandMap.map(StartupSignal).toCommand(StartupCommand);
        }


    }
}

