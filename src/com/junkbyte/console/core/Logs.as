package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.Log;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import com.junkbyte.console.Console;

    public class Logs extends ConsoleCore 
    {

        private var _channels:Object;
        private var _repeating:uint;
        private var _lastRepeat:Log;
        private var _newRepeat:Log;
        private var _hasNewLog:Boolean;
        private var _timer:uint;
        public var first:Log;
        public var last:Log;
        private var _length:uint;
        private var _lines:uint;

        public function Logs(console:Console)
        {
            super(console);
            this._channels = new Object();
            remoter.addEventListener(Event.CONNECT, this.onRemoteConnection);
            remoter.registerCallback("log", function (_arg1:ByteArray):void
            {
                registerLog(Log.FromBytes(_arg1));
            });
        }

        private function onRemoteConnection(_arg1:Event):void
        {
            var _local2:Log = this.first;
            while (_local2)
            {
                this.send2Remote(_local2);
                _local2 = _local2.next;
            };
        }

        private function send2Remote(_arg1:Log):void
        {
            var _local2:ByteArray;
            if (remoter.canSend)
            {
                _local2 = new ByteArray();
                _arg1.toBytes(_local2);
                remoter.send("log", _local2);
            };
        }

        public function update(_arg1:uint):Boolean
        {
            this._timer = _arg1;
            if (this._repeating > 0)
            {
                this._repeating--;
            };
            if (this._newRepeat)
            {
                if (this._lastRepeat)
                {
                    this.remove(this._lastRepeat);
                };
                this._lastRepeat = this._newRepeat;
                this._newRepeat = null;
                this.push(this._lastRepeat);
            };
            var _local2:Boolean = this._hasNewLog;
            this._hasNewLog = false;
            return (_local2);
        }

        public function add(_arg1:Log):void
        {
            this._lines++;
            _arg1.line = this._lines;
            _arg1.time = this._timer;
            this.registerLog(_arg1);
        }

        private function registerLog(_arg1:Log):void
        {
            this._hasNewLog = true;
            this.addChannel(_arg1.ch);
            _arg1.lineStr = (_arg1.line + " ");
            _arg1.chStr = (((('[<a href="event:channel_' + _arg1.ch) + '">') + _arg1.ch) + "</a>] ");
            _arg1.timeStr = (config.timeStampFormatter(_arg1.time) + " ");
            this.send2Remote(_arg1);
            if (_arg1.repeat)
            {
                if ((((this._repeating > 0)) && (this._lastRepeat)))
                {
                    _arg1.line = this._lastRepeat.line;
                    this._newRepeat = _arg1;
                    return;
                };
                this._repeating = config.maxRepeats;
                this._lastRepeat = _arg1;
            };
            this.push(_arg1);
            while ((((this._length > config.maxLines)) && ((config.maxLines > 0))))
            {
                this.remove(this.first);
            };
            if (((config.tracing) && (!((config.traceCall == null)))))
            {
                config.traceCall(_arg1.ch, _arg1.plainText(), _arg1.priority);
            };
        }

        public function clear(_arg1:String=null):void
        {
            var _local2:Log;
            if (_arg1)
            {
                _local2 = this.first;
                while (_local2)
                {
                    if (_local2.ch == _arg1)
                    {
                        this.remove(_local2);
                    };
                    _local2 = _local2.next;
                };
                delete this._channels[_arg1];
            }
            else
            {
                this.first = null;
                this.last = null;
                this._length = 0;
                this._channels = new Object();
            };
        }

        public function getLogsAsString(_arg1:String, _arg2:Boolean=true, _arg3:Function=null):String
        {
            var _local4 = "";
            var _local5:Log = this.first;
            while (_local5)
            {
                if ((((_arg3 == null)) || (_arg3(_local5))))
                {
                    if (this.first != _local5)
                    {
                        _local4 = (_local4 + _arg1);
                    };
                    _local4 = (_local4 + ((_arg2) ? _local5.toString() : _local5.plainText()));
                };
                _local5 = _local5.next;
            };
            return (_local4);
        }

        public function getChannels():Array
        {
            var _local3:String;
            var _local1:Array = new Array(Console.GLOBAL_CHANNEL);
            this.addIfexist(Console.DEFAULT_CHANNEL, _local1);
            this.addIfexist(Console.FILTER_CHANNEL, _local1);
            this.addIfexist(LogReferences.INSPECTING_CHANNEL, _local1);
            this.addIfexist(Console.CONSOLE_CHANNEL, _local1);
            var _local2:Array = new Array();
            for (_local3 in this._channels)
            {
                if (_local1.indexOf(_local3) < 0)
                {
                    _local2.push(_local3);
                };
            };
            return (_local1.concat(_local2.sort(Array.CASEINSENSITIVE)));
        }

        private function addIfexist(_arg1:String, _arg2:Array):void
        {
            if (this._channels.hasOwnProperty(_arg1))
            {
                _arg2.push(_arg1);
            };
        }

        public function cleanChannels():void
        {
            this._channels = new Object();
            var _local1:Log = this.first;
            while (_local1)
            {
                this.addChannel(_local1.ch);
                _local1 = _local1.next;
            };
        }

        public function addChannel(_arg1:String):void
        {
            this._channels[_arg1] = null;
        }

        private function push(_arg1:Log):void
        {
            if (this.last == null)
            {
                this.first = _arg1;
            }
            else
            {
                this.last.next = _arg1;
                _arg1.prev = this.last;
            };
            this.last = _arg1;
            this._length++;
        }

        private function remove(_arg1:Log):void
        {
            if (this.first == _arg1)
            {
                this.first = _arg1.next;
            };
            if (this.last == _arg1)
            {
                this.last = _arg1.prev;
            };
            if (_arg1 == this._lastRepeat)
            {
                this._lastRepeat = null;
            };
            if (_arg1 == this._newRepeat)
            {
                this._newRepeat = null;
            };
            if (_arg1.next != null)
            {
                _arg1.next.prev = _arg1.prev;
            };
            if (_arg1.prev != null)
            {
                _arg1.prev.next = _arg1.next;
            };
            this._length--;
        }


    }
}

