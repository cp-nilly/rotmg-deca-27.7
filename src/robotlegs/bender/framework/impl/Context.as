package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.IContext;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.framework.api.ILifecycle;
    import org.hamcrest.Matcher;
    import robotlegs.bender.framework.api.ILogTarget;

    public class Context implements IContext 
    {

        private const _injector:Injector = new Injector();
        private const _uid:String = UID.create(Context);
        private const _logManager:LogManager = new LogManager();
        private const _pin:Pin = new Pin();

        private var _lifecycle:Lifecycle;
        private var _configManager:ConfigManager;
        private var _extensionInstaller:ExtensionInstaller;
        private var _logger:ILogger;

        public function Context()
        {
            this.setup();
        }

        public function get injector():Injector
        {
            return (this._injector);
        }

        public function get logLevel():uint
        {
            return (this._logManager.logLevel);
        }

        public function set logLevel(_arg1:uint):void
        {
            this._logManager.logLevel = _arg1;
        }

        public function get lifecycle():ILifecycle
        {
            return (this._lifecycle);
        }

        public function initialize():void
        {
            this._lifecycle.initialize();
        }

        public function destroy():void
        {
            this._lifecycle.destroy();
        }

        public function extend(... _args):IContext
        {
            var _local2:Object;
            for each (_local2 in _args)
            {
                this._extensionInstaller.install(_local2);
            };
            return (this);
        }

        public function configure(... _args):IContext
        {
            var _local2:Object;
            for each (_local2 in _args)
            {
                this._configManager.addConfig(_local2);
            };
            return (this);
        }

        public function addConfigHandler(_arg1:Matcher, _arg2:Function):IContext
        {
            this._configManager.addConfigHandler(_arg1, _arg2);
            return (this);
        }

        public function getLogger(_arg1:Object):ILogger
        {
            return (this._logManager.getLogger(_arg1));
        }

        public function addLogTarget(_arg1:ILogTarget):IContext
        {
            this._logManager.addLogTarget(_arg1);
            return (this);
        }

        public function detain(... _args):IContext
        {
            var _local2:Object;
            for each (_local2 in _args)
            {
                this._pin.detain(_local2);
            };
            return (this);
        }

        public function release(... _args):IContext
        {
            var _local2:Object;
            for each (_local2 in _args)
            {
                this._pin.release(_local2);
            };
            return (this);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function setup():void
        {
            this._injector.map(Injector).toValue(this._injector);
            this._injector.map(IContext).toValue(this);
            this._logger = this._logManager.getLogger(this);
            this._lifecycle = new Lifecycle(this);
            this._configManager = new ConfigManager(this);
            this._extensionInstaller = new ExtensionInstaller(this);
            this._lifecycle.beforeInitializing(this.beforeInitializing);
            this._lifecycle.afterInitializing(this.afterInitializing);
            this._lifecycle.beforeDestroying(this.beforeDestroying);
            this._lifecycle.afterDestroying(this.afterDestroying);
        }

        private function beforeInitializing():void
        {
            this._logger.info("Initializing...");
        }

        private function afterInitializing():void
        {
            this._logger.info("Initialize complete");
        }

        private function beforeDestroying():void
        {
            this._logger.info("Destroying...");
        }

        private function afterDestroying():void
        {
            this._pin.flush();
            this._injector.teardown();
            this._logger.info("Destroy complete");
        }


    }
}

