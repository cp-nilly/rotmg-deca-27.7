package robotlegs.bender.extensions.signalCommandMap.impl
{
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public class SignalCommandMap implements ISignalCommandMap 
    {

        private const _signalTriggers:Dictionary = new Dictionary();

        private var _injector:Injector;
        private var _commandMap:ICommandCenter;

        public function SignalCommandMap(_arg1:Injector, _arg2:ICommandCenter)
        {
            this._injector = _arg1;
            this._commandMap = _arg2;
        }

        public function map(_arg1:Class, _arg2:Boolean=false):ICommandMapper
        {
            var _local3:ICommandTrigger = (this._signalTriggers[_arg1] = ((this._signalTriggers[_arg1]) || (this.createSignalTrigger(_arg1, _arg2))));
            return (this._commandMap.map(_local3));
        }

        public function unmap(_arg1:Class):ICommandUnmapper
        {
            return (this._commandMap.unmap(this.getSignalTrigger(_arg1)));
        }

        private function createSignalTrigger(_arg1:Class, _arg2:Boolean=false):ICommandTrigger
        {
            return (new SignalCommandTrigger(this._injector, _arg1, _arg2));
        }

        private function getSignalTrigger(_arg1:Class):ICommandTrigger
        {
            return (this._signalTriggers[_arg1]);
        }


    }
}

