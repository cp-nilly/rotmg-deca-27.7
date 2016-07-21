package com.company.assembleegameclient.ui.tooltip
{
    import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
    import flash.utils.Dictionary;

    public class SlotComparisonResult 
    {

        public var lineBuilder:AppendingLineBuilder;
        public var processedTags:Dictionary;

        public function SlotComparisonResult()
        {
            this.lineBuilder = new AppendingLineBuilder();
            this.processedTags = new Dictionary(true);
        }

    }
}

