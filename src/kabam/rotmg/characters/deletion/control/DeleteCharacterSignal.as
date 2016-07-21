package kabam.rotmg.characters.deletion.control
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.appengine.SavedCharacter;

    public class DeleteCharacterSignal extends Signal 
    {

        public function DeleteCharacterSignal()
        {
            super(SavedCharacter);
        }

    }
}

