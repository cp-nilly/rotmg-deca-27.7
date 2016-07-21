package robotlegs.bender.extensions.modularity.impl
{
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import org.swiftsuspenders.Injector;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.framework.api.IContext;

    public class ContextViewBasedExistenceWatcher 
    {

        private const _uid:String = UID.create(ContextViewBasedExistenceWatcher);

        private var _logger:ILogger;
        private var _injector:Injector;
        private var _contextView:DisplayObjectContainer;
        private var _childContext:IContext;

        public function ContextViewBasedExistenceWatcher(_arg1:IContext, _arg2:DisplayObjectContainer)
        {
            this._logger = _arg1.getLogger(this);
            this._injector = _arg1.injector;
            this._contextView = _arg2;
            _arg1.lifecycle.whenDestroying(this.destroy);
            this.init();
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function init():void
        {
            this._logger.debug("Listening for context existence events on contextView {0}", [this._contextView]);
            this._contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
        }

        private function destroy():void
        {
            this._logger.debug("Removing modular context existence event listener from contextView {0}", [this._contextView]);
            this._contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            if (this._childContext)
            {
                this._logger.debug("Unlinking parent injector for child context {0}", [this._childContext]);
                this._childContext.injector.parentInjector = null;
            };
        }

        private function onContextAdd(_arg1:ModularContextEvent):void
        {
            _arg1.stopImmediatePropagation();
            this._childContext = _arg1.context;
            this._logger.debug("Context existence event caught. Configuring child context {0}", [this._childContext]);
            this._childContext.injector.parentInjector = this._injector;
        }


    }
}

