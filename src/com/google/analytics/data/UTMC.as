package com.google.analytics.data
{
    public class UTMC extends UTMCookie 
    {

        private var _domainHash:Number;

        public function UTMC(_arg1:Number=NaN)
        {
            super("utmc", "__utmc", ["domainHash"]);
            this.domainHash = _arg1;
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


    }
}

