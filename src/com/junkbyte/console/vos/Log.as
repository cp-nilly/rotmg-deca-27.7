package com.junkbyte.console.vos
{
    import flash.utils.ByteArray;

    public class Log 
    {

        public var line:uint;
        public var text:String;
        public var ch:String;
        public var priority:int;
        public var repeat:Boolean;
        public var html:Boolean;
        public var time:uint;
        public var timeStr:String;
        public var lineStr:String;
        public var chStr:String;
        public var next:Log;
        public var prev:Log;

        public function Log(_arg1:String, _arg2:String, _arg3:int, _arg4:Boolean=false, _arg5:Boolean=false)
        {
            this.text = _arg1;
            this.ch = _arg2;
            this.priority = _arg3;
            this.repeat = _arg4;
            this.html = _arg5;
        }

        public static function FromBytes(_arg1:ByteArray):Log
        {
            var _local2:String = _arg1.readUTFBytes(_arg1.readUnsignedInt());
            var _local3:String = _arg1.readUTF();
            var _local4:int = _arg1.readInt();
            var _local5:Boolean = _arg1.readBoolean();
            return (new (Log)(_local2, _local3, _local4, _local5, true));
        }


        public function toBytes(_arg1:ByteArray):void
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeUTFBytes(this.text);
            _arg1.writeUnsignedInt(_local2.length);
            _arg1.writeBytes(_local2);
            _arg1.writeUTF(this.ch);
            _arg1.writeInt(this.priority);
            _arg1.writeBoolean(this.repeat);
        }

        public function plainText():String
        {
            return (this.text.replace(/<.*?>/g, "").replace(/&lt;/g, "<").replace(/&gt;/g, ">"));
        }

        public function toString():String
        {
            return (((("[" + this.ch) + "] ") + this.plainText()));
        }

        public function clone():Log
        {
            var _local1:Log = new Log(this.text, this.ch, this.priority, this.repeat, this.html);
            _local1.line = this.line;
            _local1.time = this.time;
            return (_local1);
        }


    }
}

