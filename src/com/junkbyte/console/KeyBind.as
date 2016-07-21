package com.junkbyte.console
{
    public class KeyBind 
    {

        private var _code:Boolean;
        private var _key:String;

        public function KeyBind(_arg1:*, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Boolean=false, _arg5:Boolean=false)
        {
            this._key = String(_arg1).toUpperCase();
            if ((_arg1 is uint))
            {
                this._code = true;
            }
            else
            {
                if (((!(_arg1)) || (!((this._key.length == 1)))))
                {
                    throw (new Error((("KeyBind: character (first char) must be a single character. You gave [" + _arg1) + "]")));
                };
            };
            if (this._code)
            {
                this._key = ("keycode:" + this._key);
            };
            if (_arg2)
            {
                this._key = (this._key + "+shift");
            };
            if (_arg3)
            {
                this._key = (this._key + "+ctrl");
            };
            if (_arg4)
            {
                this._key = (this._key + "+alt");
            };
            if (_arg5)
            {
                this._key = (this._key + "+up");
            };
        }

        public function get useKeyCode():Boolean
        {
            return (this._code);
        }

        public function get key():String
        {
            return (this._key);
        }


    }
}

