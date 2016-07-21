package kabam.rotmg.account.core.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;

    public class AccountInfoMediator extends Mediator 
    {

        [Inject]
        public var account:Account;
        [Inject]
        public var view:AccountInfoView;
        [Inject]
        public var update:UpdateAccountInfoSignal;


        override public function initialize():void
        {
            this.view.setInfo(this.account.getUserName(), this.account.isRegistered());
            this.update.add(this.updateLogin);
        }

        override public function destroy():void
        {
            this.update.remove(this.updateLogin);
        }

        private function updateLogin():void
        {
            this.view.setInfo(this.account.getUserName(), this.account.isRegistered());
        }


    }
}

