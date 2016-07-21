package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.InjectorError;
    import flash.utils.getQualifiedClassName;

    public class TypeDescription 
    {

        public var ctor:ConstructorInjectionPoint;
        public var injectionPoints:InjectionPoint;
        public var preDestroyMethods:PreDestroyInjectionPoint;
        private var _postConstructAdded:Boolean;

        public function TypeDescription(_arg1:Boolean=true)
        {
            if (_arg1)
            {
                this.ctor = new NoParamsConstructorInjectionPoint();
            };
        }

        public function setConstructor(_arg1:Array, _arg2:Array=null, _arg3:uint=2147483647, _arg4:Dictionary=null):TypeDescription
        {
            this.ctor = new ConstructorInjectionPoint(this.createParameterMappings(_arg1, ((_arg2) || ([]))), _arg3, _arg4);
            return (this);
        }

        public function addFieldInjection(_arg1:String, _arg2:Class, _arg3:String="", _arg4:Boolean=false, _arg5:Dictionary=null):TypeDescription
        {
            if (this._postConstructAdded)
            {
                throw (new InjectorError("Can't add injection point after post construct method"));
            };
            this.addInjectionPoint(new PropertyInjectionPoint(((getQualifiedClassName(_arg2) + "|") + _arg3), _arg1, _arg4, _arg5));
            return (this);
        }

        public function addMethodInjection(_arg1:String, _arg2:Array, _arg3:Array=null, _arg4:uint=2147483647, _arg5:Boolean=false, _arg6:Dictionary=null):TypeDescription
        {
            if (this._postConstructAdded)
            {
                throw (new InjectorError("Can't add injection point after post construct method"));
            };
            this.addInjectionPoint(new MethodInjectionPoint(_arg1, this.createParameterMappings(_arg2, ((_arg3) || ([]))), Math.min(_arg4, _arg2.length), _arg5, _arg6));
            return (this);
        }

        public function addPostConstructMethod(_arg1:String, _arg2:Array, _arg3:Array=null, _arg4:uint=2147483647):TypeDescription
        {
            this._postConstructAdded = true;
            this.addInjectionPoint(new PostConstructInjectionPoint(_arg1, this.createParameterMappings(_arg2, ((_arg3) || ([]))), Math.min(_arg4, _arg2.length), 0));
            return (this);
        }

        public function addPreDestroyMethod(_arg1:String, _arg2:Array, _arg3:Array=null, _arg4:uint=2147483647):TypeDescription
        {
            var _local5:PreDestroyInjectionPoint = new PreDestroyInjectionPoint(_arg1, this.createParameterMappings(_arg2, ((_arg3) || ([]))), Math.min(_arg4, _arg2.length), 0);
            if (this.preDestroyMethods)
            {
                this.preDestroyMethods.last.next = _local5;
                this.preDestroyMethods.last = _local5;
            }
            else
            {
                this.preDestroyMethods = _local5;
                this.preDestroyMethods.last = _local5;
            };
            return (this);
        }

        public function addInjectionPoint(_arg1:InjectionPoint):void
        {
            if (this.injectionPoints)
            {
                this.injectionPoints.last.next = _arg1;
                this.injectionPoints.last = _arg1;
            }
            else
            {
                this.injectionPoints = _arg1;
                this.injectionPoints.last = _arg1;
            };
        }

        private function createParameterMappings(_arg1:Array, _arg2:Array):Array
        {
            var _local3:Array = new Array(_arg1.length);
            var _local4:int = _local3.length;
            while (_local4--)
            {
                _local3[_local4] = ((getQualifiedClassName(_arg1[_local4]) + "|") + ((_arg2[_local4]) || ("")));
            };
            return (_local3);
        }


    }
}

