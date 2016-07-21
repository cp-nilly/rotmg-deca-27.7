package kabam.rotmg.friends
{
    import robotlegs.bender.framework.api.IConfig;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import kabam.rotmg.friends.service.FriendDataRequestTask;
    import kabam.rotmg.friends.model.FriendModel;
    import kabam.rotmg.friends.view.FriendListView;
    import kabam.rotmg.friends.view.FriendListMediator;
    import kabam.rotmg.friends.controller.FriendActionSignal;
    import kabam.rotmg.friends.controller.FriendActionCommand;

    public class FriendConfig implements IConfig 
    {

        [Inject]
        public var injector:Injector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var commandMap:ISignalCommandMap;


        public function configure():void
        {
            this.injector.map(FriendDataRequestTask).asSingleton();
            this.injector.map(FriendModel).asSingleton();
            this.mediatorMap.map(FriendListView).toMediator(FriendListMediator);
            this.commandMap.map(FriendActionSignal).toCommand(FriendActionCommand);
        }


    }
}

