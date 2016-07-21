package com.google.analytics.core
{
    public class Utils 
    {


        public static function trim(_arg1:String, _arg2:Boolean=false):String
        {
            var _local5:int;
            var _local6:int;
            var _local7:int;
            if (_arg1 == "")
            {
                return ("");
            };
            var _local3:Array = [" ", "\n", "\r", "\t"];
            var _local4:String = _arg1;
            if (_arg2)
            {
                _local5 = 0;
                while ((((_local5 < _local3.length)) && ((_local4.indexOf(_local3[_local5]) > -1))))
                {
                    _local4 = _local4.split(_local3[_local5]).join("");
                    _local5++;
                };
            }
            else
            {
                _local6 = 0;
                while ((((_local6 < _local4.length)) && ((_local3.indexOf(_local4.charAt(_local6)) > -1))))
                {
                    _local6++;
                };
                _local4 = _local4.substr(_local6);
                _local7 = (_local4.length - 1);
                while ((((_local7 >= 0)) && ((_local3.indexOf(_local4.charAt(_local7)) > -1))))
                {
                    _local7--;
                };
                _local4 = _local4.substring(0, (_local7 + 1));
            };
            return (_local4);
        }

        public static function generateHash(_arg1:String):int
        {
            var _local4:int;
            var _local5:int;
            var _local2:int = 1;
            var _local3:int;
            if (((!((_arg1 == null))) && (!((_arg1 == "")))))
            {
                _local2 = 0;
                _local4 = (_arg1.length - 1);
                while (_local4 >= 0)
                {
                    _local5 = _arg1.charCodeAt(_local4);
                    _local2 = ((((_local2 << 6) & 268435455) + _local5) + (_local5 << 14));
                    _local3 = (_local2 & 266338304);
                    if (_local3 != 0)
                    {
                        _local2 = (_local2 ^ (_local3 >> 21));
                    };
                    _local4--;
                };
            };
            return (_local2);
        }

        public static function generate32bitRandom():int
        {
            return (Math.round((Math.random() * 2147483647)));
        }

        public static function validateAccount(_arg1:String):Boolean
        {
            var _local2:RegExp = /^UA-[0-9]*-[0-9]*$/;
            return (_local2.test(_arg1));
        }


    }
}

