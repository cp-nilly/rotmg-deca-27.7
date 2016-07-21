﻿package robotlegs.bender.bundles.mvcs
{
    import robotlegs.bender.framework.api.IBundle;
    import robotlegs.bender.extensions.logging.LoggingExtension;
    import robotlegs.bender.extensions.logging.TraceLoggingExtension;
    import robotlegs.bender.extensions.contextView.ContextViewExtension;
    import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
    import robotlegs.bender.extensions.modularity.ModularityExtension;
    import robotlegs.bender.extensions.commandCenter.CommandCenterExtension;
    import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
    import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
    import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
    import robotlegs.bender.extensions.viewManager.StageObserverExtension;
    import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
    import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
    import robotlegs.bender.extensions.stageSync.StageSyncExtension;
    import robotlegs.bender.bundles.shared.configs.ContextViewListenerConfig;
    import robotlegs.bender.framework.api.IContext;

    public class MVCSBundle implements IBundle 
    {


        public function extend(_arg1:IContext):void
        {
            _arg1.extend(LoggingExtension, TraceLoggingExtension, ContextViewExtension, EventDispatcherExtension, ModularityExtension, CommandCenterExtension, EventCommandMapExtension, LocalEventMapExtension, ViewManagerExtension, StageObserverExtension, ManualStageObserverExtension, MediatorMapExtension, StageSyncExtension);
            _arg1.configure(ContextViewListenerConfig);
        }


    }
}

