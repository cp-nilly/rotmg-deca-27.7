package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import flash.display.Bitmap;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import flash.display.BitmapData;
    import kabam.rotmg.constants.ItemConstants;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

    public class ItemTileSprite extends Sprite 
    {

        protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 1, 0])];
        private static const IDENTITY_MATRIX:Matrix = new Matrix();
        private static const DOSE_MATRIX:Matrix = function ():Matrix
        {
            var _local1:* = new Matrix();
            _local1.translate(10, 5);
            return (_local1);
        }();

        public var itemId:int;
        public var itemBitmap:Bitmap;
        private var bitmapFactory:BitmapTextFactory;

        public function ItemTileSprite()
        {
            this.itemBitmap = new Bitmap();
            addChild(this.itemBitmap);
            this.itemId = -1;
        }

        public function setDim(_arg1:Boolean):void
        {
            filters = ((_arg1) ? DIM_FILTER : null);
        }

        public function setType(_arg1:int):void
        {
            this.itemId = _arg1;
            this.drawTile();
        }

        public function drawTile():void
        {
            var _local1:BitmapData;
            var _local2:XML;
            var _local3:BitmapData;
            if (this.itemId != ItemConstants.NO_ITEM)
            {
                _local1 = ObjectLibrary.getRedrawnTextureFromType(this.itemId, 80, true);
                _local2 = ObjectLibrary.xmlLibrary_[this.itemId];
                if (((((_local2) && (_local2.hasOwnProperty("Doses")))) && (this.bitmapFactory)))
                {
                    _local1 = _local1.clone();
                    _local3 = this.bitmapFactory.make(new StaticStringBuilder(String(_local2.Doses)), 12, 0xFFFFFF, false, IDENTITY_MATRIX, false);
                    _local1.draw(_local3, DOSE_MATRIX);
                };
                this.itemBitmap.bitmapData = _local1;
                this.itemBitmap.x = (-(_local1.width) / 2);
                this.itemBitmap.y = (-(_local1.height) / 2);
                visible = true;
            }
            else
            {
                visible = false;
            };
        }

        public function setBitmapFactory(_arg1:BitmapTextFactory):void
        {
            this.bitmapFactory = _arg1;
        }


    }
}

