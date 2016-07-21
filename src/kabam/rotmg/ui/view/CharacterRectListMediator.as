package kabam.rotmg.ui.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import com.company.assembleegameclient.screens.charrects.CharacterRectList;
    import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
    import kabam.rotmg.ui.signals.BuyCharacterSlotSignal;
    import com.company.assembleegameclient.screens.NewCharacterScreen;

    public class CharacterRectListMediator extends Mediator 
    {

        [Inject]
        public var view:CharacterRectList;
        [Inject]
        public var setScreenWithValidData:SetScreenWithValidDataSignal;
        [Inject]
        public var buyCharacterSlotSignal:BuyCharacterSlotSignal;


        override public function initialize():void
        {
            this.view.newCharacter.add(this.onNewCharacter);
            this.view.buyCharacterSlot.add(this.onBuyCharacterSlot);
        }

        override public function destroy():void
        {
            this.view.newCharacter.remove(this.onNewCharacter);
            this.view.buyCharacterSlot.remove(this.onBuyCharacterSlot);
        }

        private function onNewCharacter():void
        {
            this.setScreenWithValidData.dispatch(new NewCharacterScreen());
        }

        private function onBuyCharacterSlot(_arg1:int):void
        {
            this.buyCharacterSlotSignal.dispatch(_arg1);
        }


    }
}

