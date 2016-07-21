package kabam.rotmg.maploading.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.MapInfo;

    public class MapLoadedSignal extends Signal 
    {

        public function MapLoadedSignal()
        {
            super(MapInfo);
        }

    }
}

