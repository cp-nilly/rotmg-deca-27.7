package robotlegs.bender.extensions.modularity.impl
{
    import flash.events.Event;
    import robotlegs.bender.framework.api.IContext;

    public class ModularContextEvent extends Event 
    {

        public static const CONTEXT_ADD:String = "contextAdd";
        public static const CONTEXT_REMOVE:String = "contextRemove";

        private var _context:IContext;

        public function ModularContextEvent(_arg1:String, _arg2:IContext)
        {
            super(_arg1, true, true);
            this._context = _arg2;
        }

        public function get context():IContext
        {
            return (this._context);
        }

        override public function clone():Event
        {
            return (new ModularContextEvent(type, this.context));
        }

        override public function toString():String
        {
            return (formatToString("ModularContextEvent", "context"));
        }


    }
}

