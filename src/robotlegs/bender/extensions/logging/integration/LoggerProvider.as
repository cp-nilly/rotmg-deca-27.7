package robotlegs.bender.extensions.logging.integration
{
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import robotlegs.bender.framework.api.IContext;
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class LoggerProvider implements DependencyProvider 
    {

        private var _context:IContext;

        public function LoggerProvider(_arg1:IContext)
        {
            this._context = _arg1;
        }

        public function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object
        {
            return (this._context.getLogger(_arg1));
        }

        public function destroy():void
        {
        }


    }
}

