package robotlegs.bender.framework.impl
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.reflection.Reflector;
    import org.swiftsuspenders.reflection.DescribeTypeReflector;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogger;

    public class ExtensionInstaller 
    {

        private const _uid:String = UID.create(ExtensionInstaller);
        private const _classes:Dictionary = new Dictionary(true);
        private const _reflector:Reflector = new DescribeTypeReflector();

        private var _context:IContext;
        private var _logger:ILogger;

        public function ExtensionInstaller(_arg1:IContext)
        {
            this._context = _arg1;
            this._logger = this._context.getLogger(this);
        }

        public function install(_arg1:Object):void
        {
            var _local2:Class;
            if ((_arg1 is Class))
            {
                ((this._classes[_arg1]) || (this.install(new ((_arg1 as Class))())));
            }
            else
            {
                _local2 = this._reflector.getClass(_arg1);
                if (this._classes[_local2])
                {
                    return;
                };
                this._logger.debug("Installing extension {0}", [_arg1]);
                this._classes[_local2] = true;
                _arg1.extend(this._context);
            };
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}

