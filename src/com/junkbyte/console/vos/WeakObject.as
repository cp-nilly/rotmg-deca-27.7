package com.junkbyte.console.vos
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash.utils.flash_proxy;

    public dynamic class WeakObject extends Proxy 
    {

        private var _item:Array;
        private var _dir:Object;

        public function WeakObject()
        {
            this._dir = new Object();
        }

        public function set(_arg1:String, _arg2:Object, _arg3:Boolean=false):void
        {
            if (_arg2 == null)
            {
                delete this._dir[_arg1];
            }
            else
            {
                this._dir[_arg1] = new WeakRef(_arg2, _arg3);
            };
        }

        public function get(_arg1:String)
        {
            var _local2:WeakRef = this.getWeakRef(_arg1);
            return (((_local2) ? _local2.reference : undefined));
        }

        public function getWeakRef(_arg1:String):WeakRef
        {
            return ((this._dir[_arg1] as WeakRef));
        }

        override flash_proxy function getProperty(_arg1:*)
        {
            return (this.get(_arg1));
        }

        override flash_proxy function callProperty(_arg1:*, ... _args)
        {
            var _local3:Object = this.get(_arg1);
            return (_local3.apply(this, _args));
        }

        override flash_proxy function setProperty(_arg1:*, _arg2:*):void
        {
            this.set(_arg1, _arg2);
        }

        override flash_proxy function nextName(_arg1:int):String
        {
            return (this._item[(_arg1 - 1)]);
        }

        override flash_proxy function nextValue(_arg1:int)
        {
            return (this[this.nextName(_arg1)]);
        }

        override flash_proxy function nextNameIndex(_arg1:int):int
        {
            var _local2:*;
            if (_arg1 == 0)
            {
                this._item = new Array();
                for (_local2 in this._dir)
                {
                    this._item.push(_local2);
                };
            };
            if (_arg1 < this._item.length)
            {
                return ((_arg1 + 1));
            };
            return (0);
        }

        override flash_proxy function deleteProperty(_arg1:*):Boolean
        {
            return (delete this._dir[_arg1]);
        }

        public function toString():String
        {
            return ("[WeakObject]");
        }


    }
}

