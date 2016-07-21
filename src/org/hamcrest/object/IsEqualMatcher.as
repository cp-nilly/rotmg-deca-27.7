package org.hamcrest.object
{
    import org.hamcrest.BaseMatcher;
    import org.hamcrest.Description;

    public class IsEqualMatcher extends BaseMatcher 
    {

        private var _value:Object;

        public function IsEqualMatcher(_arg1:Object)
        {
            _value = _arg1;
        }

        private function areEqual(_arg1:Object, _arg2:Object):Boolean
        {
            if (isNaN((_arg1 as Number)))
            {
                return (isNaN((_arg2 as Number)));
            };
            if (_arg1 == null)
            {
                return ((_arg2 == null));
            };
            if ((_arg1 is Array))
            {
                return ((((_arg2 is Array)) && (areArraysEqual((_arg1 as Array), (_arg2 as Array)))));
            };
            return ((_arg1 == _arg2));
        }

        private function areArraysEqual(_arg1:Array, _arg2:Array):Boolean
        {
            return (((areArraysLengthsEqual(_arg1, _arg2)) && (areArrayElementsEqual(_arg1, _arg2))));
        }

        override public function describeTo(_arg1:Description):void
        {
            _arg1.appendValue(_value);
        }

        private function areArrayElementsEqual(_arg1:Array, _arg2:Array):Boolean
        {
            var _local3:int;
            var _local4:int = _arg1.length;
            while (_local3 < _local4)
            {
                if (!areEqual(_arg1[_local3], _arg2[_local3]))
                {
                    return (false);
                };
                _local3++;
            };
            return (true);
        }

        override public function matches(_arg1:Object):Boolean
        {
            return (areEqual(_arg1, _value));
        }

        private function areArraysLengthsEqual(_arg1:Array, _arg2:Array):Boolean
        {
            return ((_arg1.length == _arg2.length));
        }


    }
}

