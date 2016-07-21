package kabam.rotmg.classes.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.classes.model.CharacterSkin;

    public class FocusCharacterSkinSignal extends Signal 
    {

        public function FocusCharacterSkinSignal()
        {
            super(CharacterSkin);
        }

    }
}

