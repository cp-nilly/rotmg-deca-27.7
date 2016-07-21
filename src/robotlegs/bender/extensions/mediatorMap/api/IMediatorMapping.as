package robotlegs.bender.extensions.mediatorMap.api
{
    import robotlegs.bender.extensions.matching.ITypeFilter;

    public interface IMediatorMapping 
    {

        function get matcher():ITypeFilter;
        function get mediatorClass():Class;
        function get guards():Array;
        function get hooks():Array;
        function validate():void;

    }
}

