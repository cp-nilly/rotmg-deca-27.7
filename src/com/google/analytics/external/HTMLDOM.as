package com.google.analytics.external
{
    import com.google.analytics.debug.DebugConfiguration;

    public class HTMLDOM extends JavascriptProxy 
    {

        public static var cache_properties_js:XML = <script>
            <![CDATA[
                    function()
                    {
                        var obj = {};
                            obj.host         = document.location.host;
                            obj.language     = navigator.language ? navigator.language : navigator.browserLanguage;
                            obj.characterSet = document.characterSet ? document.characterSet : document.charset;
                            obj.colorDepth   = window.screen.colorDepth;
                            obj.location     = document.location.toString();
                            obj.pathname     = document.location.pathname;
                            obj.protocol     = document.location.protocol;
                            obj.search       = document.location.search;
                            obj.referrer     = document.referrer;
                            obj.title        = document.title;
                        
                        return obj;
                    }
                ]]>
         </script>
        ;

        private var _referrer:String;
        private var _language:String;
        private var _host:String;
        private var _pathname:String;
        private var _location:String;
        private var _search:String;
        private var _characterSet:String;
        private var _title:String;
        private var _protocol:String;
        private var _colorDepth:String;

        public function HTMLDOM(_arg1:DebugConfiguration)
        {
            super(_arg1);
        }

        public function get search():String
        {
            if (_search)
            {
                return (_search);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _search = getProperty("document.location.search");
            return (_search);
        }

        public function get location():String
        {
            if (_location)
            {
                return (_location);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _location = getPropertyString("document.location");
            return (_location);
        }

        public function get pathname():String
        {
            if (_pathname)
            {
                return (_pathname);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _pathname = getProperty("document.location.pathname");
            return (_pathname);
        }

        public function cacheProperties():void
        {
            if (!isAvailable())
            {
                return;
            };
            var _local1:Object = call(cache_properties_js);
            if (_local1)
            {
                _host = _local1.host;
                _language = _local1.language;
                _characterSet = _local1.characterSet;
                _colorDepth = _local1.colorDepth;
                _location = _local1.location;
                _pathname = _local1.pathname;
                _protocol = _local1.protocol;
                _search = _local1.search;
                _referrer = _local1.referrer;
                _title = _local1.title;
            };
        }

        public function get language():String
        {
            if (_language)
            {
                return (_language);
            };
            if (!isAvailable())
            {
                return (null);
            };
            var _local1:String = getProperty("navigator.language");
            if (_local1 == null)
            {
                _local1 = getProperty("navigator.browserLanguage");
            };
            _language = _local1;
            return (_language);
        }

        public function get colorDepth():String
        {
            if (_colorDepth)
            {
                return (_colorDepth);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _colorDepth = getProperty("window.screen.colorDepth");
            return (_colorDepth);
        }

        public function get referrer():String
        {
            if (_referrer)
            {
                return (_referrer);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _referrer = getProperty("document.referrer");
            return (_referrer);
        }

        public function get protocol():String
        {
            if (_protocol)
            {
                return (_protocol);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _protocol = getProperty("document.location.protocol");
            return (_protocol);
        }

        public function get host():String
        {
            if (_host)
            {
                return (_host);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _host = getProperty("document.location.host");
            return (_host);
        }

        public function get characterSet():String
        {
            if (_characterSet)
            {
                return (_characterSet);
            };
            if (!isAvailable())
            {
                return (null);
            };
            var _local1:String = getProperty("document.characterSet");
            if (_local1 == null)
            {
                _local1 = getProperty("document.charset");
            };
            _characterSet = _local1;
            return (_characterSet);
        }

        public function get title():String
        {
            if (_title)
            {
                return (_title);
            };
            if (!isAvailable())
            {
                return (null);
            };
            _title = getProperty("document.title");
            return (_title);
        }


    }
}

