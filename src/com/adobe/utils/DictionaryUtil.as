package com.adobe.utils
{
    import flash.utils.Dictionary;

    public class DictionaryUtil 
    {


        public static function getKeys(_arg1:Dictionary):Array
        {
            var _local3:Object;
            var _local2:Array = new Array();
            for (_local3 in _arg1)
            {
                _local2.push(_local3);
            };
            return (_local2);
        }

        public static function getValues(_arg1:Dictionary):Array
        {
            var _local3:Object;
            var _local2:Array = new Array();
            for each (_local3 in _arg1)
            {
                _local2.push(_local3);
            };
            return (_local2);
        }


    }
}

