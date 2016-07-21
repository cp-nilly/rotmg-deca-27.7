package com.google.analytics.data
{
    import com.google.analytics.utils.Timespan;

    public class UTMA extends UTMCookie 
    {

        private var _sessionId:Number;
        private var _domainHash:Number;
        private var _firstTime:Number;
        private var _currentTime:Number;
        private var _lastTime:Number;
        private var _sessionCount:Number;

        public function UTMA(_arg1:Number=NaN, _arg2:Number=NaN, _arg3:Number=NaN, _arg4:Number=NaN, _arg5:Number=NaN, _arg6:Number=NaN)
        {
            super("utma", "__utma", ["domainHash", "sessionId", "firstTime", "lastTime", "currentTime", "sessionCount"], (Timespan.twoyears * 1000));
            this.domainHash = _arg1;
            this.sessionId = _arg2;
            this.firstTime = _arg3;
            this.lastTime = _arg4;
            this.currentTime = _arg5;
            this.sessionCount = _arg6;
        }

        public function get lastTime():Number
        {
            return (_lastTime);
        }

        public function set lastTime(_arg1:Number):void
        {
            _lastTime = _arg1;
            update();
        }

        public function set currentTime(_arg1:Number):void
        {
            _currentTime = _arg1;
            update();
        }

        public function get sessionId():Number
        {
            return (_sessionId);
        }

        public function get sessionCount():Number
        {
            return (_sessionCount);
        }

        public function get firstTime():Number
        {
            return (_firstTime);
        }

        public function get currentTime():Number
        {
            return (_currentTime);
        }

        public function set domainHash(_arg1:Number):void
        {
            _domainHash = _arg1;
            update();
        }

        public function set sessionId(_arg1:Number):void
        {
            _sessionId = _arg1;
            update();
        }

        public function set sessionCount(_arg1:Number):void
        {
            _sessionCount = _arg1;
            update();
        }

        public function get domainHash():Number
        {
            return (_domainHash);
        }

        public function set firstTime(_arg1:Number):void
        {
            _firstTime = _arg1;
            update();
        }


    }
}

