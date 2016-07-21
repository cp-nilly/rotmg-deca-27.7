package kabam.rotmg.ui.commands
{
    import kabam.rotmg.ui.view.KeysView;
    import flash.display.DisplayObjectContainer;

    public class ShowHideKeyUICommand 
    {

        private static var show:Boolean = true;
        private static var view:KeysView;

        [Inject]
        public var contextView:DisplayObjectContainer;


        public function execute():void
        {
            if (show)
            {
                view = new KeysView();
                view.x = 4;
                view.y = 4;
                this.contextView.addChild(view);
                show = false;
            }
            else
            {
                this.contextView.removeChild(view);
                view = null;
                show = true;
            };
        }


    }
}

