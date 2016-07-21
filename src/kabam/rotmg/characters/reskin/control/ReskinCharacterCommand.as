package kabam.rotmg.characters.reskin.control
{
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.lib.net.api.MessageProvider;
    import kabam.lib.net.impl.SocketServer;
    import kabam.rotmg.messaging.impl.GameServerConnection;
    import kabam.rotmg.messaging.impl.outgoing.Reskin;

    public class ReskinCharacterCommand 
    {

        [Inject]
        public var skin:CharacterSkin;
        [Inject]
        public var messages:MessageProvider;
        [Inject]
        public var server:SocketServer;


        public function execute():void
        {
            var _local1:Reskin = (this.messages.require(GameServerConnection.RESKIN) as Reskin);
            _local1.skinID = this.skin.id;
            this.server.sendMessage(_local1);
        }


    }
}

