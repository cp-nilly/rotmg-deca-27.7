package robotlegs.bender.extensions.logging.impl
{
    import robotlegs.bender.framework.api.ILogTarget;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.LogLevel;

    public class TraceLogTarget implements ILogTarget 
    {

        private const _messageParser:LogMessageParser = new LogMessageParser();

        private var _context:IContext;

        public function TraceLogTarget(_arg1:IContext)
        {
            this._context = _arg1;
        }

        public function log(_arg1:Object, _arg2:uint, _arg3:int, _arg4:String, _arg5:Array=null):void
        {
            trace(((((((((_arg3 + " ") + LogLevel.NAME[_arg2]) + " ") + this._context) + " ") + _arg1) + " - ") + this._messageParser.parseMessage(_arg4, _arg5)));
        }


    }
}

