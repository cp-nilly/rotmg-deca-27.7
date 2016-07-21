package org.swiftsuspenders
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.utils.SsInternal;
    import flash.system.ApplicationDomain;
    import org.swiftsuspenders.utils.TypeDescriptor;
    import org.swiftsuspenders.reflection.Reflector;
    import avmplus.DescribeTypeJSON;
    import org.swiftsuspenders.reflection.DescribeTypeJSONReflector;
    import org.swiftsuspenders.reflection.DescribeTypeReflector;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.mapping.InjectionMapping;
    import org.swiftsuspenders.mapping.MappingEvent;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
    import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
    import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
    import flash.utils.getDefinitionByName;
    import org.swiftsuspenders.dependencyproviders.ClassProvider;
    import org.swiftsuspenders.typedescriptions.InjectionPoint;

    use namespace SsInternal;

    public class Injector extends EventDispatcher 
    {

        private static var INJECTION_POINTS_CACHE:Dictionary = new Dictionary(true);

        SsInternal const providerMappings:Dictionary = new Dictionary();

        private var _parentInjector:Injector;
        private var _applicationDomain:ApplicationDomain;
        private var _classDescriptor:TypeDescriptor;
        private var _mappings:Dictionary;
        private var _mappingsInProcess:Dictionary;
        private var _defaultProviders:Dictionary;
        private var _managedObjects:Dictionary;
        private var _reflector:Reflector;

        public function Injector()
        {
            super();
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
            try
            {
                this._reflector = ((DescribeTypeJSON.available) ? new DescribeTypeJSONReflector() : new DescribeTypeReflector());
            }
            catch(e:Error)
            {
                _reflector = new DescribeTypeReflector();
            };
            this._classDescriptor = new TypeDescriptor(this._reflector, INJECTION_POINTS_CACHE);
            this._applicationDomain = ApplicationDomain.currentDomain;
        }

        SsInternal static function purgeInjectionPointsCache():void
        {
            INJECTION_POINTS_CACHE = new Dictionary(true);
        }


        public function map(_arg1:Class, _arg2:String=""):InjectionMapping
        {
            var _local3:String = ((getQualifiedClassName(_arg1) + "|") + _arg2);
            return (((this._mappings[_local3]) || (this.createMapping(_arg1, _arg2, _local3))));
        }

        public function unmap(_arg1:Class, _arg2:String=""):void
        {
            var _local3:String = ((getQualifiedClassName(_arg1) + "|") + _arg2);
            var _local4:InjectionMapping = this._mappings[_local3];
            if (((_local4) && (_local4.isSealed)))
            {
                throw (new InjectorError("Can't unmap a sealed mapping"));
            };
            if (!_local4)
            {
                throw (new InjectorError((("Error while removing an injector mapping: " + "No mapping defined for dependency ") + _local3)));
            };
            _local4.getProvider().destroy();
            delete this._mappings[_local3];
            delete this.providerMappings[_local3];
            ((hasEventListener(MappingEvent.POST_MAPPING_REMOVE)) && (dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE, _arg1, _arg2, null))));
        }

        public function satisfies(_arg1:Class, _arg2:String=""):Boolean
        {
            return (!((this.getProvider(((getQualifiedClassName(_arg1) + "|") + _arg2)) == null)));
        }

        public function satisfiesDirectly(_arg1:Class, _arg2:String=""):Boolean
        {
            return (!((this.providerMappings[((getQualifiedClassName(_arg1) + "|") + _arg2)] == null)));
        }

        public function getMapping(_arg1:Class, _arg2:String=""):InjectionMapping
        {
            var _local3:String = ((getQualifiedClassName(_arg1) + "|") + _arg2);
            var _local4:InjectionMapping = this._mappings[_local3];
            if (!_local4)
            {
                throw (new InjectorMissingMappingError((("Error while retrieving an injector mapping: " + "No mapping defined for dependency ") + _local3)));
            };
            return (_local4);
        }

        public function injectInto(_arg1:Object):void
        {
            var _local2:Class = this._reflector.getClass(_arg1);
            this.applyInjectionPoints(_arg1, _local2, this._classDescriptor.getDescription(_local2));
        }

        public function getInstance(_arg1:Class, _arg2:String="", _arg3:Class=null)
        {
            var _local4:String;
            var _local6:ConstructorInjectionPoint;
            _local4 = ((getQualifiedClassName(_arg1) + "|") + _arg2);
            var _local5:DependencyProvider = this.getProvider(_local4, false);
            if (_local5)
            {
                _local6 = this._classDescriptor.getDescription(_arg1).ctor;
                return (_local5.apply(_arg3, this, ((_local6) ? _local6.injectParameters : null)));
            };
            if (_arg2)
            {
                throw (new InjectorMissingMappingError((("No mapping found for request " + _local4) + ". getInstance only creates an unmapped instance if no name is given.")));
            };
            return (this.instantiateUnmapped(_arg1));
        }

        public function destroyInstance(_arg1:Object):void
        {
            var _local2:Class;
            if (!_arg1)
            {
                return;
            };
            _local2 = this._reflector.getClass(_arg1);
            var _local3:TypeDescription = this.getTypeDescription(_local2);
            var _local4:PreDestroyInjectionPoint = _local3.preDestroyMethods;
            while (_local4)
            {
                _local4.applyInjection(_arg1, _local2, this);
                _local4 = PreDestroyInjectionPoint(_local4.next);
            };
        }

        public function teardown():void
        {
            var _local1:InjectionMapping;
            var _local2:Object;
            for each (_local1 in this._mappings)
            {
                _local1.getProvider().destroy();
            };
            for each (_local2 in this._managedObjects)
            {
                this.destroyInstance(_local2);
            };
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
        }

        public function createChildInjector(_arg1:ApplicationDomain=null):Injector
        {
            var _local2:Injector = new Injector();
            _local2.applicationDomain = ((_arg1) || (this.applicationDomain));
            _local2.parentInjector = this;
            return (_local2);
        }

        public function set parentInjector(_arg1:Injector):void
        {
            this._parentInjector = _arg1;
        }

        public function get parentInjector():Injector
        {
            return (this._parentInjector);
        }

        public function set applicationDomain(_arg1:ApplicationDomain):void
        {
            this._applicationDomain = ((_arg1) || (ApplicationDomain.currentDomain));
        }

        public function get applicationDomain():ApplicationDomain
        {
            return (this._applicationDomain);
        }

        public function addTypeDescription(_arg1:Class, _arg2:TypeDescription):void
        {
            this._classDescriptor.addDescription(_arg1, _arg2);
        }

        public function getTypeDescription(_arg1:Class):TypeDescription
        {
            return (this._reflector.describeInjections(_arg1));
        }

        SsInternal function instantiateUnmapped(_arg1:Class):Object
        {
            var _local2:TypeDescription = this._classDescriptor.getDescription(_arg1);
            if (!_local2.ctor)
            {
                throw (new InjectorInterfaceConstructionError(("Can't instantiate interface " + getQualifiedClassName(_arg1))));
            };
            var _local3:* = _local2.ctor.createInstance(_arg1, this);
            ((hasEventListener(InjectionEvent.POST_INSTANTIATE)) && (dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE, _local3, _arg1))));
            this.applyInjectionPoints(_local3, _arg1, _local2);
            return (_local3);
        }

        SsInternal function getProvider(_arg1:String, _arg2:Boolean=true):DependencyProvider
        {
            var _local3:DependencyProvider;
            var _local5:DependencyProvider;
            var _local4:Injector = this;
            while (_local4)
            {
                _local5 = _local4.providerMappings[_arg1];
                if (_local5)
                {
                    if ((_local5 is SoftDependencyProvider))
                    {
                        _local3 = _local5;
                        _local4 = _local4.parentInjector;
                        continue;
                    };
                    if ((((_local5 is LocalOnlyProvider)) && (!((_local4 === this)))))
                    {
                        _local4 = _local4.parentInjector;
                        continue;
                    };
                    return (_local5);
                };
                _local4 = _local4.parentInjector;
            };
            if (_local3)
            {
                return (_local3);
            };
            return (((_arg2) ? this.getDefaultProvider(_arg1) : null));
        }

        SsInternal function getDefaultProvider(mappingId:String):DependencyProvider
        {
            var parts:Array;
            var definition:Object;
            if (mappingId === "String|")
            {
                return (null);
            };
            parts = mappingId.split("|");
            var name:String = parts.pop();
            if (name.length !== 0)
            {
                return (null);
            };
            var typeName:String = parts.pop();
            try
            {
                definition = ((this._applicationDomain.hasDefinition(typeName)) ? this._applicationDomain.getDefinition(typeName) : getDefinitionByName(typeName));
            }
            catch(e:Error)
            {
                return (null);
            };
            if (((!(definition)) || (!((definition is Class)))))
            {
                return (null);
            };
            var type:Class = Class(definition);
            var description:TypeDescription = this._classDescriptor.getDescription(type);
            if (!description.ctor)
            {
                return (null);
            };
            return ((this._defaultProviders[type] = ((this._defaultProviders[type]) || (new ClassProvider(type)))));
        }

        private function createMapping(_arg1:Class, _arg2:String, _arg3:String):InjectionMapping
        {
            var _local4:InjectionMapping;
            if (this._mappingsInProcess[_arg3])
            {
                throw (new InjectorError("Can't change a mapping from inside a listener to it's creation event"));
            };
            this._mappingsInProcess[_arg3] = true;
            ((hasEventListener(MappingEvent.PRE_MAPPING_CREATE)) && (dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE, _arg1, _arg2, null))));
            _local4 = new InjectionMapping(this, _arg1, _arg2, _arg3);
            this._mappings[_arg3] = _local4;
            var _local5:Object = _local4.seal();
            ((hasEventListener(MappingEvent.POST_MAPPING_CREATE)) && (dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE, _arg1, _arg2, _local4))));
            delete this._mappingsInProcess[_arg3];
            _local4.unseal(_local5);
            return (_local4);
        }

        private function applyInjectionPoints(_arg1:Object, _arg2:Class, _arg3:TypeDescription):void
        {
            var _local4:InjectionPoint = _arg3.injectionPoints;
            ((hasEventListener(InjectionEvent.PRE_CONSTRUCT)) && (dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT, _arg1, _arg2))));
            while (_local4)
            {
                _local4.applyInjection(_arg1, _arg2, this);
                _local4 = _local4.next;
            };
            if (_arg3.preDestroyMethods)
            {
                this._managedObjects[_arg1] = _arg1;
            };
            ((hasEventListener(InjectionEvent.POST_CONSTRUCT)) && (dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT, _arg1, _arg2))));
        }


    }
}

