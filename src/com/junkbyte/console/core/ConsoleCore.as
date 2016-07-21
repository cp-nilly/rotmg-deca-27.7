package com.junkbyte.console.core
{
    import flash.events.EventDispatcher;
    import com.junkbyte.console.Console;
    import com.junkbyte.console.ConsoleConfig;

    public class ConsoleCore extends EventDispatcher 
    {

        protected var console:Console;
        protected var config:ConsoleConfig;

        public function ConsoleCore(_arg1:Console)
        {
            this.console = _arg1;
            this.config = this.console.config;
        }

        protected function get remoter():Remoting
        {
            return (this.console.remoter);
        }

        protected function report(_arg1:*="", _arg2:int=0, _arg3:Boolean=true, _arg4:String=null):void
        {
            this.console.report(_arg1, _arg2, _arg3, _arg4);
        }


    }
}

