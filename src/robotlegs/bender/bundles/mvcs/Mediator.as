package robotlegs.bender.bundles.mvcs
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public class Mediator implements IMediator 
    {

        [Inject]
        public var eventMap:IEventMap;
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        private var _viewComponent:Object;


        public function set viewComponent(_arg1:Object):void
        {
            this._viewComponent = _arg1;
        }

        public function initialize():void
        {
        }

        public function destroy():void
        {
            this.eventMap.unmapListeners();
        }

        protected function addViewListener(_arg1:String, _arg2:Function, _arg3:Class=null):void
        {
            this.eventMap.mapListener(IEventDispatcher(this._viewComponent), _arg1, _arg2, _arg3);
        }

        protected function addContextListener(_arg1:String, _arg2:Function, _arg3:Class=null):void
        {
            this.eventMap.mapListener(this.eventDispatcher, _arg1, _arg2, _arg3);
        }

        protected function removeViewListener(_arg1:String, _arg2:Function, _arg3:Class=null):void
        {
            this.eventMap.unmapListener(IEventDispatcher(this._viewComponent), _arg1, _arg2, _arg3);
        }

        protected function removeContextListener(_arg1:String, _arg2:Function, _arg3:Class=null):void
        {
            this.eventMap.unmapListener(this.eventDispatcher, _arg1, _arg2, _arg3);
        }

        protected function dispatch(_arg1:Event):void
        {
            if (this.eventDispatcher.hasEventListener(_arg1.type))
            {
                this.eventDispatcher.dispatchEvent(_arg1);
            };
        }


    }
}

