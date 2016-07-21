package com.google.analytics.core
{
    public class OrganicReferrer 
    {

        private var _engine:String;
        private var _keyword:String;

        public function OrganicReferrer(_arg1:String, _arg2:String)
        {
            this.engine = _arg1;
            this.keyword = _arg2;
        }

        public function get keyword():String
        {
            return (_keyword);
        }

        public function get engine():String
        {
            return (_engine);
        }

        public function set engine(_arg1:String):void
        {
            _engine = _arg1.toLowerCase();
        }

        public function toString():String
        {
            return (((engine + "?") + keyword));
        }

        public function set keyword(_arg1:String):void
        {
            _keyword = _arg1.toLowerCase();
        }


    }
}

