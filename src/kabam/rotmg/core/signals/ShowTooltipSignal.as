package kabam.rotmg.core.signals
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    public class ShowTooltipSignal extends Signal 
    {

        public function ShowTooltipSignal()
        {
            super(ToolTip);
        }

    }
}

