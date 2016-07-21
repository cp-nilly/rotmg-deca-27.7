package org.swiftsuspenders.mapping
{
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.dependencyproviders.ClassProvider;
    import org.swiftsuspenders.dependencyproviders.SingletonProvider;
    import org.swiftsuspenders.dependencyproviders.ValueProvider;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.InjectorError;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.dependencyproviders.ForwardingProvider;
    import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
    import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
    import org.swiftsuspenders.dependencyproviders.InjectorUsingProvider;

    public class InjectionMapping implements ProviderlessMapping, UnsealedMapping 
    {

        private var _type:Class;
        private var _name:String;
        private var _mappingId:String;
        private var _creatingInjector:Injector;
        private var _defaultProviderSet:Boolean;
        private var _overridingInjector:Injector;
        private var _soft:Boolean;
        private var _local:Boolean;
        private var _sealed:Boolean;
        private var _sealKey:Object;

        public function InjectionMapping(_arg1:Injector, _arg2:Class, _arg3:String, _arg4:String)
        {
            this._creatingInjector = _arg1;
            this._type = _arg2;
            this._name = _arg3;
            this._mappingId = _arg4;
            this._defaultProviderSet = true;
            this.mapProvider(new ClassProvider(_arg2));
        }

        public function asSingleton():UnsealedMapping
        {
            this.toSingleton(this._type);
            return (this);
        }

        public function toType(_arg1:Class):UnsealedMapping
        {
            this.toProvider(new ClassProvider(_arg1));
            return (this);
        }

        public function toSingleton(_arg1:Class):UnsealedMapping
        {
            this.toProvider(new SingletonProvider(_arg1, this._creatingInjector));
            return (this);
        }

        public function toValue(_arg1:Object):UnsealedMapping
        {
            this.toProvider(new ValueProvider(_arg1));
            return (this);
        }

        public function toProvider(_arg1:DependencyProvider):UnsealedMapping
        {
            ((this._sealed) && (this.throwSealedError()));
            if (((((this.hasProvider()) && (!((_arg1 == null))))) && (!(this._defaultProviderSet))))
            {
                trace(((((("Warning: Injector already has a mapping for " + this._mappingId) + ".\n ") + "If you have overridden this mapping intentionally you can use ") + '"injector.unmap()" prior to your replacement mapping in order to ') + "avoid seeing this message."));
                ((this._creatingInjector.hasEventListener(MappingEvent.MAPPING_OVERRIDE)) && (this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.MAPPING_OVERRIDE, this._type, this._name, this))));
            };
            this.dispatchPreChangeEvent();
            this._defaultProviderSet = false;
            this.mapProvider(_arg1);
            this.dispatchPostChangeEvent();
            return (this);
        }

        public function softly():ProviderlessMapping
        {
            var _local1:DependencyProvider;
            ((this._sealed) && (this.throwSealedError()));
            if (!this._soft)
            {
                _local1 = this.getProvider();
                this.dispatchPreChangeEvent();
                this._soft = true;
                this.mapProvider(_local1);
                this.dispatchPostChangeEvent();
            };
            return (this);
        }

        public function locally():ProviderlessMapping
        {
            ((this._sealed) && (this.throwSealedError()));
            if (this._local)
            {
                return (this);
            };
            var _local1:DependencyProvider = this.getProvider();
            this.dispatchPreChangeEvent();
            this._local = true;
            this.mapProvider(_local1);
            this.dispatchPostChangeEvent();
            return (this);
        }

        public function seal():Object
        {
            if (this._sealed)
            {
                throw (new InjectorError("Mapping is already sealed."));
            };
            this._sealed = true;
            this._sealKey = {};
            return (this._sealKey);
        }

        public function unseal(_arg1:Object):InjectionMapping
        {
            if (!this._sealed)
            {
                throw (new InjectorError("Can't unseal a non-sealed mapping."));
            };
            if (_arg1 !== this._sealKey)
            {
                throw (new InjectorError("Can't unseal mapping without the correct key."));
            };
            this._sealed = false;
            this._sealKey = null;
            return (this);
        }

        public function get isSealed():Boolean
        {
            return (this._sealed);
        }

        public function hasProvider():Boolean
        {
            return (Boolean(this._creatingInjector.SsInternal::providerMappings[this._mappingId]));
        }

        public function getProvider():DependencyProvider
        {
            var _local1:DependencyProvider = this._creatingInjector.SsInternal::providerMappings[this._mappingId];
            while ((_local1 is ForwardingProvider))
            {
                _local1 = ForwardingProvider(_local1).provider;
            };
            return (_local1);
        }

        public function setInjector(_arg1:Injector):InjectionMapping
        {
            ((this._sealed) && (this.throwSealedError()));
            if (_arg1 == this._overridingInjector)
            {
                return (this);
            };
            var _local2:DependencyProvider = this.getProvider();
            this._overridingInjector = _arg1;
            this.mapProvider(_local2);
            return (this);
        }

        private function mapProvider(_arg1:DependencyProvider):void
        {
            if (this._soft)
            {
                _arg1 = new SoftDependencyProvider(_arg1);
            };
            if (this._local)
            {
                _arg1 = new LocalOnlyProvider(_arg1);
            };
            if (this._overridingInjector)
            {
                _arg1 = new InjectorUsingProvider(this._overridingInjector, _arg1);
            };
            this._creatingInjector.SsInternal::providerMappings[this._mappingId] = _arg1;
        }

        private function throwSealedError():void
        {
            throw (new InjectorError("Can't change a sealed mapping"));
        }

        private function dispatchPreChangeEvent():void
        {
            ((this._creatingInjector.hasEventListener(MappingEvent.PRE_MAPPING_CHANGE)) && (this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CHANGE, this._type, this._name, this))));
        }

        private function dispatchPostChangeEvent():void
        {
            ((this._creatingInjector.hasEventListener(MappingEvent.POST_MAPPING_CHANGE)) && (this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CHANGE, this._type, this._name, this))));
        }


    }
}

