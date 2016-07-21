package com.google.analytics.core
{
    import flash.display.Stage;
    import flash.utils.Timer;
    import com.google.analytics.debug.DebugConfiguration;
    import flash.utils.getTimer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import com.google.analytics.debug.VisualDebugMode;
    import com.google.analytics.v4.Configuration;
    import flash.display.DisplayObject;

    public class IdleTimer 
    {

        private var _stage:Stage;
        private var _loop:Timer;
        private var _lastMove:int;
        private var _inactivity:Number;
        private var _debug:DebugConfiguration;
        private var _session:Timer;
        private var _buffer:Buffer;

        public function IdleTimer(_arg1:Configuration, _arg2:DebugConfiguration, _arg3:DisplayObject, _arg4:Buffer)
        {
            var _local5:Number = _arg1.idleLoop;
            var _local6:Number = _arg1.idleTimeout;
            var _local7:Number = _arg1.sessionTimeout;
            _loop = new Timer((_local5 * 1000));
            _session = new Timer((_local7 * 1000), 1);
            _debug = _arg2;
            _stage = _arg3.stage;
            _buffer = _arg4;
            _lastMove = getTimer();
            _inactivity = (_local6 * 1000);
            _loop.addEventListener(TimerEvent.TIMER, checkForIdle);
            _session.addEventListener(TimerEvent.TIMER_COMPLETE, endSession);
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            _debug.info(((((("delay: " + _local5) + "sec , inactivity: ") + _local6) + "sec, sessionTimeout: ") + _local7), VisualDebugMode.geek);
            _loop.start();
        }

        private function onMouseMove(_arg1:MouseEvent):void
        {
            _lastMove = getTimer();
            if (_session.running)
            {
                _debug.info("session timer reset", VisualDebugMode.geek);
                _session.reset();
            };
        }

        public function endSession(_arg1:TimerEvent):void
        {
            _session.removeEventListener(TimerEvent.TIMER_COMPLETE, endSession);
            _debug.info("session timer end session", VisualDebugMode.geek);
            _session.reset();
            _buffer.resetCurrentSession();
            _debug.info(_buffer.utmb.toString(), VisualDebugMode.geek);
            _debug.info(_buffer.utmc.toString(), VisualDebugMode.geek);
            _session.addEventListener(TimerEvent.TIMER_COMPLETE, endSession);
        }

        public function checkForIdle(_arg1:TimerEvent):void
        {
            var _local2:int = getTimer();
            if ((_local2 - _lastMove) >= _inactivity)
            {
                if (!_session.running)
                {
                    _debug.info("session timer start", VisualDebugMode.geek);
                    _session.start();
                };
            };
        }


    }
}

