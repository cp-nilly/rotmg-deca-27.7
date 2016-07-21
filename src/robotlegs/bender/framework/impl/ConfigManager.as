package robotlegs.bender.framework.impl
{
    import org.hamcrest.Matcher;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.core.not;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.framework.api.LifecycleEvent;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IConfig;

    public class ConfigManager 
    {

        private static const plainObjectMatcher:Matcher = allOf(instanceOf(Object), not(instanceOf(Class)), not(instanceOf(DisplayObject)));

        private const _uid:String = UID.create(ConfigManager);
        private const _objectProcessor:ObjectProcessor = new ObjectProcessor();
        private const _configs:Dictionary = new Dictionary();
        private const _queue:Array = [];

        private var _injector:Injector;
        private var _logger:ILogger;
        private var _initialized:Boolean;

        public function ConfigManager(_arg1:IContext)
        {
            this._injector = _arg1.injector;
            this._logger = _arg1.getLogger(this);
            this.addConfigHandler(instanceOf(Class), this.handleClass);
            this.addConfigHandler(plainObjectMatcher, this.handleObject);
            _arg1.lifecycle.addEventListener(LifecycleEvent.INITIALIZE, this.initialize, false, -100);
        }

        public function addConfig(_arg1:Object):void
        {
            if (!this._configs[_arg1])
            {
                this._configs[_arg1] = true;
                this._objectProcessor.processObject(_arg1);
            };
        }

        public function addConfigHandler(_arg1:Matcher, _arg2:Function):void
        {
            this._objectProcessor.addObjectHandler(_arg1, _arg2);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function initialize(_arg1:LifecycleEvent):void
        {
            if (!this._initialized)
            {
                this._initialized = true;
                this.processQueue();
            };
        }

        private function handleClass(_arg1:Class):void
        {
            if (this._initialized)
            {
                this._logger.debug("Already initialized. Instantiating config class {0}", [_arg1]);
                this.processClass(_arg1);
            }
            else
            {
                this._logger.debug("Not yet initialized. Queuing config class {0}", [_arg1]);
                this._queue.push(_arg1);
            };
        }

        private function handleObject(_arg1:Object):void
        {
            if (this._initialized)
            {
                this._logger.debug("Already initialized. Injecting into config object {0}", [_arg1]);
                this.processObject(_arg1);
            }
            else
            {
                this._logger.debug("Not yet initialized. Queuing config object {0}", [_arg1]);
                this._queue.push(_arg1);
            };
        }

        private function processQueue():void
        {
            var _local1:Object;
            for each (_local1 in this._queue)
            {
                if ((_local1 is Class))
                {
                    this._logger.debug("Now initializing. Instantiating config class {0}", [_local1]);
                    this.processClass((_local1 as Class));
                }
                else
                {
                    this._logger.debug("Now initializing. Injecting into config object {0}", [_local1]);
                    this.processObject(_local1);
                };
            };
            this._queue.length = 0;
        }

        private function processClass(_arg1:Class):void
        {
            var _local2:IConfig = (this._injector.getInstance(_arg1) as IConfig);
            ((_local2) && (_local2.configure()));
        }

        private function processObject(_arg1:Object):void
        {
            this._injector.injectInto(_arg1);
            var _local2:IConfig = (_arg1 as IConfig);
            ((_local2) && (_local2.configure()));
        }


    }
}

