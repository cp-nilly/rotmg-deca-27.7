package org.osflash.signals
{
    import flash.utils.getQualifiedClassName;
    import flash.errors.IllegalOperationError;

    public class OnceSignal implements IOnceSignal 
    {

        protected var _valueClasses:Array;
        protected var slots:SlotList;

        public function OnceSignal(... _args)
        {
            this.slots = SlotList.NIL;
            super();
            this.valueClasses = (((((_args.length == 1)) && ((_args[0] is Array)))) ? _args[0] : _args);
        }

        [ArrayElementType("Class")]
        public function get valueClasses():Array
        {
            return (this._valueClasses);
        }

        public function set valueClasses(_arg1:Array):void
        {
            this._valueClasses = ((_arg1) ? _arg1.slice() : []);
            var _local2:int = this._valueClasses.length;
            while (_local2--)
            {
                if (!(this._valueClasses[_local2] is Class))
                {
                    throw (new ArgumentError((((((("Invalid valueClasses argument: " + "item at index ") + _local2) + " should be a Class but was:<") + this._valueClasses[_local2]) + ">.") + getQualifiedClassName(this._valueClasses[_local2]))));
                };
            };
        }

        public function get numListeners():uint
        {
            return (this.slots.length);
        }

        public function addOnce(_arg1:Function):ISlot
        {
            return (this.registerListener(_arg1, true));
        }

        public function remove(_arg1:Function):ISlot
        {
            var _local2:ISlot = this.slots.find(_arg1);
            if (!_local2)
            {
                return (null);
            };
            this.slots = this.slots.filterNot(_arg1);
            return (_local2);
        }

        public function removeAll():void
        {
            this.slots = SlotList.NIL;
        }

        public function dispatch(... _args):void
        {
            var _local2:int = this._valueClasses.length;
            var _local3:int = _args.length;
            if (_local3 < _local2)
            {
                throw (new ArgumentError(((((("Incorrect number of arguments. " + "Expected at least ") + _local2) + " but received ") + _local3) + ".")));
            };
            var _local4:int;
            while (_local4 < _local2)
            {
                if (!(((_args[_local4] is this._valueClasses[_local4])) || ((_args[_local4] === null))))
                {
                    throw (new ArgumentError((((("Value object <" + _args[_local4]) + "> is not an instance of <") + this._valueClasses[_local4]) + ">.")));
                };
                _local4++;
            };
            var _local5:SlotList = this.slots;
            if (_local5.nonEmpty)
            {
                while (_local5.nonEmpty)
                {
                    _local5.head.execute(_args);
                    _local5 = _local5.tail;
                };
            };
        }

        protected function registerListener(_arg1:Function, _arg2:Boolean=false):ISlot
        {
            var _local3:ISlot;
            if (this.registrationPossible(_arg1, _arg2))
            {
                _local3 = new Slot(_arg1, this, _arg2);
                this.slots = this.slots.prepend(_local3);
                return (_local3);
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
            if (!_local3)
            {
                return (true);
            };
            if (_local3.once != _arg2)
            {
                throw (new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first."));
            };
            return (false);
        }


    }
}

