package mx.utils
{
    import mx.core.mx_internal;
    import flash.utils.getQualifiedClassName;
    import flash.display.DisplayObject;
    import mx.core.IRepeaterClient;

    use namespace mx_internal;

    public class NameUtil 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var counter:int = 0;


        public static function createUniqueName(_arg1:Object):String
        {
            if (!_arg1)
            {
                return (null);
            };
            var _local2:String = getQualifiedClassName(_arg1);
            var _local3:int = _local2.indexOf("::");
            if (_local3 != -1)
            {
                _local2 = _local2.substr((_local3 + 2));
            };
            var _local4:int = _local2.charCodeAt((_local2.length - 1));
            if ((((_local4 >= 48)) && ((_local4 <= 57))))
            {
                _local2 = (_local2 + "_");
            };
            return ((_local2 + counter++));
        }

        public static function displayObjectToString(_arg1:DisplayObject):String
        {
            var _local2:String;
            var _local3:DisplayObject;
            var _local4:String;
            var _local5:Array;
            try
            {
                _local3 = _arg1;
                while (_local3 != null)
                {
                    if (((((_local3.parent) && (_local3.stage))) && ((_local3.parent == _local3.stage)))) break;
                    _local4 = ((((("id" in _local3)) && (_local3["id"]))) ? _local3["id"] : _local3.name);
                    if ((_local3 is IRepeaterClient))
                    {
                        _local5 = IRepeaterClient(_local3).instanceIndices;
                        if (_local5)
                        {
                            _local4 = (_local4 + (("[" + _local5.join("][")) + "]"));
                        };
                    };
                    _local2 = (((_local2 == null)) ? _local4 : ((_local4 + ".") + _local2));
                    _local3 = _local3.parent;
                };
            }
            catch(e:SecurityError)
            {
            };
            return (_local2);
        }

        public static function getUnqualifiedClassName(_arg1:Object):String
        {
            var _local2:String;
            if ((_arg1 is String))
            {
                _local2 = (_arg1 as String);
            }
            else
            {
                _local2 = getQualifiedClassName(_arg1);
            };
            var _local3:int = _local2.indexOf("::");
            if (_local3 != -1)
            {
                _local2 = _local2.substr((_local3 + 2));
            };
            return (_local2);
        }


    }
}

