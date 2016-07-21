package robotlegs.bender.extensions.modularity.impl
{
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.framework.api.IContext;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;

    public class ViewManagerBasedExistenceWatcher 
    {

        private const _uid:String = UID.create(ViewManagerBasedExistenceWatcher);

        private var _logger:ILogger;
        private var _injector:Injector;
        private var _viewManager:IViewManager;
        private var _childContext:IContext;

        public function ViewManagerBasedExistenceWatcher(_arg1:IContext, _arg2:IViewManager)
        {
            this._logger = _arg1.getLogger(this);
            this._injector = _arg1.injector;
            this._viewManager = _arg2;
            _arg1.lifecycle.whenDestroying(this.destroy);
            this.init();
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function init():void
        {
            var _local1:DisplayObjectContainer;
            for each (_local1 in this._viewManager.containers)
            {
                this._logger.debug("Adding context existence event listener to container {0}", [_local1]);
                _local1.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            };
            this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdd);
            this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemove);
        }

        private function destroy():void
        {
            var _local1:DisplayObjectContainer;
            for each (_local1 in this._viewManager.containers)
            {
                this._logger.debug("Removing context existence event listener from container {0}", [_local1]);
                _local1.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            };
            this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdd);
            this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemove);
            if (this._childContext)
            {
                this._logger.debug("Unlinking parent injector for child context {0}", [this._childContext]);
                this._childContext.injector.parentInjector = null;
            };
        }

        private function onContainerAdd(_arg1:ViewManagerEvent):void
        {
            this._logger.debug("Adding context existence event listener to container {0}", [_arg1.container]);
            _arg1.container.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
        }

        private function onContainerRemove(_arg1:ViewManagerEvent):void
        {
            this._logger.debug("Removing context existence event listener from container {0}", [_arg1.container]);
            _arg1.container.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
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

