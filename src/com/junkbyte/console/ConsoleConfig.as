package com.junkbyte.console
{
    public class ConsoleConfig 
    {

        public var keystrokePassword:String;
        public var remotingPassword:String;
        public var maxLines:uint = 1000;
        public var maxRepeats:int = 75;
        public var autoStackPriority:int;
        public var defaultStackDepth:int = 2;
        public var useObjectLinking:Boolean = true;
        public var objectHardReferenceTimer:uint = 0;
        public var tracing:Boolean;
        public var traceCall:Function;
        public var showTimestamp:Boolean = false;
        public var timeStampFormatter:Function;
        public var showLineNumber:Boolean = false;
        public var remotingConnectionName:String = "_Console";
        public var allowedRemoteDomain:String = "*";
        public var commandLineAllowed:Boolean;
        public var commandLineAutoScope:Boolean;
        public var commandLineInputPassThrough:Function;
        public var commandLineAutoCompleteEnabled:Boolean = true;
        public var keyBindsEnabled:Boolean = true;
        public var displayRollerEnabled:Boolean = true;
        public var rulerToolEnabled:Boolean = true;
        public var rulerHidesMouse:Boolean = true;
        public var sharedObjectName:String = "com.junkbyte/Console/UserData";
        public var sharedObjectPath:String = "/";
        public var rememberFilterSettings:Boolean;
        public var alwaysOnTop:Boolean = true;
        private var _style:ConsoleStyle;

        public function ConsoleConfig()
        {
            this.autoStackPriority = Console.FATAL;
            this.traceCall = function (_arg1:String, _arg2:String, ... _args):void
            {
                trace(((("[" + _arg1) + "] ") + _arg2));
            };
            this.timeStampFormatter = function (_arg1:uint):String
            {
                var _local2:uint = (_arg1 * 0.001);
                return (((this.makeTimeDigit((_local2 / 60)) + ":") + this.makeTimeDigit((_local2 % 60))));
            };
            super();
            this._style = new ConsoleStyle();
        }

        private function makeTimeDigit(_arg1:uint):String
        {
            if (_arg1 < 10)
            {
                return (("0" + _arg1));
            };
            return (String(_arg1));
        }

        public function get style():ConsoleStyle
        {
            return (this._style);
        }


    }
}

