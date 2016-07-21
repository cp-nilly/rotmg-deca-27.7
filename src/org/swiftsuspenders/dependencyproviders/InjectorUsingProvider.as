package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class InjectorUsingProvider extends ForwardingProvider 
    {

        public var injector:Injector;

        public function InjectorUsingProvider(_arg1:Injector, _arg2:DependencyProvider)
        {
            super(_arg2);
            this.injector = _arg1;
        }

        override public function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object
        {
            return (provider.apply(_arg1, this.injector, _arg3));
        }


    }
}

