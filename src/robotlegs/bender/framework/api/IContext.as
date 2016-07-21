package robotlegs.bender.framework.api
{
    import org.swiftsuspenders.Injector;
    import org.hamcrest.Matcher;

    public interface IContext 
    {

        function get injector():Injector;
        function get lifecycle():ILifecycle;
        function get logLevel():uint;
        function set logLevel(_arg1:uint):void;
        function extend(... _args):IContext;
        function configure(... _args):IContext;
        function addConfigHandler(_arg1:Matcher, _arg2:Function):IContext;
        function getLogger(_arg1:Object):ILogger;
        function addLogTarget(_arg1:ILogTarget):IContext;
        function detain(... _args):IContext;
        function release(... _args):IContext;

    }
}

