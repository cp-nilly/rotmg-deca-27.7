package kabam.rotmg.ui.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import com.company.assembleegameclient.screens.LoadingScreen;
    import kabam.rotmg.core.signals.SetLoadingMessageSignal;

    public class LoadingMediator extends Mediator 
    {

        [Inject]
        public var view:LoadingScreen;
        [Inject]
        public var setMessage:SetLoadingMessageSignal;


        override public function initialize():void
        {
            this.setMessage.add(this.onSetMessage);
            this.view.setTextKey("Loading.text");
        }

        override public function destroy():void
        {
            this.setMessage.remove(this.onSetMessage);
        }

        private function onSetMessage(_arg1:String):void
        {
            this.view.setTextKey(_arg1);
        }


    }
}

