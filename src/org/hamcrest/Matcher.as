package org.hamcrest
{
    public interface Matcher extends SelfDescribing 
    {

        function describeMismatch(_arg1:Object, _arg2:Description):void;
        function matches(_arg1:Object):Boolean;

    }
}

