package org.osflash.signals
{
    public final class SlotList 
    {

        public static const NIL:SlotList = new (SlotList)(null, null);

        public var head:ISlot;
        public var tail:SlotList;
        public var nonEmpty:Boolean = false;

        public function SlotList(_arg1:ISlot, _arg2:SlotList=null)
        {
            if (((!(_arg1)) && (!(_arg2))))
            {
                if (NIL)
                {
                    throw (new ArgumentError("Parameters head and tail are null. Use the NIL element instead."));
                };
                this.nonEmpty = false;
            }
            else
            {
                if (!_arg1)
                {
                    throw (new ArgumentError("Parameter head cannot be null."));
                };
                this.head = _arg1;
                this.tail = ((_arg2) || (NIL));
                this.nonEmpty = true;
            };
        }

        public function get length():uint
        {
            if (!this.nonEmpty)
            {
                return (0);
            };
            if (this.tail == NIL)
            {
                return (1);
            };
            var _local1:uint;
            var _local2:SlotList = this;
            while (_local2.nonEmpty)
            {
                _local1++;
                _local2 = _local2.tail;
            };
            return (_local1);
        }

        public function prepend(_arg1:ISlot):SlotList
        {
            return (new SlotList(_arg1, this));
        }

        public function append(_arg1:ISlot):SlotList
        {
            if (!_arg1)
            {
                return (this);
            };
            if (!this.nonEmpty)
            {
                return (new SlotList(_arg1));
            };
            if (this.tail == NIL)
            {
                return (new SlotList(_arg1).prepend(this.head));
            };
            var _local2:SlotList = new SlotList(this.head);
            var _local3:SlotList = _local2;
            var _local4:SlotList = this.tail;
            while (_local4.nonEmpty)
            {
                _local3 = (_local3.tail = new SlotList(_local4.head));
                _local4 = _local4.tail;
            };
            _local3.tail = new SlotList(_arg1);
            return (_local2);
        }

        public function insertWithPriority(_arg1:ISlot):SlotList
        {
            if (!this.nonEmpty)
            {
                return (new SlotList(_arg1));
            };
            var _local2:int = _arg1.priority;
            if (_local2 > this.head.priority)
            {
                return (this.prepend(_arg1));
            };
            var _local3:SlotList = new SlotList(this.head);
            var _local4:SlotList = _local3;
            var _local5:SlotList = this.tail;
            while (_local5.nonEmpty)
            {
                if (_local2 > _local5.head.priority)
                {
                    _local4.tail = _local5.prepend(_arg1);
                    return (_local3);
                };
                _local4 = (_local4.tail = new SlotList(_local5.head));
                _local5 = _local5.tail;
            };
            _local4.tail = new SlotList(_arg1);
            return (_local3);
        }

        public function filterNot(_arg1:Function):SlotList
        {
            if (((!(this.nonEmpty)) || ((_arg1 == null))))
            {
                return (this);
            };
            if (_arg1 == this.head.listener)
            {
                return (this.tail);
            };
            var _local2:SlotList = new SlotList(this.head);
            var _local3:SlotList = _local2;
            var _local4:SlotList = this.tail;
            while (_local4.nonEmpty)
            {
                if (_local4.head.listener == _arg1)
                {
                    _local3.tail = _local4.tail;
                    return (_local2);
                };
                _local3 = (_local3.tail = new SlotList(_local4.head));
                _local4 = _local4.tail;
            };
            return (this);
        }

        public function contains(_arg1:Function):Boolean
        {
            if (!this.nonEmpty)
            {
                return (false);
            };
            var _local2:SlotList = this;
            while (_local2.nonEmpty)
            {
                if (_local2.head.listener == _arg1)
                {
                    return (true);
                };
                _local2 = _local2.tail;
            };
            return (false);
        }

        public function find(_arg1:Function):ISlot
        {
            if (!this.nonEmpty)
            {
                return (null);
            };
            var _local2:SlotList = this;
            while (_local2.nonEmpty)
            {
                if (_local2.head.listener == _arg1)
                {
                    return (_local2.head);
                };
                _local2 = _local2.tail;
            };
            return (null);
        }

        public function toString():String
        {
            var _local1 = "";
            var _local2:SlotList = this;
            while (_local2.nonEmpty)
            {
                _local1 = (_local1 + (_local2.head + " -> "));
                _local2 = _local2.tail;
            };
            _local1 = (_local1 + "NIL");
            return ((("[List " + _local1) + "]"));
        }


    }
}

