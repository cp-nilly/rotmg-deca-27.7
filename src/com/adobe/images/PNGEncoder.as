package com.adobe.images
{
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.geom.*;

    public class PNGEncoder 
    {

        private static var crcTable:Array;
        private static var crcTableComputed:Boolean = false;


        public static function encode(_arg1:BitmapData):ByteArray
        {
            var _local6:uint;
            var _local7:int;
            var _local2:ByteArray = new ByteArray();
            _local2.writeUnsignedInt(2303741511);
            _local2.writeUnsignedInt(218765834);
            var _local3:ByteArray = new ByteArray();
            _local3.writeInt(_arg1.width);
            _local3.writeInt(_arg1.height);
            _local3.writeUnsignedInt(134610944);
            _local3.writeByte(0);
            writeChunk(_local2, 1229472850, _local3);
            var _local4:ByteArray = new ByteArray();
            var _local5:int;
            while (_local5 < _arg1.height)
            {
                _local4.writeByte(0);
                if (!_arg1.transparent)
                {
                    _local7 = 0;
                    while (_local7 < _arg1.width)
                    {
                        _local6 = _arg1.getPixel(_local7, _local5);
                        _local4.writeUnsignedInt(uint((((_local6 & 0xFFFFFF) << 8) | 0xFF)));
                        _local7++;
                    };
                }
                else
                {
                    _local7 = 0;
                    while (_local7 < _arg1.width)
                    {
                        _local6 = _arg1.getPixel32(_local7, _local5);
                        _local4.writeUnsignedInt(uint((((_local6 & 0xFFFFFF) << 8) | (_local6 >>> 24))));
                        _local7++;
                    };
                };
                _local5++;
            };
            _local4.compress();
            writeChunk(_local2, 1229209940, _local4);
            writeChunk(_local2, 1229278788, null);
            return (_local2);
        }

        private static function writeChunk(_arg1:ByteArray, _arg2:uint, _arg3:ByteArray):void
        {
            var _local8:uint;
            var _local9:uint;
            var _local10:uint;
            if (!crcTableComputed)
            {
                crcTableComputed = true;
                crcTable = [];
                _local9 = 0;
                while (_local9 < 0x0100)
                {
                    _local8 = _local9;
                    _local10 = 0;
                    while (_local10 < 8)
                    {
                        if ((_local8 & 1))
                        {
                            _local8 = uint((uint(3988292384) ^ uint((_local8 >>> 1))));
                        }
                        else
                        {
                            _local8 = uint((_local8 >>> 1));
                        };
                        _local10++;
                    };
                    crcTable[_local9] = _local8;
                    _local9++;
                };
            };
            var _local4:uint;
            if (_arg3 != null)
            {
                _local4 = _arg3.length;
            };
            _arg1.writeUnsignedInt(_local4);
            var _local5:uint = _arg1.position;
            _arg1.writeUnsignedInt(_arg2);
            if (_arg3 != null)
            {
                _arg1.writeBytes(_arg3);
            };
            var _local6:uint = _arg1.position;
            _arg1.position = _local5;
            _local8 = 0xFFFFFFFF;
            var _local7:int;
            while (_local7 < (_local6 - _local5))
            {
                _local8 = uint((crcTable[((_local8 ^ _arg1.readUnsignedByte()) & uint(0xFF))] ^ uint((_local8 >>> 8))));
                _local7++;
            };
            _local8 = uint((_local8 ^ uint(0xFFFFFFFF)));
            _arg1.position = _local6;
            _arg1.writeUnsignedInt(_local8);
        }


    }
}

