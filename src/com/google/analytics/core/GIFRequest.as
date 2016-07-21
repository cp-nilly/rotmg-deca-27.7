package com.google.analytics.core
{
    import com.google.analytics.utils.Environment;
    import com.google.analytics.debug.DebugConfiguration;
    import flash.net.URLRequest;
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.debug.VisualDebugMode;
    import flash.events.IOErrorEvent;
    import com.google.analytics.utils.Variables;
    import com.google.analytics.utils.Protocols;
    import flash.events.SecurityErrorEvent;
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import flash.events.Event;

    public class GIFRequest 
    {

        private var _info:Environment;
        private var _count:int;
        private var _utmac:String;
        private var _alertcount:int;
        private var _debug:DebugConfiguration;
        private var _lastRequest:URLRequest;
        private var _buffer:Buffer;
        private var _config:Configuration;
        private var _requests:Array;

        public function GIFRequest(_arg1:Configuration, _arg2:DebugConfiguration, _arg3:Buffer, _arg4:Environment)
        {
            _config = _arg1;
            _debug = _arg2;
            _buffer = _arg3;
            _info = _arg4;
            _count = 0;
            _alertcount = 0;
            _requests = [];
        }

        public function get utmn():String
        {
            return ((Utils.generate32bitRandom() as String));
        }

        public function onIOError(_arg1:IOErrorEvent):void
        {
            var _local2:String = _lastRequest.url;
            var _local3:String = String((_requests.length - 1));
            var _local4 = (("Gif Request #" + _local3) + " failed");
            if (_debug.GIFRequests)
            {
                if (!_debug.verbose)
                {
                    if (_local2.indexOf("?") > -1)
                    {
                        _local2 = _local2.split("?")[0];
                    };
                    _local2 = _shortenURL(_local2);
                };
                if (int(_debug.mode) > int(VisualDebugMode.basic))
                {
                    _local4 = (_local4 + ((' "' + _local2) + '" does not exists or is unreachable'));
                };
                _debug.failure(_local4);
            }
            else
            {
                _debug.warning(_local4);
            };
            _removeListeners(_arg1.target);
        }

        public function send(_arg1:String, _arg2:Variables=null, _arg3:Boolean=false, _arg4:Boolean=false):void
        {
            var _local5:String;
            var _local6:URLRequest;
            var _local7:URLRequest;
            _utmac = _arg1;
            if (!_arg2)
            {
                _arg2 = new Variables();
            };
            _arg2.URIencode = false;
            _arg2.pre = ["utmwv", "utmn", "utmhn", "utmt", "utme", "utmcs", "utmsr", "utmsc", "utmul", "utmje", "utmfl", "utmdt", "utmhid", "utmr", "utmp"];
            _arg2.post = ["utmcc"];
            if (_debug.verbose)
            {
                _debug.info(((("tracking: " + _buffer.utmb.trackCount) + "/") + _config.trackingLimitPerSession), VisualDebugMode.geek);
            };
            if ((((_buffer.utmb.trackCount < _config.trackingLimitPerSession)) || (_arg3)))
            {
                if (_arg4)
                {
                    updateToken();
                };
                if (((((_arg3) || (!(_arg4)))) || ((_buffer.utmb.token >= 1))))
                {
                    if (((!(_arg3)) && (_arg4)))
                    {
                        _buffer.utmb.token--;
                    };
                    _buffer.utmb.trackCount = (_buffer.utmb.trackCount + 1);
                    if (_debug.verbose)
                    {
                        _debug.info(_buffer.utmb.toString(), VisualDebugMode.geek);
                    };
                    _arg2.utmwv = utmwv;
                    _arg2.utmn = Utils.generate32bitRandom();
                    if (_info.domainName != "")
                    {
                        _arg2.utmhn = _info.domainName;
                    };
                    if (_config.sampleRate < 1)
                    {
                        _arg2.utmsp = (_config.sampleRate * 100);
                    };
                    if ((((_config.serverMode == ServerOperationMode.local)) || ((_config.serverMode == ServerOperationMode.both))))
                    {
                        _local5 = _info.locationSWFPath;
                        if (_local5.lastIndexOf("/") > 0)
                        {
                            _local5 = _local5.substring(0, _local5.lastIndexOf("/"));
                        };
                        _local6 = new URLRequest();
                        if (_config.localGIFpath.indexOf("http") == 0)
                        {
                            _local6.url = _config.localGIFpath;
                        }
                        else
                        {
                            _local6.url = (_local5 + _config.localGIFpath);
                        };
                        _local6.url = (_local6.url + ("?" + _arg2.toString()));
                        if (((_debug.active) && (_debug.GIFRequests)))
                        {
                            _debugSend(_local6);
                        }
                        else
                        {
                            sendRequest(_local6);
                        };
                    };
                    if ((((_config.serverMode == ServerOperationMode.remote)) || ((_config.serverMode == ServerOperationMode.both))))
                    {
                        _local7 = new URLRequest();
                        if (_info.protocol == Protocols.HTTPS)
                        {
                            _local7.url = _config.secureRemoteGIFpath;
                        }
                        else
                        {
                            if (_info.protocol == Protocols.HTTP)
                            {
                                _local7.url = _config.remoteGIFpath;
                            }
                            else
                            {
                                _local7.url = _config.remoteGIFpath;
                            };
                        };
                        _arg2.utmac = utmac;
                        _arg2.utmcc = encodeURIComponent(utmcc);
                        _local7.url = (_local7.url + ("?" + _arg2.toString()));
                        if (((_debug.active) && (_debug.GIFRequests)))
                        {
                            _debugSend(_local7);
                        }
                        else
                        {
                            sendRequest(_local7);
                        };
                    };
                };
            };
        }

        public function onSecurityError(_arg1:SecurityErrorEvent):void
        {
            if (_debug.GIFRequests)
            {
                _debug.failure(_arg1.text);
            };
        }

        public function get utmsp():String
        {
            return (((_config.sampleRate * 100) as String));
        }

        public function get utmcc():String
        {
            var _local1:Array = [];
            if (_buffer.hasUTMA())
            {
                _local1.push((_buffer.utma.toURLString() + ";"));
            };
            if (_buffer.hasUTMZ())
            {
                _local1.push((_buffer.utmz.toURLString() + ";"));
            };
            if (_buffer.hasUTMV())
            {
                _local1.push((_buffer.utmv.toURLString() + ";"));
            };
            return (_local1.join("+"));
        }

        public function get utmac():String
        {
            return (_utmac);
        }

        public function get utmwv():String
        {
            return (_config.version);
        }

        public function sendRequest(request:URLRequest):void
        {
            var loader:Loader = new Loader();
            loader.name = String(_count++);
            var context:LoaderContext = new LoaderContext(false);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            _lastRequest = request;
            _requests[loader.name] = new RequestObject(request);
            try
            {
                loader.load(request, context);
            }
            catch(e:Error)
            {
                _debug.failure('"Loader.load()" could not instanciate Gif Request');
            };
        }

        private function _removeListeners(_arg1:Object):void
        {
            _arg1.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _arg1.removeEventListener(Event.COMPLETE, onComplete);
        }

        public function updateToken():void
        {
            var _local2:Number;
            var _local1:Number = new Date().getTime();
            _local2 = ((_local1 - _buffer.utmb.lastTime) * (_config.tokenRate / 1000));
            if (_debug.verbose)
            {
                _debug.info(("tokenDelta: " + _local2), VisualDebugMode.geek);
            };
            if (_local2 >= 1)
            {
                _buffer.utmb.token = Math.min(Math.floor((_buffer.utmb.token + _local2)), _config.bucketCapacity);
                _buffer.utmb.lastTime = _local1;
                if (_debug.verbose)
                {
                    _debug.info(_buffer.utmb.toString(), VisualDebugMode.geek);
                };
            };
        }

        public function get utmhn():String
        {
            return (_info.domainName);
        }

        private function _shortenURL(_arg1:String):String
        {
            var _local2:Array;
            if (_arg1.length > 60)
            {
                _local2 = _arg1.split("/");
                while (_arg1.length > 60)
                {
                    _local2.shift();
                    _arg1 = ("../" + _local2.join("/"));
                };
            };
            return (_arg1);
        }

        private function _debugSend(_arg1:URLRequest):void
        {
            var _local3:String;
            var _local2 = "";
            switch (_debug.mode)
            {
                case VisualDebugMode.geek:
                    _local2 = ((("Gif Request #" + _alertcount) + ":\n") + _arg1.url);
                    break;
                case VisualDebugMode.advanced:
                    _local3 = _arg1.url;
                    if (_local3.indexOf("?") > -1)
                    {
                        _local3 = _local3.split("?")[0];
                    };
                    _local3 = _shortenURL(_local3);
                    _local2 = (((("Send Gif Request #" + _alertcount) + ":\n") + _local3) + " ?");
                    break;
                case VisualDebugMode.basic:
                default:
                    _local2 = (((("Send " + _config.serverMode.toString()) + " Gif Request #") + _alertcount) + " ?");
            };
            _debug.alertGifRequest(_local2, _arg1, this);
            _alertcount++;
        }

        public function onComplete(_arg1:Event):void
        {
            var _local2:String = _arg1.target.loader.name;
            _requests[_local2].complete();
            var _local3 = (("Gif Request #" + _local2) + " sent");
            var _local4:String = _requests[_local2].request.url;
            if (_debug.GIFRequests)
            {
                if (!_debug.verbose)
                {
                    if (_local4.indexOf("?") > -1)
                    {
                        _local4 = _local4.split("?")[0];
                    };
                    _local4 = _shortenURL(_local4);
                };
                if (int(_debug.mode) > int(VisualDebugMode.basic))
                {
                    _local3 = (_local3 + ((' to "' + _local4) + '"'));
                };
                _debug.success(_local3);
            }
            else
            {
                _debug.info(_local3);
            };
            _removeListeners(_arg1.target);
        }


    }
}

