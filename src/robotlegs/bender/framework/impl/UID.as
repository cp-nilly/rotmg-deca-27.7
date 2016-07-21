package robotlegs.bender.framework.impl
{
    import flash.utils.getQualifiedClassName;

    public class UID 
    {

        private static var _i:uint;


        public static function create(_arg1:*=null):String
        {
            if ((_arg1 is Class))
            {
                _arg1 = getQualifiedClassName(_arg1).split("::").pop();
            };
            return ((((((_arg1) ? (_arg1 + "-") : "") + _i++.toString(16)) + "-") + (Math.random() * 0xFF).toString(16)));
        }


    }
}

