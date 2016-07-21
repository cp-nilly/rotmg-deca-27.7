package com.adobe.serialization.json
{
    public class JSONToken 
    {

        private var _type:int;
        private var _value:Object;

        public function JSONToken(_arg1:int=-1, _arg2:Object=null)
        {
            this._type = _arg1;
            this._value = _arg2;
        }

        public function get type():int
        {
            return (this._type);
        }

        public function set type(_arg1:int):void
        {
            this._type = _arg1;
        }

        public function get value():Object
        {
            return (this._value);
        }

        public function set value(_arg1:Object):void
        {
            this._value = _arg1;
        }


    }
}

