package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class ForwardingProvider implements DependencyProvider 
    {

        public var provider:DependencyProvider;

        public function ForwardingProvider(_arg1:DependencyProvider)
        {
            this.provider = _arg1;
        }

        public function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object
        {
            return (this.provider.apply(_arg1, _arg2, _arg3));
        }

        public function destroy():void
        {
            this.provider.destroy();
        }


    }
}

