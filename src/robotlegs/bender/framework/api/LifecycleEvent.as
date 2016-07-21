package robotlegs.bender.framework.api
{
    import flash.events.Event;

    public class LifecycleEvent extends Event 
    {

        public static const ERROR:String = "error";
        public static const PRE_INITIALIZE:String = "preInitialize";
        public static const INITIALIZE:String = "initialize";
        public static const POST_INITIALIZE:String = "postInitialize";
        public static const PRE_SUSPEND:String = "preSuspend";
        public static const SUSPEND:String = "suspend";
        public static const POST_SUSPEND:String = "postSuspend";
        public static const PRE_RESUME:String = "preResume";
        public static const RESUME:String = "resume";
        public static const POST_RESUME:String = "postResume";
        public static const PRE_DESTROY:String = "preDestroy";
        public static const DESTROY:String = "destroy";
        public static const POST_DESTROY:String = "postDestroy";

        public var error:Error;

        public function LifecycleEvent(_arg1:String)
        {
            super(_arg1);
        }

        override public function clone():Event
        {
            var _local1:LifecycleEvent = new LifecycleEvent(type);
            _local1.error = this.error;
            return (_local1);
        }


    }
}

