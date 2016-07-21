package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.ILogTarget;
    import __AS3__.vec.Vector;
    import robotlegs.bender.framework.api.ILogger;
    import __AS3__.vec.*;

    public class LogManager implements ILogTarget 
    {

        private const _targets:Vector.<ILogTarget> = new Vector.<ILogTarget>();

        private var _logLevel:uint = 16;


        public function get logLevel():uint
        {
            return (this._logLevel);
        }

        public function set logLevel(_arg1:uint):void
        {
            this._logLevel = _arg1;
        }

        public function getLogger(_arg1:Object):ILogger
        {
            return (new Logger(_arg1, this));
        }

        public function addLogTarget(_arg1:ILogTarget):void
        {
            this._targets.push(_arg1);
        }

        public function log(_arg1:Object, _arg2:uint, _arg3:int, _arg4:String, _arg5:Array=null):void
        {
            var _local6:ILogTarget;
            if (_arg2 > this._logLevel)
            {
                return;
            };
            for each (_local6 in this._targets)
            {
                _local6.log(_arg1, _arg2, _arg3, _arg4, _arg5);
            };
        }


    }
}

