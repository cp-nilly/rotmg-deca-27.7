package robotlegs.bender.extensions.viewManager.impl
{
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;

    public class ManualStageObserver 
    {

        private var _registry:ContainerRegistry;

        public function ManualStageObserver(_arg1:ContainerRegistry)
        {
            var _local2:ContainerBinding;
            super();
            this._registry = _arg1;
            this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD, this.onContainerAdd);
            this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, this.onContainerRemove);
            for each (_local2 in this._registry.bindings)
            {
                this.addContainerListener(_local2.container);
            };
        }

        public function destroy():void
        {
            var _local1:ContainerBinding;
            this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD, this.onContainerAdd);
            this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, this.onContainerRemove);
            for each (_local1 in this._registry.bindings)
            {
                this.removeContainerListener(_local1.container);
            };
        }

        private function onContainerAdd(_arg1:ContainerRegistryEvent):void
        {
            this.addContainerListener(_arg1.container);
        }

        private function onContainerRemove(_arg1:ContainerRegistryEvent):void
        {
            this.removeContainerListener(_arg1.container);
        }

        private function addContainerListener(_arg1:DisplayObjectContainer):void
        {
            _arg1.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, this.onConfigureView);
        }

        private function removeContainerListener(_arg1:DisplayObjectContainer):void
        {
            _arg1.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW, this.onConfigureView);
        }

        private function onConfigureView(_arg1:ConfigureViewEvent):void
        {
            var _local3:DisplayObject;
            _arg1.stopImmediatePropagation();
            var _local2:DisplayObjectContainer = (_arg1.currentTarget as DisplayObjectContainer);
            _local3 = (_arg1.target as DisplayObject);
            var _local4:Class = _local3["constructor"];
            this._registry.getBinding(_local2).handleView(_local3, _local4);
        }


    }
}

