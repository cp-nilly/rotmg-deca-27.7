package org.hamcrest
{
    public class StringDescription extends BaseDescription 
    {

        private var _out:String;

        public function StringDescription()
        {
            clear();
        }

        public static function toString(_arg1:SelfDescribing):String
        {
            return (new (StringDescription)().appendDescriptionOf(_arg1).toString());
        }


        override protected function append(_arg1:Object):void
        {
            _out = (_out + String(_arg1));
        }

        override public function toString():String
        {
            return (_out);
        }

        public function clear():void
        {
            _out = "";
        }


    }
}

