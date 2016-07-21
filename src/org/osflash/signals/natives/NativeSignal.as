package org.osflash.signals.natives
{
    import flash.events.IEventDispatcher;
    import org.osflash.signals.SlotList;
    import flash.events.Event;
    import org.osflash.signals.ISlot;
    import org.osflash.signals.Slot;
    import flash.errors.IllegalOperationError;

    public class NativeSignal implements INativeDispatcher 
    {

        protected var _target:IEventDispatcher;
        protected var _eventType:String;
        protected var _eventClass:Class;
        protected var _valueClasses:Array;
        protected var slots:SlotList;

        public function NativeSignal(_arg1:IEventDispatcher=null, _arg2:String="", _arg3:Class=null)
        {
            this.slots = SlotList.NIL;
            this.target = _arg1;
            this.eventType = _arg2;
            this.eventClass = _arg3;
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
            this._valueClasses = [this._eventClass];
        }

        [ArrayElementType("Class")]
        public function get valueClasses():Array
        {
            return (this._valueClasses);
        }

        public function set valueClasses(_arg1:Array):void
        {
            this.eventClass = ((((_arg1) && ((_arg1.length > 0)))) ? _arg1[0] : null);
        }

        public function get numListeners():uint
        {
            return (this.slots.length);
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

        public function add(_arg1:Function):ISlot
        {
            return (this.addWithPriority(_arg1));
        }

        public function addWithPriority(_arg1:Function, _arg2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg1, false, _arg2));
        }

        public function addOnce(_arg1:Function):ISlot
        {
            return (this.addOnceWithPriority(_arg1));
        }

        public function addOnceWithPriority(_arg1:Function, _arg2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg1, true, _arg2));
        }

        public function remove(_arg1:Function):ISlot
        {
            var _local2:ISlot = this.slots.find(_arg1);
            if (!_local2)
            {
                return (null);
            };
            this._target.removeEventListener(this._eventType, _local2.execute1);
            this.slots = this.slots.filterNot(_arg1);
            return (_local2);
        }

        public function removeAll():void
        {
            var _local1:SlotList = this.slots;
            while (_local1.nonEmpty)
            {
                this.target.removeEventListener(this._eventType, _local1.head.execute1);
                _local1 = _local1.tail;
            };
            this.slots = SlotList.NIL;
        }

        public function dispatch(... _args):void
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

        protected function registerListenerWithPriority(_arg1:Function, _arg2:Boolean=false, _arg3:int=0):ISlot
        {
            var _local4:ISlot;
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            if (this.registrationPossible(_arg1, _arg2))
            {
                _local4 = new Slot(_arg1, this, _arg2, _arg3);
                this.slots = this.slots.prepend(_local4);
                this._target.addEventListener(this._eventType, _local4.execute1, false, _arg3);
                return (_local4);
            };
            return (this.slots.find(_arg1));
        }

        protected function registrationPossible(_arg1:Function, _arg2:Boolean):Boolean
        {
            if (!this.slots.nonEmpty)
            {
                return (true);
            };
            var _local3:ISlot = this.slots.find(_arg1);
            if (_local3)
            {
                if (_local3.once != _arg2)
                {
                    throw (new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first."));
                };
                return (false);
            };
            return (true);
        }


    }
}

