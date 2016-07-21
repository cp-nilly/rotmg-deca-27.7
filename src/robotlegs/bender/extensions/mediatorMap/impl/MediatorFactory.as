package robotlegs.bender.extensions.mediatorMap.impl
{
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import __AS3__.vec.Vector;

    public class MediatorFactory extends EventDispatcher implements IMediatorFactory 
    {

        private const _mediators:Dictionary = new Dictionary();

        private var _injector:Injector;

        public function MediatorFactory(_arg1:Injector)
        {
            this._injector = _arg1;
        }

        public function getMediator(_arg1:Object, _arg2:IMediatorMapping):Object
        {
            return (((this._mediators[_arg1]) ? this._mediators[_arg1][_arg2] : null));
        }

        public function createMediators(_arg1:Object, _arg2:Class, _arg3:Array):Array
        {
            var _local5:ITypeFilter;
            var _local6:Object;
            var _local7:IMediatorMapping;
            var _local4:Array = [];
            for each (_local7 in _arg3)
            {
                _local6 = this.getMediator(_arg1, _local7);
                if (!_local6)
                {
                    _local5 = _local7.matcher;
                    this.mapTypeForFilterBinding(_local5, _arg2, _arg1);
                    _local6 = this.createMediator(_arg1, _local7);
                    this.unmapTypeForFilterBinding(_local5, _arg2, _arg1);
                };
                if (_local6)
                {
                    _local4.push(_local6);
                };
            };
            return (_local4);
        }

        public function removeMediators(_arg1:Object):void
        {
            var _local3:Object;
            var _local2:Dictionary = this._mediators[_arg1];
            if (!_local2)
            {
                return;
            };
            if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
            {
                for (_local3 in _local2)
                {
                    dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_REMOVE, _local2[_local3], _arg1, (_local3 as IMediatorMapping), this));
                };
            };
            delete this._mediators[_arg1];
        }

        public function removeAllMediators():void
        {
            var _local1:Object;
            for (_local1 in this._mediators)
            {
                this.removeMediators(_local1);
            };
        }

        private function createMediator(_arg1:Object, _arg2:IMediatorMapping):Object
        {
            var _local3:Object = this.getMediator(_arg1, _arg2);
            if (_local3)
            {
                return (_local3);
            };
            if (guardsApprove(_arg2.guards, this._injector))
            {
                _local3 = this._injector.getInstance(_arg2.mediatorClass);
                this._injector.map(_arg2.mediatorClass).toValue(_local3);
                applyHooks(_arg2.hooks, this._injector);
                this._injector.unmap(_arg2.mediatorClass);
                this.addMediator(_local3, _arg1, _arg2);
            };
            return (_local3);
        }

        private function addMediator(_arg1:Object, _arg2:Object, _arg3:IMediatorMapping):void
        {
            this._mediators[_arg2] = ((this._mediators[_arg2]) || (new Dictionary()));
            this._mediators[_arg2][_arg3] = _arg1;
            if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
            {
                dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_CREATE, _arg1, _arg2, _arg3, this));
            };
        }

        private function mapTypeForFilterBinding(_arg1:ITypeFilter, _arg2:Class, _arg3:Object):void
        {
            var _local4:Class;
            var _local5:Vector.<Class> = this.requiredTypesFor(_arg1, _arg2);
            for each (_local4 in _local5)
            {
                this._injector.map(_local4).toValue(_arg3);
            };
        }

        private function unmapTypeForFilterBinding(_arg1:ITypeFilter, _arg2:Class, _arg3:Object):void
        {
            var _local4:Class;
            var _local5:Vector.<Class> = this.requiredTypesFor(_arg1, _arg2);
            for each (_local4 in _local5)
            {
                if (this._injector.satisfiesDirectly(_local4))
                {
                    this._injector.unmap(_local4);
                };
            };
        }

        private function requiredTypesFor(_arg1:ITypeFilter, _arg2:Class):Vector.<Class>
        {
            var _local3:Vector.<Class> = _arg1.allOfTypes.concat(_arg1.anyOfTypes);
            if (_local3.indexOf(_arg2) == -1)
            {
                _local3.push(_arg2);
            };
            return (_local3);
        }


    }
}

