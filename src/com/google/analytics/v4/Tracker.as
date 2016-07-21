package com.google.analytics.v4
{
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.data.X10;
    import com.google.analytics.core.BrowserInfo;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.core.Buffer;
    import com.google.analytics.campaign.CampaignManager;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.campaign.CampaignInfo;
    import com.google.analytics.core.GIFRequest;
    import com.google.analytics.core.Ecommerce;
    import com.google.analytics.core.Utils;
    import com.google.analytics.utils.Protocols;
    import com.google.analytics.debug.VisualDebugMode;
    import com.google.analytics.ecommerce.Transaction;
    import com.google.analytics.utils.Variables;
    import com.google.analytics.core.EventInfo;
    import com.google.analytics.utils.URL;
    import com.google.analytics.core.EventTracker;
    import com.google.analytics.core.DomainNameMode;
    import com.google.analytics.core.DocumentInfo;
    import com.google.analytics.core.ServerOperationMode;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class Tracker implements GoogleAnalyticsAPI 
    {

        private const EVENT_TRACKER_LABEL_KEY_NUM:int = 3;
        private const EVENT_TRACKER_VALUE_VALUE_NUM:int = 1;
        private const EVENT_TRACKER_PROJECT_ID:int = 5;
        private const EVENT_TRACKER_OBJECT_NAME_KEY_NUM:int = 1;
        private const EVENT_TRACKER_TYPE_KEY_NUM:int = 2;

        private var _adSense:AdSenseGlobals;
        private var _eventTracker:X10;
        private var _noSessionInformation:Boolean = false;
        private var _browserInfo:BrowserInfo;
        private var _debug:DebugConfiguration;
        private var _isNewVisitor:Boolean = false;
        private var _buffer:Buffer;
        private var _config:Configuration;
        private var _x10Module:X10;
        private var _campaign:CampaignManager;
        private var _formatedReferrer:String;
        private var _timeStamp:Number;
        private var _info:Environment;
        private var _domainHash:Number;
        private var _campaignInfo:CampaignInfo;
        private var _gifRequest:GIFRequest;
        private var _hasInitData:Boolean = false;
        private var _ecom:Ecommerce;
        private var _account:String;

        public function Tracker(_arg1:String, _arg2:Configuration, _arg3:DebugConfiguration, _arg4:Environment, _arg5:Buffer, _arg6:GIFRequest, _arg7:AdSenseGlobals, _arg8:Ecommerce)
        {
            var _local9:String;
            super();
            _account = _arg1;
            _config = _arg2;
            _debug = _arg3;
            _info = _arg4;
            _buffer = _arg5;
            _gifRequest = _arg6;
            _adSense = _arg7;
            _ecom = _arg8;
            if (!Utils.validateAccount(_arg1))
            {
                _local9 = (('Account "' + _arg1) + '" is not valid.');
                _debug.warning(_local9);
                throw (new Error(_local9));
            };
        }

        private function _doTracking():Boolean
        {
            if (((((!((_info.protocol == Protocols.file))) && (!((_info.protocol == Protocols.none))))) && (_isNotGoogleSearch())))
            {
                return (true);
            };
            if (_config.allowLocalTracking)
            {
                return (true);
            };
            return (false);
        }

        public function addOrganic(_arg1:String, _arg2:String):void
        {
            _debug.info((("addOrganic( " + [_arg1, _arg2].join(", ")) + " )"));
            _config.organic.addSource(_arg1, _arg2);
        }

        public function setAllowLinker(_arg1:Boolean):void
        {
            _config.allowLinker = _arg1;
            _debug.info((("setAllowLinker( " + _config.allowLinker) + " )"));
        }

        public function getLinkerUrl(_arg1:String="", _arg2:Boolean=false):String
        {
            _initData();
            _debug.info((((("getLinkerUrl( " + _arg1) + ", ") + _arg2.toString()) + " )"));
            return (_buffer.getLinkerUrl(_arg1, _arg2));
        }

        public function trackEvent(_arg1:String, _arg2:String, _arg3:String=null, _arg4:Number=NaN):Boolean
        {
            _initData();
            var _local5:Boolean = true;
            var _local6:int = 2;
            if (((!((_arg1 == ""))) && (!((_arg2 == "")))))
            {
                _eventTracker.clearKey(EVENT_TRACKER_PROJECT_ID);
                _eventTracker.clearValue(EVENT_TRACKER_PROJECT_ID);
                _local5 = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID, EVENT_TRACKER_OBJECT_NAME_KEY_NUM, _arg1);
                _local5 = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID, EVENT_TRACKER_TYPE_KEY_NUM, _arg2);
                if (_arg3)
                {
                    _local5 = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID, EVENT_TRACKER_LABEL_KEY_NUM, _arg3);
                    _local6 = 3;
                };
                if (!isNaN(_arg4))
                {
                    _local5 = _eventTracker.setValue(EVENT_TRACKER_PROJECT_ID, EVENT_TRACKER_VALUE_VALUE_NUM, _arg4);
                    _local6 = 4;
                };
                if (_local5)
                {
                    _debug.info(((("valid event tracking call\ncategory: " + _arg1) + "\naction: ") + _arg2), VisualDebugMode.geek);
                    _sendXEvent(_eventTracker);
                };
            }
            else
            {
                _debug.warning(((("event tracking call is not valid, failed!\ncategory: " + _arg1) + "\naction: ") + _arg2), VisualDebugMode.geek);
                _local5 = false;
            };
            switch (_local6)
            {
                case 4:
                    _debug.info((("trackEvent( " + [_arg1, _arg2, _arg3, _arg4].join(", ")) + " )"));
                    break;
                case 3:
                    _debug.info((("trackEvent( " + [_arg1, _arg2, _arg3].join(", ")) + " )"));
                    break;
                case 2:
                default:
                    _debug.info((("trackEvent( " + [_arg1, _arg2].join(", ")) + " )"));
            };
            return (_local5);
        }

        public function trackPageview(_arg1:String=""):void
        {
            _debug.info((("trackPageview( " + _arg1) + " )"));
            if (_doTracking())
            {
                _initData();
                _trackMetrics(_arg1);
                _noSessionInformation = false;
            }
            else
            {
                _debug.warning((("trackPageview( " + _arg1) + " ) failed"));
            };
        }

        public function setCookieTimeout(_arg1:int):void
        {
            _config.conversionTimeout = _arg1;
            _debug.info((("setCookieTimeout( " + _config.conversionTimeout) + " )"));
        }

        public function trackTrans():void
        {
            var _local1:Number;
            var _local2:Number;
            var _local4:Transaction;
            _initData();
            var _local3:Array = new Array();
            if (_takeSample())
            {
                _local1 = 0;
                while (_local1 < _ecom.getTransLength())
                {
                    _local4 = _ecom.getTransFromArray(_local1);
                    _local3.push(_local4.toGifParams());
                    _local2 = 0;
                    while (_local2 < _local4.getItemsLength())
                    {
                        _local3.push(_local4.getItemFromArray(_local2).toGifParams());
                        _local2++;
                    };
                    _local1++;
                };
                _local1 = 0;
                while (_local1 < _local3.length)
                {
                    _gifRequest.send(_account, _local3[_local1]);
                    _local1++;
                };
            };
        }

        public function setClientInfo(_arg1:Boolean):void
        {
            _config.detectClientInfo = _arg1;
            _debug.info((("setClientInfo( " + _config.detectClientInfo) + " )"));
        }

        public function linkByPost(_arg1:Object, _arg2:Boolean=false):void
        {
            _debug.warning("linkByPost not implemented in AS3 mode");
        }

        private function _initData():void
        {
            var _local1:String;
            var _local2:String;
            if (!_hasInitData)
            {
                _updateDomainName();
                _domainHash = _getDomainHash();
                _timeStamp = Math.round((new Date().getTime() / 1000));
                if (_debug.verbose)
                {
                    _local1 = "";
                    _local1 = (_local1 + "_initData 0");
                    _local1 = (_local1 + ("\ndomain name: " + _config.domainName));
                    _local1 = (_local1 + ("\ndomain hash: " + _domainHash));
                    _local1 = (_local1 + (((("\ntimestamp:   " + _timeStamp) + " (") + new Date((_timeStamp * 1000))) + ")"));
                    _debug.info(_local1, VisualDebugMode.geek);
                };
            };
            if (_doTracking())
            {
                _handleCookie();
            };
            if (!_hasInitData)
            {
                if (_doTracking())
                {
                    _formatedReferrer = _formatReferrer();
                    _browserInfo = new BrowserInfo(_config, _info);
                    _debug.info(("browserInfo: " + _browserInfo.toURLString()), VisualDebugMode.advanced);
                    if (_config.campaignTracking)
                    {
                        _campaign = new CampaignManager(_config, _debug, _buffer, _domainHash, _formatedReferrer, _timeStamp);
                        _campaignInfo = _campaign.getCampaignInformation(_info.locationSearch, _noSessionInformation);
                        _debug.info(("campaignInfo: " + _campaignInfo.toURLString()), VisualDebugMode.advanced);
                        _debug.info(("Search: " + _info.locationSearch));
                        _debug.info(("CampaignTrackig: " + _buffer.utmz.campaignTracking));
                    };
                };
                _x10Module = new X10();
                _eventTracker = new X10();
                _hasInitData = true;
            };
            if (_config.hasSiteOverlay)
            {
                _debug.warning("Site Overlay is not supported");
            };
            if (_debug.verbose)
            {
                _local2 = "";
                _local2 = (_local2 + "_initData (misc)");
                _local2 = (_local2 + ("\nflash version: " + _info.flashVersion.toString(4)));
                _local2 = (_local2 + ("\nprotocol: " + _info.protocol));
                _local2 = (_local2 + (('\ndefault domain name (auto): "' + _info.domainName) + '"'));
                _local2 = (_local2 + ("\nlanguage: " + _info.language));
                _local2 = (_local2 + ("\ndomain hash: " + _getDomainHash()));
                _local2 = (_local2 + ("\nuser-agent: " + _info.userAgent));
                _debug.info(_local2, VisualDebugMode.geek);
            };
        }

        public function getDetectTitle():Boolean
        {
            _debug.info("getDetectTitle()");
            return (_config.detectTitle);
        }

        public function resetSession():void
        {
            _debug.info("resetSession()");
            _buffer.resetCurrentSession();
        }

        public function getClientInfo():Boolean
        {
            _debug.info("getClientInfo()");
            return (_config.detectClientInfo);
        }

        private function _sendXEvent(_arg1:X10=null):void
        {
            var _local2:Variables;
            var _local3:EventInfo;
            var _local4:Variables;
            var _local5:Variables;
            if (_takeSample())
            {
                _local2 = new Variables();
                _local2.URIencode = true;
                _local3 = new EventInfo(true, _x10Module, _arg1);
                _local4 = _local3.toVariables();
                _local5 = _renderMetricsSearchVariables();
                _local2.join(_local4, _local5);
                _gifRequest.send(_account, _local2, false, true);
            };
        }

        public function setDetectFlash(_arg1:Boolean):void
        {
            _config.detectFlash = _arg1;
            _debug.info((("setDetectFlash( " + _config.detectFlash) + " )"));
        }

        public function setCampNameKey(_arg1:String):void
        {
            _config.campaignKey.UCCN = _arg1;
            var _local2 = (("setCampNameKey( " + _config.campaignKey.UCCN) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCCN]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        private function _formatReferrer():String
        {
            var _local2:String;
            var _local3:URL;
            var _local4:URL;
            var _local1:String = _info.referrer;
            if ((((_local1 == "")) || ((_local1 == "localhost"))))
            {
                _local1 = "-";
            }
            else
            {
                _local2 = _info.domainName;
                _local3 = new URL(_local1);
                _local4 = new URL(("http://" + _local2));
                if (_local3.hostName == _local2)
                {
                    return ("-");
                };
                if (_local4.domain == _local3.domain)
                {
                    if (_local4.subDomain != _local3.subDomain)
                    {
                        _local1 = "0";
                    };
                };
                if ((((_local1.charAt(0) == "[")) && (_local1.charAt((_local1.length - 1)))))
                {
                    _local1 = "-";
                };
            };
            _debug.info(("formated referrer: " + _local1), VisualDebugMode.advanced);
            return (_local1);
        }

        private function _visitCode():Number
        {
            if (_debug.verbose)
            {
                _debug.info(("visitCode: " + _buffer.utma.sessionId), VisualDebugMode.geek);
            };
            return (_buffer.utma.sessionId);
        }

        public function createEventTracker(_arg1:String):EventTracker
        {
            _debug.info((("createEventTracker( " + _arg1) + " )"));
            return (new EventTracker(_arg1, this));
        }

        public function addItem(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:Number, _arg6:int):void
        {
            var _local7:Transaction;
            _local7 = _ecom.getTransaction(_arg1);
            if (_local7 == null)
            {
                _local7 = _ecom.addTransaction(_arg1, "", "", "", "", "", "", "");
            };
            _local7.addItem(_arg2, _arg3, _arg4, _arg5.toString(), _arg6.toString());
            if (_debug.active)
            {
                _debug.info((("addItem( " + [_arg1, _arg2, _arg3, _arg4, _arg5, _arg6].join(", ")) + " )"));
            };
        }

        public function clearIgnoredOrganic():void
        {
            _debug.info("clearIgnoredOrganic()");
            _config.organic.clearIgnoredKeywords();
        }

        public function setVar(_arg1:String):void
        {
            var _local2:Variables;
            if (((!((_arg1 == ""))) && (_isNotGoogleSearch())))
            {
                _initData();
                _buffer.utmv.domainHash = _domainHash;
                _buffer.utmv.value = encodeURI(_arg1);
                if (_debug.verbose)
                {
                    _debug.info(_buffer.utmv.toString(), VisualDebugMode.geek);
                };
                _debug.info((("setVar( " + _arg1) + " )"));
                if (_takeSample())
                {
                    _local2 = new Variables();
                    _local2.utmt = "var";
                    _gifRequest.send(_account, _local2);
                };
            }
            else
            {
                _debug.warning((('setVar "' + _arg1) + '" is ignored'));
            };
        }

        public function setDomainName(_arg1:String):void
        {
            if (_arg1 == "auto")
            {
                _config.domain.mode = DomainNameMode.auto;
            }
            else
            {
                if (_arg1 == "none")
                {
                    _config.domain.mode = DomainNameMode.none;
                }
                else
                {
                    _config.domain.mode = DomainNameMode.custom;
                    _config.domain.name = _arg1;
                };
            };
            _updateDomainName();
            _debug.info((("setDomainName( " + _config.domainName) + " )"));
        }

        private function _updateDomainName():void
        {
            var _local1:String;
            if (_config.domain.mode == DomainNameMode.auto)
            {
                _local1 = _info.domainName;
                if (_local1.substring(0, 4) == "www.")
                {
                    _local1 = _local1.substring(4);
                };
                _config.domain.name = _local1;
            };
            _config.domainName = _config.domain.name.toLowerCase();
            _debug.info(("domain name: " + _config.domainName), VisualDebugMode.advanced);
        }

        public function addTrans(_arg1:String, _arg2:String, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:String, _arg7:String, _arg8:String):void
        {
            _ecom.addTransaction(_arg1, _arg2, _arg3.toString(), _arg4.toString(), _arg5.toString(), _arg6, _arg7, _arg8);
            if (_debug.active)
            {
                _debug.info((("addTrans( " + [_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8].join(", ")) + " );"));
            };
        }

        private function _renderMetricsSearchVariables(_arg1:String=""):Variables
        {
            var _local4:Variables;
            var _local2:Variables = new Variables();
            _local2.URIencode = true;
            var _local3:DocumentInfo = new DocumentInfo(_config, _info, _formatedReferrer, _arg1, _adSense);
            _debug.info(("docInfo: " + _local3.toURLString()), VisualDebugMode.geek);
            if (_config.campaignTracking)
            {
                _local4 = _campaignInfo.toVariables();
            };
            var _local5:Variables = _browserInfo.toVariables();
            _local2.join(_local3.toVariables(), _local5, _local4);
            return (_local2);
        }

        public function setCampContentKey(_arg1:String):void
        {
            _config.campaignKey.UCCT = _arg1;
            var _local2 = (("setCampContentKey( " + _config.campaignKey.UCCT) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCCT]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        private function _handleCookie():void
        {
            var _local1:String;
            var _local2:String;
            var _local3:Array;
            var _local4:String;
            if (_config.allowLinker)
            {
            };
            _buffer.createSO();
            if (((_buffer.hasUTMA()) && (!(_buffer.utma.isEmpty()))))
            {
                if (((!(_buffer.hasUTMB())) || (!(_buffer.hasUTMC()))))
                {
                    _buffer.updateUTMA(_timeStamp);
                    _noSessionInformation = true;
                };
                if (_debug.verbose)
                {
                    _debug.info(("from cookie " + _buffer.utma.toString()), VisualDebugMode.geek);
                };
            }
            else
            {
                _debug.info("create a new utma", VisualDebugMode.advanced);
                _buffer.utma.domainHash = _domainHash;
                _buffer.utma.sessionId = _getUniqueSessionId();
                _buffer.utma.firstTime = _timeStamp;
                _buffer.utma.lastTime = _timeStamp;
                _buffer.utma.currentTime = _timeStamp;
                _buffer.utma.sessionCount = 1;
                if (_debug.verbose)
                {
                    _debug.info(_buffer.utma.toString(), VisualDebugMode.geek);
                };
                _noSessionInformation = true;
                _isNewVisitor = true;
            };
            if (((_adSense.gaGlobal) && ((_adSense.dh == String(_domainHash)))))
            {
                if (_adSense.sid)
                {
                    _buffer.utma.currentTime = Number(_adSense.sid);
                    if (_debug.verbose)
                    {
                        _local1 = "";
                        _local1 = (_local1 + "AdSense sid found\n");
                        _local1 = (_local1 + (((("Override currentTime(" + _buffer.utma.currentTime) + ") from AdSense sid(") + Number(_adSense.sid)) + ")"));
                        _debug.info(_local1, VisualDebugMode.geek);
                    };
                };
                if (_isNewVisitor)
                {
                    if (_adSense.sid)
                    {
                        _buffer.utma.lastTime = Number(_adSense.sid);
                        if (_debug.verbose)
                        {
                            _local2 = "";
                            _local2 = (_local2 + "AdSense sid found (new visitor)\n");
                            _local2 = (_local2 + (((("Override lastTime(" + _buffer.utma.lastTime) + ") from AdSense sid(") + Number(_adSense.sid)) + ")"));
                            _debug.info(_local2, VisualDebugMode.geek);
                        };
                    };
                    if (_adSense.vid)
                    {
                        _local3 = _adSense.vid.split(".");
                        _buffer.utma.sessionId = Number(_local3[0]);
                        _buffer.utma.firstTime = Number(_local3[1]);
                        if (_debug.verbose)
                        {
                            _local4 = "";
                            _local4 = (_local4 + "AdSense vid found (new visitor)\n");
                            _local4 = (_local4 + (((("Override sessionId(" + _buffer.utma.sessionId) + ") from AdSense vid(") + Number(_local3[0])) + ")\n"));
                            _local4 = (_local4 + (((("Override firstTime(" + _buffer.utma.firstTime) + ") from AdSense vid(") + Number(_local3[1])) + ")"));
                            _debug.info(_local4, VisualDebugMode.geek);
                        };
                    };
                    if (_debug.verbose)
                    {
                        _debug.info(("AdSense modified : " + _buffer.utma.toString()), VisualDebugMode.geek);
                    };
                };
            };
            _buffer.utmb.domainHash = _domainHash;
            if (isNaN(_buffer.utmb.trackCount))
            {
                _buffer.utmb.trackCount = 0;
            };
            if (isNaN(_buffer.utmb.token))
            {
                _buffer.utmb.token = _config.tokenCliff;
            };
            if (isNaN(_buffer.utmb.lastTime))
            {
                _buffer.utmb.lastTime = _buffer.utma.currentTime;
            };
            _buffer.utmc.domainHash = _domainHash;
            if (_debug.verbose)
            {
                _debug.info(_buffer.utmb.toString(), VisualDebugMode.advanced);
                _debug.info(_buffer.utmc.toString(), VisualDebugMode.advanced);
            };
        }

        public function setLocalServerMode():void
        {
            _config.serverMode = ServerOperationMode.local;
            _debug.info("setLocalServerMode()");
        }

        public function clearIgnoredRef():void
        {
            _debug.info("clearIgnoredRef()");
            _config.organic.clearIgnoredReferrals();
        }

        public function setCampSourceKey(_arg1:String):void
        {
            _config.campaignKey.UCSR = _arg1;
            var _local2 = (("setCampSourceKey( " + _config.campaignKey.UCSR) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCSR]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        public function getLocalGifPath():String
        {
            _debug.info("getLocalGifPath()");
            return (_config.localGIFpath);
        }

        public function setLocalGifPath(_arg1:String):void
        {
            _config.localGIFpath = _arg1;
            _debug.info((("setLocalGifPath( " + _config.localGIFpath) + " )"));
        }

        public function getVersion():String
        {
            _debug.info("getVersion()");
            return (_config.version);
        }

        public function setAllowAnchor(_arg1:Boolean):void
        {
            _config.allowAnchor = _arg1;
            _debug.info((("setAllowAnchor( " + _config.allowAnchor) + " )"));
        }

        private function _isNotGoogleSearch():Boolean
        {
            var _local1:String = _config.domainName;
            var _local2 = (_local1.indexOf("www.google.") < 0);
            var _local3 = (_local1.indexOf(".google.") < 0);
            var _local4 = (_local1.indexOf("google.") < 0);
            var _local5 = (_local1.indexOf("google.org") > -1);
            return (((((((((_local2) || (_local3))) || (_local4))) || (!((_config.cookiePath == "/"))))) || (_local5)));
        }

        public function setSampleRate(_arg1:Number):void
        {
            if (_arg1 < 0)
            {
                _debug.warning("sample rate can not be negative, ignoring value.");
            }
            else
            {
                _config.sampleRate = _arg1;
            };
            _debug.info((("setSampleRate( " + _config.sampleRate) + " )"));
        }

        private function _takeSample():Boolean
        {
            if (_debug.verbose)
            {
                _debug.info((((("takeSample: (" + (_visitCode() % 10000)) + ") < (") + (_config.sampleRate * 10000)) + ")"), VisualDebugMode.geek);
            };
            return (((_visitCode() % 10000) < (_config.sampleRate * 10000)));
        }

        public function setCookiePath(_arg1:String):void
        {
            _config.cookiePath = _arg1;
            _debug.info((("setCookiePath( " + _config.cookiePath) + " )"));
        }

        public function setAllowHash(_arg1:Boolean):void
        {
            _config.allowDomainHash = _arg1;
            _debug.info((("setAllowHash( " + _config.allowDomainHash) + " )"));
        }

        private function _generateUserDataHash():Number
        {
            var _local1 = "";
            _local1 = (_local1 + _info.appName);
            _local1 = (_local1 + _info.appVersion);
            _local1 = (_local1 + _info.language);
            _local1 = (_local1 + _info.platform);
            _local1 = (_local1 + _info.userAgent.toString());
            _local1 = (_local1 + (((_info.screenWidth + "x") + _info.screenHeight) + _info.screenColorDepth));
            _local1 = (_local1 + _info.referrer);
            return (Utils.generateHash(_local1));
        }

        public function setCampNOKey(_arg1:String):void
        {
            _config.campaignKey.UCNO = _arg1;
            var _local2 = (("setCampNOKey( " + _config.campaignKey.UCNO) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCNO]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        public function addIgnoredOrganic(_arg1:String):void
        {
            _debug.info((("addIgnoredOrganic( " + _arg1) + " )"));
            _config.organic.addIgnoredKeyword(_arg1);
        }

        public function setLocalRemoteServerMode():void
        {
            _config.serverMode = ServerOperationMode.both;
            _debug.info("setLocalRemoteServerMode()");
        }

        public function cookiePathCopy(_arg1:String):void
        {
            _debug.warning((("cookiePathCopy( " + _arg1) + " ) not implemented"));
        }

        public function setDetectTitle(_arg1:Boolean):void
        {
            _config.detectTitle = _arg1;
            _debug.info((("setDetectTitle( " + _config.detectTitle) + " )"));
        }

        public function setCampTermKey(_arg1:String):void
        {
            _config.campaignKey.UCTR = _arg1;
            var _local2 = (("setCampTermKey( " + _config.campaignKey.UCTR) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCTR]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        public function getServiceMode():ServerOperationMode
        {
            _debug.info("getServiceMode()");
            return (_config.serverMode);
        }

        private function _trackMetrics(_arg1:String=""):void
        {
            var _local2:Variables;
            var _local3:Variables;
            var _local4:Variables;
            var _local5:EventInfo;
            if (_takeSample())
            {
                _local2 = new Variables();
                _local2.URIencode = true;
                if (((_x10Module) && (_x10Module.hasData())))
                {
                    _local5 = new EventInfo(false, _x10Module);
                    _local3 = _local5.toVariables();
                };
                _local4 = _renderMetricsSearchVariables(_arg1);
                _local2.join(_local3, _local4);
                _gifRequest.send(_account, _local2);
            };
        }

        public function setCampaignTrack(_arg1:Boolean):void
        {
            _config.campaignTracking = _arg1;
            _debug.info((("setCampaignTrack( " + _config.campaignTracking) + " )"));
        }

        public function addIgnoredRef(_arg1:String):void
        {
            _debug.info((("addIgnoredRef( " + _arg1) + " )"));
            _config.organic.addIgnoredReferral(_arg1);
        }

        public function clearOrganic():void
        {
            _debug.info("clearOrganic()");
            _config.organic.clearEngines();
        }

        public function getDetectFlash():Boolean
        {
            _debug.info("getDetectFlash()");
            return (_config.detectFlash);
        }

        public function setCampMediumKey(_arg1:String):void
        {
            _config.campaignKey.UCMD = _arg1;
            var _local2 = (("setCampMediumKey( " + _config.campaignKey.UCMD) + " )");
            if (_debug.mode == VisualDebugMode.geek)
            {
                _debug.info((_local2 + " [UCMD]"));
            }
            else
            {
                _debug.info(_local2);
            };
        }

        private function _getUniqueSessionId():Number
        {
            var _local1:Number = ((Utils.generate32bitRandom() ^ _generateUserDataHash()) * 2147483647);
            _debug.info(("Session ID: " + _local1), VisualDebugMode.geek);
            return (_local1);
        }

        private function _getDomainHash():Number
        {
            if (((((!(_config.domainName)) || ((_config.domainName == "")))) || ((_config.domain.mode == DomainNameMode.none))))
            {
                _config.domainName = "";
                return (1);
            };
            _updateDomainName();
            if (_config.allowDomainHash)
            {
                return (Utils.generateHash(_config.domainName));
            };
            return (1);
        }

        public function setSessionTimeout(_arg1:int):void
        {
            _config.sessionTimeout = _arg1;
            _debug.info((("setSessionTimeout( " + _config.sessionTimeout) + " )"));
        }

        public function getAccount():String
        {
            _debug.info("getAccount()");
            return (_account);
        }

        public function link(targetUrl:String, useHash:Boolean=false):void
        {
            _initData();
            var out:String = _buffer.getLinkerUrl(targetUrl, useHash);
            var request:URLRequest = new URLRequest(out);
            _debug.info((("link( " + [targetUrl, useHash].join(",")) + " )"));
            try
            {
                navigateToURL(request, "_top");
            }
            catch(e:Error)
            {
                _debug.warning(("An error occured in link() msg: " + e.message));
            };
        }

        public function setRemoteServerMode():void
        {
            _config.serverMode = ServerOperationMode.remote;
            _debug.info("setRemoteServerMode()");
        }


    }
}

