package kabam.rotmg.news.view
{
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;
    import com.company.util.AssetLibrary;
    import com.company.util.KeyCodes;
    import com.company.util.MoreColorUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;

    import kabam.rotmg.account.core.view.EmptyFrame;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.news.model.NewsModel;
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.ui.model.HUDModel;

    public class NewsModal extends EmptyFrame
    {
        public static const MODAL_WIDTH:int = 440;
        public static const MODAL_HEIGHT:int = 400;
        private static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1, (220 / 0xFF), (133 / 0xFF));
        private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);
        private static const GLOW_FILTER:GlowFilter = new GlowFilter(0xFF0000, 1, 11, 5);
        private static const filterWithGlow:Array = [DROP_SHADOW_FILTER, GLOW_FILTER];
        private static const filterNoGlow:Array = [DROP_SHADOW_FILTER];
        public static var backgroundImageEmbed:Class = NewsModal_backgroundImageEmbed;
        public static var foregroundImageEmbed:Class = NewsModal_foregroundImageEmbed;
        public static var modalWidth:int = MODAL_WIDTH;//440
        public static var modalHeight:int = MODAL_HEIGHT;//400
        private var currentPage:NewsModalPage;
        private var currentPageNum:int = -1;
        private var pageOneNav:TextField;
        private var pageTwoNav:TextField;
        private var pageThreeNav:TextField;
        private var pageFourNav:TextField;
        private var pageNavs:Vector.<TextField>;
        private var leftNavSprite:Sprite;
        private var rightNavSprite:Sprite;

        public function NewsModal(_arg1:int = 1)
        {
            modalWidth = MODAL_WIDTH;
            modalHeight = MODAL_HEIGHT;
            super(modalWidth, modalHeight);
            this.setCloseButton(true);
            this.initNavButtons();
            this.setPage(_arg1);
            WebMain.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownListener);
            addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
        }

        public static function refreshNewsButton():void
        {
            var _local1:HUDModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
            if (((!((_local1 == null))) && (!((_local1.gameSprite == null)))))
            {
                _local1.gameSprite.refreshNewsUpdateButton();
            }
        }

        public static function hasUpdates():Boolean
        {
            var _local1:int = 1;
            while (_local1 <= NewsModel.MODAL_PAGE_COUNT)
            {
                if (((!((Parameters.data_[("hasNewsUpdate" + _local1)] == null))) && ((Parameters.data_[("hasNewsUpdate" + _local1)] == true))))
                {
                    return (true);
                }
                _local1++;
            }
            return (false);
        }

        public static function getText(_arg1:String, _arg2:int, _arg3:int, _arg4:Boolean):TextFieldDisplayConcrete
        {
            var _local5:TextFieldDisplayConcrete;
            _local5 = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF).setTextWidth((NewsModal.modalWidth - (TEXT_MARGIN * 2)));
            _local5.setBold(true);
            if (_arg4)
            {
                _local5.setStringBuilder(new StaticStringBuilder(_arg1));
            }
            else
            {
                _local5.setStringBuilder(new LineBuilder().setParams(_arg1));
            }
            _local5.setWordWrap(true);
            _local5.setMultiLine(true);
            _local5.setAutoSize(TextFieldAutoSize.CENTER);
            _local5.setHorizontalAlign(TextFormatAlign.CENTER);
            _local5.filters = [new DropShadowFilter(0, 0, 0)];
            _local5.x = _arg2;
            _local5.y = _arg3;
            return (_local5);
        }

        private function initNavButtons():void
        {
            var _local4:TextField;
            var _local1:int = NewsModel.MODAL_PAGE_COUNT;
            this.pageNavs = new Vector.<TextField>(_local1, true);
            this.pageOneNav = new TextField();
            this.pageTwoNav = new TextField();
            this.pageThreeNav = new TextField();
            this.pageFourNav = new TextField();
            this.pageNavs[0] = this.pageOneNav;
            this.pageNavs[1] = this.pageTwoNav;
            this.pageNavs[2] = this.pageThreeNav;
            this.pageNavs[3] = this.pageFourNav;
            var _local2:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
            var _local3:int = 1;
            for each (_local4 in this.pageNavs)
            {
                _local2.apply(_local4, 20, 0xFFFFFF, true);
                _local4.filters = filterNoGlow;
                if ((((_local3 > 0)) && ((_local3 <= NewsModel.MODAL_PAGE_COUNT))))
                {
                    _local4.text = (("  " + _local3) + "  ");
                    _local4.width = _local4.textWidth;
                    _local4.x = (((modalWidth * (_local3 + 3)) / 11) - (_local4.textWidth / 2));
                    _local4.addEventListener(MouseEvent.ROLL_OVER, this.onNavHover);
                    _local4.addEventListener(MouseEvent.ROLL_OUT, this.onNavHoverOut);
                }
                _local4.height = _local4.textHeight;
                _local4.y = (modalHeight - 33);
                _local4.selectable = false;
                _local4.addEventListener(MouseEvent.CLICK, this.onClick);
                addChild(_local4);
                _local3++;
            }
            this.leftNavSprite = this.makeLeftNav();
            this.rightNavSprite = this.makeRightNav();
            this.leftNavSprite.x = (((modalWidth * 3) / 11) - (this.rightNavSprite.width / 2));
            this.leftNavSprite.y = (modalHeight - 4);
            addChild(this.leftNavSprite);
            this.rightNavSprite.x = (((modalWidth * 8) / 11) - (this.rightNavSprite.width / 2));
            this.rightNavSprite.y = (modalHeight - 4);
            addChild(this.rightNavSprite);
        }

        public function onNavHover(_arg1:MouseEvent):void
        {
            var _local2:TextField = (_arg1.currentTarget as TextField);
            _local2.textColor = 16701832;
        }

        public function onNavHoverOut(_arg1:MouseEvent):void
        {
            var _local2:TextField = (_arg1.currentTarget as TextField);
            _local2.textColor = 0xFFFFFF;
        }

        public function onClick(_arg1:MouseEvent):void
        {
            switch (_arg1.currentTarget)
            {
                case this.rightNavSprite:
                    if ((this.currentPageNum + 1) <= NewsModel.MODAL_PAGE_COUNT)
                    {
                        this.setPage((this.currentPageNum + 1));
                    }
                    return;
                case this.leftNavSprite:
                    if ((this.currentPageNum - 1) >= 1)
                    {
                        this.setPage((this.currentPageNum - 1));
                    }
                    return;
                case this.pageOneNav:
                    this.setPage(1);
                    return;
                case this.pageTwoNav:
                    this.setPage(2);
                    return;
                case this.pageThreeNav:
                    this.setPage(3);
                    return;
                case this.pageFourNav:
                    this.setPage(4);
                    return;
            }
        }

        private function getPageNavForGlow(_arg1:int):TextField
        {
            if ((_arg1 >= 0) < NewsModel.MODAL_PAGE_COUNT)
            {
                return (this.pageNavs[(_arg1 - 1)]);
            }
            return (null);
        }

        private function destroy(_arg1:Event):void
        {
            var _local2:TextField;
            WebMain.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownListener);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            if (this.pageNavs != null)
            {
                for each (_local2 in this.pageNavs)
                {
                    _local2.removeEventListener(MouseEvent.CLICK, this.onClick);
                    _local2.removeEventListener(MouseEvent.ROLL_OVER, this.onNavHover);
                    _local2.removeEventListener(MouseEvent.ROLL_OUT, this.onNavHoverOut);
                }
            }
            this.leftNavSprite.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.onArrowHover);
            this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.onArrowHoverOut);
            this.rightNavSprite.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.onArrowHover);
            this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.onArrowHoverOut);
        }

        private function setPage(_arg1:int):void
        {
            var _local3:TextField;
            var _local2:Boolean = hasUpdates();
            if ((((_arg1 < 1)) || ((_arg1 > NewsModel.MODAL_PAGE_COUNT))))
            {
                return;
            }
            if (this.currentPageNum != -1)
            {
                removeChild(this.currentPage);
                _local3 = this.getPageNavForGlow(this.currentPageNum);
                if (_local3 != null)
                {
                    _local3.filters = filterNoGlow;
                }
                SoundEffectLibrary.play("button_click");
            }
            this.currentPageNum = _arg1;
            var _local4:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
            this.currentPage = _local4.getModalPage(_arg1);
            addChild(this.currentPage);
            _local3 = this.getPageNavForGlow(this.currentPageNum);
            if (_local3 != null)
            {
                _local3.filters = filterWithGlow;
            }
            Parameters.data_[("hasNewsUpdate" + _arg1)] = false;
            var _local5:Boolean = hasUpdates();
            if (_local2 != _local5)
            {
                refreshNewsButton();
            }
        }

        override protected function makeModalBackground():Sprite
        {
            var _local3:DisplayObject;
            var _local1:Sprite = new Sprite();
            var _local2:DisplayObject = new backgroundImageEmbed();
            _local2.width = (modalWidth + 1);
            _local2.height = (modalHeight - 25);
            _local2.y = 27;
            _local2.alpha = 0.95;
            _local3 = new foregroundImageEmbed();
            _local3.width = (modalWidth + 1);
            _local3.height = (modalHeight - 67);
            _local3.y = 27;
            _local3.alpha = 1;
            var _local4:PopupWindowBackground = new PopupWindowBackground();
            _local4.draw(modalWidth, modalHeight, PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
            _local1.addChild(_local2);
            _local1.addChild(_local3);
            _local1.addChild(_local4);
            return (_local1);
        }

        private function keyDownListener(_arg1:KeyboardEvent):void
        {
            if (_arg1.keyCode == KeyCodes.RIGHT)
            {
                if ((this.currentPageNum + 1) <= NewsModel.MODAL_PAGE_COUNT)
                {
                    this.setPage((this.currentPageNum + 1));
                }
            }
            else
            {
                if (_arg1.keyCode == KeyCodes.LEFT)
                {
                    if ((this.currentPageNum - 1) >= 1)
                    {
                        this.setPage((this.currentPageNum - 1));
                    }
                }
            }
        }

        private function makeLeftNav():Sprite
        {
            var _local1:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 54);
            var _local2:Bitmap = new Bitmap(_local1);
            _local2.scaleX = 4;
            _local2.scaleY = 4;
            _local2.rotation = -90;
            var _local3:Sprite = new Sprite();
            _local3.addChild(_local2);
            _local3.addEventListener(MouseEvent.MOUSE_OVER, this.onArrowHover);
            _local3.addEventListener(MouseEvent.MOUSE_OUT, this.onArrowHoverOut);
            _local3.addEventListener(MouseEvent.CLICK, this.onClick);
            return (_local3);
        }

        private function makeRightNav():Sprite
        {
            var _local1:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 55);
            var _local2:Bitmap = new Bitmap(_local1);
            _local2.scaleX = 4;
            _local2.scaleY = 4;
            _local2.rotation = -90;
            var _local3:Sprite = new Sprite();
            _local3.addChild(_local2);
            _local3.addEventListener(MouseEvent.MOUSE_OVER, this.onArrowHover);
            _local3.addEventListener(MouseEvent.MOUSE_OUT, this.onArrowHoverOut);
            _local3.addEventListener(MouseEvent.CLICK, this.onClick);
            return (_local3);
        }

        private function onArrowHover(_arg1:MouseEvent):void
        {
            _arg1.currentTarget.transform.colorTransform = OVER_COLOR_TRANSFORM;
        }

        private function onArrowHoverOut(_arg1:MouseEvent):void
        {
            _arg1.currentTarget.transform.colorTransform = MoreColorUtil.identity;
        }

        override public function onCloseClick(_arg1:MouseEvent):void
        {
            SoundEffectLibrary.play("button_click");
        }
    }
}

