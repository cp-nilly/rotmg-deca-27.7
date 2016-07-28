package kabam.rotmg.news.view
{
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;

    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;

    public class NewsModalPage extends Sprite
    {
        public static const TEXT_MARGIN:int = 22;
        public static const TEXT_MARGIN_HTML:int = 26;

        public function NewsModalPage(_arg1:String, _arg2:String)
        {
            var _local3:TextField;
            super();
            this.doubleClickEnabled = false;
            this.mouseEnabled = false;
            _local3 = new TextField();
            var _local4:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
            _local4.apply(_local3, 16, 15792127, false, true);
            _local3.width = (NewsModal.MODAL_WIDTH - (TEXT_MARGIN_HTML * 2));
            _local3.height = (NewsModal.MODAL_HEIGHT - 101);
            _local3.multiline = true;
            _local3.wordWrap = true;
            _local3.htmlText = _arg2;
            _local3.x = TEXT_MARGIN_HTML;
            _local3.y = 53;
            _local3.filters = [new DropShadowFilter(0, 0, 0)];
            disableMouseOnText(_local3);
            addChild(_local3);
            var _local5:TextFieldDisplayConcrete = NewsModal.getText(_arg1, TEXT_MARGIN, 6, true);
            addChild(_local5);
        }

        private static function disableMouseOnText(_arg1:TextField):void
        {
            _arg1.mouseWheelEnabled = false;
        }
    }
}

