package robotlegs.bender.extensions.mediatorMap.api
{
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;

    public interface IMediatorViewHandler extends IViewHandler 
    {

        function addMapping(_arg1:IMediatorMapping):void;
        function removeMapping(_arg1:IMediatorMapping):void;
        function handleItem(_arg1:Object, _arg2:Class):void;

    }
}

