package kabam.rotmg.core
{
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.impl.Context;

    public class StaticInjectorContext extends Context
    {
        public static var injector:IInjector;

        public function StaticInjectorContext()
        {
            if (!StaticInjectorContext.injector)
            {
                StaticInjectorContext.injector = this.injector;
            }
        }

        public static function getInjector():IInjector
        {
            return (injector);
        }
    }
}

