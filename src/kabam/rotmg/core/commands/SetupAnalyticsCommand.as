package kabam.rotmg.core.commands
{
    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.core.service.GoogleAnalytics;

    import robotlegs.bender.extensions.contextView.ContextView;

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

