package robotlegs.bender.framework.impl
{
    import flash.utils.Dictionary;

    public class Pin 
    {

        private const _instances:Dictionary = new Dictionary(false);


        public function detain(_arg1:Object):void
        {
            this._instances[_arg1] = true;
        }

        public function release(_arg1:Object):void
        {
            delete this._instances[_arg1];
        }

        public function flush():void
        {
            var _local1:Object;
            for (_local1 in this._instances)
            {
                delete this._instances[_local1];
            };
        }


    }
}

