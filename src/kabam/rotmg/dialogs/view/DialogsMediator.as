package kabam.rotmg.dialogs.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.ShowDialogBackgroundSignal;
    import kabam.rotmg.dialogs.control.PushDialogSignal;
    import kabam.rotmg.dialogs.control.PopDialogSignal;
    import flash.display.Sprite;

    public class DialogsMediator extends Mediator 
    {

        [Inject]
        public var view:DialogsView;
        [Inject]
        public var openDialogNoModal:OpenDialogNoModalSignal;
        [Inject]
        public var openDialog:OpenDialogSignal;
        [Inject]
        public var closeDialog:CloseDialogsSignal;
        [Inject]
        public var showDialogBackground:ShowDialogBackgroundSignal;
        [Inject]
        public var pushDialogSignal:PushDialogSignal;
        [Inject]
        public var popDialogSignal:PopDialogSignal;


        override public function initialize():void
        {
            this.showDialogBackground.add(this.onShowDialogBackground);
            this.openDialog.add(this.onOpenDialog);
            this.openDialogNoModal.add(this.onOpenDialogNoModal);
            this.closeDialog.add(this.onCloseDialog);
            this.pushDialogSignal.add(this.onPushDialog);
            this.popDialogSignal.add(this.onPopDialog);
        }

        private function onPushDialog(_arg1:Sprite):void
        {
            this.view.push(_arg1);
        }

        private function onPopDialog():void
        {
            this.view.pop();
        }

        override public function destroy():void
        {
            this.showDialogBackground.remove(this.onShowDialogBackground);
            this.openDialog.remove(this.onOpenDialog);
            this.openDialogNoModal.remove(this.onOpenDialogNoModal);
            this.closeDialog.remove(this.onCloseDialog);
            this.pushDialogSignal.remove(this.onPushDialog);
            this.popDialogSignal.remove(this.onPopDialog);
        }

        private function onShowDialogBackground(_arg1:int=0x151515):void
        {
            this.view.showBackground(_arg1);
        }

        private function onOpenDialog(_arg1:Sprite):void
        {
            this.view.show(_arg1, true);
        }

        private function onOpenDialogNoModal(_arg1:Sprite):void
        {
            this.view.show(_arg1, false);
        }

        private function onCloseDialog():void
        {
            this.view.stage.focus = null;
            this.view.hideAll();
        }


    }
}

