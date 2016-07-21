package com.hurlant.util.der
{
    import flash.utils.ByteArray;

    public class DER 
    {

        public static var indent:String = "";


        public static function parse(_arg1:ByteArray, _arg2:*=null):IAsn1Type
        {
            var _local3:int;
            var _local5:int;
            var _local6:ByteArray;
            var _local7:int;
            var _local8:int;
            var _local9:Sequence;
            var _local10:Array;
            var _local11:Set;
            var _local12:ByteString;
            var _local13:PrintableString;
            var _local14:UTCTime;
            var _local15:Object;
            var _local16:Boolean;
            var _local17:Boolean;
            var _local18:String;
            var _local19:*;
            var _local20:IAsn1Type;
            var _local21:int;
            var _local22:ByteArray;
            _local3 = _arg1.readUnsignedByte();
            var _local4 = !(((_local3 & 32) == 0));
            _local3 = (_local3 & 31);
            _local5 = _arg1.readUnsignedByte();
            if (_local5 >= 128)
            {
                _local7 = (_local5 & 127);
                _local5 = 0;
                while (_local7 > 0)
                {
                    _local5 = ((_local5 << 8) | _arg1.readUnsignedByte());
                    _local7--;
                };
            };
            switch (_local3)
            {
                case 0:
                case 16:
                    _local8 = _arg1.position;
                    _local9 = new Sequence(_local3, _local5);
                    _local10 = (_arg2 as Array);
                    if (_local10 != null)
                    {
                        _local10 = _local10.concat();
                    };
                    while (_arg1.position < (_local8 + _local5))
                    {
                        _local15 = null;
                        if (_local10 != null)
                        {
                            _local15 = _local10.shift();
                        };
                        if (_local15 != null)
                        {
                            while (((_local15) && (_local15.optional)))
                            {
                                _local16 = (_local15.value is Array);
                                _local17 = isConstructedType(_arg1);
                                if (_local16 != _local17)
                                {
                                    _local9.push(_local15.defaultValue);
                                    _local9[_local15.name] = _local15.defaultValue;
                                    _local15 = _local10.shift();
                                }
                                else
                                {
                                    break;
                                };
                            };
                        };
                        if (_local15 != null)
                        {
                            _local18 = _local15.name;
                            _local19 = _local15.value;
                            if (_local15.extract)
                            {
                                _local21 = getLengthOfNextElement(_arg1);
                                _local22 = new ByteArray();
                                _local22.writeBytes(_arg1, _arg1.position, _local21);
                                _local9[(_local18 + "_bin")] = _local22;
                            };
                            _local20 = DER.parse(_arg1, _local19);
                            _local9.push(_local20);
                            _local9[_local18] = _local20;
                        }
                        else
                        {
                            _local9.push(DER.parse(_arg1));
                        };
                    };
                    return (_local9);
                case 17:
                    _local8 = _arg1.position;
                    _local11 = new Set(_local3, _local5);
                    while (_arg1.position < (_local8 + _local5))
                    {
                        _local11.push(DER.parse(_arg1));
                    };
                    return (_local11);
                case 2:
                    _local6 = new ByteArray();
                    _arg1.readBytes(_local6, 0, _local5);
                    _local6.position = 0;
                    return (new Integer(_local3, _local5, _local6));
                case 6:
                    _local6 = new ByteArray();
                    _arg1.readBytes(_local6, 0, _local5);
                    _local6.position = 0;
                    return (new ObjectIdentifier(_local3, _local5, _local6));
                default:
                    trace(("I DONT KNOW HOW TO HANDLE DER stuff of TYPE " + _local3));
                case 3:
                    if (_arg1[_arg1.position] == 0)
                    {
                        _arg1.position++;
                        _local5--;
                    };
                case 4:
                    _local12 = new ByteString(_local3, _local5);
                    _arg1.readBytes(_local12, 0, _local5);
                    return (_local12);
                case 5:
                    return (null);
                case 19:
                    _local13 = new PrintableString(_local3, _local5);
                    _local13.setString(_arg1.readMultiByte(_local5, "US-ASCII"));
                    return (_local13);
                case 34:
                case 20:
                    _local13 = new PrintableString(_local3, _local5);
                    _local13.setString(_arg1.readMultiByte(_local5, "latin1"));
                    return (_local13);
                case 23:
                    _local14 = new UTCTime(_local3, _local5);
                    _local14.setUTCTime(_arg1.readMultiByte(_local5, "US-ASCII"));
                    return (_local14);
            };
        }

        private static function getLengthOfNextElement(_arg1:ByteArray):int
        {
            var _local4:int;
            var _local2:uint = _arg1.position;
            _arg1.position++;
            var _local3:int = _arg1.readUnsignedByte();
            if (_local3 >= 128)
            {
                _local4 = (_local3 & 127);
                _local3 = 0;
                while (_local4 > 0)
                {
                    _local3 = ((_local3 << 8) | _arg1.readUnsignedByte());
                    _local4--;
                };
            };
            _local3 = (_local3 + (_arg1.position - _local2));
            _arg1.position = _local2;
            return (_local3);
        }

        private static function isConstructedType(_arg1:ByteArray):Boolean
        {
            var _local2:int = _arg1[_arg1.position];
            return (!(((_local2 & 32) == 0)));
        }

        public static function wrapDER(_arg1:int, _arg2:ByteArray):ByteArray
        {
            var _local3:ByteArray = new ByteArray();
            _local3.writeByte(_arg1);
            var _local4:int = _arg2.length;
            if (_local4 < 128)
            {
                _local3.writeByte(_local4);
            }
            else
            {
                if (_local4 < 0x0100)
                {
                    _local3.writeByte((1 | 128));
                    _local3.writeByte(_local4);
                }
                else
                {
                    if (_local4 < 65536)
                    {
                        _local3.writeByte((2 | 128));
                        _local3.writeByte((_local4 >> 8));
                        _local3.writeByte(_local4);
                    }
                    else
                    {
                        if (_local4 < (65536 * 0x0100))
                        {
                            _local3.writeByte((3 | 128));
                            _local3.writeByte((_local4 >> 16));
                            _local3.writeByte((_local4 >> 8));
                            _local3.writeByte(_local4);
                        }
                        else
                        {
                            _local3.writeByte((4 | 128));
                            _local3.writeByte((_local4 >> 24));
                            _local3.writeByte((_local4 >> 16));
                            _local3.writeByte((_local4 >> 8));
                            _local3.writeByte(_local4);
                        };
                    };
                };
            };
            _local3.writeBytes(_arg2);
            _local3.position = 0;
            return (_local3);
        }


    }
}

