package kabam.rotmg.account.core.commands
{
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.account.core.view.MoneyFrame;

    public class InternalOpenMoneyWindowCommand 
    {

        [Inject]
        public var openDialog:OpenDialogSignal;


        public function execute():void
        {
            this.openDialog.dispatch(new MoneyFrame());
        }


    }
}

