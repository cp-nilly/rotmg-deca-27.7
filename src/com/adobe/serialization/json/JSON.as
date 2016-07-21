package com.adobe.serialization.json
{
    public class JSON 
    {


        public static function encode(_arg1:Object):String
        {
            var _local2:JSONEncoder = new JSONEncoder(_arg1);
            return (_local2.getString());
        }

        public static function decode(_arg1:String)
        {
            var _local2:JSONDecoder = new JSONDecoder(_arg1);
            return (_local2.getValue());
        }


    }
}

