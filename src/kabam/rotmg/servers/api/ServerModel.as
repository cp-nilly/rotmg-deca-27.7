package kabam.rotmg.servers.api
{
    import __AS3__.vec.Vector;

    public interface ServerModel 
    {

        function setServers(_arg1:Vector.<Server>):void;
        function getServer():Server;
        function isServerAvailable():Boolean;
        function getServers():Vector.<Server>;

    }
}

