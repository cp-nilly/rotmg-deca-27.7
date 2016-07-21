package com.company.assembleegameclient.ui.dialogs
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import org.osflash.signals.Signal;

    public class DialogCloserMediator extends Mediator 
    {

        [Inject]
        public var dialog:DialogCloser;
        [Inject]
        public var closeDialogsSignal:CloseDialogsSignal;
        private var closeSignal:Signal;


        override public function initialize():void
        {
            this.closeSignal = this.dialog.getCloseSignal();
            this.closeSignal.add(this.onClose);
        }

        private function onClose():void
        {
            this.closeDialogsSignal.dispatch();
        }

        override public function destroy():void
        {
            this.closeSignal.remove(this.onClose);
        }


    }
}

