package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.text.view.BitmapTextFactory;

    public class ItemTileSpriteMediator extends Mediator 
    {

        [Inject]
        public var bitmapFactor:BitmapTextFactory;
        [Inject]
        public var view:ItemTileSprite;


        override public function initialize():void
        {
            this.view.setBitmapFactory(this.bitmapFactor);
            this.view.drawTile();
        }


    }
}

