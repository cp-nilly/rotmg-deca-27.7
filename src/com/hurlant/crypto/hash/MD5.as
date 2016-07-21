package com.hurlant.crypto.hash
{
    import flash.utils.Endian;
    import flash.utils.ByteArray;

    public class MD5 implements IHash 
    {

        public static const HASH_SIZE:int = 16;

        public var pad_size:int = 48;


        public function getInputSize():uint
        {
            return (64);
        }

        public function getHashSize():uint
        {
            return (HASH_SIZE);
        }

        public function getPadSize():int
        {
            return (this.pad_size);
        }

        public function hash(_arg1:ByteArray):ByteArray
        {
            var _local2:uint = (_arg1.length * 8);
            var _local3:String = _arg1.endian;
            while ((_arg1.length % 4) != 0)
            {
                _arg1[_arg1.length] = 0;
            };
            _arg1.position = 0;
            var _local4:Array = [];
            _arg1.endian = Endian.LITTLE_ENDIAN;
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local4.push(_arg1.readUnsignedInt());
                _local5 = (_local5 + 4);
            };
            var _local6:Array = this.core_md5(_local4, _local2);
            var _local7:ByteArray = new ByteArray();
            _local7.endian = Endian.LITTLE_ENDIAN;
            _local5 = 0;
            while (_local5 < 4)
            {
                _local7.writeUnsignedInt(_local6[_local5]);
                _local5++;
            };
            _arg1.length = (_local2 / 8);
            _arg1.endian = _local3;
            return (_local7);
        }

        private function core_md5(_arg1:Array, _arg2:uint):Array
        {
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local11:uint;
            _arg1[(_arg2 >> 5)] = (_arg1[(_arg2 >> 5)] | (128 << (_arg2 % 32)));
            _arg1[((((_arg2 + 64) >>> 9) << 4) + 14)] = _arg2;
            var _local3:uint = 1732584193;
            var _local4:uint = 4023233417;
            var _local5:uint = 2562383102;
            var _local6:uint = 271733878;
            var _local7:uint;
            while (_local7 < _arg1.length)
            {
                _arg1[_local7] = ((_arg1[_local7]) || (0));
                _arg1[(_local7 + 1)] = ((_arg1[(_local7 + 1)]) || (0));
                _arg1[(_local7 + 2)] = ((_arg1[(_local7 + 2)]) || (0));
                _arg1[(_local7 + 3)] = ((_arg1[(_local7 + 3)]) || (0));
                _arg1[(_local7 + 4)] = ((_arg1[(_local7 + 4)]) || (0));
                _arg1[(_local7 + 5)] = ((_arg1[(_local7 + 5)]) || (0));
                _arg1[(_local7 + 6)] = ((_arg1[(_local7 + 6)]) || (0));
                _arg1[(_local7 + 7)] = ((_arg1[(_local7 + 7)]) || (0));
                _arg1[(_local7 + 8)] = ((_arg1[(_local7 + 8)]) || (0));
                _arg1[(_local7 + 9)] = ((_arg1[(_local7 + 9)]) || (0));
                _arg1[(_local7 + 10)] = ((_arg1[(_local7 + 10)]) || (0));
                _arg1[(_local7 + 11)] = ((_arg1[(_local7 + 11)]) || (0));
                _arg1[(_local7 + 12)] = ((_arg1[(_local7 + 12)]) || (0));
                _arg1[(_local7 + 13)] = ((_arg1[(_local7 + 13)]) || (0));
                _arg1[(_local7 + 14)] = ((_arg1[(_local7 + 14)]) || (0));
                _arg1[(_local7 + 15)] = ((_arg1[(_local7 + 15)]) || (0));
                _local8 = _local3;
                _local9 = _local4;
                _local10 = _local5;
                _local11 = _local6;
                _local3 = this.ff(_local3, _local4, _local5, _local6, _arg1[(_local7 + 0)], 7, 3614090360);
                _local6 = this.ff(_local6, _local3, _local4, _local5, _arg1[(_local7 + 1)], 12, 3905402710);
                _local5 = this.ff(_local5, _local6, _local3, _local4, _arg1[(_local7 + 2)], 17, 606105819);
                _local4 = this.ff(_local4, _local5, _local6, _local3, _arg1[(_local7 + 3)], 22, 3250441966);
                _local3 = this.ff(_local3, _local4, _local5, _local6, _arg1[(_local7 + 4)], 7, 4118548399);
                _local6 = this.ff(_local6, _local3, _local4, _local5, _arg1[(_local7 + 5)], 12, 1200080426);
                _local5 = this.ff(_local5, _local6, _local3, _local4, _arg1[(_local7 + 6)], 17, 2821735955);
                _local4 = this.ff(_local4, _local5, _local6, _local3, _arg1[(_local7 + 7)], 22, 4249261313);
                _local3 = this.ff(_local3, _local4, _local5, _local6, _arg1[(_local7 + 8)], 7, 1770035416);
                _local6 = this.ff(_local6, _local3, _local4, _local5, _arg1[(_local7 + 9)], 12, 2336552879);
                _local5 = this.ff(_local5, _local6, _local3, _local4, _arg1[(_local7 + 10)], 17, 0xFFFF5BB1);
                _local4 = this.ff(_local4, _local5, _local6, _local3, _arg1[(_local7 + 11)], 22, 2304563134);
                _local3 = this.ff(_local3, _local4, _local5, _local6, _arg1[(_local7 + 12)], 7, 1804603682);
                _local6 = this.ff(_local6, _local3, _local4, _local5, _arg1[(_local7 + 13)], 12, 4254626195);
                _local5 = this.ff(_local5, _local6, _local3, _local4, _arg1[(_local7 + 14)], 17, 2792965006);
                _local4 = this.ff(_local4, _local5, _local6, _local3, _arg1[(_local7 + 15)], 22, 1236535329);
                _local3 = this.gg(_local3, _local4, _local5, _local6, _arg1[(_local7 + 1)], 5, 4129170786);
                _local6 = this.gg(_local6, _local3, _local4, _local5, _arg1[(_local7 + 6)], 9, 3225465664);
                _local5 = this.gg(_local5, _local6, _local3, _local4, _arg1[(_local7 + 11)], 14, 643717713);
                _local4 = this.gg(_local4, _local5, _local6, _local3, _arg1[(_local7 + 0)], 20, 3921069994);
                _local3 = this.gg(_local3, _local4, _local5, _local6, _arg1[(_local7 + 5)], 5, 3593408605);
                _local6 = this.gg(_local6, _local3, _local4, _local5, _arg1[(_local7 + 10)], 9, 38016083);
                _local5 = this.gg(_local5, _local6, _local3, _local4, _arg1[(_local7 + 15)], 14, 3634488961);
                _local4 = this.gg(_local4, _local5, _local6, _local3, _arg1[(_local7 + 4)], 20, 3889429448);
                _local3 = this.gg(_local3, _local4, _local5, _local6, _arg1[(_local7 + 9)], 5, 568446438);
                _local6 = this.gg(_local6, _local3, _local4, _local5, _arg1[(_local7 + 14)], 9, 3275163606);
                _local5 = this.gg(_local5, _local6, _local3, _local4, _arg1[(_local7 + 3)], 14, 4107603335);
                _local4 = this.gg(_local4, _local5, _local6, _local3, _arg1[(_local7 + 8)], 20, 1163531501);
                _local3 = this.gg(_local3, _local4, _local5, _local6, _arg1[(_local7 + 13)], 5, 2850285829);
                _local6 = this.gg(_local6, _local3, _local4, _local5, _arg1[(_local7 + 2)], 9, 4243563512);
                _local5 = this.gg(_local5, _local6, _local3, _local4, _arg1[(_local7 + 7)], 14, 1735328473);
                _local4 = this.gg(_local4, _local5, _local6, _local3, _arg1[(_local7 + 12)], 20, 2368359562);
                _local3 = this.hh(_local3, _local4, _local5, _local6, _arg1[(_local7 + 5)], 4, 4294588738);
                _local6 = this.hh(_local6, _local3, _local4, _local5, _arg1[(_local7 + 8)], 11, 2272392833);
                _local5 = this.hh(_local5, _local6, _local3, _local4, _arg1[(_local7 + 11)], 16, 1839030562);
                _local4 = this.hh(_local4, _local5, _local6, _local3, _arg1[(_local7 + 14)], 23, 4259657740);
                _local3 = this.hh(_local3, _local4, _local5, _local6, _arg1[(_local7 + 1)], 4, 2763975236);
                _local6 = this.hh(_local6, _local3, _local4, _local5, _arg1[(_local7 + 4)], 11, 1272893353);
                _local5 = this.hh(_local5, _local6, _local3, _local4, _arg1[(_local7 + 7)], 16, 4139469664);
                _local4 = this.hh(_local4, _local5, _local6, _local3, _arg1[(_local7 + 10)], 23, 3200236656);
                _local3 = this.hh(_local3, _local4, _local5, _local6, _arg1[(_local7 + 13)], 4, 681279174);
                _local6 = this.hh(_local6, _local3, _local4, _local5, _arg1[(_local7 + 0)], 11, 3936430074);
                _local5 = this.hh(_local5, _local6, _local3, _local4, _arg1[(_local7 + 3)], 16, 3572445317);
                _local4 = this.hh(_local4, _local5, _local6, _local3, _arg1[(_local7 + 6)], 23, 76029189);
                _local3 = this.hh(_local3, _local4, _local5, _local6, _arg1[(_local7 + 9)], 4, 3654602809);
                _local6 = this.hh(_local6, _local3, _local4, _local5, _arg1[(_local7 + 12)], 11, 3873151461);
                _local5 = this.hh(_local5, _local6, _local3, _local4, _arg1[(_local7 + 15)], 16, 530742520);
                _local4 = this.hh(_local4, _local5, _local6, _local3, _arg1[(_local7 + 2)], 23, 3299628645);
                _local3 = this.ii(_local3, _local4, _local5, _local6, _arg1[(_local7 + 0)], 6, 4096336452);
                _local6 = this.ii(_local6, _local3, _local4, _local5, _arg1[(_local7 + 7)], 10, 1126891415);
                _local5 = this.ii(_local5, _local6, _local3, _local4, _arg1[(_local7 + 14)], 15, 2878612391);
                _local4 = this.ii(_local4, _local5, _local6, _local3, _arg1[(_local7 + 5)], 21, 4237533241);
                _local3 = this.ii(_local3, _local4, _local5, _local6, _arg1[(_local7 + 12)], 6, 1700485571);
                _local6 = this.ii(_local6, _local3, _local4, _local5, _arg1[(_local7 + 3)], 10, 2399980690);
                _local5 = this.ii(_local5, _local6, _local3, _local4, _arg1[(_local7 + 10)], 15, 4293915773);
                _local4 = this.ii(_local4, _local5, _local6, _local3, _arg1[(_local7 + 1)], 21, 2240044497);
                _local3 = this.ii(_local3, _local4, _local5, _local6, _arg1[(_local7 + 8)], 6, 1873313359);
                _local6 = this.ii(_local6, _local3, _local4, _local5, _arg1[(_local7 + 15)], 10, 4264355552);
                _local5 = this.ii(_local5, _local6, _local3, _local4, _arg1[(_local7 + 6)], 15, 2734768916);
                _local4 = this.ii(_local4, _local5, _local6, _local3, _arg1[(_local7 + 13)], 21, 1309151649);
                _local3 = this.ii(_local3, _local4, _local5, _local6, _arg1[(_local7 + 4)], 6, 4149444226);
                _local6 = this.ii(_local6, _local3, _local4, _local5, _arg1[(_local7 + 11)], 10, 3174756917);
                _local5 = this.ii(_local5, _local6, _local3, _local4, _arg1[(_local7 + 2)], 15, 718787259);
                _local4 = this.ii(_local4, _local5, _local6, _local3, _arg1[(_local7 + 9)], 21, 3951481745);
                _local3 = (_local3 + _local8);
                _local4 = (_local4 + _local9);
                _local5 = (_local5 + _local10);
                _local6 = (_local6 + _local11);
                _local7 = (_local7 + 16);
            };
            return ([_local3, _local4, _local5, _local6]);
        }

        private function rol(_arg1:uint, _arg2:uint):uint
        {
            return (((_arg1 << _arg2) | (_arg1 >>> (32 - _arg2))));
        }

        private function cmn(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint):uint
        {
            return ((this.rol((((_arg2 + _arg1) + _arg4) + _arg6), _arg5) + _arg3));
        }

        private function ff(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint, _arg7:uint):uint
        {
            return (this.cmn(((_arg2 & _arg3) | (~(_arg2) & _arg4)), _arg1, _arg2, _arg5, _arg6, _arg7));
        }

        private function gg(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint, _arg7:uint):uint
        {
            return (this.cmn(((_arg2 & _arg4) | (_arg3 & ~(_arg4))), _arg1, _arg2, _arg5, _arg6, _arg7));
        }

        private function hh(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint, _arg7:uint):uint
        {
            return (this.cmn(((_arg2 ^ _arg3) ^ _arg4), _arg1, _arg2, _arg5, _arg6, _arg7));
        }

        private function ii(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint, _arg7:uint):uint
        {
            return (this.cmn((_arg3 ^ (_arg2 | ~(_arg4))), _arg1, _arg2, _arg5, _arg6, _arg7));
        }

        public function toString():String
        {
            return ("md5");
        }


    }
}

