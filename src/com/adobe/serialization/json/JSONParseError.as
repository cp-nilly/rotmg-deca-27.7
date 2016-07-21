package com.adobe.serialization.json
{
    public class JSONParseError extends Error 
    {

        private var _location:int;
        private var _text:String;

        public function JSONParseError(_arg1:String="", _arg2:int=0, _arg3:String="")
        {
            super(_arg1);
            name = "JSONParseError";
            this._location = _arg2;
            this._text = _arg3;
        }

        public function get location():int
        {
            return (this._location);
        }

        public function get text():String
        {
            return (this._text);
        }


    }
}

