package kabam.rotmg.ui.signals
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.objects.Player;

    public class UpdateHUDSignal extends Signal 
    {

        public function UpdateHUDSignal()
        {
            super(Player);
        }

    }
}

