package kabam.rotmg.build
{
    import robotlegs.bender.framework.api.IConfig;
    import org.swiftsuspenders.Injector;
    import kabam.rotmg.build.impl.BuildEnvironments;
    import kabam.rotmg.build.api.BuildData;
    import kabam.rotmg.build.impl.CompileTimeBuildData;

    public class BuildConfig implements IConfig 
    {

        [Inject]
        public var injector:Injector;


        public function configure():void
        {
            this.injector.map(BuildEnvironments).asSingleton();
            this.injector.map(BuildData).toSingleton(CompileTimeBuildData);
        }


    }
}

