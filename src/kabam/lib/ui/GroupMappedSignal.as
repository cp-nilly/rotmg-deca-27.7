package kabam.lib.ui
{
    import org.osflash.signals.Signal;
    import flash.utils.Dictionary;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public class GroupMappedSignal extends Signal 
    {

        private var eventType:String;
        private var mappedTargets:Dictionary;

        public function GroupMappedSignal(_arg1:String, ... _args)
        {
            this.eventType = _arg1;
            this.mappedTargets = new Dictionary(true);
            super(_args);
        }

        public function map(_arg1:IEventDispatcher, _arg2:*):void
        {
            this.mappedTargets[_arg1] = _arg2;
            _arg1.addEventListener(this.eventType, this.onTarget, false, 0, true);
        }

        private function onTarget(_arg1:Event):void
        {
            dispatch(this.mappedTargets[_arg1.target]);
        }


    }
}

