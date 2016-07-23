package kabam.lib.console.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import kabam.lib.console.signals.ToggleConsoleSignal;
    import flash.events.KeyboardEvent;

    public class ConsoleKeyMediator extends Mediator 
    {

        private const TRIGGER:uint = 27;

        [Inject]
        public var contextView:ContextView;
        [Inject]
        public var toggle:ToggleConsoleSignal;


        override public function initialize():void
        {
            this.contextView.view.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        }

        override public function destroy():void
        {
            this.contextView.view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        }

        private function onKeyDown(_arg1:KeyboardEvent):void
        {
            if (_arg1.keyCode == this.TRIGGER)
            {
                this.toggle.dispatch();
            };
        }


    }
}

