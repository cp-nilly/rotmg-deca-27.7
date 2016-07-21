package org.swiftsuspenders.mapping
{
    import flash.events.Event;

    public class MappingEvent extends Event 
    {

        public static const PRE_MAPPING_CREATE:String = "preMappingCreate";
        public static const POST_MAPPING_CREATE:String = "postMappingCreate";
        public static const PRE_MAPPING_CHANGE:String = "preMappingChange";
        public static const POST_MAPPING_CHANGE:String = "postMappingChange";
        public static const POST_MAPPING_REMOVE:String = "postMappingRemove";
        public static const MAPPING_OVERRIDE:String = "mappingOverride";

        public var mappedType:Class;
        public var mappedName:String;
        public var mapping:InjectionMapping;

        public function MappingEvent(_arg1:String, _arg2:Class, _arg3:String, _arg4:InjectionMapping)
        {
            super(_arg1);
            this.mappedType = _arg2;
            this.mappedName = _arg3;
            this.mapping = _arg4;
        }

        override public function clone():Event
        {
            return (new MappingEvent(type, this.mappedType, this.mappedName, this.mapping));
        }


    }
}

