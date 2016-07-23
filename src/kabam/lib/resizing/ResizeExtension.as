package kabam.lib.resizing
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
    import robotlegs.bender.framework.api.IContext;

    public class ResizeExtension implements IExtension 
    {


        public function extend(_arg1:IContext):void
        {
            _arg1.install(MediatorMapExtension);
            _arg1.configure(ResizeConfig);
        }


    }
}

