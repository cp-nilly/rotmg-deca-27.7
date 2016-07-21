package com.company.assembleegameclient.mapeditor
{
    import flash.display.Sprite;
    import com.company.assembleegameclient.mapeditor.MEMap_transbackgroundEmbed_;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import com.company.assembleegameclient.mapeditor.BigBitmapData;
    import flash.display.Shape;
    import com.company.util.IntPoint;
    import flash.display.Bitmap;
    import com.company.util.AssetLibrary;
    import flash.events.Event;
    import com.company.assembleegameclient.mapeditor.METile;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import com.company.util.KeyCodes;
    import com.company.assembleegameclient.mapeditor.Layer;
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.map.RegionLibrary;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import com.company.util.PointUtil;
    import __AS3__.vec.*;
    import com.company.assembleegameclient.mapeditor.*;

    class MEMap extends Sprite 
    {

        public static const NUM_SQUARES:int = 0x0200;
        public static const SQUARE_SIZE:int = 16;
        public static const SIZE:int = 0x0200;
        public static const MIN_ZOOM:Number = 0.0625;
        public static const MAX_ZOOM:Number = 16;

        private static var transbackgroundEmbed_:Class = MEMap_transbackgroundEmbed_;
        private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;

        public var tileDict_:Dictionary;
        public var fullMap_:BigBitmapData;
        public var regionMap_:BitmapData;
        public var map_:BitmapData;
        public var overlay_:Shape;
        public var posT_:IntPoint;
        public var zoom_:Number = 1;
        private var mouseRectAnchorT_:IntPoint = null;
        private var mouseMoveAnchorT_:IntPoint = null;
        private var rectWidthOverride:int = 0;
        private var rectHeightOverride:int = 0;
        private var invisibleTexture_:BitmapData;
        private var replaceTexture_:BitmapData;
        public var anchorLock:Boolean = false;

        public function MEMap()
        {
            this.tileDict_ = new Dictionary();
            this.fullMap_ = new BigBitmapData((NUM_SQUARES * SQUARE_SIZE), (NUM_SQUARES * SQUARE_SIZE), true, 0);
            this.regionMap_ = new BitmapDataSpy(NUM_SQUARES, NUM_SQUARES, true, 0);
            this.map_ = new BitmapDataSpy(SIZE, SIZE, true, 0);
            this.overlay_ = new Shape();
            super();
            graphics.beginBitmapFill(transbackgroundBD_, null, true);
            graphics.drawRect(0, 0, SIZE, SIZE);
            addChild(new Bitmap(this.map_));
            addChild(this.overlay_);
            this.posT_ = new IntPoint(((NUM_SQUARES / 2) - (this.sizeInTiles() / 2)), ((NUM_SQUARES / 2) - (this.sizeInTiles() / 2)));
            this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible", 0);
            this.replaceTexture_ = AssetLibrary.getImageFromSet("lofiObj3", 0xFF);
            this.draw();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        public function getType(_arg1:int, _arg2:int, _arg3:int):int
        {
            var _local4:METile = this.getTile(_arg1, _arg2);
            if (_local4 == null)
            {
                return (-1);
            };
            return (_local4.types_[_arg3]);
        }

        public function getTile(_arg1:int, _arg2:int):METile
        {
            return (this.tileDict_[(_arg1 + (_arg2 * NUM_SQUARES))]);
        }

        public function modifyTile(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void
        {
            var _local5:METile = this.getOrCreateTile(_arg1, _arg2);
            if (_local5.types_[_arg3] == _arg4)
            {
                return;
            };
            _local5.types_[_arg3] = _arg4;
            this.drawTile(_arg1, _arg2, _local5);
        }

        public function getObjectName(_arg1:int, _arg2:int):String
        {
            var _local3:METile = this.getTile(_arg1, _arg2);
            if (_local3 == null)
            {
                return (null);
            };
            return (_local3.objName_);
        }

        public function modifyObjectName(_arg1:int, _arg2:int, _arg3:String):void
        {
            var _local4:METile = this.getOrCreateTile(_arg1, _arg2);
            _local4.objName_ = _arg3;
        }

        public function getAllTiles():Vector.<IntPoint>
        {
            var _local2:String;
            var _local3:int;
            var _local1:Vector.<IntPoint> = new Vector.<IntPoint>();
            for (_local2 in this.tileDict_)
            {
                _local3 = int(_local2);
                _local1.push(new IntPoint((_local3 % NUM_SQUARES), (_local3 / NUM_SQUARES)));
            };
            return (_local1);
        }

        public function setTile(_arg1:int, _arg2:int, _arg3:METile):void
        {
            _arg3 = _arg3.clone();
            this.tileDict_[(_arg1 + (_arg2 * NUM_SQUARES))] = _arg3;
            this.drawTile(_arg1, _arg2, _arg3);
        }

        public function eraseTile(_arg1:int, _arg2:int):void
        {
            this.clearTile(_arg1, _arg2);
            this.drawTile(_arg1, _arg2, null);
        }

        public function clear():void
        {
            var _local1:String;
            var _local2:int;
            for (_local1 in this.tileDict_)
            {
                _local2 = int(_local1);
                this.eraseTile((_local2 % NUM_SQUARES), (_local2 / NUM_SQUARES));
            };
        }

        public function getTileBounds():Rectangle
        {
            var _local5:String;
            var _local6:METile;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local1:int = NUM_SQUARES;
            var _local2:int = NUM_SQUARES;
            var _local3:int;
            var _local4:int;
            for (_local5 in this.tileDict_)
            {
                _local6 = this.tileDict_[_local5];
                if (!_local6.isEmpty())
                {
                    _local7 = int(_local5);
                    _local8 = (_local7 % NUM_SQUARES);
                    _local9 = (_local7 / NUM_SQUARES);
                    if (_local8 < _local1)
                    {
                        _local1 = _local8;
                    };
                    if (_local9 < _local2)
                    {
                        _local2 = _local9;
                    };
                    if ((_local8 + 1) > _local3)
                    {
                        _local3 = (_local8 + 1);
                    };
                    if ((_local9 + 1) > _local4)
                    {
                        _local4 = (_local9 + 1);
                    };
                };
            };
            if (_local1 > _local3)
            {
                return (null);
            };
            return (new Rectangle(_local1, _local2, (_local3 - _local1), (_local4 - _local2)));
        }

        private function sizeInTiles():int
        {
            return ((SIZE / (SQUARE_SIZE * this.zoom_)));
        }

        private function modifyZoom(_arg1:Number):void
        {
            if ((((((_arg1 > 1)) && ((this.zoom_ >= MAX_ZOOM)))) || ((((_arg1 < 1)) && ((this.zoom_ <= MIN_ZOOM))))))
            {
                return;
            };
            var _local2:IntPoint = this.mousePosT();
            this.zoom_ = (this.zoom_ * _arg1);
            var _local3:IntPoint = this.mousePosT();
            this.movePosT((_local2.x_ - _local3.x_), (_local2.y_ - _local3.y_));
        }

        private function canMove():Boolean
        {
            return ((((this.mouseRectAnchorT_ == null)) && ((this.mouseMoveAnchorT_ == null))));
        }

        private function increaseZoom():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.modifyZoom(2);
            this.draw();
        }

        private function decreaseZoom():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.modifyZoom(0.5);
            this.draw();
        }

        private function moveLeft():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.movePosT(-1, 0);
            this.draw();
        }

        private function moveRight():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.movePosT(1, 0);
            this.draw();
        }

        private function moveUp():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.movePosT(0, -1);
            this.draw();
        }

        private function moveDown():void
        {
            if (!this.canMove())
            {
                return;
            };
            this.movePosT(0, 1);
            this.draw();
        }

        private function movePosT(_arg1:int, _arg2:int):void
        {
            var _local3:int;
            var _local4:int = (NUM_SQUARES - this.sizeInTiles());
            this.posT_.x_ = Math.max(_local3, Math.min(_local4, (this.posT_.x_ + _arg1)));
            this.posT_.y_ = Math.max(_local3, Math.min(_local4, (this.posT_.y_ + _arg2)));
        }

        private function mousePosT():IntPoint
        {
            var _local1:int = Math.max(0, Math.min((SIZE - 1), mouseX));
            var _local2:int = Math.max(0, Math.min((SIZE - 1), mouseY));
            return (new IntPoint((this.posT_.x_ + (_local1 / (SQUARE_SIZE * this.zoom_))), (this.posT_.y_ + (_local2 / (SQUARE_SIZE * this.zoom_)))));
        }

        public function mouseRectT():Rectangle
        {
            var _local1:IntPoint = this.mousePosT();
            if (this.mouseRectAnchorT_ == null)
            {
                return (new Rectangle(_local1.x_, _local1.y_, 1, 1));
            };
            return (new Rectangle(Math.min(_local1.x_, this.mouseRectAnchorT_.x_), Math.min(_local1.y_, this.mouseRectAnchorT_.y_), (Math.abs((_local1.x_ - this.mouseRectAnchorT_.x_)) + 1), (Math.abs((_local1.y_ - this.mouseRectAnchorT_.y_)) + 1)));
        }

        private function posTToPosP(_arg1:IntPoint):IntPoint
        {
            return (new IntPoint((((_arg1.x_ - this.posT_.x_) * SQUARE_SIZE) * this.zoom_), (((_arg1.y_ - this.posT_.y_) * SQUARE_SIZE) * this.zoom_)));
        }

        private function sizeTToSizeP(_arg1:int):Number
        {
            return (((_arg1 * this.zoom_) * SQUARE_SIZE));
        }

        private function mouseRectP():Rectangle
        {
            var _local1:Rectangle = this.mouseRectT();
            var _local2:IntPoint = this.posTToPosP(new IntPoint(_local1.x, _local1.y));
            _local1.x = _local2.x_;
            _local1.y = _local2.y_;
            _local1.width = (this.sizeTToSizeP(_local1.width) - 1);
            _local1.height = (this.sizeTToSizeP(_local1.height) - 1);
            return (_local1);
        }

        private function onAddedToStage(_arg1:Event):void
        {
            addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        }

        private function onRemovedFromStage(_arg1:Event):void
        {
            removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        }

        private function onKeyDown(_arg1:KeyboardEvent):void
        {
            switch (_arg1.keyCode)
            {
                case Keyboard.SHIFT:
                    if (this.mouseRectAnchorT_ != null) break;
                    this.mouseRectAnchorT_ = this.mousePosT();
                    break;
                case Keyboard.CONTROL:
                    if (this.mouseMoveAnchorT_ != null) break;
                    this.mouseMoveAnchorT_ = this.mousePosT();
                    break;
                case Keyboard.LEFT:
                    this.moveLeft();
                    break;
                case Keyboard.RIGHT:
                    this.moveRight();
                    break;
                case Keyboard.UP:
                    this.moveUp();
                    break;
                case Keyboard.DOWN:
                    this.moveDown();
                    break;
                case KeyCodes.MINUS:
                    this.decreaseZoom();
                    break;
                case KeyCodes.EQUAL:
                    this.increaseZoom();
                    break;
            };
            this.draw();
        }

        private function onKeyUp(_arg1:KeyboardEvent):void
        {
            switch (_arg1.keyCode)
            {
                case Keyboard.SHIFT:
                    this.mouseRectAnchorT_ = null;
                    break;
                case Keyboard.CONTROL:
                    this.mouseMoveAnchorT_ = null;
                    break;
            };
            this.draw();
        }

        private function onMouseWheel(_arg1:MouseEvent):void
        {
            if (_arg1.delta > 0)
            {
                this.increaseZoom();
            }
            else
            {
                if (_arg1.delta < 0)
                {
                    this.decreaseZoom();
                };
            };
        }

        private function onMouseDown(_arg1:MouseEvent):void
        {
            var _local7:int;
            var _local2:Rectangle = this.mouseRectT();
            var _local3:Vector.<IntPoint> = new Vector.<IntPoint>();
            var _local4:int = Math.max((_local2.x + this.rectWidthOverride), _local2.right);
            var _local5:int = Math.max((_local2.y + this.rectHeightOverride), _local2.bottom);
            var _local6:int = _local2.x;
            while (_local6 < _local4)
            {
                _local7 = _local2.y;
                while (_local7 < _local5)
                {
                    _local3.push(new IntPoint(_local6, _local7));
                    _local7++;
                };
                _local6++;
            };
            dispatchEvent(new TilesEvent(_local3));
        }

        public function freezeSelect():void
        {
            var _local1:Rectangle = this.mouseRectT();
            this.rectWidthOverride = _local1.width;
            this.rectHeightOverride = _local1.height;
        }

        public function clearSelect():void
        {
            this.rectHeightOverride = 0;
            this.rectWidthOverride = 0;
        }

        private function onMouseMove(_arg1:MouseEvent):void
        {
            var _local2:IntPoint;
            if (!_arg1.shiftKey)
            {
                this.mouseRectAnchorT_ = null;
            }
            else
            {
                if (this.mouseRectAnchorT_ == null)
                {
                    this.mouseRectAnchorT_ = this.mousePosT();
                };
            };
            if (!_arg1.ctrlKey)
            {
                this.mouseMoveAnchorT_ = null;
            }
            else
            {
                if (this.mouseMoveAnchorT_ == null)
                {
                    this.mouseMoveAnchorT_ = this.mousePosT();
                };
            };
            if (_arg1.buttonDown)
            {
                dispatchEvent(new TilesEvent(new <IntPoint>[this.mousePosT()]));
            };
            if (this.mouseMoveAnchorT_ != null)
            {
                _local2 = this.mousePosT();
                this.movePosT((this.mouseMoveAnchorT_.x_ - _local2.x_), (this.mouseMoveAnchorT_.y_ - _local2.y_));
                this.draw();
            }
            else
            {
                this.drawOverlay();
            };
        }

        private function getOrCreateTile(_arg1:int, _arg2:int):METile
        {
            var _local3:int = (_arg1 + (_arg2 * NUM_SQUARES));
            var _local4:METile = this.tileDict_[_local3];
            if (_local4 != null)
            {
                return (_local4);
            };
            _local4 = new METile();
            this.tileDict_[_local3] = _local4;
            return (_local4);
        }

        private function clearTile(_arg1:int, _arg2:int):void
        {
            delete this.tileDict_[(_arg1 + (_arg2 * NUM_SQUARES))];
        }

        private function drawTile(_arg1:int, _arg2:int, _arg3:METile):void
        {
            var _local5:BitmapData;
            var _local6:BitmapData;
            var _local7:uint;
            var _local4:Rectangle = new Rectangle((_arg1 * SQUARE_SIZE), (_arg2 * SQUARE_SIZE), SQUARE_SIZE, SQUARE_SIZE);
            this.fullMap_.erase(_local4);
            this.regionMap_.setPixel32(_arg1, _arg2, 0);
            if (_arg3 == null)
            {
                return;
            };
            if (_arg3.types_[Layer.GROUND] != -1)
            {
                _local5 = GroundLibrary.getBitmapData(_arg3.types_[Layer.GROUND]);
                this.fullMap_.copyTo(_local5, _local5.rect, _local4);
            };
            if (_arg3.types_[Layer.OBJECT] != -1)
            {
                _local6 = ObjectLibrary.getTextureFromType(_arg3.types_[Layer.OBJECT]);
                if ((((_local6 == null)) || ((_local6 == this.invisibleTexture_))))
                {
                    this.fullMap_.copyTo(this.replaceTexture_, this.replaceTexture_.rect, _local4);
                }
                else
                {
                    this.fullMap_.copyTo(_local6, _local6.rect, _local4);
                };
            };
            if (_arg3.types_[Layer.REGION] != -1)
            {
                _local7 = RegionLibrary.getColor(_arg3.types_[Layer.REGION]);
                this.regionMap_.setPixel32(_arg1, _arg2, (0x5F000000 | _local7));
            };
        }

        private function drawOverlay():void
        {
            var _local1:Rectangle = this.mouseRectP();
            var _local2:Graphics = this.overlay_.graphics;
            _local2.clear();
            _local2.lineStyle(1, 0xFFFFFF);
            _local2.beginFill(0xFFFFFF, 0.1);
            _local2.drawRect(_local1.x, _local1.y, _local1.width, _local1.height);
            _local2.endFill();
            _local2.lineStyle();
        }

        public function draw():void
        {
            var _local2:Matrix;
            var _local3:int;
            var _local4:BitmapData;
            var _local1:int = (SIZE / this.zoom_);
            this.map_.fillRect(this.map_.rect, 0);
            this.fullMap_.copyFrom(new Rectangle((this.posT_.x_ * SQUARE_SIZE), (this.posT_.y_ * SQUARE_SIZE), _local1, _local1), this.map_, this.map_.rect);
            _local2 = new Matrix();
            _local2.identity();
            _local3 = (SQUARE_SIZE * this.zoom_);
            if (this.zoom_ > 2)
            {
                _local4 = new BitmapDataSpy((SIZE / _local3), (SIZE / _local3));
                _local4.copyPixels(this.regionMap_, new Rectangle(this.posT_.x_, this.posT_.y_, _local1, _local1), PointUtil.ORIGIN);
                _local2.scale(_local3, _local3);
                this.map_.draw(_local4, _local2);
            }
            else
            {
                _local2.translate(-(this.posT_.x_), -(this.posT_.y_));
                _local2.scale(_local3, _local3);
                this.map_.draw(this.regionMap_, _local2, null, null, this.map_.rect);
            };
            this.drawOverlay();
        }


    }
}

