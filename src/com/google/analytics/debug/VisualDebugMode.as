package com.google.analytics.debug
{
    public class VisualDebugMode 
    {

        public static const basic:VisualDebugMode = new (VisualDebugMode)(0, "basic");
        public static const advanced:VisualDebugMode = new (VisualDebugMode)(1, "advanced");
        public static const geek:VisualDebugMode = new (VisualDebugMode)(2, "geek");

        private var _value:int;
        private var _name:String;

        public function VisualDebugMode(_arg1:int=0, _arg2:String="")
        {
            _value = _arg1;
            _name = _arg2;
        }

        public function valueOf():int
        {
            return (_value);
        }

        public function toString():String
        {
            return (_name);
        }


    }
}

