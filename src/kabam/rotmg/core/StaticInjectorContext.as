package kabam.rotmg.core
{
    import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.api.IInjector;

    public class StaticInjectorContext extends Context 
    {

        public static var injector:IInjector;

        public function StaticInjectorContext()
        {
            if (!StaticInjectorContext.injector)
            {
                StaticInjectorContext.injector = this.injector;
            };
        }

        public static function getInjector():IInjector
        {
            return (injector);
        }


    }
}

