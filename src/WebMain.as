package 
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import robotlegs.bender.framework.api.IContext;
    import flash.events.Event;
    import com.company.assembleegameclient.util.AssetLoader;
    import flash.display.StageScaleMode;
    import kabam.rotmg.startup.control.StartupSignal;
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.core.StaticInjectorContext;
    import flash.display.LoaderInfo;
    import com.company.assembleegameclient.util.StageProxy;
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
    import kabam.rotmg.build.BuildConfig;
    import kabam.rotmg.startup.StartupConfig;
    import kabam.lib.net.NetConfig;
    import kabam.rotmg.assets.AssetsConfig;
    import kabam.rotmg.dialogs.DialogsConfig;
    import kabam.rotmg.application.EnvironmentConfig;
    import kabam.rotmg.application.ApplicationConfig;
    import kabam.rotmg.language.LanguageConfig;
    import kabam.rotmg.text.TextConfig;
    import kabam.rotmg.appengine.AppEngineConfig;
    import kabam.rotmg.account.AccountConfig;
    import kabam.rotmg.errors.ErrorConfig;
    import kabam.rotmg.core.CoreConfig;
    import kabam.rotmg.application.ApplicationSpecificConfig;
    import kabam.rotmg.death.DeathConfig;
    import kabam.rotmg.characters.CharactersConfig;
    import kabam.rotmg.servers.ServersConfig;
    import kabam.rotmg.game.GameConfig;
    import kabam.rotmg.ui.UIConfig;
    import kabam.rotmg.minimap.MiniMapConfig;
    import kabam.rotmg.legends.LegendsConfig;
    import kabam.rotmg.news.NewsConfig;
    import kabam.rotmg.fame.FameConfig;
    import kabam.rotmg.tooltips.TooltipsConfig;
    import kabam.rotmg.promotions.PromotionsConfig;
    import kabam.rotmg.protip.ProTipConfig;
    import kabam.rotmg.maploading.MapLoadingConfig;
    import kabam.rotmg.classes.ClassesConfig;
    import kabam.rotmg.packages.PackageConfig;
    import kabam.rotmg.pets.PetsConfig;
    import kabam.rotmg.questrewards.QuestRewardsConfig;
    import kabam.rotmg.stage3D.Stage3DConfig;
    import kabam.rotmg.arena.ArenaConfig;
    import kabam.rotmg.external.ExternalConfig;
    import kabam.rotmg.mysterybox.MysteryBoxConfig;
    import kabam.rotmg.fortune.FortuneConfig;
    import kabam.rotmg.friends.FriendConfig;
    import robotlegs.bender.framework.api.LogLevel;
    import flash.system.Capabilities;

    public class WebMain extends Sprite 
    {

        public static var STAGE:Stage;

        protected var context:IContext;

        public function WebMain()
        {
            if (stage)
            {
                this.setup();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            };
        }

        private function onAddedToStage(_arg1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.setup();
        }

        private function setup():void
        {
            this.hackParameters();
            this.createContext();
            new AssetLoader().load();
            stage.scaleMode = StageScaleMode.EXACT_FIT;
            this.context.injector.getInstance(StartupSignal).dispatch();
            this.configureForAirIfDesktopPlayer();
            STAGE = stage;
        }

        private function hackParameters():void
        {
            Parameters.root = stage.root;
        }

        private function createContext():void
        {
            this.context = new StaticInjectorContext();
            this.context.injector.map(LoaderInfo).toValue(root.stage.root.loaderInfo);
            var _local1:StageProxy = new StageProxy(this);
            this.context.injector.map(StageProxy).toValue(_local1);
            this.context.extend(MVCSBundle).extend(SignalCommandMapExtension).configure(BuildConfig).configure(StartupConfig).configure(NetConfig).configure(AssetsConfig).configure(DialogsConfig).configure(EnvironmentConfig).configure(ApplicationConfig).configure(LanguageConfig).configure(TextConfig).configure(AppEngineConfig).configure(AccountConfig).configure(ErrorConfig).configure(CoreConfig).configure(ApplicationSpecificConfig).configure(DeathConfig).configure(CharactersConfig).configure(ServersConfig).configure(GameConfig).configure(UIConfig).configure(MiniMapConfig).configure(LegendsConfig).configure(NewsConfig).configure(FameConfig).configure(TooltipsConfig).configure(PromotionsConfig).configure(ProTipConfig).configure(MapLoadingConfig).configure(ClassesConfig).configure(PackageConfig).configure(PetsConfig).configure(QuestRewardsConfig).configure(Stage3DConfig).configure(ArenaConfig).configure(ExternalConfig).configure(MysteryBoxConfig).configure(FortuneConfig).configure(FriendConfig).configure(this);
            this.context.logLevel = LogLevel.DEBUG;
        }

        private function configureForAirIfDesktopPlayer():void
        {
            if (Capabilities.playerType == "Desktop")
            {
                Parameters.data_.fullscreenMode = false;
                Parameters.save();
            };
        }


    }
} 

