package org.hamcrest.core
{
    import org.hamcrest.BaseMatcher;
    import org.hamcrest.Matcher;
    import org.hamcrest.Description;

    public class IsNotMatcher extends BaseMatcher 
    {

        private var _matcher:Matcher;

        public function IsNotMatcher(_arg1:Matcher)
        {
            _matcher = _arg1;
        }

        override public function matches(_arg1:Object):Boolean
        {
            return (!(_matcher.matches(_arg1)));
        }

        override public function describeTo(_arg1:Description):void
        {
            _arg1.appendText("not ").appendDescriptionOf(_matcher);
        }


    }
}

