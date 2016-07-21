package com.google.analytics.core
{
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.debug.VisualDebugMode;

    public class Domain 
    {

        private var _mode:DomainNameMode;
        private var _debug:DebugConfiguration;
        private var _name:String;

        public function Domain(_arg1:DomainNameMode=null, _arg2:String="", _arg3:DebugConfiguration=null)
        {
            _debug = _arg3;
            if (_arg1 == null)
            {
                _arg1 = DomainNameMode.auto;
            };
            _mode = _arg1;
            if (_arg1 == DomainNameMode.custom)
            {
                this.name = _arg2;
            }
            else
            {
                _name = _arg2;
            };
        }

        public function get mode():DomainNameMode
        {
            return (_mode);
        }

        public function set mode(_arg1:DomainNameMode):void
        {
            _mode = _arg1;
            if (_mode == DomainNameMode.none)
            {
                _name = "";
            };
        }

        public function get name():String
        {
            return (_name);
        }

        public function set name(_arg1:String):void
        {
            if (((!((_arg1.charAt(0) == "."))) && (_debug)))
            {
                _debug.warning(('missing leading period ".", cookie will only be accessible on ' + _arg1), VisualDebugMode.geek);
            };
            _name = _arg1;
        }


    }
}

