package org.swiftsuspenders
{
    import flash.events.Event;

    public class InjectionEvent extends Event 
    {

        public static const POST_INSTANTIATE:String = "postInstantiate";
        public static const PRE_CONSTRUCT:String = "preConstruct";
        public static const POST_CONSTRUCT:String = "postConstruct";

        public var instance;
        public var instanceType:Class;

        public function InjectionEvent(_arg1:String, _arg2:Object, _arg3:Class)
        {
            super(_arg1);
            this.instance = _arg2;
            this.instanceType = _arg3;
        }

        override public function clone():Event
        {
            return (new InjectionEvent(type, this.instance, this.instanceType));
        }


    }
}

