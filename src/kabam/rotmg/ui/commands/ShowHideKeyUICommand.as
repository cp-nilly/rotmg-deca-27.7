package kabam.rotmg.ui.commands
{
    import kabam.rotmg.ui.view.KeysView;

    import robotlegs.bender.extensions.contextView.ContextView;

    public class ShowHideKeyUICommand
    {
        private static var show:Boolean = true;
        private static var view:KeysView;
        [Inject]
        public var contextView:ContextView;

        public function execute():void
        {
            if (show)
            {
                view = new KeysView();
                view.x = 4;
                view.y = 4;
                this.contextView.view.addChild(view);
                show = false;
            }
            else
            {
                this.contextView.view.removeChild(view);
                view = null;
                show = true;
            }
        }
    }
}

