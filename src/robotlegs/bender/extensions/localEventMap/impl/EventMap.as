package robotlegs.bender.extensions.localEventMap.impl
{
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import __AS3__.vec.Vector;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class EventMap implements IEventMap 
    {

        private const _listeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
        private const _suspendedListeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();

        private var _eventDispatcher:IEventDispatcher;
        private var _suspended:Boolean = false;

        public function EventMap(_arg1:IEventDispatcher)
        {
            this._eventDispatcher = _arg1;
        }

        public function mapListener(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class=null, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
        {
            var eventConfig:EventMapConfig;
            var callback:Function;
            eventClass = ((eventClass) || (Event));
            var currentListeners:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            var i:int = currentListeners.length;
            while ((i = (i - 1)), i)
            {
                eventConfig = currentListeners[i];
                if ((((((((((eventConfig.dispatcher == dispatcher)) && ((eventConfig.eventString == eventString)))) && ((eventConfig.listener == listener)))) && ((eventConfig.useCapture == useCapture)))) && ((eventConfig.eventClass == eventClass))))
                {
                    return;
                };
            };
            if (eventClass != Event)
            {
                callback = function (_arg1:Event):void
                {
                    routeEventToListener(_arg1, listener, eventClass);
                };
            }
            else
            {
                callback = listener;
            };
            eventConfig = new EventMapConfig(dispatcher, eventString, listener, eventClass, callback, useCapture);
            currentListeners.push(eventConfig);
            if (!this._suspended)
            {
                dispatcher.addEventListener(eventString, callback, useCapture, priority, useWeakReference);
            };
        }

        public function unmapListener(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class=null, _arg5:Boolean=false):void
        {
            var _local6:EventMapConfig;
            _arg4 = ((_arg4) || (Event));
            var _local7:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            var _local8:int = _local7.length;
            while (_local8--)
            {
                _local6 = _local7[_local8];
                if ((((((((((_local6.dispatcher == _arg1)) && ((_local6.eventString == _arg2)))) && ((_local6.listener == _arg3)))) && ((_local6.useCapture == _arg5)))) && ((_local6.eventClass == _arg4))))
                {
                    if (!this._suspended)
                    {
                        _arg1.removeEventListener(_arg2, _local6.callback, _arg5);
                    };
                    _local7.splice(_local8, 1);
                    return;
                };
            };
        }

        public function unmapListeners():void
        {
            var _local2:EventMapConfig;
            var _local3:IEventDispatcher;
            var _local1:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            while ((_local2 = _local1.pop()))
            {
                if (!this._suspended)
                {
                    _local3 = _local2.dispatcher;
                    _local3.removeEventListener(_local2.eventString, _local2.callback, _local2.useCapture);
                };
            };
        }

        public function suspend():void
        {
            var _local1:EventMapConfig;
            var _local2:IEventDispatcher;
            if (this._suspended)
            {
                return;
            };
            this._suspended = true;
            while ((_local1 = this._listeners.pop()))
            {
                _local2 = _local1.dispatcher;
                _local2.removeEventListener(_local1.eventString, _local1.callback, _local1.useCapture);
                this._suspendedListeners.push(_local1);
            };
        }

        public function resume():void
        {
            var _local1:EventMapConfig;
            var _local2:IEventDispatcher;
            if (!this._suspended)
            {
                return;
            };
            this._suspended = false;
            while ((_local1 = this._suspendedListeners.pop()))
            {
                _local2 = _local1.dispatcher;
                _local2.addEventListener(_local1.eventString, _local1.callback, _local1.useCapture);
                this._listeners.push(_local1);
            };
        }

        private function routeEventToListener(_arg1:Event, _arg2:Function, _arg3:Class):void
        {
            if ((_arg1 is _arg3))
            {
                (_arg2(_arg1));
            };
        }


    }
}

