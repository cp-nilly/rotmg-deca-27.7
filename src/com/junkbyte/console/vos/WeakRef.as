package com.junkbyte.console.vos
{
    import flash.utils.Dictionary;

    public class WeakRef 
    {

        private var _val;
        private var _strong:Boolean;

        public function WeakRef(_arg1:*, _arg2:Boolean=false)
        {
            this._strong = _arg2;
            this.reference = _arg1;
        }

        public function get reference()
        {
            var _local1:*;
            if (this._strong)
            {
                return (this._val);
            };
            for (_local1 in this._val)
            {
                return (_local1);
            };
            return (null);
        }

        public function set reference(_arg1:*):void
        {
            if (this._strong)
            {
                this._val = _arg1;
            }
            else
            {
                this._val = new Dictionary(true);
                this._val[_arg1] = null;
            };
        }

        public function get strong():Boolean
        {
            return (this._strong);
        }


    }
}

