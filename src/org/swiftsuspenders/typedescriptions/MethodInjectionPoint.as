package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import avmplus.getQualifiedClassName;

    public class MethodInjectionPoint extends InjectionPoint 
    {

        private static const _parameterValues:Array = [];

        protected var _parameterMappingIDs:Array;
        protected var _requiredParameters:int;
        private var _isOptional:Boolean;
        private var _methodName:String;

        public function MethodInjectionPoint(_arg1:String, _arg2:Array, _arg3:uint, _arg4:Boolean, _arg5:Dictionary)
        {
            this._methodName = _arg1;
            this._parameterMappingIDs = _arg2;
            this._requiredParameters = _arg3;
            this._isOptional = _arg4;
            this.injectParameters = _arg5;
        }

        override public function applyInjection(_arg1:Object, _arg2:Class, _arg3:Injector):void
        {
            var _local4:Array = this.gatherParameterValues(_arg1, _arg2, _arg3);
            if (_local4.length >= this._requiredParameters)
            {
                (_arg1[this._methodName] as Function).apply(_arg1, _local4);
            };
            _local4.length = 0;
        }

        protected function gatherParameterValues(_arg1:Object, _arg2:Class, _arg3:Injector):Array
        {
            var _local7:String;
            var _local8:DependencyProvider;
            var _local4:int = this._parameterMappingIDs.length;
            var _local5:Array = _parameterValues;
            _local5.length = _local4;
            var _local6:int;
            while (_local6 < _local4)
            {
                _local7 = this._parameterMappingIDs[_local6];
                _local8 = _arg3.SsInternal::getProvider(_local7);
                if (!_local8)
                {
                    if ((((_local6 >= this._requiredParameters)) || (this._isOptional))) break;
                    throw (new InjectorMissingMappingError(((((((((('Injector is missing a mapping to handle injection into target "' + _arg1) + '" of type "') + getQualifiedClassName(_arg2)) + '". \t\t\t\t\t\tTarget dependency: ') + _local7) + ", method: ") + this._methodName) + ", parameter: ") + (_local6 + 1))));
                };
                _local5[_local6] = _local8.apply(_arg2, _arg3, injectParameters);
                _local6++;
            };
            return (_local5);
        }


    }
}

