package com.hurlant.util.der
{
    import flash.utils.ByteArray;

    public class UTCTime implements IAsn1Type 
    {

        protected var type:uint;
        protected var len:uint;
        public var date:Date;

        public function UTCTime(_arg1:uint, _arg2:uint)
        {
            this.type = _arg1;
            this.len = _arg2;
        }

        public function getLength():uint
        {
            return (this.len);
        }

        public function getType():uint
        {
            return (this.type);
        }

        public function setUTCTime(_arg1:String):void
        {
            var _local2:uint = parseInt(_arg1.substr(0, 2));
            if (_local2 < 50)
            {
                _local2 = (_local2 + 2000);
            }
            else
            {
                _local2 = (_local2 + 1900);
            };
            var _local3:uint = parseInt(_arg1.substr(2, 2));
            var _local4:uint = parseInt(_arg1.substr(4, 2));
            var _local5:uint = parseInt(_arg1.substr(6, 2));
            var _local6:uint = parseInt(_arg1.substr(8, 2));
            this.date = new Date(_local2, (_local3 - 1), _local4, _local5, _local6);
        }

        public function toString():String
        {
            return ((((((((DER.indent + "UTCTime[") + this.type) + "][") + this.len) + "][") + this.date) + "]"));
        }

        public function toDER():ByteArray
        {
            return (null);
        }


    }
}

