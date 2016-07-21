package com.company.assembleegameclient.mapeditor
{
    import com.company.assembleegameclient.mapeditor.Element;
    import flash.display.Bitmap;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.BitmapData;
    import com.company.assembleegameclient.mapeditor.ObjectTypeToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.assembleegameclient.mapeditor.*;

    class ObjectElement extends Element 
    {

        public var objXML_:XML;

        public function ObjectElement(_arg1:XML)
        {
            var _local3:Bitmap;
            super(int(_arg1.@type));
            this.objXML_ = _arg1;
            var _local2:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_, 100, true, false);
            _local3 = new Bitmap(_local2);
            var _local4:Number = ((WIDTH - 4) / Math.max(_local3.width, _local3.height));
            _local3.scaleX = (_local3.scaleY = _local4);
            _local3.x = ((WIDTH / 2) - (_local3.width / 2));
            _local3.y = ((HEIGHT / 2) - (_local3.height / 2));
            addChild(_local3);
        }

        override protected function getToolTip():ToolTip
        {
            return (new ObjectTypeToolTip(this.objXML_));
        }


    }
}

