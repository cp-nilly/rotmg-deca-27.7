package kabam.rotmg.pets.view.components
{
    import flash.display.Sprite;
    import org.osflash.signals.Signal;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    public class DialogCloseButton extends Sprite 
    {

        public static var CloseButtonAsset:Class = DialogCloseButton_CloseButtonAsset;
        public static var CloseButtonLargeAsset:Class = DialogCloseButton_CloseButtonLargeAsset;

        public const clicked:Signal = new Signal();

        public var disabled:Boolean = false;

        public function DialogCloseButton(_arg1:Number=-1)
        {
            var _local2:DisplayObject;
            super();
            if (_arg1 < 0)
            {
                addChild(new CloseButtonAsset());
            }
            else
            {
                _local2 = new CloseButtonLargeAsset();
                addChild(new CloseButtonLargeAsset());
                scaleX = (scaleX * _arg1);
                scaleY = (scaleY * _arg1);
            };
            buttonMode = true;
            addEventListener(MouseEvent.CLICK, this.onClicked);
        }

        public function setDisabled(_arg1:Boolean):void
        {
            this.disabled = _arg1;
            if (_arg1)
            {
                removeEventListener(MouseEvent.CLICK, this.onClicked);
            }
            else
            {
                addEventListener(MouseEvent.CLICK, this.onClicked);
            };
        }

        public function disableLegacyCloseBehavior():void
        {
            this.disabled = true;
            removeEventListener(MouseEvent.CLICK, this.onClicked);
        }

        private function onClicked(_arg1:MouseEvent):void
        {
            if (!this.disabled)
            {
                this.clicked.dispatch();
                removeEventListener(MouseEvent.CLICK, this.onClicked);
            };
        }


    }
}

