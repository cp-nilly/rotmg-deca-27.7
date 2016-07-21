package com.company.assembleegameclient.screens
{
    import flash.display.Sprite;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.ui.view.components.ScreenBase;
    import com.company.rotmg.graphics.ScreenGraphic;
    import flash.text.TextFieldAutoSize;
    import flash.events.Event;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.model.TextKey;
    import flash.filters.DropShadowFilter;

    public class LoadingScreen extends Sprite 
    {

        private var text:TextFieldDisplayConcrete;

        public function LoadingScreen()
        {
            this.text = new TextFieldDisplayConcrete();
            super();
            addChild(new ScreenBase());
            addChild(new ScreenGraphic());
            this.text.setSize(30).setColor(0xFFFFFF).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE).setAutoSize(TextFieldAutoSize.CENTER).setBold(true);
            this.text.y = 550;
            addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            this.text.setStringBuilder(new LineBuilder().setParams(TextKey.LOADING_TEXT));
            this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            addChild(this.text);
        }

        private function onAdded(_arg1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            this.text.x = (stage.stageWidth / 2);
        }

        public function setTextKey(_arg1:String):void
        {
            this.text.setStringBuilder(new LineBuilder().setParams(_arg1));
        }


    }
}

