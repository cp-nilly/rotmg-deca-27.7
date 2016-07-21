package com.google.analytics.campaign
{
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.core.Buffer;
    import com.google.analytics.utils.URL;
    import com.google.analytics.utils.Protocols;
    import com.google.analytics.debug.VisualDebugMode;
    import com.google.analytics.utils.Variables;
    import com.google.analytics.core.OrganicReferrer;

    public class CampaignManager 
    {

        public static const trackingDelimiter:String = "|";

        private var _config:Configuration;
        private var _domainHash:Number;
        private var _debug:DebugConfiguration;
        private var _timeStamp:Number;
        private var _referrer:String;
        private var _buffer:Buffer;

        public function CampaignManager(_arg1:Configuration, _arg2:DebugConfiguration, _arg3:Buffer, _arg4:Number, _arg5:String, _arg6:Number)
        {
            _config = _arg1;
            _debug = _arg2;
            _buffer = _arg3;
            _domainHash = _arg4;
            _referrer = _arg5;
            _timeStamp = _arg6;
        }

        public static function isInvalidReferrer(_arg1:String):Boolean
        {
            var _local2:URL;
            if ((((((_arg1 == "")) || ((_arg1 == "-")))) || ((_arg1 == "0"))))
            {
                return (true);
            };
            if (_arg1.indexOf("://") > -1)
            {
                _local2 = new URL(_arg1);
                if ((((_local2.protocol == Protocols.file)) || ((_local2.protocol == Protocols.none))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function isFromGoogleCSE(_arg1:String, _arg2:Configuration):Boolean
        {
            var _local3:URL = new URL(_arg1);
            if (_local3.hostName.indexOf(_arg2.google) > -1)
            {
                if (_local3.search.indexOf((_arg2.googleSearchParam + "=")) > -1)
                {
                    if (_local3.path == ("/" + _arg2.googleCsePath))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }


        public function getCampaignInformation(_arg1:String, _arg2:Boolean):CampaignInfo
        {
            var _local4:CampaignTracker;
            var _local8:CampaignTracker;
            var _local9:int;
            var _local3:CampaignInfo = new CampaignInfo();
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:int;
            if (((_config.allowLinker) && (_buffer.isGenuine())))
            {
                if (!_buffer.hasUTMZ())
                {
                    return (_local3);
                };
            };
            _local4 = getTrackerFromSearchString(_arg1);
            if (isValid(_local4))
            {
                _local6 = hasNoOverride(_arg1);
                if (((_local6) && (!(_buffer.hasUTMZ()))))
                {
                    return (_local3);
                };
            };
            if (!isValid(_local4))
            {
                _local4 = getOrganicCampaign();
                if (((!(_buffer.hasUTMZ())) && (isIgnoredKeyword(_local4))))
                {
                    return (_local3);
                };
            };
            if (((!(isValid(_local4))) && (_arg2)))
            {
                _local4 = getReferrerCampaign();
                if (((!(_buffer.hasUTMZ())) && (isIgnoredReferral(_local4))))
                {
                    return (_local3);
                };
            };
            if (!isValid(_local4))
            {
                if (((!(_buffer.hasUTMZ())) && (_arg2)))
                {
                    _local4 = getDirectCampaign();
                };
            };
            if (!isValid(_local4))
            {
                return (_local3);
            };
            if (((_buffer.hasUTMZ()) && (!(_buffer.utmz.isEmpty()))))
            {
                _local8 = new CampaignTracker();
                _local8.fromTrackerString(_buffer.utmz.campaignTracking);
                _local5 = (_local8.toTrackerString() == _local4.toTrackerString());
                _local7 = _buffer.utmz.responseCount;
            };
            if (((!(_local5)) || (_arg2)))
            {
                _local9 = _buffer.utma.sessionCount;
                _local7++;
                if (_local9 == 0)
                {
                    _local9 = 1;
                };
                _buffer.utmz.domainHash = _domainHash;
                _buffer.utmz.campaignCreation = _timeStamp;
                _buffer.utmz.campaignSessions = _local9;
                _buffer.utmz.responseCount = _local7;
                _buffer.utmz.campaignTracking = _local4.toTrackerString();
                _debug.info(_buffer.utmz.toString(), VisualDebugMode.geek);
                _local3 = new CampaignInfo(false, true);
            }
            else
            {
                _local3 = new CampaignInfo(false, false);
            };
            return (_local3);
        }

        public function hasNoOverride(_arg1:String):Boolean
        {
            var _local2:CampaignKey = _config.campaignKey;
            if (_arg1 == "")
            {
                return (false);
            };
            var _local3:Variables = new Variables(_arg1);
            var _local4 = "";
            if (_local3.hasOwnProperty(_local2.UCNO))
            {
                _local4 = _local3[_local2.UCNO];
                switch (_local4)
                {
                    case "1":
                        return (true);
                    case "":
                    case "0":
                    default:
                        return (false);
                };
            };
            return (false);
        }

        public function getTrackerFromSearchString(_arg1:String):CampaignTracker
        {
            var _local2:CampaignTracker = getOrganicCampaign();
            var _local3:CampaignTracker = new CampaignTracker();
            var _local4:CampaignKey = _config.campaignKey;
            if (_arg1 == "")
            {
                return (_local3);
            };
            var _local5:Variables = new Variables(_arg1);
            if (_local5.hasOwnProperty(_local4.UCID))
            {
                _local3.id = _local5[_local4.UCID];
            };
            if (_local5.hasOwnProperty(_local4.UCSR))
            {
                _local3.source = _local5[_local4.UCSR];
            };
            if (_local5.hasOwnProperty(_local4.UGCLID))
            {
                _local3.clickId = _local5[_local4.UGCLID];
            };
            if (_local5.hasOwnProperty(_local4.UCCN))
            {
                _local3.name = _local5[_local4.UCCN];
            }
            else
            {
                _local3.name = "(not set)";
            };
            if (_local5.hasOwnProperty(_local4.UCMD))
            {
                _local3.medium = _local5[_local4.UCMD];
            }
            else
            {
                _local3.medium = "(not set)";
            };
            if (_local5.hasOwnProperty(_local4.UCTR))
            {
                _local3.term = _local5[_local4.UCTR];
            }
            else
            {
                if (((_local2) && (!((_local2.term == "")))))
                {
                    _local3.term = _local2.term;
                };
            };
            if (_local5.hasOwnProperty(_local4.UCCT))
            {
                _local3.content = _local5[_local4.UCCT];
            };
            return (_local3);
        }

        public function getOrganicCampaign():CampaignTracker
        {
            var _local1:CampaignTracker;
            var _local4:Array;
            var _local5:OrganicReferrer;
            var _local6:String;
            if (((isInvalidReferrer(_referrer)) || (isFromGoogleCSE(_referrer, _config))))
            {
                return (_local1);
            };
            var _local2:URL = new URL(_referrer);
            var _local3 = "";
            if (_local2.hostName != "")
            {
                if (_local2.hostName.indexOf(".") > -1)
                {
                    _local4 = _local2.hostName.split(".");
                    switch (_local4.length)
                    {
                        case 2:
                            _local3 = _local4[0];
                            break;
                        case 3:
                            _local3 = _local4[1];
                            break;
                    };
                };
            };
            if (_config.organic.match(_local3))
            {
                _local5 = _config.organic.getReferrerByName(_local3);
                _local6 = _config.organic.getKeywordValue(_local5, _local2.search);
                _local1 = new CampaignTracker();
                _local1.source = _local5.engine;
                _local1.name = "(organic)";
                _local1.medium = "organic";
                _local1.term = _local6;
            };
            return (_local1);
        }

        public function getDirectCampaign():CampaignTracker
        {
            var _local1:CampaignTracker = new CampaignTracker();
            _local1.source = "(direct)";
            _local1.name = "(direct)";
            _local1.medium = "(none)";
            return (_local1);
        }

        public function isIgnoredKeyword(_arg1:CampaignTracker):Boolean
        {
            if (((_arg1) && ((_arg1.medium == "organic"))))
            {
                return (_config.organic.isIgnoredKeyword(_arg1.term));
            };
            return (false);
        }

        public function isIgnoredReferral(_arg1:CampaignTracker):Boolean
        {
            if (((_arg1) && ((_arg1.medium == "referral"))))
            {
                return (_config.organic.isIgnoredReferral(_arg1.source));
            };
            return (false);
        }

        public function isValid(_arg1:CampaignTracker):Boolean
        {
            if (((_arg1) && (_arg1.isValid())))
            {
                return (true);
            };
            return (false);
        }

        public function getReferrerCampaign():CampaignTracker
        {
            var _local1:CampaignTracker;
            if (((isInvalidReferrer(_referrer)) || (isFromGoogleCSE(_referrer, _config))))
            {
                return (_local1);
            };
            var _local2:URL = new URL(_referrer);
            var _local3:String = _local2.hostName;
            var _local4:String = _local2.path;
            if (_local3.indexOf("www.") == 0)
            {
                _local3 = _local3.substr(4);
            };
            _local1 = new CampaignTracker();
            _local1.source = _local3;
            _local1.name = "(referral)";
            _local1.medium = "referral";
            _local1.content = _local4;
            return (_local1);
        }


    }
}

