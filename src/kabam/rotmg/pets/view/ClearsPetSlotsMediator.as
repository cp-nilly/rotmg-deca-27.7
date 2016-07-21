package kabam.rotmg.pets.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.pets.data.PetSlotsState;
    import kabam.rotmg.maploading.signals.ChangeMapSignal;

    public class ClearsPetSlotsMediator extends Mediator 
    {

        [Inject]
        public var petSlotsState:PetSlotsState;
        [Inject]
        public var changeMapSignal:ChangeMapSignal;


        override public function initialize():void
        {
            this.changeMapSignal.add(this.onMapChange);
        }

        override public function destroy():void
        {
            this.changeMapSignal.remove(this.onMapChange);
        }

        private function onMapChange():void
        {
            this.petSlotsState.clear();
        }


    }
}

