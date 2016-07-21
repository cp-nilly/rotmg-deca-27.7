package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class ContainerRegistry extends EventDispatcher 
    {

        private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
        private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
        private const _bindingByContainer:Dictionary = new Dictionary();


        public function get bindings():Vector.<ContainerBinding>
        {
            return (this._bindings);
        }

        public function get rootBindings():Vector.<ContainerBinding>
        {
            return (this._rootBindings);
        }

        public function addContainer(_arg1:DisplayObjectContainer):ContainerBinding
        {
            return ((this._bindingByContainer[_arg1] = ((this._bindingByContainer[_arg1]) || (this.createBinding(_arg1)))));
        }

        public function removeContainer(_arg1:DisplayObjectContainer):ContainerBinding
        {
            var _local2:ContainerBinding = this._bindingByContainer[_arg1];
            ((_local2) && (this.removeBinding(_local2)));
            return (_local2);
        }

        public function findParentBinding(_arg1:DisplayObject):ContainerBinding
        {
            var _local3:ContainerBinding;
            var _local2:DisplayObjectContainer = _arg1.parent;
            while (_local2)
            {
                _local3 = this._bindingByContainer[_local2];
                if (_local3)
                {
                    return (_local3);
                };
                _local2 = _local2.parent;
            };
            return (null);
        }

        public function getBinding(_arg1:DisplayObjectContainer):ContainerBinding
        {
            return (this._bindingByContainer[_arg1]);
        }

        private function createBinding(_arg1:DisplayObjectContainer):ContainerBinding
        {
            var _local3:ContainerBinding;
            var _local2:ContainerBinding = new ContainerBinding(_arg1);
            this._bindings.push(_local2);
            _local2.addEventListener(ContainerBindingEvent.BINDING_EMPTY, this.onBindingEmpty);
            _local2.parent = this.findParentBinding(_arg1);
            if (_local2.parent == null)
            {
                this.addRootBinding(_local2);
            };
            for each (_local3 in this._bindingByContainer)
            {
                if (_arg1.contains(_local3.container))
                {
                    if (!_local3.parent)
                    {
                        this.removeRootBinding(_local3);
                        _local3.parent = _local2;
                    }
                    else
                    {
                        if (!_arg1.contains(_local3.parent.container))
                        {
                            _local3.parent = _local2;
                        };
                    };
                };
            };
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD, _local2.container));
            return (_local2);
        }

        private function removeBinding(_arg1:ContainerBinding):void
        {
            var _local3:ContainerBinding;
            delete this._bindingByContainer[_arg1.container];
            var _local2:int = this._bindings.indexOf(_arg1);
            this._bindings.splice(_local2, 1);
            _arg1.removeEventListener(ContainerBindingEvent.BINDING_EMPTY, this.onBindingEmpty);
            if (!_arg1.parent)
            {
                this.removeRootBinding(_arg1);
            };
            for each (_local3 in this._bindingByContainer)
            {
                if (_local3.parent == _arg1)
                {
                    _local3.parent = _arg1.parent;
                    if (!_local3.parent)
                    {
                        this.addRootBinding(_local3);
                    };
                };
            };
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE, _arg1.container));
        }

        private function addRootBinding(_arg1:ContainerBinding):void
        {
            this._rootBindings.push(_arg1);
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD, _arg1.container));
        }

        private function removeRootBinding(_arg1:ContainerBinding):void
        {
            var _local2:int = this._rootBindings.indexOf(_arg1);
            this._rootBindings.splice(_local2, 1);
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, _arg1.container));
        }

        private function onBindingEmpty(_arg1:ContainerBindingEvent):void
        {
            this.removeBinding((_arg1.target as ContainerBinding));
        }


    }
}

