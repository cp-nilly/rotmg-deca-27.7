package com.google.analytics.core
{
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    import flash.errors.IllegalOperationError;

    public class TrackerCache implements GoogleAnalyticsAPI 
    {

        public static var CACHE_THROW_ERROR:Boolean;

        public var tracker:GoogleAnalyticsAPI;
        private var _ar:Array;

        public function TrackerCache(_arg1:GoogleAnalyticsAPI=null)
        {
            this.tracker = _arg1;
            _ar = [];
        }

        public function size():uint
        {
            return (_ar.length);
        }

        public function flush():void
        {
            var _local1:Object;
            var _local2:String;
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            if (tracker == null)
            {
                return;
            };
            if (size() > 0)
            {
                _local4 = _ar.length;
                while (_local5 < _local4)
                {
                    _local1 = _ar.shift();
                    _local2 = (_local1.name as String);
                    _local3 = (_local1.args as Array);
                    if (((!((_local2 == null))) && ((_local2 in tracker))))
                    {
                        (tracker[_local2] as Function).apply(tracker, _local3);
                    };
                    _local5++;
                };
            };
        }

        public function enqueue(_arg1:String, ... _args):Boolean
        {
            if (_arg1 == null)
            {
                return (false);
            };
            _ar.push({
                "name":_arg1,
                "args":_args
            });
            return (true);
        }

        public function link(_arg1:String, _arg2:Boolean=false):void
        {
            enqueue("link", _arg1, _arg2);
        }

        public function addOrganic(_arg1:String, _arg2:String):void
        {
            enqueue("addOrganic", _arg1, _arg2);
        }

        public function setAllowLinker(_arg1:Boolean):void
        {
            enqueue("setAllowLinker", _arg1);
        }

        public function trackEvent(_arg1:String, _arg2:String, _arg3:String=null, _arg4:Number=NaN):Boolean
        {
            enqueue("trackEvent", _arg1, _arg2, _arg3, _arg4);
            return (true);
        }

        public function getLinkerUrl(_arg1:String="", _arg2:Boolean=false):String
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getLinkerUrl' method for the moment."));
            };
            return ("");
        }

        public function getClientInfo():Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getClientInfo' method for the moment."));
            };
            return (false);
        }

        public function trackTrans():void
        {
            enqueue("trackTrans");
        }

        public function trackPageview(_arg1:String=""):void
        {
            enqueue("trackPageview", _arg1);
        }

        public function setClientInfo(_arg1:Boolean):void
        {
            enqueue("setClientInfo", _arg1);
        }

        public function linkByPost(_arg1:Object, _arg2:Boolean=false):void
        {
            enqueue("linkByPost", _arg1, _arg2);
        }

        public function setCookieTimeout(_arg1:int):void
        {
            enqueue("setCookieTimeout", _arg1);
        }

        public function isEmpty():Boolean
        {
            return ((_ar.length == 0));
        }

        public function getDetectTitle():Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getDetectTitle' method for the moment."));
            };
            return (false);
        }

        public function resetSession():void
        {
            enqueue("resetSession");
        }

        public function setDetectFlash(_arg1:Boolean):void
        {
            enqueue("setDetectFlash", _arg1);
        }

        public function clear():void
        {
            _ar = [];
        }

        public function setCampNameKey(_arg1:String):void
        {
            enqueue("setCampNameKey", _arg1);
        }

        public function addItem(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:Number, _arg6:int):void
        {
            enqueue("addItem", _arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
        }

        public function createEventTracker(_arg1:String):EventTracker
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'createEventTracker' method for the moment."));
            };
            return (null);
        }

        public function clearIgnoredOrganic():void
        {
            enqueue("clearIgnoredOrganic");
        }

        public function setVar(_arg1:String):void
        {
            enqueue("setVar", _arg1);
        }

        public function setDomainName(_arg1:String):void
        {
            enqueue("setDomainName", _arg1);
        }

        public function setCampSourceKey(_arg1:String):void
        {
            enqueue("setCampSourceKey", _arg1);
        }

        public function addTrans(_arg1:String, _arg2:String, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:String, _arg7:String, _arg8:String):void
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'addTrans' method for the moment."));
            };
        }

        public function setCampContentKey(_arg1:String):void
        {
            enqueue("setCampContentKey", _arg1);
        }

        public function setLocalServerMode():void
        {
            enqueue("setLocalServerMode");
        }

        public function getLocalGifPath():String
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getLocalGifPath' method for the moment."));
            };
            return ("");
        }

        public function setAllowAnchor(_arg1:Boolean):void
        {
            enqueue("setAllowAnchor", _arg1);
        }

        public function clearIgnoredRef():void
        {
            enqueue("clearIgnoredRef");
        }

        public function setLocalGifPath(_arg1:String):void
        {
            enqueue("setLocalGifPath", _arg1);
        }

        public function getVersion():String
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getVersion' method for the moment."));
            };
            return ("");
        }

        public function setCookiePath(_arg1:String):void
        {
            enqueue("setCookiePath", _arg1);
        }

        public function setSampleRate(_arg1:Number):void
        {
            enqueue("setSampleRate", _arg1);
        }

        public function setDetectTitle(_arg1:Boolean):void
        {
            enqueue("setDetectTitle", _arg1);
        }

        public function setAllowHash(_arg1:Boolean):void
        {
            enqueue("setAllowHash", _arg1);
        }

        public function addIgnoredOrganic(_arg1:String):void
        {
            enqueue("addIgnoredOrganic", _arg1);
        }

        public function setCampNOKey(_arg1:String):void
        {
            enqueue("setCampNOKey", _arg1);
        }

        public function getServiceMode():ServerOperationMode
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getServiceMode' method for the moment."));
            };
            return (null);
        }

        public function setLocalRemoteServerMode():void
        {
            enqueue("setLocalRemoteServerMode");
        }

        public function cookiePathCopy(_arg1:String):void
        {
            enqueue("cookiePathCopy", _arg1);
        }

        public function getDetectFlash():Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getDetectFlash' method for the moment."));
            };
            return (false);
        }

        public function setCampaignTrack(_arg1:Boolean):void
        {
            enqueue("setCampaignTrack", _arg1);
        }

        public function clearOrganic():void
        {
            enqueue("clearOrganic");
        }

        public function setCampTermKey(_arg1:String):void
        {
            enqueue("setCampTermKey", _arg1);
        }

        public function addIgnoredRef(_arg1:String):void
        {
            enqueue("addIgnoredRef", _arg1);
        }

        public function setCampMediumKey(_arg1:String):void
        {
            enqueue("setCampMediumKey", _arg1);
        }

        public function setSessionTimeout(_arg1:int):void
        {
            enqueue("setSessionTimeout", _arg1);
        }

        public function setRemoteServerMode():void
        {
            enqueue("setRemoteServerMode");
        }

        public function element()
        {
            return (_ar[0]);
        }

        public function getAccount():String
        {
            if (CACHE_THROW_ERROR)
            {
                throw (new IllegalOperationError("The tracker is not ready and you can use the 'getAccount' method for the moment."));
            };
            return ("");
        }


    }
}

