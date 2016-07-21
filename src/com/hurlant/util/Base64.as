package com.hurlant.util
{
    import flash.utils.ByteArray;

    public class Base64 
    {

        private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        public static const version:String = "1.0.0";

        public function Base64()
        {
            throw (new Error("Base64 class is static container only"));
        }

        public static function encode(_arg1:String):String
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeUTFBytes(_arg1);
            return (encodeByteArray(_local2));
        }

        public static function encodeByteArray(_arg1:ByteArray):String
        {
            var _local3:Array;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local2 = "";
            var _local4:Array = new Array(4);
            _arg1.position = 0;
            while (_arg1.bytesAvailable > 0)
            {
                _local3 = new Array();
                _local5 = 0;
                while ((((_local5 < 3)) && ((_arg1.bytesAvailable > 0))))
                {
                    _local3[_local5] = _arg1.readUnsignedByte();
                    _local5++;
                };
                _local4[0] = ((_local3[0] & 252) >> 2);
                _local4[1] = (((_local3[0] & 3) << 4) | (_local3[1] >> 4));
                _local4[2] = (((_local3[1] & 15) << 2) | (_local3[2] >> 6));
                _local4[3] = (_local3[2] & 63);
                _local6 = _local3.length;
                while (_local6 < 3)
                {
                    _local4[(_local6 + 1)] = 64;
                    _local6++;
                };
                _local7 = 0;
                while (_local7 < _local4.length)
                {
                    _local2 = (_local2 + BASE64_CHARS.charAt(_local4[_local7]));
                    _local7++;
                };
            };
            return (_local2);
        }

        public static function decode(_arg1:String):String
        {
            var _local2:ByteArray = decodeToByteArrayB(_arg1);
            return (_local2.readUTFBytes(_local2.length));
        }

        public static function decodeToByteArray(_arg1:String):ByteArray
        {
            var _local6:uint;
            var _local7:uint;
            var _local2:ByteArray = new ByteArray();
            var _local3:Array = new Array(4);
            var _local4:Array = new Array(3);
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local6 = 0;
                while ((((_local6 < 4)) && (((_local5 + _local6) < _arg1.length))))
                {
                    _local3[_local6] = BASE64_CHARS.indexOf(_arg1.charAt((_local5 + _local6)));
                    _local6++;
                };
                _local4[0] = ((_local3[0] << 2) + ((_local3[1] & 48) >> 4));
                _local4[1] = (((_local3[1] & 15) << 4) + ((_local3[2] & 60) >> 2));
                _local4[2] = (((_local3[2] & 3) << 6) + _local3[3]);
                _local7 = 0;
                while (_local7 < _local4.length)
                {
                    if (_local3[(_local7 + 1)] == 64) break;
                    _local2.writeByte(_local4[_local7]);
                    _local7++;
                };
                _local5 = (_local5 + 4);
            };
            _local2.position = 0;
            return (_local2);
        }

        public static function decodeToByteArrayB(_arg1:String):ByteArray
        {
            var _local6:uint;
            var _local7:uint;
            var _local2:ByteArray = new ByteArray();
            var _local3:Array = new Array(4);
            var _local4:Array = new Array(3);
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local6 = 0;
                while ((((_local6 < 4)) && (((_local5 + _local6) < _arg1.length))))
                {
                    _local3[_local6] = BASE64_CHARS.indexOf(_arg1.charAt((_local5 + _local6)));
                    while ((((_local3[_local6] < 0)) && ((_local5 < _arg1.length))))
                    {
                        _local5++;
                        _local3[_local6] = BASE64_CHARS.indexOf(_arg1.charAt((_local5 + _local6)));
                    };
                    _local6++;
                };
                _local4[0] = ((_local3[0] << 2) + ((_local3[1] & 48) >> 4));
                _local4[1] = (((_local3[1] & 15) << 4) + ((_local3[2] & 60) >> 2));
                _local4[2] = (((_local3[2] & 3) << 6) + _local3[3]);
                _local7 = 0;
                while (_local7 < _local4.length)
                {
                    if (_local3[(_local7 + 1)] == 64) break;
                    _local2.writeByte(_local4[_local7]);
                    _local7++;
                };
                _local5 = (_local5 + 4);
            };
            _local2.position = 0;
            return (_local2);
        }


    }
}

