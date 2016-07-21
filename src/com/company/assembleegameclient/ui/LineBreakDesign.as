package com.company.assembleegameclient.ui
{
    import flash.display.Shape;
    import __AS3__.vec.Vector;
    import flash.display.IGraphicsData;
    import com.company.util.GraphicsUtil;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathWinding;
    import __AS3__.vec.*;

    public class LineBreakDesign extends Shape 
    {

        private const designGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[designFill_, designPath_, GraphicsUtil.END_FILL];

        private var designFill_:GraphicsSolidFill;
        private var designPath_:GraphicsPath;

        public function LineBreakDesign(_arg1:int, _arg2:uint)
        {
            this.designFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
            this.designPath_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>(), GraphicsPathWinding.NON_ZERO);
            super();
            this.setWidthColor(_arg1, _arg2);
        }

        public function setWidthColor(_arg1:int, _arg2:uint):void
        {
            graphics.clear();
            this.designFill_.color = _arg2;
            GraphicsUtil.clearPath(this.designPath_);
            GraphicsUtil.drawDiamond(0, 0, 4, this.designPath_);
            GraphicsUtil.drawDiamond(_arg1, 0, 4, this.designPath_);
            GraphicsUtil.drawRect(0, -1, _arg1, 2, this.designPath_);
            graphics.drawGraphicsData(this.designGraphicsData_);
        }


    }
}

