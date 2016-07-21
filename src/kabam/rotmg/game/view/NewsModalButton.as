package kabam.rotmg.game.view
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import kabam.rotmg.ui.UIUtils;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.news.view.NewsModal;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;

    public class NewsModalButton extends Sprite 
    {

        public static const IMAGE_NAME:String = "lofiObj2";
        public static const IMAGE_ID:int = 345;

        public static var showsHasUpdate:Boolean = false;

        private var bitmap:Bitmap;
        private var background:Sprite;
        private var background2:Sprite;
        private var icon:BitmapData;
        private var text:TextFieldDisplayConcrete;

        public function NewsModalButton()
        {
            mouseChildren = false;
            this.icon = TextureRedrawer.redraw(AssetLibrary.getImageFromSet(IMAGE_NAME, IMAGE_ID), 40, true, 0);
            this.bitmap = new Bitmap(this.icon);
            this.bitmap.x = -5;
            this.bitmap.y = -8;
            this.background = UIUtils.makeStaticHUDBackground();
            this.background2 = UIUtils.makeHUDBackground(31, UIUtils.NOTIFICATION_BACKGROUND_HEIGHT);
            this.text = new TextFieldDisplayConcrete().setSize(16).setColor(0xFFFFFF);
            this.text.setStringBuilder(new StaticStringBuilder("Update!"));
            this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
            this.text.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
            this.drawAsOpen();
            var _local1:Rectangle = this.bitmap.getBounds(this);
            var _local2:int = 10;
            this.text.x = (_local1.right - _local2);
            this.text.y = (_local1.bottom - _local2);
            addEventListener(MouseEvent.CLICK, this.onClick);
        }

        public function onClick(_arg1:MouseEvent):void
        {
            var _local2:OpenDialogSignal = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _local2.dispatch(new NewsModal());
            SoundEffectLibrary.play("button_click");
        }

        public function drawAsOpen():void
        {
            if (NewsModal.hasUpdates())
            {
                showsHasUpdate = true;
                addChild(this.background);
                addChild(this.text);
            }
            else
            {
                showsHasUpdate = false;
                addChild(this.background2);
            };
            addChild(this.bitmap);
        }


    }
}

