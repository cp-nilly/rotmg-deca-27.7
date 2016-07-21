package com.google.analytics.core
{
    import com.google.analytics.v4.GoogleAnalyticsAPI;

    public class EventTracker 
    {

        private var _parent:GoogleAnalyticsAPI;
        public var name:String;

        public function EventTracker(_arg1:String, _arg2:GoogleAnalyticsAPI)
        {
            this.name = _arg1;
            _parent = _arg2;
        }

        public function trackEvent(_arg1:String, _arg2:String=null, _arg3:Number=NaN):Boolean
        {
            return (_parent.trackEvent(name, _arg1, _arg2, _arg3));
        }


    }
}

