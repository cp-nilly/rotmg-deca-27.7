package com.google.analytics.debug
{
    import flash.display.Shape;
    import flash.text.TextField;
    import flash.events.TextEvent;
    import flash.display.Graphics;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;

    public class Label extends UISprite 
    {

        public static var count:uint = 0;

        private var _color:uint;
        private var _background:Shape;
        private var _textField:TextField;
        public var stickToEdge:Boolean;
        private var _text:String;
        protected var selectable:Boolean;
        private var _tag:String;

        public function Label(_arg1:String="", _arg2:String="uiLabel", _arg3:uint=0, _arg4:Align=null, _arg5:Boolean=false)
        {
            this.name = ("Label" + count++);
            selectable = false;
            _background = new Shape();
            _textField = new TextField();
            _text = _arg1;
            _tag = _arg2;
            if (_arg4 == null)
            {
                _arg4 = Align.none;
            };
            this.alignement = _arg4;
            this.stickToEdge = _arg5;
            if (_arg3 == 0)
            {
                _arg3 = Style.backgroundColor;
            };
            _color = _arg3;
            _textField.addEventListener(TextEvent.LINK, onLink);
        }

        public function get tag():String
        {
            return (_tag);
        }

        private function _draw():void
        {
            var _local1:Graphics = _background.graphics;
            _local1.clear();
            _local1.beginFill(_color);
            var _local2:uint = _textField.width;
            var _local3:uint = _textField.height;
            if (forcedWidth > 0)
            {
                _local2 = forcedWidth;
            };
            Background.drawRounded(this, _local1, _local2, _local3);
            _local1.endFill();
        }

        public function get text():String
        {
            return (_textField.text);
        }

        public function appendText(_arg1:String, _arg2:String=""):void
        {
            if (_arg1 == "")
            {
                return;
            };
            if (_arg2 == "")
            {
                _arg2 = tag;
            };
            _textField.htmlText = (_textField.htmlText + (((('<span class="' + _arg2) + '">') + _arg1) + "</span>"));
            _text = (_text + _arg1);
            _draw();
            resize();
        }

        public function set text(_arg1:String):void
        {
            if (_arg1 == "")
            {
                _arg1 = _text;
            };
            _textField.htmlText = (((('<span class="' + tag) + '">') + _arg1) + "</span>");
            _text = _arg1;
            _draw();
            resize();
        }

        override protected function layout():void
        {
            _textField.type = TextFieldType.DYNAMIC;
            _textField.autoSize = TextFieldAutoSize.LEFT;
            _textField.background = false;
            _textField.selectable = selectable;
            _textField.multiline = true;
            _textField.styleSheet = Style.sheet;
            this.text = _text;
            addChild(_background);
            addChild(_textField);
        }

        public function set tag(_arg1:String):void
        {
            _tag = _arg1;
            text = "";
        }

        public function onLink(_arg1:TextEvent):void
        {
        }

        override protected function dispose():void
        {
            _textField.removeEventListener(TextEvent.LINK, onLink);
            super.dispose();
        }


    }
}

