package kabam.rotmg.pets.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.pets.view.dialogs.CaretakerQueryDialog;
    import kabam.rotmg.pets.data.PetsModel;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.BitmapData;

    public class CaretakerQueryDialogMediator extends Mediator 
    {

        [Inject]
        public var view:CaretakerQueryDialog;
        [Inject]
        public var model:PetsModel;
        [Inject]
        public var closeDialogs:CloseDialogsSignal;


        override public function initialize():void
        {
            this.view.closed.addOnce(this.onClosed);
            this.view.setCaretakerIcon(this.makeCaretakerIcon());
        }

        private function makeCaretakerIcon():BitmapData
        {
            var _local1:int = this.model.getPetYardObjectID();
            return (ObjectLibrary.getRedrawnTextureFromType(_local1, 80, true));
        }

        override public function destroy():void
        {
            this.view.closed.removeAll();
        }

        private function onClosed():void
        {
            this.closeDialogs.dispatch();
        }


    }
}

