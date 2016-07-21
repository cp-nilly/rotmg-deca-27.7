package kabam.rotmg.ui.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import com.company.assembleegameclient.mapeditor.MapEditor;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.servers.api.ServerModel;

    public class MapEditorMediator extends Mediator 
    {

        [Inject]
        public var view:MapEditor;
        [Inject]
        public var model:PlayerModel;
        [Inject]
        public var servers:ServerModel;


        override public function initialize():void
        {
            this.view.initialize(this.model, this.servers.getServer());
        }


    }
}

