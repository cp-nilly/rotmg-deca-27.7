package kabam.rotmg.packages.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.packages.model.PackageInfo;

    public class BuyPackageSignal extends Signal 
    {

        public function BuyPackageSignal()
        {
            super(PackageInfo);
        }

    }
}

