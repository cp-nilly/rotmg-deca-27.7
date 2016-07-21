package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.framework.api.ILogTarget;
    import flash.utils.getTimer;

    public class Logger implements ILogger 
    {

        private var _source:Object;
        private var _target:ILogTarget;

        public function Logger(_arg1:Object, _arg2:ILogTarget)
        {
            this._source = _arg1;
            this._target = _arg2;
        }

        public function debug(_arg1:*, _arg2:Array=null):void
        {
            this._target.log(this._source, 32, getTimer(), _arg1, _arg2);
        }

        public function info(_arg1:*, _arg2:Array=null):void
        {
            this._target.log(this._source, 16, getTimer(), _arg1, _arg2);
        }

        public function warn(_arg1:*, _arg2:Array=null):void
        {
            this._target.log(this._source, 8, getTimer(), _arg1, _arg2);
        }

        public function error(_arg1:*, _arg2:Array=null):void
        {
            this._target.log(this._source, 4, getTimer(), _arg1, _arg2);
        }

        public function fatal(_arg1:*, _arg2:Array=null):void
        {
            this._target.log(this._source, 2, getTimer(), _arg1, _arg2);
        }


    }
}

