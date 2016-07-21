package kabam.rotmg.language
{
    import kabam.rotmg.text.model.TextAndMapProvider;
    import kabam.rotmg.language.model.DebugStringMap;
    import kabam.rotmg.text.view.DebugTextField;
    import flash.text.TextField;
    import kabam.rotmg.language.model.StringMap;

    public class DebugTextAndMapProvider implements TextAndMapProvider 
    {

        [Inject]
        public var debugStringMap:DebugStringMap;


        public function getTextField():TextField
        {
            var _local1:DebugTextField = new DebugTextField();
            _local1.debugStringMap = this.debugStringMap;
            return (_local1);
        }

        public function getStringMap():StringMap
        {
            return (this.debugStringMap);
        }


    }
}

