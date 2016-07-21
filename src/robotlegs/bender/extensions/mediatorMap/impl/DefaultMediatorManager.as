package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
    import flash.utils.getDefinitionByName;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class DefaultMediatorManager 
    {

        private static const flexAvailable:Boolean = checkFlex();

        private static var UIComponentClass:Class;

        private var _factory:IMediatorFactory;

        public function DefaultMediatorManager(_arg1:IMediatorFactory)
        {
            this._factory = _arg1;
            this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, this.onMediatorCreate);
            this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, this.onMediatorRemove);
        }

        private static function checkFlex():Boolean
        {
            try
            {
                UIComponentClass = (getDefinitionByName("mx.core::UIComponent") as Class);
            }
            catch(error:Error)
            {
            };
            return (!((UIComponentClass == null)));
        }


        private function onMediatorCreate(event:MediatorFactoryEvent):void
        {
            var mediator:Object;
            var displayObject:DisplayObject;
            mediator = event.mediator;
            displayObject = (event.view as DisplayObject);
            if (!displayObject)
            {
                this.initializeMediator(event.view, mediator);
                return;
            };
            displayObject.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            if (((((flexAvailable) && ((displayObject is UIComponentClass)))) && (!(displayObject["initialized"]))))
            {
                displayObject.addEventListener("creationComplete", function (_arg1:Event):void
                {
                    displayObject.removeEventListener("creationComplete", arguments.callee);
                    if (_factory.getMediator(displayObject, event.mapping))
                    {
                        initializeMediator(displayObject, mediator);
                    };
                });
            }
            else
            {
                this.initializeMediator(displayObject, mediator);
            };
        }

        private function onMediatorRemove(_arg1:MediatorFactoryEvent):void
        {
            var _local2:DisplayObject = (_arg1.view as DisplayObject);
            if (_local2)
            {
                _local2.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            };
            if (_arg1.mediator)
            {
                this.destroyMediator(_arg1.mediator);
            };
        }

        private function onRemovedFromStage(_arg1:Event):void
        {
            this._factory.removeMediators(_arg1.target);
        }

        private function initializeMediator(_arg1:Object, _arg2:Object):void
        {
            if (_arg2.hasOwnProperty("viewComponent"))
            {
                _arg2.viewComponent = _arg1;
            };
            if (_arg2.hasOwnProperty("initialize"))
            {
                _arg2.initialize();
            };
        }

        private function destroyMediator(_arg1:Object):void
        {
            if (_arg1.hasOwnProperty("destroy"))
            {
                _arg1.destroy();
            };
        }


    }
}

