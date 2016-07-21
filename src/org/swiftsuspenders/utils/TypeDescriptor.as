package org.swiftsuspenders.utils
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.reflection.Reflector;
    import org.swiftsuspenders.typedescriptions.TypeDescription;

    public class TypeDescriptor 
    {

        public var _descriptionsCache:Dictionary;
        private var _reflector:Reflector;

        public function TypeDescriptor(_arg1:Reflector, _arg2:Dictionary)
        {
            this._descriptionsCache = _arg2;
            this._reflector = _arg1;
        }

        public function getDescription(_arg1:Class):TypeDescription
        {
            return ((this._descriptionsCache[_arg1] = ((this._descriptionsCache[_arg1]) || (this._reflector.describeInjections(_arg1)))));
        }

        public function addDescription(_arg1:Class, _arg2:TypeDescription):void
        {
            this._descriptionsCache[_arg1] = _arg2;
        }


    }
}

