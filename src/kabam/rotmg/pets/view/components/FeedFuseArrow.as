package kabam.rotmg.pets.view.components
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import flash.display.IGraphicsData;
    import com.company.util.GraphicsUtil;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathWinding;
    import flash.geom.ColorTransform;
    import __AS3__.vec.*;

    public class FeedFuseArrow extends Sprite 
    {

        private const designGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[designFill_, designPath_, GraphicsUtil.END_FILL];

        private var designFill_:GraphicsSolidFill;
        private var designPath_:GraphicsPath;

        public function FeedFuseArrow()
        {
            this.designFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
            this.designPath_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>(), GraphicsPathWinding.NON_ZERO);
            super();
            this.setColor(0x666666);
        }

        public function setColor(_arg1:uint):void
        {
            graphics.clear();
            GraphicsUtil.clearPath(this.designPath_);
            this.designFill_.color = _arg1;
            this.drawArrow();
            GraphicsUtil.drawRect(26, 11.5, 24, 19, this.designPath_);
            graphics.drawGraphicsData(this.designGraphicsData_);
        }

        public function highlight(_arg1:Boolean):void
        {
            var _local2:ColorTransform = transform.colorTransform;
            _local2.color = ((_arg1) ? 16777103 : 0x545454);
            transform.colorTransform = _local2;
        }

        private function drawArrow():void
        {
            this.designPath_.moveTo(0, 20);
            this.designPath_.lineTo(26, 0);
            this.designPath_.lineTo(26, 40);
            this.designPath_.lineTo(0, 20);
            graphics.drawGraphicsData(this.designGraphicsData_);
        }


    }
}

