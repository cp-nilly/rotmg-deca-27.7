package robotlegs.bender.framework.api
{
    public class MappingConfigError extends Error 
    {

        private var _trigger:Object;
        private var _action:Object;

        public function MappingConfigError(_arg1:String, _arg2:*, _arg3:*)
        {
            super(_arg1);
            this._trigger = _arg2;
            this._action = _arg3;
        }

        public function get trigger():Object
        {
            return (this._trigger);
        }

        public function get action():Object
        {
            return (this._action);
        }


    }
}

