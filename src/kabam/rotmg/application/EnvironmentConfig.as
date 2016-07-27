package kabam.rotmg.application
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import kabam.rotmg.application.model.DomainModel;
    import kabam.rotmg.application.model.PlatformModel;

    public class EnvironmentConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;


        public function configure():void
        {
            this.injector.map(PlatformModel).asSingleton();
            this.injector.map(DomainModel).asSingleton();
        }


    }
}

