package com.google.analytics.campaign
{
    import com.google.analytics.utils.Variables;

    public class CampaignTracker 
    {

        public var content:String;
        public var source:String;
        public var clickId:String;
        public var name:String;
        public var term:String;
        public var medium:String;
        public var id:String;

        public function CampaignTracker(_arg1:String="", _arg2:String="", _arg3:String="", _arg4:String="", _arg5:String="", _arg6:String="", _arg7:String="")
        {
            this.id = _arg1;
            this.source = _arg2;
            this.clickId = _arg3;
            this.name = _arg4;
            this.medium = _arg5;
            this.term = _arg6;
            this.content = _arg7;
        }

        public function isValid():Boolean
        {
            if (((((!((id == ""))) || (!((source == ""))))) || (!((clickId == "")))))
            {
                return (true);
            };
            return (false);
        }

        public function toTrackerString():String
        {
            var _local1:Array = [];
            _addIfNotEmpty(_local1, "utmcid=", id);
            _addIfNotEmpty(_local1, "utmcsr=", source);
            _addIfNotEmpty(_local1, "utmgclid=", clickId);
            _addIfNotEmpty(_local1, "utmccn=", name);
            _addIfNotEmpty(_local1, "utmcmd=", medium);
            _addIfNotEmpty(_local1, "utmctr=", term);
            _addIfNotEmpty(_local1, "utmcct=", content);
            return (_local1.join(CampaignManager.trackingDelimiter));
        }

        private function _addIfNotEmpty(_arg1:Array, _arg2:String, _arg3:String):void
        {
            if (((!((_arg3 == null))) && (!((_arg3 == "")))))
            {
                _arg3 = _arg3.split("+").join("%20");
                _arg3 = _arg3.split(" ").join("%20");
                _arg1.push((_arg2 + _arg3));
            };
        }

        public function fromTrackerString(_arg1:String):void
        {
            var _local2:String = _arg1.split(CampaignManager.trackingDelimiter).join("&");
            var _local3:Variables = new Variables(_local2);
            if (_local3.hasOwnProperty("utmcid"))
            {
                this.id = _local3["utmcid"];
            };
            if (_local3.hasOwnProperty("utmcsr"))
            {
                this.source = _local3["utmcsr"];
            };
            if (_local3.hasOwnProperty("utmccn"))
            {
                this.name = _local3["utmccn"];
            };
            if (_local3.hasOwnProperty("utmcmd"))
            {
                this.medium = _local3["utmcmd"];
            };
            if (_local3.hasOwnProperty("utmctr"))
            {
                this.term = _local3["utmctr"];
            };
            if (_local3.hasOwnProperty("utmcct"))
            {
                this.content = _local3["utmcct"];
            };
            if (_local3.hasOwnProperty("utmgclid"))
            {
                this.clickId = _local3["utmgclid"];
            };
        }


    }
}

