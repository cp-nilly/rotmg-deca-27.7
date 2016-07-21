package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class ValueProvider implements DependencyProvider 
    {

        private var _value:Object;

        public function ValueProvider(_arg1:Object)
        {
            this._value = _arg1;
        }

        public function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object
        {
            return (this._value);
        }

        public function destroy():void
        {
        }


    }
}

