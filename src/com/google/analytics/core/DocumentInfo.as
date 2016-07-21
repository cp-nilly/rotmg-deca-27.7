package com.google.analytics.core
{
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.Variables;

    public class DocumentInfo 
    {

        private var _pageURL:String;
        private var _utmr:String;
        private var _config:Configuration;
        private var _adSense:AdSenseGlobals;
        private var _info:Environment;

        public function DocumentInfo(_arg1:Configuration, _arg2:Environment, _arg3:String, _arg4:String=null, _arg5:AdSenseGlobals=null)
        {
            _config = _arg1;
            _info = _arg2;
            _utmr = _arg3;
            _pageURL = _arg4;
            _adSense = _arg5;
        }

        public function get utmr():String
        {
            if (!_utmr)
            {
                return ("-");
            };
            return (_utmr);
        }

        public function toURLString():String
        {
            var _local1:Variables = toVariables();
            return (_local1.toString());
        }

        private function _renderPageURL(_arg1:String=""):String
        {
            var _local2:String = _info.locationPath;
            var _local3:String = _info.locationSearch;
            if (((!(_arg1)) || ((_arg1 == ""))))
            {
                _arg1 = (_local2 + unescape(_local3));
                if (_arg1 == "")
                {
                    _arg1 = "/";
                };
            };
            return (_arg1);
        }

        public function get utmp():String
        {
            return (_renderPageURL(_pageURL));
        }

        public function get utmhid():String
        {
            return (String(_generateHitId()));
        }

        private function _generateHitId():Number
        {
            var _local1:Number;
            if (((_adSense.hid) && (!((_adSense.hid == "")))))
            {
                _local1 = Number(_adSense.hid);
            }
            else
            {
                _local1 = Math.round((Math.random() * 2147483647));
                _adSense.hid = String(_local1);
            };
            return (_local1);
        }

        public function toVariables():Variables
        {
            var _local1:Variables = new Variables();
            _local1.URIencode = true;
            if (((_config.detectTitle) && (!((utmdt == "")))))
            {
                _local1.utmdt = utmdt;
            };
            _local1.utmhid = utmhid;
            _local1.utmr = utmr;
            _local1.utmp = utmp;
            return (_local1);
        }

        public function get utmdt():String
        {
            return (_info.documentTitle);
        }


    }
}

