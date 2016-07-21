package org.hamcrest
{
    public interface Description 
    {

        function appendValue(_arg1:Object):Description;
        function appendList(_arg1:String, _arg2:String, _arg3:String, _arg4:Array):Description;
        function appendDescriptionOf(_arg1:SelfDescribing):Description;
        function toString():String;
        function appendText(_arg1:String):Description;
        function appendMismatchOf(_arg1:Matcher, _arg2:*):Description;

    }
}

