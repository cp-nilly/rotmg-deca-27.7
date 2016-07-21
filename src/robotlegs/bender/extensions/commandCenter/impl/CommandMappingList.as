package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class CommandMappingList 
    {

        protected var _head:ICommandMapping;


        public function get head():ICommandMapping
        {
            return (this._head);
        }

        public function set head(_arg1:ICommandMapping):void
        {
            if (_arg1 !== this._head)
            {
                this._head = _arg1;
            };
        }

        public function get tail():ICommandMapping
        {
            if (!this._head)
            {
                return (null);
            };
            var _local1:ICommandMapping = this._head;
            while (_local1.next)
            {
                _local1 = _local1.next;
            };
            return (_local1);
        }

        public function remove(_arg1:ICommandMapping):void
        {
            var _local2:ICommandMapping = this._head;
            if (_local2 == _arg1)
            {
                this._head = _arg1.next;
            };
            while (_local2)
            {
                if (_local2.next == _arg1)
                {
                    _local2.next = _arg1.next;
                };
                _local2 = _local2.next;
            };
        }


    }
}

