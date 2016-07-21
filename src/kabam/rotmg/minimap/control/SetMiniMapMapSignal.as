package kabam.rotmg.minimap.control
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.map.Map;

    public class SetMiniMapMapSignal extends Signal 
    {

        public function SetMiniMapMapSignal()
        {
            super(Map);
        }

    }
}

