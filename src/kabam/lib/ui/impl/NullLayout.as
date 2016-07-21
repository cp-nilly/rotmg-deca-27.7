package kabam.lib.ui.impl
{
    import kabam.lib.ui.api.Layout;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;

    public class NullLayout implements Layout 
    {


        public function getPadding():int
        {
            return (0);
        }

        public function setPadding(_arg1:int):void
        {
        }

        public function layout(_arg1:Vector.<DisplayObject>, _arg2:int=0):void
        {
        }


    }
}

