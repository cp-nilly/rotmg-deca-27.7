package kabam.rotmg.core.commands
{
	import robotlegs.bender.extensions.contextView.ContextView;
    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.core.service.GoogleAnalytics;

    public class SetupAnalyticsCommand 
    {

        [Inject]
        public var contextView:ContextView;
        [Inject]
        public var setup:ApplicationSetup;
        [Inject]
        public var analytics:GoogleAnalytics;


        public function execute():void
        {
            this.analytics.init(this.contextView.view.stage, this.setup.getAnalyticsCode());
        }


    }
}

