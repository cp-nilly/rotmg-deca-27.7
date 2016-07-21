package com.google.analytics.debug
{
    public class AlertAction 
    {

        public var container:Alert;
        private var _callback;
        public var activator:String;
        public var name:String;

        public function AlertAction(_arg1:String, _arg2:String, _arg3:*)
        {
            this.name = _arg1;
            this.activator = _arg2;
            _callback = _arg3;
        }

        public function execute():void
        {
            if (_callback)
            {
                if ((_callback is Function))
                {
                    ((_callback as Function)());
                }
                else
                {
                    if ((_callback is String))
                    {
                        var _local1 = container;
                        (_local1[_callback]());
                    };
                };
            };
        }


    }
}

