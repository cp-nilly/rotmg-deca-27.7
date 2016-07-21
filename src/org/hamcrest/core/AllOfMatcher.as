package org.hamcrest.core
{
    import org.hamcrest.DiagnosingMatcher;
    import org.hamcrest.Matcher;
    import org.hamcrest.Description;

    public class AllOfMatcher extends DiagnosingMatcher 
    {

        private var _matchers:Array;

        public function AllOfMatcher(_arg1:Array)
        {
            _matchers = ((_arg1) || ([]));
        }

        override protected function matchesOrDescribesMismatch(_arg1:Object, _arg2:Description):Boolean
        {
            var _local3:Matcher;
            for each (_local3 in _matchers)
            {
                if (!_local3.matches(_arg1))
                {
                    _arg2.appendDescriptionOf(_local3).appendText(" ").appendMismatchOf(_local3, _arg1);
                    return (false);
                };
            };
            return (true);
        }

        override public function describeTo(_arg1:Description):void
        {
            _arg1.appendList("(", " and ", ")", _matchers);
        }


    }
}

