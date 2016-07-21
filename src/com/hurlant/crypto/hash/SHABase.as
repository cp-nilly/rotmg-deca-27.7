package com.hurlant.crypto.hash
{
    import flash.utils.Endian;
    import flash.utils.ByteArray;

    public class SHABase implements IHash 
    {

        public var pad_size:int = 40;


        public function getInputSize():uint
        {
            return (64);
        }

        public function getHashSize():uint
        {
            return (0);
        }

        public function getPadSize():int
        {
            return (this.pad_size);
        }

        public function hash(_arg1:ByteArray):ByteArray
        {
            var _local2:uint = _arg1.length;
            var _local3:String = _arg1.endian;
            _arg1.endian = Endian.BIG_ENDIAN;
            var _local4:uint = (_local2 * 8);
            while ((_arg1.length % 4) != 0)
            {
                _arg1[_arg1.length] = 0;
            };
            _arg1.position = 0;
            var _local5:Array = [];
            var _local6:uint;
            while (_local6 < _arg1.length)
            {
                _local5.push(_arg1.readUnsignedInt());
                _local6 = (_local6 + 4);
            };
            var _local7:Array = this.core(_local5, _local4);
            var _local8:ByteArray = new ByteArray();
            var _local9:uint = (this.getHashSize() / 4);
            _local6 = 0;
            while (_local6 < _local9)
            {
                _local8.writeUnsignedInt(_local7[_local6]);
                _local6++;
            };
            _arg1.length = _local2;
            _arg1.endian = _local3;
            return (_local8);
        }

        protected function core(_arg1:Array, _arg2:uint):Array
        {
            return (null);
        }

        public function toString():String
        {
            return ("sha");
        }


    }
}

