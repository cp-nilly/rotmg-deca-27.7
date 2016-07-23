package kabam.rotmg.assets
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.assets.services.IconFactory;

    public class AssetsConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;


        public function configure():void
        {
            this.injector.map(CharacterFactory).asSingleton();
            this.injector.map(IconFactory).asSingleton();
        }


    }
}

