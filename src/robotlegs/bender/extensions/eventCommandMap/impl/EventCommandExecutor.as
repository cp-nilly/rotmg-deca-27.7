package robotlegs.bender.extensions.eventCommandMap.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
    import org.swiftsuspenders.Injector;
    import flash.events.Event;

    public class EventCommandExecutor 
    {

        private var _trigger:ICommandTrigger;
        private var _mappings:Vector.<ICommandMapping>;
        private var _mappingList:CommandMappingList;
        private var _injector:Injector;
        private var _eventClass:Class;
        private var _factory:EventCommandFactory;

        public function EventCommandExecutor(_arg1:ICommandTrigger, _arg2:CommandMappingList, _arg3:Injector, _arg4:Class)
        {
            this._trigger = _arg1;
            this._mappingList = _arg2;
            this._injector = _arg3.createChildInjector();
            this._eventClass = _arg4;
            this._factory = new EventCommandFactory(this._injector);
        }

        public function execute(_arg1:Event):void
        {
            var _local2:Class = (_arg1["constructor"] as Class);
            if (this.isTriggerEvent(_local2))
            {
                this.runCommands(_arg1, _local2);
            };
        }

        private function isTriggerEvent(_arg1:Class):Boolean
        {
            return (((!(this._eventClass)) || ((_arg1 == this._eventClass))));
        }

        private function isStronglyTyped(_arg1:Class):Boolean
        {
            return (!((_arg1 == Event)));
        }

        private function mapEventForInjection(_arg1:Event, _arg2:Class):void
        {
            this._injector.map(Event).toValue(_arg1);
            if (this.isStronglyTyped(_arg2))
            {
                this._injector.map(((this._eventClass) || (_arg2))).toValue(_arg1);
            };
        }

        private function unmapEventAfterInjection(_arg1:Class):void
        {
            this._injector.unmap(Event);
            if (this.isStronglyTyped(_arg1))
            {
                this._injector.unmap(((this._eventClass) || (_arg1)));
            };
        }

        private function runCommands(_arg1:Event, _arg2:Class):void
        {
            var _local3:Object;
            var _local4:ICommandMapping = this._mappingList.head;
            while (_local4)
            {
                _local4.validate();
                this.mapEventForInjection(_arg1, _arg2);
                _local3 = this._factory.create(_local4);
                this.unmapEventAfterInjection(_arg2);
                if (_local3)
                {
                    this.removeFireOnceMapping(_local4);
                    _local3.execute();
                };
                _local4 = _local4.next;
            };
        }

        private function removeFireOnceMapping(_arg1:ICommandMapping):void
        {
            if (_arg1.fireOnce)
            {
                this._trigger.removeMapping(_arg1);
            };
        }


    }
}

