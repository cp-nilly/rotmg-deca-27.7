package robotlegs.bender.extensions.localEventMap.impl
{
    import flash.events.IEventDispatcher;

    public class EventMapConfig 
    {

        private var _dispatcher:IEventDispatcher;
        private var _eventString:String;
        private var _listener:Function;
        private var _eventClass:Class;
        private var _callback:Function;
        private var _useCapture:Boolean;

        public function EventMapConfig(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class, _arg5:Function, _arg6:Boolean)
        {
            this._dispatcher = _arg1;
            this._eventString = _arg2;
            this._listener = _arg3;
            this._eventClass = _arg4;
            this._callback = _arg5;
            this._useCapture = _arg6;
        }

        public function get dispatcher():IEventDispatcher
        {
            return (this._dispatcher);
        }

        public function get eventString():String
        {
            return (this._eventString);
        }

        public function get listener():Function
        {
            return (this._listener);
        }

        public function get eventClass():Class
        {
            return (this._eventClass);
        }

        public function get callback():Function
        {
            return (this._callback);
        }

        public function get useCapture():Boolean
        {
            return (this._useCapture);
        }


    }
}

