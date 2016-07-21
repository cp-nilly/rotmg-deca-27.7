package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.MappingConfigError;

    public class MappingConfigValidator 
    {

        private const CANT_CHANGE_GUARDS_AND_HOOKS:String = "You can't change the guards and hooks on an existing mapping. Unmap first.";
        private const STORED_ERROR_EXPLANATION:String = " The stacktrace for this error was stored at the time when you duplicated the mapping - you may have failed to add guards and hooks that were already present.";

        private var _guards:Array;
        private var _hooks:Array;
        private var _trigger;
        private var _action;
        private var _storedError:MappingConfigError;
        private var _valid:Boolean = false;

        public function MappingConfigValidator(_arg1:Array, _arg2:Array, _arg3:*, _arg4:*)
        {
            this._guards = _arg1;
            this._hooks = _arg2;
            this._trigger = _arg3;
            this._action = _arg4;
            super();
        }

        public function get valid():Boolean
        {
            return (this._valid);
        }

        public function invalidate():void
        {
            this._valid = false;
            this._storedError = new MappingConfigError((this.CANT_CHANGE_GUARDS_AND_HOOKS + this.STORED_ERROR_EXPLANATION), this._trigger, this._action);
        }

        public function validate(_arg1:Array, _arg2:Array):void
        {
            if (((!(this.arraysMatch(this._guards, _arg1))) || (!(this.arraysMatch(this._hooks, _arg2)))))
            {
                ((this.throwStoredError()) || (this.throwMappingError()));
            };
            this._valid = true;
            this._storedError = null;
        }

        public function checkGuards(_arg1:Array):void
        {
            if (this.changesContent(this._guards, _arg1))
            {
                this.throwMappingError();
            };
        }

        public function checkHooks(_arg1:Array):void
        {
            if (this.changesContent(this._hooks, _arg1))
            {
                this.throwMappingError();
            };
        }

        private function changesContent(_arg1:Array, _arg2:Array):Boolean
        {
            var _local3:*;
            _arg2 = this.flatten(_arg2);
            for each (_local3 in _arg2)
            {
                if (_arg1.indexOf(_local3) == -1)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function arraysMatch(_arg1:Array, _arg2:Array):Boolean
        {
            var _local3:int;
            _arg1 = _arg1.slice();
            if (_arg1.length != _arg2.length)
            {
                return (false);
            };
            var _local4:uint = _arg2.length;
            var _local5:uint;
            while (_local5 < _local4)
            {
                _local3 = _arg1.indexOf(_arg2[_local5]);
                if (_local3 == -1)
                {
                    return (false);
                };
                _arg1.splice(_local3, 1);
                _local5++;
            };
            return (true);
        }

        public function flatten(_arg1:Array):Array
        {
            var _local3:*;
            var _local2:Array = [];
            for each (_local3 in _arg1)
            {
                if ((_local3 is Array))
                {
                    _local2 = _local2.concat(this.flatten((_local3 as Array)));
                }
                else
                {
                    _local2.push(_local3);
                };
            };
            return (_local2);
        }

        private function throwMappingError():void
        {
            throw (new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS, this._trigger, this._action));
        }

        private function throwStoredError():Boolean
        {
            if (this._storedError)
            {
                throw (this._storedError);
            };
            return (false);
        }


    }
}

