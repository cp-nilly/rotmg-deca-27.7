package org.swiftsuspenders.reflection
{
    import flash.utils.describeType;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.InjectorError;
    import flash.utils.*;

    public class DescribeTypeReflector extends ReflectorBase implements Reflector 
    {

        private var _currentFactoryXML:XML;


        public function typeImplements(type:Class, superType:Class):Boolean
        {
            if (type == superType)
            {
                return (true);
            };
            var factoryDescription:XML = describeType(type).factory[0];
            return ((factoryDescription.children().(((name() == "implementsInterface")) || ((name() == "extendsClass"))).(attribute("type") == getQualifiedClassName(superType)).length() > 0));
        }

        public function describeInjections(_arg1:Class):TypeDescription
        {
            this._currentFactoryXML = describeType(_arg1).factory[0];
            var _local2:TypeDescription = new TypeDescription(false);
            this.addCtorInjectionPoint(_local2, _arg1);
            this.addFieldInjectionPoints(_local2);
            this.addMethodInjectionPoints(_local2);
            this.addPostConstructMethodPoints(_local2);
            this.addPreDestroyMethodPoints(_local2);
            this._currentFactoryXML = null;
            return (_local2);
        }

        private function addCtorInjectionPoint(description:TypeDescription, type:Class):void
        {
            var injectParameters:Dictionary;
            var parameters:Array;
            var node:XML = this._currentFactoryXML.constructor[0];
            if (!node)
            {
                if ((((this._currentFactoryXML.parent().@name == "Object")) || ((this._currentFactoryXML.extendsClass.length() > 0))))
                {
                    description.ctor = new NoParamsConstructorInjectionPoint();
                };
                return;
            };
            injectParameters = this.extractNodeParameters(node.parent().metadata.arg);
            var parameterNames:Array = ((injectParameters.name) || ("")).split(",");
            var parameterNodes:XMLList = node.parameter;
            if (parameterNodes.(@type == "*").length() == parameterNodes.@type.length())
            {
                this.createDummyInstance(node, type);
            };
            parameters = this.gatherMethodParameters(parameterNodes, parameterNames);
            var requiredParameters:uint = parameters.required;
            delete parameters.required;
            description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
        }

        private function extractNodeParameters(_arg1:XMLList):Dictionary
        {
            var _local5:XML;
            var _local6:String;
            var _local2:Dictionary = new Dictionary();
            var _local3:uint = _arg1.length();
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = _arg1[_local4];
                _local6 = _local5.@key;
                _local2[_local6] = ((_local2[_local6]) ? ((_local2[_local6] + ",") + _local5.attribute("value")) : _local5.attribute("value"));
                _local4++;
            };
            return (_local2);
        }

        private function addFieldInjectionPoints(description:TypeDescription):void
        {
            var node:XML;
            var mappingId:String;
            var propertyName:String;
            var injectParameters:Dictionary;
            var injectionPoint:PropertyInjectionPoint;
            for each (node in this._currentFactoryXML.*.(((name() == "variable")) || ((name() == "accessor"))).metadata.(@name == "Inject"))
            {
                mappingId = ((node.parent().@type + "|") + node.arg.(@key == "name").attribute("value"));
                propertyName = node.parent().@name;
                injectParameters = this.extractNodeParameters(node.arg);
                injectionPoint = new PropertyInjectionPoint(mappingId, propertyName, (injectParameters.optional == "true"), injectParameters);
                description.addInjectionPoint(injectionPoint);
            };
        }

        private function addMethodInjectionPoints(description:TypeDescription):void
        {
            var node:XML;
            var injectParameters:Dictionary;
            var parameterNames:Array;
            var parameters:Array;
            var requiredParameters:uint;
            var injectionPoint:MethodInjectionPoint;
            for each (node in this._currentFactoryXML.method.metadata.(@name == "Inject"))
            {
                injectParameters = this.extractNodeParameters(node.arg);
                parameterNames = ((injectParameters.name) || ("")).split(",");
                parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
                requiredParameters = parameters.required;
                delete parameters.required;
                injectionPoint = new MethodInjectionPoint(node.parent().@name, parameters, requiredParameters, (injectParameters.optional == "true"), injectParameters);
                description.addInjectionPoint(injectionPoint);
            };
        }

        private function addPostConstructMethodPoints(_arg1:TypeDescription):void
        {
            var _local2:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct");
            var _local3:int;
            var _local4:int = _local2.length;
            while (_local3 < _local4)
            {
                _arg1.addInjectionPoint(_local2[_local3]);
                _local3++;
            };
        }

        private function addPreDestroyMethodPoints(_arg1:TypeDescription):void
        {
            var _local2:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy");
            if (!_local2.length)
            {
                return;
            };
            _arg1.preDestroyMethods = _local2[0];
            _arg1.preDestroyMethods.last = _local2[0];
            var _local3:int = 1;
            var _local4:int = _local2.length;
            while (_local3 < _local4)
            {
                _arg1.preDestroyMethods.last.next = _local2[_local3];
                _arg1.preDestroyMethods.last = _local2[_local3];
                _local3++;
            };
        }

        private function gatherMethodParameters(_arg1:XMLList, _arg2:Array):Array
        {
            var _local4:uint;
            var _local7:XML;
            var _local8:String;
            var _local9:String;
            var _local10:Boolean;
            var _local3:uint;
            _local4 = _arg1.length();
            var _local5:Array = new Array(_local4);
            var _local6:int;
            while (_local6 < _local4)
            {
                _local7 = _arg1[_local6];
                _local8 = ((_arg2[_local6]) || (""));
                _local9 = _local7.@type;
                _local10 = (_local7.@optional == "true");
                if (_local9 == "*")
                {
                    if (!_local10)
                    {
                        throw (new InjectorError((('Error in method definition of injectee "' + this._currentFactoryXML.@type) + "Required parameters can't have type \"*\".")));
                    };
                    _local9 = null;
                };
                if (!_local10)
                {
                    _local3++;
                };
                _local5[_local6] = ((_local9 + "|") + _local8);
                _local6++;
            };
            _local5.required = _local3;
            return (_local5);
        }

        private function gatherOrderedInjectionPointsForTag(injectionPointType:Class, tag:String):Array
        {
            var node:XML;
            var injectParameters:Dictionary;
            var parameterNames:Array;
            var parameters:Array;
            var requiredParameters:uint;
            var order:Number;
            var injectionPoints:Array = [];
            for each (node in this._currentFactoryXML..metadata.(@name == tag))
            {
                injectParameters = this.extractNodeParameters(node.arg);
                parameterNames = ((injectParameters.name) || ("")).split(",");
                parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
                requiredParameters = parameters.required;
                delete parameters.required;
                order = parseInt(node.arg.(@key == "order").@value);
                injectionPoints.push(new (injectionPointType)(node.parent().@name, parameters, requiredParameters, ((isNaN(order)) ? int.MAX_VALUE : order)));
            };
            if (injectionPoints.length > 0)
            {
                injectionPoints.sortOn("order", Array.NUMERIC);
            };
            return (injectionPoints);
        }

        private function createDummyInstance(constructorNode:XML, clazz:Class):void
        {
            try
            {
                switch (constructorNode.children().length())
                {
                    case 0:
                        new (clazz)();
                        break;
                    case 1:
                        new (clazz)(null);
                        break;
                    case 2:
                        new (clazz)(null, null);
                        break;
                    case 3:
                        new (clazz)(null, null, null);
                        break;
                    case 4:
                        new (clazz)(null, null, null, null);
                        break;
                    case 5:
                        new (clazz)(null, null, null, null, null);
                        break;
                    case 6:
                        new (clazz)(null, null, null, null, null, null);
                        break;
                    case 7:
                        new (clazz)(null, null, null, null, null, null, null);
                        break;
                    case 8:
                        new (clazz)(null, null, null, null, null, null, null, null);
                        break;
                    case 9:
                        new (clazz)(null, null, null, null, null, null, null, null, null);
                        break;
                    case 10:
                        new (clazz)(null, null, null, null, null, null, null, null, null, null);
                        break;
                };
            }
            catch(error:Error)
            {
                trace(((((("Exception caught while trying to create dummy instance for constructor " + "injection. It's almost certainly ok to ignore this exception, but you ") + "might want to restructure your constructor to prevent errors from ") + "happening. See the Swiftsuspenders documentation for more details.\n") + "The caught exception was:\n") + error));
            };
            constructorNode.setChildren(describeType(clazz).factory.constructor[0].children());
        }


    }
}

