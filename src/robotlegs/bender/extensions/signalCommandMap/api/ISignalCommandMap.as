package robotlegs.bender.extensions.signalCommandMap.api
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public interface ISignalCommandMap 
    {

        function map(_arg1:Class, _arg2:Boolean=false):ICommandMapper;
        function unmap(_arg1:Class):ICommandUnmapper;

    }
}

