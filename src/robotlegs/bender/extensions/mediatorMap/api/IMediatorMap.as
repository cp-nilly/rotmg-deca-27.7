package robotlegs.bender.extensions.mediatorMap.api
{
    import robotlegs.bender.extensions.matching.ITypeMatcher;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

    public interface IMediatorMap 
    {

        function mapMatcher(_arg1:ITypeMatcher):IMediatorMapper;
        function map(_arg1:Class):IMediatorMapper;
        function unmapMatcher(_arg1:ITypeMatcher):IMediatorUnmapper;
        function unmap(_arg1:Class):IMediatorUnmapper;
        function mediate(_arg1:Object):void;
        function unmediate(_arg1:Object):void;

    }
}

