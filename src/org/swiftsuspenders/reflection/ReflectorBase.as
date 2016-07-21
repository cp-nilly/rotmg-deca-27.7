package org.swiftsuspenders.reflection
{
    import flash.utils.Proxy;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class ReflectorBase 
    {


        public function getClass(_arg1:Object):Class
        {
            if ((((((((_arg1 is Proxy)) || ((_arg1 is Number)))) || ((_arg1 is XML)))) || ((_arg1 is XMLList))))
            {
                return (Class(getDefinitionByName(getQualifiedClassName(_arg1))));
            };
            return (_arg1.constructor);
        }

        public function getFQCN(_arg1:*, _arg2:Boolean=false):String
        {
            var _local3:String;
            var _local4:int;
            if ((_arg1 is String))
            {
                _local3 = _arg1;
                if (((!(_arg2)) && ((_local3.indexOf("::") == -1))))
                {
                    _local4 = _local3.lastIndexOf(".");
                    if (_local4 == -1)
                    {
                        return (_local3);
                    };
                    return (((_local3.substring(0, _local4) + "::") + _local3.substring((_local4 + 1))));
                };
            }
            else
            {
                _local3 = getQualifiedClassName(_arg1);
            };
            return (((_arg2) ? _local3.replace("::", ".") : _local3));
        }


    }
}

