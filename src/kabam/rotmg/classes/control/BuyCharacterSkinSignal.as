package kabam.rotmg.classes.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.classes.model.CharacterSkin;

    public class BuyCharacterSkinSignal extends Signal 
    {

        public function BuyCharacterSkinSignal()
        {
            super(CharacterSkin);
        }

    }
}

