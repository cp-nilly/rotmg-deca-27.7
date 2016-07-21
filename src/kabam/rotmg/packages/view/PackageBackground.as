package kabam.rotmg.packages.view
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    public class PackageBackground extends Sprite 
    {

        private static const Background:Class = PackageBackground_Background;

        private const asset:DisplayObject = makeBackground();


        private function makeBackground():DisplayObject
        {
            var _local1:DisplayObject = new Background();
            addChild(_local1);
            return (_local1);
        }


    }
}

