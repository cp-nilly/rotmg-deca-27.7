package kabam.rotmg.characters.reskin.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.classes.model.CharacterSkin;

    public class ReskinCharacterSignal extends Signal 
    {

        public function ReskinCharacterSignal()
        {
            super(CharacterSkin);
        }

    }
}

