package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.matching.ITypeMatcher;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.matching.TypeMatcher;
    import flash.display.DisplayObject;

    public class MediatorMap implements IMediatorMap, IViewHandler 
    {

        private const _mappers:Dictionary = new Dictionary();
        private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();

        private var _handler:IMediatorViewHandler;
        private var _factory:IMediatorFactory;

        public function MediatorMap(_arg1:IMediatorFactory, _arg2:IMediatorViewHandler=null)
        {
            this._factory = _arg1;
            this._handler = ((_arg2) || (new MediatorViewHandler(this._factory)));
        }

        public function mapMatcher(_arg1:ITypeMatcher):IMediatorMapper
        {
            return ((this._mappers[_arg1.createTypeFilter().descriptor] = ((this._mappers[_arg1.createTypeFilter().descriptor]) || (this.createMapper(_arg1)))));
        }

        public function map(_arg1:Class):IMediatorMapper
        {
            var _local2:ITypeMatcher = new TypeMatcher().allOf(_arg1);
            return (this.mapMatcher(_local2));
        }

        public function unmapMatcher(_arg1:ITypeMatcher):IMediatorUnmapper
        {
            return (((this._mappers[_arg1.createTypeFilter().descriptor]) || (this.NULL_UNMAPPER)));
        }

        public function unmap(_arg1:Class):IMediatorUnmapper
        {
            var _local2:ITypeMatcher = new TypeMatcher().allOf(_arg1);
            return (this.unmapMatcher(_local2));
        }

        public function handleView(_arg1:DisplayObject, _arg2:Class):void
        {
            this._handler.handleView(_arg1, _arg2);
        }

        public function mediate(_arg1:Object):void
        {
            var _local2:Class = (_arg1.constructor as Class);
            this._handler.handleItem(_arg1, _local2);
        }

        public function unmediate(_arg1:Object):void
        {
            this._factory.removeMediators(_arg1);
        }

        private function createMapper(_arg1:ITypeMatcher, _arg2:Class=null):IMediatorMapper
        {
            return (new MediatorMapper(_arg1.createTypeFilter(), this._handler));
        }


    }
}

