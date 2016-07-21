package kabam.rotmg.arena.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.game.model.GameModel;
    import flash.display.Sprite;

    public class ArenaLeaderboardListItemMediator extends Mediator 
    {

        [Inject]
        public var view:ArenaLeaderboardListItem;
        [Inject]
        public var showTooltip:ShowTooltipSignal;
        [Inject]
        public var hideTooltips:HideTooltipsSignal;
        [Inject]
        public var gameModel:GameModel;


        override public function initialize():void
        {
            this.view.showTooltip.add(this.onShow);
            this.view.hideTooltip.add(this.onHide);
            this.view.setColor();
        }

        override public function destroy():void
        {
            this.view.showTooltip.remove(this.onShow);
            this.view.hideTooltip.remove(this.onHide);
        }

        private function onShow(_arg1:Sprite):void
        {
            this.showTooltip.dispatch(_arg1);
        }

        private function onHide():void
        {
            this.hideTooltips.dispatch();
        }


    }
}

