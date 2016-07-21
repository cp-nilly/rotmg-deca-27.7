package robotlegs.bender.extensions.mediatorMap.api
{
    import flash.events.IEventDispatcher;

    public interface IMediatorFactory extends IEventDispatcher 
    {

        function getMediator(_arg1:Object, _arg2:IMediatorMapping):Object;
        function createMediators(_arg1:Object, _arg2:Class, _arg3:Array):Array;
        function removeMediators(_arg1:Object):void;
        function removeAllMediators():void;

    }
}

