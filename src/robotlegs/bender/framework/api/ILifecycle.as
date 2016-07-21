package robotlegs.bender.framework.api
{
    import flash.events.IEventDispatcher;

    public interface ILifecycle extends IEventDispatcher 
    {

        function get state():String;
        function get target():Object;
        function get initialized():Boolean;
        function get active():Boolean;
        function get suspended():Boolean;
        function get destroyed():Boolean;
        function initialize(_arg1:Function=null):void;
        function suspend(_arg1:Function=null):void;
        function resume(_arg1:Function=null):void;
        function destroy(_arg1:Function=null):void;
        function beforeInitializing(_arg1:Function):ILifecycle;
        function whenInitializing(_arg1:Function):ILifecycle;
        function afterInitializing(_arg1:Function):ILifecycle;
        function beforeSuspending(_arg1:Function):ILifecycle;
        function whenSuspending(_arg1:Function):ILifecycle;
        function afterSuspending(_arg1:Function):ILifecycle;
        function beforeResuming(_arg1:Function):ILifecycle;
        function whenResuming(_arg1:Function):ILifecycle;
        function afterResuming(_arg1:Function):ILifecycle;
        function beforeDestroying(_arg1:Function):ILifecycle;
        function whenDestroying(_arg1:Function):ILifecycle;
        function afterDestroying(_arg1:Function):ILifecycle;

    }
}

