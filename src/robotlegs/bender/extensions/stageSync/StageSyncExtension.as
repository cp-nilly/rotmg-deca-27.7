package robotlegs.bender.extensions.stageSync
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.IContext;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.framework.api.ILogger;
    import org.hamcrest.object.instanceOf;
    import flash.events.Event;

    public class StageSyncExtension implements IExtension 
    {

        private const _uid:String = UID.create(StageSyncExtension);

        private var _context:IContext;
        private var _contextView:DisplayObjectContainer;
        private var _logger:ILogger;


        public function extend(_arg1:IContext):void
        {
            this._context = _arg1;
            this._logger = _arg1.getLogger(this);
            this._context.addConfigHandler(instanceOf(DisplayObjectContainer), this.handleContextView);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function handleContextView(_arg1:DisplayObjectContainer):void
        {
            if (this._contextView)
            {
                this._logger.warn("A contextView has already been set, ignoring {0}", [_arg1]);
                return;
            };
            this._contextView = _arg1;
            if (this._contextView.stage)
            {
                this.initializeContext();
            }
            else
            {
                this._logger.debug("Context view is not yet on stage. Waiting...");
                this._contextView.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            };
        }

        private function onAddedToStage(_arg1:Event):void
        {
            this._contextView.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.initializeContext();
        }

        private function initializeContext():void
        {
            this._logger.debug("Context view is now on stage. Initializing context...");
            this._context.lifecycle.initialize();
            this._contextView.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        private function onRemovedFromStage(_arg1:Event):void
        {
            this._logger.debug("Context view has left the stage. Destroying context...");
            this._contextView.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            this._context.lifecycle.destroy();
        }


    }
}

