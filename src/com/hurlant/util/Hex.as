package com.hurlant.util
{
    import flash.utils.ByteArray;

    public class Hex 
    {


        public static function toArray(_arg1:String):ByteArray
        {
            _arg1 = _arg1.replace(/\s|:/gm, "");
            var _local2:ByteArray = new ByteArray();
            if ((_arg1.length & (1 == 1)))
            {
                _arg1 = ("0" + _arg1);
            };
            var _local3:uint;
            while (_local3 < _arg1.length)
            {
                _local2[(_local3 / 2)] = parseInt(_arg1.substr(_local3, 2), 16);
                _local3 = (_local3 + 2);
            };
            return (_local2);
        }

        public static function fromArray(_arg1:ByteArray, _arg2:Boolean=false):String
        {
            var _local3 = "";
            var _local4:uint;
            while (_local4 < _arg1.length)
            {
                _local3 = (_local3 + ("0" + _arg1[_local4].toString(16)).substr(-2, 2));
                if (_arg2)
                {
                    if (_local4 < (_arg1.length - 1))
                    {
                        _local3 = (_local3 + ":");
                    };
                };
                _local4++;
            };
            return (_local3);
        }

        public static function toString(_arg1:String):String
        {
            var _local2:ByteArray = toArray(_arg1);
            return (_local2.readUTFBytes(_local2.length));
        }

        public static function fromString(_arg1:String, _arg2:Boolean=false):String
        {
            var _local3:ByteArray = new ByteArray();
            _local3.writeUTFBytes(_arg1);
            return (fromArray(_local3, _arg2));
        }


    }
}

