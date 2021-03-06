﻿package kabam.rotmg.application
{
    import flash.display.LoaderInfo;

    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.application.api.DebugSetup;
    import kabam.rotmg.application.impl.FixedIPSetup;
    import kabam.rotmg.application.impl.LocalhostSetup;
    import kabam.rotmg.application.impl.PrivateSetup;
    import kabam.rotmg.application.impl.ProductionSetup;
    import kabam.rotmg.application.impl.Testing2Setup;
    import kabam.rotmg.application.impl.TestingSetup;
    import kabam.rotmg.application.model.DomainModel;
    import kabam.rotmg.build.api.BuildData;
    import kabam.rotmg.build.api.BuildEnvironment;

    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;

    public class ApplicationConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var root:ContextView;
        [Inject]
        public var data:BuildData;
        [Inject]
        public var loaderInfo:LoaderInfo;
        [Inject]
        public var domainModel:DomainModel;

        public function configure():void
        {
            var _local1:ApplicationSetup = this.makeTestingSetup();
            this.injector.map(DebugSetup).toValue(_local1);
            this.injector.map(ApplicationSetup).toValue(_local1);
        }

        private function makeTestingSetup():ApplicationSetup
        {
            var _local1:BuildEnvironment = this.data.getEnvironment();
            switch (_local1)
            {
                case BuildEnvironment.LOCALHOST:
                    return (new LocalhostSetup());
                case BuildEnvironment.FIXED_IP:
                    return (this.makeFixedIPSetup());
                case BuildEnvironment.PRIVATE:
                    return (new PrivateSetup());
                case BuildEnvironment.TESTING:
                    return (new TestingSetup());
                case BuildEnvironment.TESTING2:
                    return (new Testing2Setup());
                default:
                    return (new ProductionSetup());
            }
        }

        private function makeFixedIPSetup():FixedIPSetup
        {
            return (new FixedIPSetup().setAddress(this.data.getEnvironmentString()));
        }
    }
}

