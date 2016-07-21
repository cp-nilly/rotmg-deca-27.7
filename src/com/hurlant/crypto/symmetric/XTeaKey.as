package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Memory;

    public class XTeaKey implements ISymmetricKey 
    {

        public const NUM_ROUNDS:uint = 64;

        private var k:Array;

        public function XTeaKey(_arg1:ByteArray)
        {
            _arg1.position = 0;
            this.k = [_arg1.readUnsignedInt(), _arg1.readUnsignedInt(), _arg1.readUnsignedInt(), _arg1.readUnsignedInt()];
        }

        public static function parseKey(_arg1:String):XTeaKey
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeUnsignedInt(parseInt(_arg1.substr(0, 8), 16));
            _local2.writeUnsignedInt(parseInt(_arg1.substr(8, 8), 16));
            _local2.writeUnsignedInt(parseInt(_arg1.substr(16, 8), 16));
            _local2.writeUnsignedInt(parseInt(_arg1.substr(24, 8), 16));
            _local2.position = 0;
            return (new (XTeaKey)(_local2));
        }


        public function getBlockSize():uint
        {
            return (8);
        }

        public function encrypt(_arg1:ByteArray, _arg2:uint=0):void
        {
            var _local5:uint;
            _arg1.position = _arg2;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local6:uint;
            var _local7:uint = 2654435769;
            _local5 = 0;
            while (_local5 < this.NUM_ROUNDS)
            {
                _local3 = (_local3 + ((((_local4 << 4) ^ (_local4 >> 5)) + _local4) ^ (_local6 + this.k[(_local6 & 3)])));
                _local6 = (_local6 + _local7);
                _local4 = (_local4 + ((((_local3 << 4) ^ (_local3 >> 5)) + _local3) ^ (_local6 + this.k[((_local6 >> 11) & 3)])));
                _local5++;
            };
            _arg1.position = (_arg1.position - 8);
            _arg1.writeUnsignedInt(_local3);
            _arg1.writeUnsignedInt(_local4);
        }

        public function decrypt(_arg1:ByteArray, _arg2:uint=0):void
        {
            var _local5:uint;
            _arg1.position = _arg2;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local6:uint = 2654435769;
            var _local7:uint = (_local6 * this.NUM_ROUNDS);
            _local5 = 0;
            while (_local5 < this.NUM_ROUNDS)
            {
                _local4 = (_local4 - ((((_local3 << 4) ^ (_local3 >> 5)) + _local3) ^ (_local7 + this.k[((_local7 >> 11) & 3)])));
                _local7 = (_local7 - _local6);
                _local3 = (_local3 - ((((_local4 << 4) ^ (_local4 >> 5)) + _local4) ^ (_local7 + this.k[(_local7 & 3)])));
                _local5++;
            };
            _arg1.position = (_arg1.position - 8);
            _arg1.writeUnsignedInt(_local3);
            _arg1.writeUnsignedInt(_local4);
        }

        public function dispose():void
        {
            var _local1:Random = new Random();
            var _local2:uint;
            while (_local2 < this.k.length)
            {
                this.k[_local2] = _local1.nextByte();
                delete this.k[_local2];
                _local2++;
            };
            this.k = null;
            Memory.gc();
        }

        public function toString():String
        {
            return ("xtea");
        }


    }
}

