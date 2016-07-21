package com.google.analytics.utils
{
    import com.google.analytics.external.HTMLDOM;
    import com.google.analytics.debug.DebugConfiguration;
    import flash.system.Security;
    import flash.system.Capabilities;
    import flash.system.System;
    import com.google.analytics.core.ga_internal;

    use namespace ga_internal;

    public class Environment 
    {

        private var _dom:HTMLDOM;
        private var _appName:String;
        private var _debug:DebugConfiguration;
        private var _appVersion:Version;
        private var _url:String;
        private var _protocol:Protocols;
        private var _userAgent:UserAgent;

        public function Environment(_arg1:String="", _arg2:String="", _arg3:String="", _arg4:DebugConfiguration=null, _arg5:HTMLDOM=null)
        {
            var _local6:Version;
            super();
            if (_arg2 == "")
            {
                if (isAIR())
                {
                    _arg2 = "AIR";
                }
                else
                {
                    _arg2 = "Flash";
                };
            };
            if (_arg3 == "")
            {
                _local6 = flashVersion;
            }
            else
            {
                _local6 = Version.fromString(_arg3);
            };
            _url = _arg1;
            _appName = _arg2;
            _appVersion = _local6;
            _debug = _arg4;
            _dom = _arg5;
        }

        public function isAIR():Boolean
        {
            return ((((playerType == "Desktop")) && ((Security.sandboxType.toString() == "application"))));
        }

        public function get screenWidth():Number
        {
            return (Capabilities.screenResolutionX);
        }

        public function get playerType():String
        {
            return (Capabilities.playerType);
        }

        public function get locationSearch():String
        {
            var _local1:String = _dom.search;
            if (_local1)
            {
                return (_local1);
            };
            return ("");
        }

        public function get protocol():Protocols
        {
            if (!_protocol)
            {
                _findProtocol();
            };
            return (_protocol);
        }

        public function get flashVersion():Version
        {
            return (Version.fromString(Capabilities.version.split(" ")[1], ","));
        }

        public function get userAgent():UserAgent
        {
            if (!_userAgent)
            {
                _userAgent = new UserAgent(this, appName, appVersion.toString(4));
            };
            return (_userAgent);
        }

        public function get languageEncoding():String
        {
            var _local1:String;
            if (System.useCodePage)
            {
                _local1 = _dom.characterSet;
                if (_local1)
                {
                    return (_local1);
                };
                return ("-");
            };
            return ("UTF-8");
        }

        public function get appName():String
        {
            return (_appName);
        }

        public function get screenColorDepth():String
        {
            var _local1:String;
            switch (Capabilities.screenColor)
            {
                case "bw":
                    _local1 = "1";
                    break;
                case "gray":
                    _local1 = "2";
                    break;
                case "color":
                default:
                    _local1 = "24";
            };
            var _local2:String = _dom.colorDepth;
            if (_local2)
            {
                _local1 = _local2;
            };
            return (_local1);
        }

        private function _findProtocol():void
        {
            var _local4:String;
            var _local5:String;
            var _local1:Protocols = Protocols.none;
            if (_url != "")
            {
                _local4 = _url.toLowerCase();
                _local5 = _local4.substr(0, 5);
                switch (_local5)
                {
                    case "file:":
                        _local1 = Protocols.file;
                        break;
                    case "http:":
                        _local1 = Protocols.HTTP;
                        break;
                    case "https":
                        if (_local4.charAt(5) == ":")
                        {
                            _local1 = Protocols.HTTPS;
                        };
                        break;
                    default:
                        _protocol = Protocols.none;
                };
            };
            var _local2:String = _dom.protocol;
            var _local3:String = (_local1.toString() + ":").toLowerCase();
            if (((((_local2) && (!((_local2 == _local3))))) && (_debug)))
            {
                _debug.warning(((("Protocol mismatch: SWF=" + _local3) + ", DOM=") + _local2));
            };
            _protocol = _local1;
        }

        public function get locationSWFPath():String
        {
            return (_url);
        }

        public function get platform():String
        {
            var _local1:String = Capabilities.manufacturer;
            return (_local1.split("Adobe ")[1]);
        }

        public function get operatingSystem():String
        {
            return (Capabilities.os);
        }

        public function set appName(_arg1:String):void
        {
            _appName = _arg1;
            userAgent.applicationProduct = _arg1;
        }

        ga_internal function set url(_arg1:String):void
        {
            _url = _arg1;
        }

        public function get referrer():String
        {
            var _local1:String = _dom.referrer;
            if (_local1)
            {
                return (_local1);
            };
            if (protocol == Protocols.file)
            {
                return ("localhost");
            };
            return ("");
        }

        public function isInHTML():Boolean
        {
            return ((Capabilities.playerType == "PlugIn"));
        }

        public function get language():String
        {
            var _local1:String = _dom.language;
            var _local2:String = Capabilities.language;
            if (_local1)
            {
                if ((((_local1.length > _local2.length)) && ((_local1.substr(0, _local2.length) == _local2))))
                {
                    _local2 = _local1;
                };
            };
            return (_local2);
        }

        public function get domainName():String
        {
            var _local1:String;
            var _local2:String;
            var _local3:int;
            if ((((protocol == Protocols.HTTP)) || ((protocol == Protocols.HTTPS))))
            {
                _local1 = _url.toLowerCase();
                if (protocol == Protocols.HTTP)
                {
                    _local2 = _local1.split("http://").join("");
                }
                else
                {
                    if (protocol == Protocols.HTTPS)
                    {
                        _local2 = _local1.split("https://").join("");
                    };
                };
                _local3 = _local2.indexOf("/");
                if (_local3 > -1)
                {
                    _local2 = _local2.substring(0, _local3);
                };
                return (_local2);
            };
            if (protocol == Protocols.file)
            {
                return ("localhost");
            };
            return ("");
        }

        public function set userAgent(_arg1:UserAgent):void
        {
            _userAgent = _arg1;
        }

        public function set appVersion(_arg1:Version):void
        {
            _appVersion = _arg1;
            userAgent.applicationVersion = _arg1.toString(4);
        }

        public function get screenHeight():Number
        {
            return (Capabilities.screenResolutionY);
        }

        public function get locationPath():String
        {
            var _local1:String = _dom.pathname;
            if (_local1)
            {
                return (_local1);
            };
            return ("");
        }

        public function get documentTitle():String
        {
            var _local1:String = _dom.title;
            if (_local1)
            {
                return (_local1);
            };
            return ("");
        }

        public function get appVersion():Version
        {
            return (_appVersion);
        }


    }
}

