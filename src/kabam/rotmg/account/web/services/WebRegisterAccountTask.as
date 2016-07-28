package kabam.rotmg.account.web.services
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.RegisterAccountTask;
    import kabam.rotmg.account.web.model.AccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;

    public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask
    {
        [Inject]
        public var data:AccountData;
        [Inject]
        public var account:Account;
        [Inject]
        public var model:PlayerModel;
        [Inject]
        public var client:AppEngineClient;

        override protected function startTask():void
        {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/account/register", this.makeDataPacket());
        }

        private function makeDataPacket():Object
        {
            var _local1:Object = {};
            _local1.guid = this.account.getUserId();
            _local1.newGUID = this.data.username;
            _local1.newPassword = this.data.password;
            _local1.entrytag = this.account.getEntryTag();
            _local1.isAgeVerified = 1;
            return (_local1);
        }

        private function onComplete(_arg1:Boolean, _arg2:*):void
        {
            ((_arg1) && (this.onRegisterDone()));
            completeTask(_arg1, _arg2);
        }

        private function onRegisterDone():void
        {
            this.model.setIsAgeVerified(true);
            this.account.updateUser(this.data.username, this.data.password);
        }
    }
}

