package org.hamcrest
{
    public class NullDescription implements Description 
    {


        public function appendMismatchOf(_arg1:Matcher, _arg2:*):Description
        {
            return (this);
        }

        public function toString():String
        {
            return ("");
        }

        public function appendText(_arg1:String):Description
        {
            return (this);
        }

        public function appendValue(_arg1:Object):Description
        {
            return (this);
        }

        public function appendList(_arg1:String, _arg2:String, _arg3:String, _arg4:Array):Description
        {
            return (this);
        }

        public function appendDescriptionOf(_arg1:SelfDescribing):Description
        {
            return (this);
        }


    }
}

