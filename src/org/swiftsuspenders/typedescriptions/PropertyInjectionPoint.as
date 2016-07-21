package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.Injector;

    public class PropertyInjectionPoint extends InjectionPoint 
    {

        private var _propertyName:String;
        private var _mappingId:String;
        private var _optional:Boolean;

        public function PropertyInjectionPoint(_arg1:String, _arg2:String, _arg3:Boolean, _arg4:Dictionary)
        {
            this._propertyName = _arg2;
            this._mappingId = _arg1;
            this._optional = _arg3;
            this.injectParameters = _arg4;
        }

        override public function applyInjection(_arg1:Object, _arg2:Class, _arg3:Injector):void
        {
            var _local4:DependencyProvider = _arg3.SsInternal::getProvider(this._mappingId);
            if (!_local4)
            {
                if (this._optional)
                {
                    return;
                };
                throw (new InjectorMissingMappingError((((((((('Injector is missing a mapping to handle injection into property "' + this._propertyName) + '" of object "') + _arg1) + '" with type "') + getQualifiedClassName(_arg2)) + '". Target dependency: "') + this._mappingId) + '"')));
            };
            _arg1[this._propertyName] = _local4.apply(_arg2, _arg3, injectParameters);
        }


    }
}

