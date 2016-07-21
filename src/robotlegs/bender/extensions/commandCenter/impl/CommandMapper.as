package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class CommandMapper implements ICommandMapper, ICommandUnmapper 
    {

        private const _mappings:Dictionary = new Dictionary();

        private var _trigger:ICommandTrigger;

        public function CommandMapper(_arg1:ICommandTrigger)
        {
            this._trigger = _arg1;
        }

        public function toCommand(_arg1:Class):ICommandMappingConfig
        {
            return (((this.locked(this._mappings[_arg1])) || (this.createMapping(_arg1))));
        }

        public function fromCommand(_arg1:Class):void
        {
            var _local2:ICommandMapping = this._mappings[_arg1];
            ((_local2) && (this._trigger.removeMapping(_local2)));
            delete this._mappings[_arg1];
        }

        public function fromAll():void
        {
            var _local1:ICommandMapping;
            for each (_local1 in this._mappings)
            {
                this._trigger.removeMapping(_local1);
                delete this._mappings[_local1.commandClass];
            };
        }

        private function createMapping(_arg1:Class):CommandMapping
        {
            var _local2:CommandMapping = new CommandMapping(_arg1);
            this._trigger.addMapping(_local2);
            this._mappings[_arg1] = _local2;
            return (_local2);
        }

        private function locked(_arg1:CommandMapping):CommandMapping
        {
            if (!_arg1)
            {
                return (null);
            };
            _arg1.invalidate();
            return (_arg1);
        }


    }
}

