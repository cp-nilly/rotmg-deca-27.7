package robotlegs.bender.extensions.commandCenter.api
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public interface ICommandCenter 
    {

        function map(_arg1:ICommandTrigger):ICommandMapper;
        function unmap(_arg1:ICommandTrigger):ICommandUnmapper;

    }
}

