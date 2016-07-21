package kabam.rotmg.account.steam.commands
{
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.account.steam.view.SteamAccountDetailDialog;

    public class SteamOpenAccountInfoCommand 
    {

        [Inject]
        public var openDialog:OpenDialogSignal;


        public function execute():void
        {
            this.openDialog.dispatch(new SteamAccountDetailDialog());
        }


    }
}

