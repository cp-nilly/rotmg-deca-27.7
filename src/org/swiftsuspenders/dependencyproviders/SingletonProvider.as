package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.InjectorError;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;

    public class SingletonProvider implements DependencyProvider 
    {

        private var _responseType:Class;
        private var _creatingInjector:Injector;
        private var _response:Object;
        private var _destroyed:Boolean;

        public function SingletonProvider(_arg1:Class, _arg2:Injector)
        {
            this._responseType = _arg1;
            this._creatingInjector = _arg2;
        }

        public function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object
        {
            return ((this._response = ((this._response) || (this.createResponse(this._creatingInjector)))));
        }

        private function createResponse(_arg1:Injector):Object
        {
            if (this._destroyed)
            {
                throw (new InjectorError(("Forbidden usage of unmapped singleton provider for type " + getQualifiedClassName(this._responseType))));
            };
            return (_arg1.SsInternal::instantiateUnmapped(this._responseType));
        }

        public function destroy():void
        {
            this._destroyed = true;
            if (!this._response)
            {
                return;
            };
            var _local1:TypeDescription = this._creatingInjector.getTypeDescription(this._responseType);
            var _local2:PreDestroyInjectionPoint = _local1.preDestroyMethods;
            while (_local2)
            {
                _local2.applyInjection(this._response, this._responseType, this._creatingInjector);
                _local2 = PreDestroyInjectionPoint(_local2.next);
            };
            this._response = null;
        }


    }
}

