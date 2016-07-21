package kabam.rotmg.pets.view.dialogs.evolving
{
    import flash.display.Sprite;
    import org.osflash.signals.Signal;
    import kabam.rotmg.pets.view.dialogs.evolving.configuration.EvolveTransitionConfiguration;
    import kabam.rotmg.pets.view.dialogs.evolving.configuration.ToOpaqueTween;
    import kabam.rotmg.pets.view.dialogs.evolving.configuration.AfterOpaqueTween;

    public class EvolveTransition extends Sprite 
    {

        public const opaqueReached:Signal = new Signal();

        public var toOpaqueTween:TweenProxy;
        public var afterOpaqueTween:TweenProxy;

        public function EvolveTransition()
        {
            addChild(EvolveTransitionConfiguration.makeBackground());
            this.toOpaqueTween = new ToOpaqueTween(this);
            this.afterOpaqueTween = new AfterOpaqueTween(this);
            alpha = 0;
        }

        public function play():void
        {
            this.toOpaqueTween.setOnComplete(this.toOpaqueComplete);
            this.toOpaqueTween.start();
        }

        private function toOpaqueComplete():void
        {
            this.opaqueReached.dispatch();
            this.afterOpaqueTween.start();
        }


    }
}

