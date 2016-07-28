package kabam.rotmg.fortune
{
    import kabam.rotmg.fortune.services.FortuneModel;
    import kabam.rotmg.startup.control.StartupSequence;

    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;

    public class FortuneConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var commandMap:ISignalCommandMap;
        [Inject]
        public var sequence:StartupSequence;

        public function configure():void
        {
            this.injector.map(FortuneModel).asSingleton();
        }
    }
}

