package kabam.rotmg.minimap.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.minimap.model.UpdateGroundTileVO;

    public class UpdateGroundTileSignal extends Signal 
    {

        public function UpdateGroundTileSignal()
        {
            super(UpdateGroundTileVO);
        }

    }
}

