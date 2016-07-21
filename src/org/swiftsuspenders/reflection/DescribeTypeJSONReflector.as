package org.swiftsuspenders.reflection
{
    import avmplus.DescribeTypeJSON;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
    import org.swiftsuspenders.InjectorError;

    public class DescribeTypeJSONReflector extends ReflectorBase implements Reflector 
    {

        private const _descriptor:DescribeTypeJSON = new DescribeTypeJSON();


        public function typeImplements(_arg1:Class, _arg2:Class):Boolean
        {
            if (_arg1 == _arg2)
            {
                return (true);
            };
            var _local3:String = getQualifiedClassName(_arg2);
            var _local4:Object = this._descriptor.getInstanceDescription(_arg1).traits;
            return (((((_local4.bases as Array).indexOf(_local3) > -1)) || (((_local4.interfaces as Array).indexOf(_local3) > -1))));
        }

        public function describeInjections(_arg1:Class):TypeDescription
        {
            var _local2:Object;
            _local2 = this._descriptor.getInstanceDescription(_arg1);
            var _local3:Object = _local2.traits;
            var _local4:String = _local2.name;
            var _local5:TypeDescription = new TypeDescription(false);
            this.addCtorInjectionPoint(_local5, _local3, _local4);
            this.addFieldInjectionPoints(_local5, _local3.variables);
            this.addFieldInjectionPoints(_local5, _local3.accessors);
            this.addMethodInjectionPoints(_local5, _local3.methods, _local4);
            this.addPostConstructMethodPoints(_local5, _local3.variables, _local4);
            this.addPostConstructMethodPoints(_local5, _local3.accessors, _local4);
            this.addPostConstructMethodPoints(_local5, _local3.methods, _local4);
            this.addPreDestroyMethodPoints(_local5, _local3.methods, _local4);
            return (_local5);
        }

        private function addCtorInjectionPoint(_arg1:TypeDescription, _arg2:Object, _arg3:String):void
        {
            var _local5:Dictionary;
            var _local6:Array;
            var _local4:Array = _arg2.constructor;
            if (!_local4)
            {
                _arg1.ctor = (((_arg2.bases.length > 0)) ? new NoParamsConstructorInjectionPoint() : null);
                return;
            };
            _local5 = this.extractTagParameters("Inject", _arg2.metadata);
            _local6 = ((((_local5) && (_local5.name))) || ("")).split(",");
            var _local7:int = this.gatherMethodParameters(_local4, _local6, _arg3);
            _arg1.ctor = new ConstructorInjectionPoint(_local4, _local7, _local5);
        }

        private function addMethodInjectionPoints(_arg1:TypeDescription, _arg2:Array, _arg3:String):void
        {
            var _local6:Object;
            var _local7:Dictionary;
            var _local8:Boolean;
            var _local9:Array;
            var _local10:Array;
            var _local11:uint;
            var _local12:MethodInjectionPoint;
            if (!_arg2)
            {
                return;
            };
            var _local4:uint = _arg2.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = _arg2[_local5];
                _local7 = this.extractTagParameters("Inject", _local6.metadata);
                if (_local7)
                {
                    _local8 = (_local7.optional == "true");
                    _local9 = ((_local7.name) || ("")).split(",");
                    _local10 = _local6.parameters;
                    _local11 = this.gatherMethodParameters(_local10, _local9, _arg3);
                    _local12 = new MethodInjectionPoint(_local6.name, _local10, _local11, _local8, _local7);
                    _arg1.addInjectionPoint(_local12);
                };
                _local5++;
            };
        }

        private function addPostConstructMethodPoints(_arg1:TypeDescription, _arg2:Array, _arg3:String):void
        {
            var _local4:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct", _arg2, _arg3);
            var _local5:int;
            var _local6:int = _local4.length;
            while (_local5 < _local6)
            {
                _arg1.addInjectionPoint(_local4[_local5]);
                _local5++;
            };
        }

        private function addPreDestroyMethodPoints(_arg1:TypeDescription, _arg2:Array, _arg3:String):void
        {
            var _local4:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy", _arg2, _arg3);
            if (!_local4.length)
            {
                return;
            };
            _arg1.preDestroyMethods = _local4[0];
            _arg1.preDestroyMethods.last = _local4[0];
            var _local5:int = 1;
            var _local6:int = _local4.length;
            while (_local5 < _local6)
            {
                _arg1.preDestroyMethods.last.next = _local4[_local5];
                _arg1.preDestroyMethods.last = _local4[_local5];
                _local5++;
            };
        }

        private function addFieldInjectionPoints(_arg1:TypeDescription, _arg2:Array):void
        {
            var _local5:Object;
            var _local6:Dictionary;
            var _local7:String;
            var _local8:Boolean;
            var _local9:PropertyInjectionPoint;
            if (!_arg2)
            {
                return;
            };
            var _local3:uint = _arg2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = _arg2[_local4];
                _local6 = this.extractTagParameters("Inject", _local5.metadata);
                if (_local6)
                {
                    _local7 = ((_local6.name) || (""));
                    _local8 = (_local6.optional == "true");
                    _local9 = new PropertyInjectionPoint(((_local5.type + "|") + _local7), _local5.name, _local8, _local6);
                    _arg1.addInjectionPoint(_local9);
                };
                _local4++;
            };
        }

        private function gatherMethodParameters(_arg1:Array, _arg2:Array, _arg3:String):uint
        {
            var _local7:Object;
            var _local8:String;
            var _local9:String;
            var _local4:uint;
            var _local5:uint = _arg1.length;
            var _local6:int;
            while (_local6 < _local5)
            {
                _local7 = _arg1[_local6];
                _local8 = ((_arg2[_local6]) || (""));
                _local9 = _local7.type;
                if (_local9 == "*")
                {
                    if (!_local7.optional)
                    {
                        throw (new InjectorError((('Error in method definition of injectee "' + _arg3) + ". Required parameters can't have type \"*\".")));
                    };
                    _local9 = null;
                };
                if (!_local7.optional)
                {
                    _local4++;
                };
                _arg1[_local6] = ((_local9 + "|") + _local8);
                _local6++;
            };
            return (_local4);
        }

        private function gatherOrderedInjectionPointsForTag(_arg1:Class, _arg2:String, _arg3:Array, _arg4:String):Array
        {
            var _local8:Object;
            var _local9:Object;
            var _local10:Array;
            var _local11:Array;
            var _local12:uint;
            var _local13:int;
            var _local5:Array = [];
            if (!_arg3)
            {
                return (_local5);
            };
            var _local6:uint = _arg3.length;
            var _local7:int;
            while (_local7 < _local6)
            {
                _local8 = _arg3[_local7];
                _local9 = this.extractTagParameters(_arg2, _local8.metadata);
                if (_local9)
                {
                    _local10 = ((_local9.name) || ("")).split(",");
                    _local11 = _local8.parameters;
                    if (_local11)
                    {
                        _local12 = this.gatherMethodParameters(_local11, _local10, _arg4);
                    }
                    else
                    {
                        _local11 = [];
                        _local12 = 0;
                    };
                    _local13 = parseInt(_local9.order, 10);
                    if (_local13.toString(10) != _local9.order)
                    {
                        _local13 = int.MAX_VALUE;
                    };
                    _local5.push(new (_arg1)(_local8.name, _local11, _local12, _local13));
                };
                _local7++;
            };
            if (_local5.length > 0)
            {
                _local5.sortOn("order", Array.NUMERIC);
            };
            return (_local5);
        }

        private function extractTagParameters(_arg1:String, _arg2:Array):Dictionary
        {
            var _local5:Object;
            var _local6:Array;
            var _local7:Dictionary;
            var _local8:int;
            var _local9:int;
            var _local10:Object;
            var _local3:uint = ((_arg2) ? _arg2.length : 0);
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = _arg2[_local4];
                if (_local5.name == _arg1)
                {
                    _local6 = _local5.value;
                    _local7 = new Dictionary();
                    _local8 = _local6.length;
                    _local9 = 0;
                    while (_local9 < _local8)
                    {
                        _local10 = _local6[_local9];
                        _local7[_local10.key] = ((_local7[_local10.key]) ? ((_local7[_local10.key] + ",") + _local10.value) : _local10.value);
                        _local9++;
                    };
                    return (_local7);
                };
                _local4++;
            };
            return (null);
        }


    }
}

