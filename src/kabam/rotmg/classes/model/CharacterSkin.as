package kabam.rotmg.classes.model
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.assets.model.CharacterTemplate;

    public class CharacterSkin 
    {

        public const changed:Signal = new Signal(CharacterSkin);

        public var id:int = 0;
        public var name:String = "";
        public var unlockLevel:int;
        public var unlockSpecial:String;
        public var template:CharacterTemplate;
        public var cost:int;
        public var limited:Boolean = false;
        public var skinSelectEnabled:Boolean = true;
        private var state:CharacterSkinState;
        private var isSelected:Boolean;

        public function CharacterSkin()
        {
            this.state = CharacterSkinState.NULL;
            super();
        }

        public function getIsSelected():Boolean
        {
            return (this.isSelected);
        }

        public function setIsSelected(_arg1:Boolean):void
        {
            if (this.isSelected != _arg1)
            {
                this.isSelected = _arg1;
                this.changed.dispatch(this);
            };
        }

        public function getState():CharacterSkinState
        {
            return (this.state);
        }

        public function setState(_arg1:CharacterSkinState):void
        {
            if (this.state != _arg1)
            {
                this.state = _arg1;
                this.changed.dispatch(this);
            };
        }


    }
}

