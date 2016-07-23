package kabam.lib.resizing
{
	import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import kabam.lib.resizing.signals.Resize;
    import kabam.lib.resizing.view.Resizable;
    import kabam.lib.resizing.view.ResizableMediator;

    public class ResizeConfig 
    {

        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;


        [PostConstruct]
        public function setup():void
        {
            this.injector.map(Resize).asSingleton();
            this.mediatorMap.map(Resizable).toMediator(ResizableMediator);
        }


    }
}

