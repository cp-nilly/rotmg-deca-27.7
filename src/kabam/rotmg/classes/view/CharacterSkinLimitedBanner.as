package kabam.rotmg.classes.view
{
    import flash.display.Sprite;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import org.osflash.signals.Signal;
    import flash.filters.DropShadowFilter;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.model.TextKey;

    public class CharacterSkinLimitedBanner extends Sprite 
    {

        private const limitedText:TextFieldDisplayConcrete = makeText();
        private const limitedBanner = makeLimitedBanner();
        public const readyForPositioning:Signal = new Signal();

        private var LimitedBanner:Class;

        public function CharacterSkinLimitedBanner()
        {
            this.LimitedBanner = CharacterSkinLimitedBanner_LimitedBanner;
            super();
        }

        private function makeText():TextFieldDisplayConcrete
        {
            var _local1:TextFieldDisplayConcrete;
            _local1 = new TextFieldDisplayConcrete().setSize(16).setColor(0xB3B3B3).setBold(true);
            _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            _local1.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SKIN_LIMITED));
            _local1.textChanged.addOnce(this.layout);
            addChild(_local1);
            return (_local1);
        }

        private function makeLimitedBanner()
        {
            var _local1:* = new this.LimitedBanner();
            addChild(_local1);
            return (_local1);
        }

        public function layout():void
        {
            this.limitedText.y = (((height / 2) - (this.limitedText.height / 2)) + 1);
            this.limitedBanner.x = (this.limitedText.x + this.limitedText.width);
            this.readyForPositioning.dispatch();
        }


    }
}

