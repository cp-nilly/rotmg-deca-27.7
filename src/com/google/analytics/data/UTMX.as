package com.google.analytics.data
{
    public class UTMX extends UTMCookie 
    {

        private var _value:String;

        public function UTMX()
        {
            super("utmx", "__utmx", ["value"], 0);
            _value = "-";
        }

        public function get value():String
        {
            return (_value);
        }

        public function set value(_arg1:String):void
        {
            _value = _arg1;
        }


    }
}

