package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import __AS3__.vec.*;

    public class ViewManager extends EventDispatcher implements IViewManager 
    {

        private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

        private var _registry:ContainerRegistry;

        public function ViewManager(_arg1:ContainerRegistry)
        {
            this._registry = _arg1;
        }

        public function get containers():Vector.<DisplayObjectContainer>
        {
            return (this._containers);
        }

        public function addContainer(_arg1:DisplayObjectContainer):void
        {
            var _local2:IViewHandler;
            if (!this.validContainer(_arg1))
            {
                return;
            };
            this._containers.push(_arg1);
            for each (_local2 in this._handlers)
            {
                this._registry.addContainer(_arg1).addHandler(_local2);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD, _arg1));
        }

        public function removeContainer(_arg1:DisplayObjectContainer):void
        {
            var _local4:IViewHandler;
            var _local2:int = this._containers.indexOf(_arg1);
            if (_local2 == -1)
            {
                return;
            };
            this._containers.splice(_local2, 1);
            var _local3:ContainerBinding = this._registry.getBinding(_arg1);
            for each (_local4 in this._handlers)
            {
                _local3.removeHandler(_local4);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE, _arg1));
        }

        public function addViewHandler(_arg1:IViewHandler):void
        {
            var _local2:DisplayObjectContainer;
            if (this._handlers.indexOf(_arg1) != -1)
            {
                return;
            };
            this._handlers.push(_arg1);
            for each (_local2 in this._containers)
            {
                this._registry.addContainer(_local2).addHandler(_arg1);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD, null, _arg1));
        }

        public function removeViewHandler(_arg1:IViewHandler):void
        {
            var _local3:DisplayObjectContainer;
            var _local2:int = this._handlers.indexOf(_arg1);
            if (_local2 == -1)
            {
                return;
            };
            this._handlers.splice(_local2, 1);
            for each (_local3 in this._containers)
            {
                this._registry.getBinding(_local3).removeHandler(_arg1);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE, null, _arg1));
        }

        public function removeAllHandlers():void
        {
            var _local1:DisplayObjectContainer;
            var _local2:ContainerBinding;
            var _local3:IViewHandler;
            for each (_local1 in this._containers)
            {
                _local2 = this._registry.getBinding(_local1);
                for each (_local3 in this._handlers)
                {
                    _local2.removeHandler(_local3);
                };
            };
        }

        private function validContainer(_arg1:DisplayObjectContainer):Boolean
        {
            var _local2:DisplayObjectContainer;
            for each (_local2 in this._containers)
            {
                if (_arg1 == _local2)
                {
                    return (false);
                };
                if (((_local2.contains(_arg1)) || (_arg1.contains(_local2))))
                {
                    throw (new Error("Containers can not be nested"));
                };
            };
            return (true);
        }


    }
}

