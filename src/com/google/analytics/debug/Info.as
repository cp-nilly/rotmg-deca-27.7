package com.google.analytics.debug
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.TextEvent;

    public class Info extends Label 
    {

        private var _timer:Timer;

        public function Info(_arg1:String="", _arg2:uint=3000)
        {
            super(_arg1, "uiInfo", Style.infoColor, Align.top, true);
            if (_arg2 > 0)
            {
                _timer = new Timer(_arg2, 1);
                _timer.start();
                _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete, false, 0, true);
            };
        }

        public function close():void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        override public function onLink(_arg1:TextEvent):void
        {
            switch (_arg1.text)
            {
                case "hide":
                    close();
                    return;
            };
        }

        public function onComplete(_arg1:TimerEvent):void
        {
            close();
        }


    }
}

