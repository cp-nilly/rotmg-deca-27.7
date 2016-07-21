package org.hamcrest.object
{
    import org.hamcrest.BaseMatcher;
    import flash.utils.getQualifiedClassName;
    import org.hamcrest.Description;

    public class IsInstanceOfMatcher extends BaseMatcher 
    {

        private var _typeName:String;
        private var _type:Class;

        public function IsInstanceOfMatcher(_arg1:Class)
        {
            _type = _arg1;
            _typeName = getQualifiedClassName(_arg1);
        }

        override public function describeTo(_arg1:Description):void
        {
            _arg1.appendText("an instance of ").appendText(_typeName);
        }

        override public function matches(_arg1:Object):Boolean
        {
            return ((_arg1 is _type));
        }


    }
}

