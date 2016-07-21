package robotlegs.bender.extensions.viewManager.api
{
    import flash.events.IEventDispatcher;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;

    public interface IViewManager extends IEventDispatcher 
    {

        function get containers():Vector.<DisplayObjectContainer>;
        function addContainer(_arg1:DisplayObjectContainer):void;
        function removeContainer(_arg1:DisplayObjectContainer):void;
        function addViewHandler(_arg1:IViewHandler):void;
        function removeViewHandler(_arg1:IViewHandler):void;
        function removeAllHandlers():void;

    }
}

