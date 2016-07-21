package org.osflash.signals.natives
{
    import org.osflash.signals.Signal;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import org.osflash.signals.ISlot;
    import org.osflash.signals.SlotList;
    import org.osflash.signals.Slot;

    public class NativeRelaySignal extends Signal implements INativeDispatcher 
    {

        protected var _target:IEventDispatcher;
        protected var _eventType:String;
        protected var _eventClass:Class;

        public function NativeRelaySignal(_arg1:IEventDispatcher, _arg2:String, _arg3:Class=null)
        {
            super(((_arg3) || (Event)));
            this.eventType = _arg2;
            this.eventClass = _arg3;
            this.target = _arg1;
        }

        public function get target():IEventDispatcher
        {
            return (this._target);
        }

        public function set target(_arg1:IEventDispatcher):void
        {
            if (_arg1 == this._target)
            {
                return;
            };
            if (this._target)
            {
                this.removeAll();
            };
            this._target = _arg1;
        }

        public function get eventType():String
        {
            return (this._eventType);
        }

        public function set eventType(_arg1:String):void
        {
            this._eventType = _arg1;
        }

        public function get eventClass():Class
        {
            return (this._eventClass);
        }

        public function set eventClass(_arg1:Class):void
        {
            this._eventClass = ((_arg1) || (Event));
            _valueClasses = [this._eventClass];
        }

        override public function set valueClasses(_arg1:Array):void
        {
            this.eventClass = ((((_arg1) && ((_arg1.length > 0)))) ? _arg1[0] : null);
        }

        override public function add(_arg1:Function):ISlot
        {
            return (this.addWithPriority(_arg1));
        }

        override public function addOnce(_arg1:Function):ISlot
        {
            return (this.addOnceWithPriority(_arg1));
        }

        public function addWithPriority(_arg1:Function, _arg2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg1, false, _arg2));
        }

        public function addOnceWithPriority(_arg1:Function, _arg2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg1, true, _arg2));
        }

        override public function remove(_arg1:Function):ISlot
        {
            var _local2:Boolean = slots.nonEmpty;
            var _local3:ISlot = super.remove(_arg1);
            if (_local2 != slots.nonEmpty)
            {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            };
            return (_local3);
        }

        override public function removeAll():void
        {
            if (this.target)
            {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            };
            super.removeAll();
        }

        override public function dispatch(... _args):void
        {
            if (null == _args)
            {
                throw (new ArgumentError("Event object expected."));
            };
            if (_args.length != 1)
            {
                throw (new ArgumentError("No more than one Event object expected."));
            };
            this.dispatchEvent((_args[0] as Event));
        }

        public function dispatchEvent(_arg1:Event):Boolean
        {
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            if (!_arg1)
            {
                throw (new ArgumentError("Event object cannot be null."));
            };
            if (!(_arg1 is this.eventClass))
            {
                throw (new ArgumentError((((("Event object " + _arg1) + " is not an instance of ") + this.eventClass) + ".")));
            };
            if (_arg1.type != this.eventType)
            {
                throw (new ArgumentError((((("Event object has incorrect type. Expected <" + this.eventType) + "> but was <") + _arg1.type) + ">.")));
            };
            return (this.target.dispatchEvent(_arg1));
        }

        protected function onNativeEvent(_arg1:Event):void
        {
            var _local2:SlotList = slots;
            while (_local2.nonEmpty)
            {
                _local2.head.execute1(_arg1);
                _local2 = _local2.tail;
            };
        }

        protected function registerListenerWithPriority(_arg1:Function, _arg2:Boolean=false, _arg3:int=0):ISlot
        {
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            var _local4:Boolean = slots.nonEmpty;
            var _local5:ISlot;
            if (registrationPossible(_arg1, _arg2))
            {
                _local5 = new Slot(_arg1, this, _arg2, _arg3);
                slots = slots.insertWithPriority(_local5);
            }
            else
            {
                _local5 = slots.find(_arg1);
            };
            if (_local4 != slots.nonEmpty)
            {
                this.target.addEventListener(this.eventType, this.onNativeEvent, false, _arg3);
            };
            return (_local5);
        }


    }
}

