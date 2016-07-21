package robotlegs.bender.extensions.mediatorMap.dsl
{
    public interface IMediatorMappingConfig 
    {

        function withGuards(... _args):IMediatorMappingConfig;
        function withHooks(... _args):IMediatorMappingConfig;

    }
}

