package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class ContainerBinding extends EventDispatcher 
    {

        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

        private var _parent:ContainerBinding;
        private var _container:DisplayObjectContainer;

        public function ContainerBinding(_arg1:DisplayObjectContainer)
        {
            this._container = _arg1;
        }

        public function get parent():ContainerBinding
        {
            return (this._parent);
        }

        public function set parent(_arg1:ContainerBinding):void
        {
            this._parent = _arg1;
        }

        public function get container():DisplayObjectContainer
        {
            return (this._container);
        }

        public function get numHandlers():uint
        {
            return (this._handlers.length);
        }

        public function addHandler(_arg1:IViewHandler):void
        {
            if (this._handlers.indexOf(_arg1) > -1)
            {
                return;
            };
            this._handlers.push(_arg1);
        }

        public function removeHandler(_arg1:IViewHandler):void
        {
            var _local2:int = this._handlers.indexOf(_arg1);
            if (_local2 > -1)
            {
                this._handlers.splice(_local2, 1);
                if (this._handlers.length == 0)
                {
                    dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
                };
            };
        }

        public function handleView(_arg1:DisplayObject, _arg2:Class):void
        {
            var _local5:IViewHandler;
            var _local3:uint = this._handlers.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = (this._handlers[_local4] as IViewHandler);
                _local5.handleView(_arg1, _arg2);
                _local4++;
            };
        }


    }
}

