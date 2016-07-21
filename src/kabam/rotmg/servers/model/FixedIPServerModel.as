package kabam.rotmg.servers.model
{
    import kabam.rotmg.servers.api.ServerModel;
    import kabam.rotmg.servers.api.Server;
    import com.company.assembleegameclient.parameters.Parameters;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class FixedIPServerModel implements ServerModel 
    {

        private var localhost:Server;

        public function FixedIPServerModel()
        {
            this.localhost = new Server().setName("localhost").setPort(Parameters.PORT);
        }

        public function setIP(_arg1:String):FixedIPServerModel
        {
            this.localhost.setAddress(_arg1);
            return (this);
        }

        public function getServers():Vector.<Server>
        {
            return (new <Server>[this.localhost]);
        }

        public function getServer():Server
        {
            return (this.localhost);
        }

        public function isServerAvailable():Boolean
        {
            return (true);
        }

        public function setServers(_arg1:Vector.<Server>):void
        {
        }


    }
}

