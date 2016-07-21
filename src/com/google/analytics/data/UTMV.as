package com.google.analytics.data
{
    import com.google.analytics.utils.Timespan;

    public class UTMV extends UTMCookie 
    {

        private var _domainHash:Number;
        private var _value:String;

        public function UTMV(_arg1:Number=NaN, _arg2:String="")
        {
            super("utmv", "__utmv", ["domainHash", "value"], (Timespan.twoyears * 1000));
            this.domainHash = _arg1;
            this.value = _arg2;
        }

        public function get value():String
        {
            return (_value);
        }

        public function get domainHash():Number
        {
            return (_domainHash);
        }

        public function set domainHash(_arg1:Number):void
        {
            _domainHash = _arg1;
            update();
        }

        public function set value(_arg1:String):void
        {
            _value = _arg1;
            update();
        }


    }
}

