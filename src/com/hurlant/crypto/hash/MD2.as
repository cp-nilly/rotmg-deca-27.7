package com.hurlant.crypto.hash
{
    import flash.utils.ByteArray;

    public class MD2 implements IHash 
    {

        public static const HASH_SIZE:int = 16;
        private static const S:Array = [41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6, 19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188, 76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24, 138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251, 245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63, 148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50, 39, 53, 62, 204, 231, 191, 247, 151, 3, 0xFF, 25, 48, 179, 72, 165, 181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210, 150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157, 112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27, 96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15, 85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197, 234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65, 129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123, 8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233, 203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228, 166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237, 31, 26, 219, 153, 141, 51, 159, 17, 131, 20];

        public var pad_size:int = 48;


        public function getInputSize():uint
        {
            return (16);
        }

        public function getPadSize():int
        {
            return (this.pad_size);
        }

        public function getHashSize():uint
        {
            return (HASH_SIZE);
        }

        public function hash(_arg1:ByteArray):ByteArray
        {
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            var _local2:uint = _arg1.length;
            var _local3:uint = (((16 - (_arg1.length % 16))) || (16));
            do 
            {
                _arg1[_arg1.length] = _local3;
            } while ((_arg1.length % 16) != 0);
            var _local4:uint = _arg1.length;
            var _local5:ByteArray = new ByteArray();
            var _local6:uint;
            _local3 = 0;
            while (_local3 < _local4)
            {
                _local8 = 0;
                while (_local8 < 16)
                {
                    _local6 = (_local5[_local8] = (_local5[_local8] ^ S[(_arg1[(_local3 + _local8)] ^ _local6)]));
                    _local8++;
                };
                _local3 = (_local3 + 16);
            };
            _arg1.position = _arg1.length;
            _arg1.writeBytes(_local5);
            _local4 = (_local4 + 16);
            var _local7:ByteArray = new ByteArray();
            _local3 = 0;
            while (_local3 < _local4)
            {
                _local8 = 0;
                while (_local8 < 16)
                {
                    _local7[(32 + _local8)] = ((_local7[(16 + _local8)] = _arg1[(_local3 + _local8)]) ^ _local7[_local8]);
                    _local8++;
                };
                _local9 = 0;
                _local8 = 0;
                while (_local8 < 18)
                {
                    _local10 = 0;
                    while (_local10 < 48)
                    {
                        _local9 = (_local7[_local10] ^ S[_local9]);
                        _local7[_local10] = _local9;
                        _local10++;
                    };
                    _local9 = ((_local9 + _local8) & 0xFF);
                    _local8++;
                };
                _local3 = (_local3 + 16);
            };
            _local7.length = 16;
            _arg1.length = _local2;
            return (_local7);
        }

        public function toString():String
        {
            return ("md2");
        }


    }
}

