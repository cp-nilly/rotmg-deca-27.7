package com.google.analytics.v4
{
    import com.google.analytics.core.EventTracker;
    import com.google.analytics.core.ServerOperationMode;

    public interface GoogleAnalyticsAPI 
    {

        function setCampSourceKey(_arg1:String):void;
        function setDetectTitle(_arg1:Boolean):void;
        function setLocalRemoteServerMode():void;
        function resetSession():void;
        function setLocalServerMode():void;
        function setCampContentKey(_arg1:String):void;
        function addOrganic(_arg1:String, _arg2:String):void;
        function setDetectFlash(_arg1:Boolean):void;
        function setAllowLinker(_arg1:Boolean):void;
        function trackEvent(_arg1:String, _arg2:String, _arg3:String=null, _arg4:Number=NaN):Boolean;
        function setCampTermKey(_arg1:String):void;
        function setCampNameKey(_arg1:String):void;
        function getLinkerUrl(_arg1:String="", _arg2:Boolean=false):String;
        function addItem(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:Number, _arg6:int):void;
        function clearIgnoredRef():void;
        function addTrans(_arg1:String, _arg2:String, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:String, _arg7:String, _arg8:String):void;
        function getDetectFlash():Boolean;
        function setCampaignTrack(_arg1:Boolean):void;
        function createEventTracker(_arg1:String):EventTracker;
        function setCookieTimeout(_arg1:int):void;
        function setAllowAnchor(_arg1:Boolean):void;
        function trackTrans():void;
        function clearOrganic():void;
        function trackPageview(_arg1:String=""):void;
        function setLocalGifPath(_arg1:String):void;
        function getVersion():String;
        function getLocalGifPath():String;
        function getServiceMode():ServerOperationMode;
        function setVar(_arg1:String):void;
        function clearIgnoredOrganic():void;
        function setCampMediumKey(_arg1:String):void;
        function addIgnoredRef(_arg1:String):void;
        function setClientInfo(_arg1:Boolean):void;
        function setCookiePath(_arg1:String):void;
        function setSampleRate(_arg1:Number):void;
        function setSessionTimeout(_arg1:int):void;
        function setRemoteServerMode():void;
        function setDomainName(_arg1:String):void;
        function addIgnoredOrganic(_arg1:String):void;
        function setAllowHash(_arg1:Boolean):void;
        function getAccount():String;
        function linkByPost(_arg1:Object, _arg2:Boolean=false):void;
        function link(_arg1:String, _arg2:Boolean=false):void;
        function setCampNOKey(_arg1:String):void;
        function getClientInfo():Boolean;
        function cookiePathCopy(_arg1:String):void;
        function getDetectTitle():Boolean;

    }
}

