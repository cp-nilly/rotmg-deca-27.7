package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

    public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper 
    {

        private const _mappings:Dictionary = new Dictionary();

        private var _matcher:ITypeFilter;
        private var _handler:IMediatorViewHandler;

        public function MediatorMapper(_arg1:ITypeFilter, _arg2:IMediatorViewHandler)
        {
            this._matcher = _arg1;
            this._handler = _arg2;
        }

        public function toMediator(_arg1:Class):IMediatorMappingConfig
        {
            return (((this.lockedMappingFor(_arg1)) || (this.createMapping(_arg1))));
        }

        public function forMediator(_arg1:Class):IMediatorMapping
        {
            return (this._mappings[_arg1]);
        }

        public function fromMediator(_arg1:Class):void
        {
            var _local2:IMediatorMapping = this._mappings[_arg1];
            delete this._mappings[_arg1];
            this._handler.removeMapping(_local2);
        }

        public function fromMediators():void
        {
            var _local1:IMediatorMapping;
            for each (_local1 in this._mappings)
            {
                delete this._mappings[_local1.mediatorClass];
                this._handler.removeMapping(_local1);
            };
        }

        private function createMapping(_arg1:Class):MediatorMapping
        {
            var _local2:MediatorMapping = new MediatorMapping(this._matcher, _arg1);
            this._handler.addMapping(_local2);
            this._mappings[_arg1] = _local2;
            return (_local2);
        }

        private function lockedMappingFor(_arg1:Class):MediatorMapping
        {
            var _local2:MediatorMapping = this._mappings[_arg1];
            if (_local2)
            {
                _local2.invalidate();
            };
            return (_local2);
        }


    }
}

