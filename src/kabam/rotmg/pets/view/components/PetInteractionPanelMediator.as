package kabam.rotmg.pets.view.components
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import flash.events.MouseEvent;
    import kabam.rotmg.pets.view.FusePetView;
    import kabam.rotmg.pets.view.FeedPetView;

    public class PetInteractionPanelMediator extends Mediator 
    {

        [Inject]
        public var view:PetInteractionPanel;
        [Inject]
        public var openNoModalDialog:OpenDialogNoModalSignal;
        [Inject]
        public var openDialog:OpenDialogSignal;


        override public function initialize():void
        {
            this.view.init();
            this.view.feedButton.addEventListener(MouseEvent.CLICK, this.onButtonLeftClick);
            this.view.fuseButton.addEventListener(MouseEvent.CLICK, this.onButtonRightClick);
        }

        override public function destroy():void
        {
            super.destroy();
        }

        protected function onButtonRightClick(_arg1:MouseEvent):void
        {
            this.openDialog.dispatch(new FusePetView());
        }

        protected function onButtonLeftClick(_arg1:MouseEvent):void
        {
            this.openNoModalDialog.dispatch(new FeedPetView());
        }


    }
}

