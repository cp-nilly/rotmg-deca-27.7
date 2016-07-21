package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import flash.display.DisplayObject;

    public class MediatorViewHandler implements IMediatorViewHandler 
    {

        private const _mappings:Array = [];

        private var _knownMappings:Dictionary;
        private var _factory:IMediatorFactory;

        public function MediatorViewHandler(_arg1:IMediatorFactory):void
        {
            this._knownMappings = new Dictionary(true);
            super();
            this._factory = _arg1;
        }

        public function addMapping(_arg1:IMediatorMapping):void
        {
            var _local2:int = this._mappings.indexOf(_arg1);
            if (_local2 > -1)
            {
                return;
            };
            this._mappings.push(_arg1);
            this.flushCache();
        }

        public function removeMapping(_arg1:IMediatorMapping):void
        {
            var _local2:int = this._mappings.indexOf(_arg1);
            if (_local2 == -1)
            {
                return;
            };
            this._mappings.splice(_local2, 1);
            this.flushCache();
        }

        public function handleView(_arg1:DisplayObject, _arg2:Class):void
        {
            var _local3:Array = this.getInterestedMappingsFor(_arg1, _arg2);
            if (_local3)
            {
                this._factory.createMediators(_arg1, _arg2, _local3);
            };
        }

        public function handleItem(_arg1:Object, _arg2:Class):void
        {
            var _local3:Array = this.getInterestedMappingsFor(_arg1, _arg2);
            if (_local3)
            {
                this._factory.createMediators(_arg1, _arg2, _local3);
            };
        }

        private function flushCache():void
        {
            this._knownMappings = new Dictionary(true);
        }

        private function getInterestedMappingsFor(_arg1:Object, _arg2:Class):Array
        {
            var _local3:IMediatorMapping;
            if (this._knownMappings[_arg2] === false)
            {
                return (null);
            };
            if (this._knownMappings[_arg2] == undefined)
            {
                this._knownMappings[_arg2] = false;
                for each (_local3 in this._mappings)
                {
                    _local3.validate();
                    if (_local3.matcher.matches(_arg1))
                    {
                        this._knownMappings[_arg2] = ((this._knownMappings[_arg2]) || ([]));
                        this._knownMappings[_arg2].push(_local3);
                    };
                };
                if (this._knownMappings[_arg2] === false)
                {
                    return (null);
                };
            };
            return ((this._knownMappings[_arg2] as Array));
        }


    }
}

