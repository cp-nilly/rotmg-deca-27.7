package 
{
    import flash.display.*;
    
    [Embed(source="MapLoadingScreen.swf", symbol = "MapLoadingScreen")]
    public dynamic class MapLoadingScreen extends flash.display.MovieClip
    {
        public function MapLoadingScreen()
        {
            super();
            return;
        }

        public var difficulty_indicators:flash.display.MovieClip;

        public var mapNameContainer:flash.display.MovieClip;

        public var bgGroup:flash.display.MovieClip;
    }
}
