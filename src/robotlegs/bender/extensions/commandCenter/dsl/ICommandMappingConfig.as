package robotlegs.bender.extensions.commandCenter.dsl
{
    public interface ICommandMappingConfig 
    {

        function withGuards(... _args):ICommandMappingConfig;
        function withHooks(... _args):ICommandMappingConfig;
        function once(_arg1:Boolean=true):ICommandMappingConfig;

    }
}

