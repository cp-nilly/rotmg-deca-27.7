package robotlegs.bender.extensions.eventCommandMap.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
    import flash.events.IEventDispatcher;
    import org.swiftsuspenders.Injector;
    import flash.utils.describeType;
    import __AS3__.vec.*;

    public class EventCommandTrigger implements ICommandTrigger 
    {

        private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
        private const _mappingList:CommandMappingList = new CommandMappingList();

        private var _dispatcher:IEventDispatcher;
        private var _type:String;
        private var _executor:EventCommandExecutor;

        public function EventCommandTrigger(_arg1:Injector, _arg2:IEventDispatcher, _arg3:String, _arg4:Class=null)
        {
            this._dispatcher = _arg2;
            this._type = _arg3;
            this._executor = new EventCommandExecutor(this, this._mappingList, _arg1, _arg4);
        }

        public function addMapping(_arg1:ICommandMapping):void
        {
            this.verifyCommandClass(_arg1);
            if (this._mappingList.tail)
            {
                this._mappingList.tail.next = _arg1;
            }
            else
            {
                this._mappingList.head = _arg1;
                this.addListener();
            };
        }

        public function removeMapping(_arg1:ICommandMapping):void
        {
            this._mappingList.remove(_arg1);
            if (!this._mappingList.head)
            {
                this.removeListener();
            };
        }

        private function verifyCommandClass(mapping:ICommandMapping):void
        {
            if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
            {
                throw (new Error("Command Class must expose an execute method"));
            };
        }

        private function addListener():void
        {
            this._dispatcher.addEventListener(this._type, this._executor.execute);
        }

        private function removeListener():void
        {
            this._dispatcher.removeEventListener(this._type, this._executor.execute);
        }


    }
}

