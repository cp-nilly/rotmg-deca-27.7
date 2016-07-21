package robotlegs.bender.framework.api
{
    public interface ILogger 
    {

        function debug(_arg1:*, _arg2:Array=null):void;
        function info(_arg1:*, _arg2:Array=null):void;
        function warn(_arg1:*, _arg2:Array=null):void;
        function error(_arg1:*, _arg2:Array=null):void;
        function fatal(_arg1:*, _arg2:Array=null):void;

    }
}

