package kabam.rotmg.text.view
{
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.model.TextAndMapProvider;

    import robotlegs.bender.framework.api.IInjector;

    public class StaticTextDisplay extends TextDisplay
    {
        public function StaticTextDisplay()
        {
            var _local1:IInjector = StaticInjectorContext.getInjector();
            super(_local1.getInstance(FontModel), _local1.getInstance(TextAndMapProvider));
        }
    }
}

