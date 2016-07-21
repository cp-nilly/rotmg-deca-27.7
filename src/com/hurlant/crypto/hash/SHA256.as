package com.hurlant.crypto.hash
{
    public class SHA256 extends SHABase implements IHash 
    {

        protected static const k:Array = [1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298];

        protected var h:Array;

        public function SHA256()
        {
            this.h = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225];
            super();
        }

        override public function getHashSize():uint
        {
            return (32);
        }

        override protected function core(_arg1:Array, _arg2:uint):Array
        {
            var _local13:uint;
            var _local14:uint;
            var _local15:uint;
            var _local16:uint;
            var _local17:uint;
            var _local18:uint;
            var _local19:uint;
            var _local20:uint;
            var _local21:uint;
            var _local22:uint;
            var _local23:uint;
            var _local24:uint;
            var _local25:uint;
            _arg1[(_arg2 >> 5)] = (_arg1[(_arg2 >> 5)] | (128 << (24 - (_arg2 % 32))));
            _arg1[((((_arg2 + 64) >> 9) << 4) + 15)] = _arg2;
            var _local3:Array = [];
            var _local4:uint = this.h[0];
            var _local5:uint = this.h[1];
            var _local6:uint = this.h[2];
            var _local7:uint = this.h[3];
            var _local8:uint = this.h[4];
            var _local9:uint = this.h[5];
            var _local10:uint = this.h[6];
            var _local11:uint = this.h[7];
            var _local12:uint;
            while (_local12 < _arg1.length)
            {
                _local13 = _local4;
                _local14 = _local5;
                _local15 = _local6;
                _local16 = _local7;
                _local17 = _local8;
                _local18 = _local9;
                _local19 = _local10;
                _local20 = _local11;
                _local21 = 0;
                while (_local21 < 64)
                {
                    if (_local21 < 16)
                    {
                        _local3[_local21] = ((_arg1[(_local12 + _local21)]) || (0));
                    }
                    else
                    {
                        _local24 = ((this.rrol(_local3[(_local21 - 15)], 7) ^ this.rrol(_local3[(_local21 - 15)], 18)) ^ (_local3[(_local21 - 15)] >>> 3));
                        _local25 = ((this.rrol(_local3[(_local21 - 2)], 17) ^ this.rrol(_local3[(_local21 - 2)], 19)) ^ (_local3[(_local21 - 2)] >>> 10));
                        _local3[_local21] = (((_local3[(_local21 - 16)] + _local24) + _local3[(_local21 - 7)]) + _local25);
                    };
                    _local22 = (((this.rrol(_local4, 2) ^ this.rrol(_local4, 13)) ^ this.rrol(_local4, 22)) + (((_local4 & _local5) ^ (_local4 & _local6)) ^ (_local5 & _local6)));
                    _local23 = ((((_local11 + ((this.rrol(_local8, 6) ^ this.rrol(_local8, 11)) ^ this.rrol(_local8, 25))) + ((_local8 & _local9) ^ (_local10 & ~(_local8)))) + k[_local21]) + _local3[_local21]);
                    _local11 = _local10;
                    _local10 = _local9;
                    _local9 = _local8;
                    _local8 = (_local7 + _local23);
                    _local7 = _local6;
                    _local6 = _local5;
                    _local5 = _local4;
                    _local4 = (_local23 + _local22);
                    _local21++;
                };
                _local4 = (_local4 + _local13);
                _local5 = (_local5 + _local14);
                _local6 = (_local6 + _local15);
                _local7 = (_local7 + _local16);
                _local8 = (_local8 + _local17);
                _local9 = (_local9 + _local18);
                _local10 = (_local10 + _local19);
                _local11 = (_local11 + _local20);
                _local12 = (_local12 + 16);
            };
            return ([_local4, _local5, _local6, _local7, _local8, _local9, _local10, _local11]);
        }

        protected function rrol(_arg1:uint, _arg2:uint):uint
        {
            return (((_arg1 << (32 - _arg2)) | (_arg1 >>> _arg2)));
        }

        override public function toString():String
        {
            return ("sha256");
        }


    }
}

