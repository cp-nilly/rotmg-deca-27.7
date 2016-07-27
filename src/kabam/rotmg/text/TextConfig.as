package kabam.rotmg.text
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.view.TextFieldDisplay;
    import kabam.rotmg.text.controller.TextFieldDisplayMediator;
    import com.company.ui.BaseSimpleText;
    import kabam.rotmg.text.view.BaseSimpleTextMediator;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.model.TextAndMapProvider;
    import kabam.rotmg.language.DebugTextAndMapProvider;
    import kabam.rotmg.language.model.DebugStringMap;
    import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
    import robotlegs.bender.extensions.viewProcessorMap.utils.MediatorCreator;
    import kabam.rotmg.text.view.TextDisplay;

    public class TextConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var viewProcessorMap:IViewProcessorMap;
        [Inject]
        public var applicationSetup:ApplicationSetup;


        public function configure():void
        {
            this.injector.map(FontModel).asSingleton();
            this.mapTextFieldProvider();
            this.viewProcessorMap.map(TextFieldDisplay).toProcess(new MediatorCreator(TextFieldDisplayMediator));
            this.mediatorMap.map(BaseSimpleText).toMediator(BaseSimpleTextMediator);
            this.injector.map(BitmapTextFactory);
        }

        private function mapTextFieldProvider():void
        {
            this.injector.map(DebugStringMap).asSingleton();
            this.injector.map(TextAndMapProvider).toType(DebugTextAndMapProvider);
        }


    }
}

