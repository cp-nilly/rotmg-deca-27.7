package robotlegs.bender.framework.api
{
    public interface IMessageDispatcher 
    {

        function addMessageHandler(_arg1:Object, _arg2:Function):void;
        function removeMessageHandler(_arg1:Object, _arg2:Function):void;
        function hasMessageHandler(_arg1:Object):Boolean;
        function dispatchMessage(_arg1:Object, _arg2:Function=null, _arg3:Boolean=false):void;

    }
}

