package kabam.rotmg.core.service
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.ui.view.NotEnoughGoldDialog;
    import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

    public class PurchaseCharacterErrorTask extends BaseTask 
    {

        [Inject]
        public var openDialog:OpenDialogSignal;
        public var parentTask:PurchaseCharacterClassTask;


        override protected function startTask():void
        {
            if (this.parentTask.error == "Not enough Gold.")
            {
                this.openDialog.dispatch(new NotEnoughGoldDialog());
            }
            else
            {
                this.openDialog.dispatch(new ErrorDialog(this.parentTask.error));
            };
        }


    }
}

