package org.osflash.signals
{
    public class Slot implements ISlot 
    {

        protected var _signal:IOnceSignal;
        protected var _enabled:Boolean = true;
        protected var _listener:Function;
        protected var _once:Boolean = false;
        protected var _priority:int = 0;
        protected var _params:Array;

        public function Slot(_arg1:Function, _arg2:IOnceSignal, _arg3:Boolean=false, _arg4:int=0)
        {
            this._listener = _arg1;
            this._once = _arg3;
            this._signal = _arg2;
            this._priority = _arg4;
            this.verifyListener(_arg1);
        }

        public function execute0():void
        {
            if (!this._enabled)
            {
                return;
            };
            if (this._once)
            {
                this.remove();
            };
            if (((this._params) && (this._params.length)))
            {
                this._listener.apply(null, this._params);
                return;
            };
            this._listener();
        }

        public function execute1(_arg1:Object):void
        {
            if (!this._enabled)
            {
                return;
            };
            if (this._once)
            {
                this.remove();
            };
            if (((this._params) && (this._params.length)))
            {
                this._listener.apply(null, [_arg1].concat(this._params));
                return;
            };
            this._listener(_arg1);
        }

        public function execute(_arg1:Array):void
        {
            if (!this._enabled)
            {
                return;
            };
            if (this._once)
            {
                this.remove();
            };
            if (((this._params) && (this._params.length)))
            {
                _arg1 = _arg1.concat(this._params);
            };
            var _local2:int = _arg1.length;
            if (_local2 == 0)
            {
                this._listener();
            }
            else
            {
                if (_local2 == 1)
                {
                    this._listener(_arg1[0]);
                }
                else
                {
                    if (_local2 == 2)
                    {
                        this._listener(_arg1[0], _arg1[1]);
                    }
                    else
                    {
                        if (_local2 == 3)
                        {
                            this._listener(_arg1[0], _arg1[1], _arg1[2]);
                        }
                        else
                        {
                            this._listener.apply(null, _arg1);
                        };
                    };
                };
            };
        }

        public function get listener():Function
        {
            return (this._listener);
        }

        public function set listener(_arg1:Function):void
        {
            if (null == _arg1)
            {
                throw (new ArgumentError("Given listener is null.\nDid you want to set enabled to false instead?"));
            };
            this.verifyListener(_arg1);
            this._listener = _arg1;
        }

        public function get once():Boolean
        {
            return (this._once);
        }

        public function get priority():int
        {
            return (this._priority);
        }

        public function toString():String
        {
            return ((((((((("[Slot listener: " + this._listener) + ", once: ") + this._once) + ", priority: ") + this._priority) + ", enabled: ") + this._enabled) + "]"));
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg1:Boolean):void
        {
            this._enabled = _arg1;
        }

        public function get params():Array
        {
            return (this._params);
        }

        public function set params(_arg1:Array):void
        {
            this._params = _arg1;
        }

        public function remove():void
        {
            this._signal.remove(this._listener);
        }

        protected function verifyListener(_arg1:Function):void
        {
            if (null == _arg1)
            {
                throw (new ArgumentError("Given listener is null."));
            };
            if (null == this._signal)
            {
                throw (new Error("Internal signal reference has not been set yet."));
            };
        }


    }
}

