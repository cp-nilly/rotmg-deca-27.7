package com.google.analytics.core
{
    public class DomainNameMode 
    {

        public static const none:DomainNameMode = new (DomainNameMode)(0, "none");
        public static const auto:DomainNameMode = new (DomainNameMode)(1, "auto");
        public static const custom:DomainNameMode = new (DomainNameMode)(2, "custom");

        private var _value:int;
        private var _name:String;

        public function DomainNameMode(_arg1:int=0, _arg2:String="")
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

