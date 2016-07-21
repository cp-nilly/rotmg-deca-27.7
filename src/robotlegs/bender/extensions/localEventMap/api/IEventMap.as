package robotlegs.bender.extensions.localEventMap.api
{
    import flash.events.IEventDispatcher;

    public interface IEventMap 
    {

        function mapListener(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class=null, _arg5:Boolean=false, _arg6:int=0, _arg7:Boolean=true):void;
        function unmapListener(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class=null, _arg5:Boolean=false):void;
        function unmapListeners():void;
        function suspend():void;
        function resume():void;

    }
}

