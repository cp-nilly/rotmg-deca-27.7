package kabam.rotmg.assets
{
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.assets.services.IconFactory;

    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;

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

