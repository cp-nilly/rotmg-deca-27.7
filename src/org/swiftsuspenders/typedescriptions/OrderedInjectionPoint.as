package org.swiftsuspenders.typedescriptions
{
    public class OrderedInjectionPoint extends MethodInjectionPoint 
    {

        public var order:int;

        public function OrderedInjectionPoint(_arg1:String, _arg2:Array, _arg3:uint, _arg4:int)
        {
            super(_arg1, _arg2, _arg3, false, null);
            this.order = _arg4;
        }

    }
}

