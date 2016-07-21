package kabam.rotmg.application
{
    import robotlegs.bender.framework.api.IConfig;
    import org.swiftsuspenders.Injector;
    import kabam.rotmg.application.model.DomainModel;

    public class EnvironmentConfig implements IConfig 
    {

        [Inject]
        public var injector:Injector;


        public function configure():void
        {
            this.injector.map(DomainModel).asSingleton();
        }


    }
}

