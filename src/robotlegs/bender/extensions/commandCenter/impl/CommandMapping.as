package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
    import robotlegs.bender.framework.impl.MappingConfigValidator;
    import robotlegs.bender.extensions.commandCenter.api.CommandMappingError;

    public class CommandMapping implements ICommandMapping, ICommandMappingConfig 
    {

        private var _commandClass:Class;
        private var _guards:Array;
        private var _hooks:Array;
        private var _once:Boolean;
        private var _next:ICommandMapping;
        private var _validator:MappingConfigValidator;

        public function CommandMapping(_arg1:Class)
        {
            this._guards = [];
            this._hooks = [];
            super();
            this._commandClass = _arg1;
        }

        public function get commandClass():Class
        {
            return (this._commandClass);
        }

        public function get guards():Array
        {
            return (this._guards);
        }

        public function get hooks():Array
        {
            return (this._hooks);
        }

        public function withGuards(... _args):ICommandMappingConfig
        {
            ((this._validator) && (this._validator.checkGuards(_args)));
            this._guards = this._guards.concat.apply(null, _args);
            return (this);
        }

        public function withHooks(... _args):ICommandMappingConfig
        {
            ((this._validator) && (this._validator.checkHooks(_args)));
            this._hooks = this._hooks.concat.apply(null, _args);
            return (this);
        }

        public function get fireOnce():Boolean
        {
            return (this._once);
        }

        public function once(_arg1:Boolean=true):ICommandMappingConfig
        {
            ((((this._validator) && (!(this._once)))) && (this.throwMappingError((("You attempted to change an existing mapping for " + this._commandClass) + " by setting once(). Please unmap first."))));
            this._once = _arg1;
            return (this);
        }

        public function get next():ICommandMapping
        {
            return (this._next);
        }

        public function set next(_arg1:ICommandMapping):void
        {
            this._next = _arg1;
        }

        private function throwMappingError(_arg1:String):void
        {
            throw (new CommandMappingError(_arg1));
        }

        function invalidate():void
        {
            if (this._validator)
            {
                this._validator.invalidate();
            }
            else
            {
                this.createValidator();
            };
            this._guards = [];
            this._hooks = [];
        }

        public function validate():void
        {
            if (!this._validator)
            {
                this.createValidator();
            }
            else
            {
                if (!this._validator.valid)
                {
                    this._validator.validate(this._guards, this._hooks);
                };
            };
        }

        private function createValidator():void
        {
            this._validator = new MappingConfigValidator(this._guards.slice(), this._hooks.slice(), null, this._commandClass);
        }


    }
}

