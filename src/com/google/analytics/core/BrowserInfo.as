package com.google.analytics.core
{
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.Variables;
    import com.google.analytics.utils.Version;

    public class BrowserInfo 
    {

        private var _config:Configuration;
        private var _info:Environment;

        public function BrowserInfo(_arg1:Configuration, _arg2:Environment)
        {
            _config = _arg1;
            _info = _arg2;
        }

        public function get utmul():String
        {
            return (_info.language.toLowerCase());
        }

        public function get utmje():String
        {
            return ("0");
        }

        public function toURLString():String
        {
            var _local1:Variables = toVariables();
            return (_local1.toString());
        }

        public function get utmsr():String
        {
            return (((_info.screenWidth + "x") + _info.screenHeight));
        }

        public function get utmfl():String
        {
            var _local1:Version;
            if (_config.detectFlash)
            {
                _local1 = _info.flashVersion;
                return (((((_local1.major + ".") + _local1.minor) + " r") + _local1.build));
            };
            return ("-");
        }

        public function get utmcs():String
        {
            return (_info.languageEncoding);
        }

        public function toVariables():Variables
        {
            var _local1:Variables = new Variables();
            _local1.URIencode = true;
            _local1.utmcs = utmcs;
            _local1.utmsr = utmsr;
            _local1.utmsc = utmsc;
            _local1.utmul = utmul;
            _local1.utmje = utmje;
            _local1.utmfl = utmfl;
            return (_local1);
        }

        public function get utmsc():String
        {
            return ((_info.screenColorDepth + "-bit"));
        }


    }
}

