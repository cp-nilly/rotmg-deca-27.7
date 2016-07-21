package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;

    public class StageObserver 
    {

        private const _filter:RegExp = /^mx\.|^spark\.|^flash\./;

        private var _registry:ContainerRegistry;

        public function StageObserver(_arg1:ContainerRegistry)
        {
            var _local2:ContainerBinding;
            super();
            this._registry = _arg1;
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, this.onRootContainerAdd);
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, this.onRootContainerRemove);
            for each (_local2 in this._registry.rootBindings)
            {
                this.addRootListener(_local2.container);
            };
        }

        public function destroy():void
        {
            var _local1:ContainerBinding;
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, this.onRootContainerAdd);
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, this.onRootContainerRemove);
            for each (_local1 in this._registry.rootBindings)
            {
                this.removeRootListener(_local1.container);
            };
        }

        private function onRootContainerAdd(_arg1:ContainerRegistryEvent):void
        {
            this.addRootListener(_arg1.container);
        }

        private function onRootContainerRemove(_arg1:ContainerRegistryEvent):void
        {
            this.removeRootListener(_arg1.container);
        }

        private function addRootListener(_arg1:DisplayObjectContainer):void
        {
            _arg1.addEventListener(Event.ADDED_TO_STAGE, this.onViewAddedToStage, true);
            _arg1.addEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
        }

        private function removeRootListener(_arg1:DisplayObjectContainer):void
        {
            _arg1.removeEventListener(Event.ADDED_TO_STAGE, this.onViewAddedToStage, true);
            _arg1.removeEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
        }

        private function onViewAddedToStage(_arg1:Event):void
        {
            var _local2:DisplayObject;
            var _local3:String;
            _local2 = (_arg1.target as DisplayObject);
            _local3 = getQualifiedClassName(_local2);
            var _local4:Boolean = this._filter.test(_local3);
            if (_local4)
            {
                return;
            };
            var _local5:Class = _local2["constructor"];
            var _local6:ContainerBinding = this._registry.findParentBinding(_local2);
            while (_local6)
            {
                _local6.handleView(_local2, _local5);
                _local6 = _local6.parent;
            };
        }

        private function onContainerRootAddedToStage(_arg1:Event):void
        {
            var _local2:DisplayObjectContainer;
            _local2 = (_arg1.target as DisplayObjectContainer);
            _local2.removeEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
            var _local3:Class = _local2["constructor"];
            var _local4:ContainerBinding = this._registry.getBinding(_local2);
            _local4.handleView(_local2, _local3);
        }


    }
}

