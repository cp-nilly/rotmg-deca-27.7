package kabam.rotmg.pets.view.dialogs
{
    import flash.display.Sprite;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import com.company.util.GraphicsUtil;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class PetItemBackground extends Sprite 
    {

        private var backgroundFill_:GraphicsSolidFill;
        private var path_:GraphicsPath;

        public function PetItemBackground(_arg1:int, _arg2:Array)
        {
            this.backgroundFill_ = new GraphicsSolidFill(0x545454);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            super();
            var _local3:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_, this.path_, GraphicsUtil.END_FILL];
            GraphicsUtil.drawCutEdgeRect(0, 0, _arg1, _arg1, (_arg1 / 12), _arg2, this.path_);
            graphics.drawGraphicsData(_local3);
        }

    }
}

