package avmplus
{
    public class DescribeTypeJSON 
    {

        public static const INSTANCE_FLAGS:uint = (((((((((INCLUDE_BASES | INCLUDE_INTERFACES) | INCLUDE_VARIABLES) | INCLUDE_ACCESSORS) | INCLUDE_METHODS) | INCLUDE_METADATA) | INCLUDE_CONSTRUCTOR) | INCLUDE_TRAITS) | USE_ITRAITS) | HIDE_OBJECT);
        public static const CLASS_FLAGS:uint = ((((((INCLUDE_INTERFACES | INCLUDE_VARIABLES) | INCLUDE_ACCESSORS) | INCLUDE_METHODS) | INCLUDE_METADATA) | INCLUDE_TRAITS) | HIDE_OBJECT);

        public static var available:Boolean = !((describeTypeJSON == null));


        public function describeType(_arg1:Object, _arg2:uint):Object
        {
            return (describeTypeJSON(_arg1, _arg2));
        }

        public function getInstanceDescription(_arg1:Class):Object
        {
            return (describeTypeJSON(_arg1, INSTANCE_FLAGS));
        }

        public function getClassDescription(_arg1:Class):Object
        {
            return (describeTypeJSON(_arg1, CLASS_FLAGS));
        }


    }
}

