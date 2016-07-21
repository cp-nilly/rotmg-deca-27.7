package com.google.analytics.debug
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.display.Graphics;
    import flash.display.DisplayObject;

    public class Panel extends UISprite 
    {

        private var _savedH:uint;
        private var _data:UISprite;
        private var _mask:Sprite;
        private var _background:Shape;
        private var _savedW:uint;
        private var _stickToEdge:Boolean;
        private var _border:Shape;
        private var _borderColor:uint;
        protected var baseAlpha:Number;
        private var _backgroundColor:uint;
        private var _title:Label;
        private var _colapsed:Boolean;
        private var _name:String;

        public function Panel(_arg1:String, _arg2:uint, _arg3:uint, _arg4:uint=0, _arg5:uint=0, _arg6:Number=0.3, _arg7:Align=null, _arg8:Boolean=false)
        {
            _name = _arg1;
            this.name = _arg1;
            this.mouseEnabled = false;
            _colapsed = false;
            forcedWidth = _arg2;
            forcedHeight = _arg3;
            this.baseAlpha = _arg6;
            _background = new Shape();
            _data = new UISprite();
            _data.forcedWidth = _arg2;
            _data.forcedHeight = _arg3;
            _data.mouseEnabled = false;
            _title = new Label(_arg1, "uiLabel", 0xFFFFFF, Align.topLeft, _arg8);
            _title.buttonMode = true;
            _title.margin.top = 0.6;
            _title.margin.left = 0.6;
            _title.addEventListener(MouseEvent.CLICK, onToggle);
            _title.mouseChildren = false;
            _border = new Shape();
            _mask = new Sprite();
            _mask.useHandCursor = false;
            _mask.mouseEnabled = false;
            _mask.mouseChildren = false;
            if (_arg7 == null)
            {
                _arg7 = Align.none;
            };
            this.alignement = _arg7;
            this.stickToEdge = _arg8;
            if (_arg4 == 0)
            {
                _arg4 = Style.backgroundColor;
            };
            _backgroundColor = _arg4;
            if (_arg5 == 0)
            {
                _arg5 = Style.borderColor;
            };
            _borderColor = _arg5;
        }

        public function get stickToEdge():Boolean
        {
            return (_stickToEdge);
        }

        public function onToggle(_arg1:MouseEvent=null):void
        {
            if (_colapsed)
            {
                _data.visible = true;
            }
            else
            {
                _data.visible = false;
            };
            _colapsed = !(_colapsed);
            _update();
            resize();
        }

        public function set stickToEdge(_arg1:Boolean):void
        {
            _stickToEdge = _arg1;
            _title.stickToEdge = _arg1;
        }

        override protected function dispose():void
        {
            _title.removeEventListener(MouseEvent.CLICK, onToggle);
            super.dispose();
        }

        private function _draw():void
        {
            var _local1:uint;
            var _local2:uint;
            if (((_savedW) && (_savedH)))
            {
                forcedWidth = _savedW;
                forcedHeight = _savedH;
            };
            if (!_colapsed)
            {
                _local1 = forcedWidth;
                _local2 = forcedHeight;
            }
            else
            {
                _local1 = _title.width;
                _local2 = _title.height;
                _savedW = forcedWidth;
                _savedH = forcedHeight;
                forcedWidth = _local1;
                forcedHeight = _local2;
            };
            var _local3:Graphics = _background.graphics;
            _local3.clear();
            _local3.beginFill(_backgroundColor);
            Background.drawRounded(this, _local3, _local1, _local2);
            _local3.endFill();
            var _local4:Graphics = _data.graphics;
            _local4.clear();
            _local4.beginFill(_backgroundColor, 0);
            Background.drawRounded(this, _local4, _local1, _local2);
            _local4.endFill();
            var _local5:Graphics = _border.graphics;
            _local5.clear();
            _local5.lineStyle(0.1, _borderColor);
            Background.drawRounded(this, _local5, _local1, _local2);
            _local5.endFill();
            var _local6:Graphics = _mask.graphics;
            _local6.clear();
            _local6.beginFill(_backgroundColor);
            Background.drawRounded(this, _local6, (_local1 + 1), (_local2 + 1));
            _local6.endFill();
        }

        public function get title():String
        {
            return (_title.text);
        }

        private function _update():void
        {
            _draw();
            if (baseAlpha < 1)
            {
                _background.alpha = baseAlpha;
                _border.alpha = baseAlpha;
            };
        }

        public function addData(_arg1:DisplayObject):void
        {
            _data.addChild(_arg1);
        }

        override protected function layout():void
        {
            _update();
            addChild(_background);
            addChild(_data);
            addChild(_title);
            addChild(_border);
            addChild(_mask);
            mask = _mask;
        }

        public function set title(_arg1:String):void
        {
            _title.text = _arg1;
        }

        public function close():void
        {
            dispose();
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }


    }
}

