package com.google.analytics.utils
{
    public class URL 
    {

        private var _url:String;

        public function URL(_arg1:String="")
        {
            _url = _arg1.toLowerCase();
        }

        public function get domain():String
        {
            var _local1:Array;
            if (((!((hostName == ""))) && ((hostName.indexOf(".") > -1))))
            {
                _local1 = hostName.split(".");
                switch (_local1.length)
                {
                    case 2:
                        return (hostName);
                    case 3:
                        if (_local1[1] == "co")
                        {
                            return (hostName);
                        };
                        _local1.shift();
                        return (_local1.join("."));
                    case 4:
                        _local1.shift();
                        return (_local1.join("."));
                };
            };
            return ("");
        }

        public function get path():String
        {
            var _local1:String = _url;
            if (_local1.indexOf("://") > -1)
            {
                _local1 = _local1.split("://")[1];
            };
            if (_local1.indexOf(hostName) == 0)
            {
                _local1 = _local1.substr(hostName.length);
            };
            if (_local1.indexOf("?") > -1)
            {
                _local1 = _local1.split("?")[0];
            };
            if (_local1.charAt(0) != "/")
            {
                _local1 = ("/" + _local1);
            };
            return (_local1);
        }

        public function get protocol():Protocols
        {
            var _local1:String = _url.split("://")[0];
            switch (_local1)
            {
                case "file":
                    return (Protocols.file);
                case "http":
                    return (Protocols.HTTP);
                case "https":
                    return (Protocols.HTTPS);
                default:
                    return (Protocols.none);
            };
        }

        public function get hostName():String
        {
            var _local1:String = _url;
            if (_local1.indexOf("://") > -1)
            {
                _local1 = _local1.split("://")[1];
            };
            if (_local1.indexOf("/") > -1)
            {
                _local1 = _local1.split("/")[0];
            };
            if (_local1.indexOf("?") > -1)
            {
                _local1 = _local1.split("?")[0];
            };
            if ((((protocol == Protocols.file)) || ((protocol == Protocols.none))))
            {
                return ("");
            };
            return (_local1);
        }

        public function get subDomain():String
        {
            if (((!((domain == ""))) && (!((domain == hostName)))))
            {
                return (hostName.split(("." + domain)).join(""));
            };
            return ("");
        }

        public function get search():String
        {
            var _local1:String = _url;
            if (_local1.indexOf("://") > -1)
            {
                _local1 = _local1.split("://")[1];
            };
            if (_local1.indexOf(hostName) == 0)
            {
                _local1 = _local1.substr(hostName.length);
            };
            if (_local1.indexOf("?") > -1)
            {
                _local1 = _local1.split("?")[1];
            }
            else
            {
                _local1 = "";
            };
            return (_local1);
        }


    }
}

