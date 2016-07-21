package robotlegs.bender.extensions.eventCommandMap.impl
{
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import flash.events.IEventDispatcher;
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public class EventCommandMap implements IEventCommandMap 
    {

        private const _triggers:Dictionary = new Dictionary();

        private var _injector:Injector;
        private var _dispatcher:IEventDispatcher;
        private var _commandCenter:ICommandCenter;

        public function EventCommandMap(_arg1:Injector, _arg2:IEventDispatcher, _arg3:ICommandCenter)
        {
            this._injector = _arg1;
            this._dispatcher = _arg2;
            this._commandCenter = _arg3;
        }

        public function map(_arg1:String, _arg2:Class=null):ICommandMapper
        {
            var _local3:ICommandTrigger = (this._triggers[(_arg1 + _arg2)] = ((this._triggers[(_arg1 + _arg2)]) || (this.createTrigger(_arg1, _arg2))));
            return (this._commandCenter.map(_local3));
        }

        public function unmap(_arg1:String, _arg2:Class=null):ICommandUnmapper
        {
            return (this._commandCenter.unmap(this.getTrigger(_arg1, _arg2)));
        }

        private function createTrigger(_arg1:String, _arg2:Class=null):ICommandTrigger
        {
            return (new EventCommandTrigger(this._injector, this._dispatcher, _arg1, _arg2));
        }

        private function getTrigger(_arg1:String, _arg2:Class=null):ICommandTrigger
        {
            return (this._triggers[(_arg1 + _arg2)]);
        }


    }
}

