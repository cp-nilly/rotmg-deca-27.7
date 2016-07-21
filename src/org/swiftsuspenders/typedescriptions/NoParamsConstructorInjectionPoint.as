package org.swiftsuspenders.typedescriptions
{
    import org.swiftsuspenders.Injector;

    public class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint 
    {

        public function NoParamsConstructorInjectionPoint()
        {
            super([], 0, injectParameters);
        }

        override public function createInstance(_arg1:Class, _arg2:Injector):Object
        {
            return (new (_arg1)());
        }


    }
}

