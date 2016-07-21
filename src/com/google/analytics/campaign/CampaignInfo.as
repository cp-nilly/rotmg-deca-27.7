package com.google.analytics.campaign
{
    import com.google.analytics.utils.Variables;

    public class CampaignInfo 
    {

        private var _new:Boolean;
        private var _empty:Boolean;

        public function CampaignInfo(_arg1:Boolean=true, _arg2:Boolean=false)
        {
            _empty = _arg1;
            _new = _arg2;
        }

        public function toURLString():String
        {
            var _local1:Variables = toVariables();
            return (_local1.toString());
        }

        public function isNew():Boolean
        {
            return (_new);
        }

        public function get utmcn():String
        {
            return ("1");
        }

        public function isEmpty():Boolean
        {
            return (_empty);
        }

        public function toVariables():Variables
        {
            var _local1:Variables = new Variables();
            _local1.URIencode = true;
            if (((!(isEmpty())) && (isNew())))
            {
                _local1.utmcn = utmcn;
            };
            if (((!(isEmpty())) && (!(isNew()))))
            {
                _local1.utmcr = utmcr;
            };
            return (_local1);
        }

        public function get utmcr():String
        {
            return ("1");
        }


    }
}

