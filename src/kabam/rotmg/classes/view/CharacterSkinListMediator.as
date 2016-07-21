﻿package kabam.rotmg.classes.view
{
    import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.classes.model.ClassesModel;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import kabam.rotmg.classes.model.CharacterClass;

    public class CharacterSkinListMediator extends Mediator 
    {

        [Inject]
        public var view:CharacterSkinListView;
        [Inject]
        public var model:ClassesModel;
        [Inject]
        public var factory:CharacterSkinListItemFactory;


        override public function initialize():void
        {
            this.model.selected.add(this.setSkins);
            this.setSkins(this.model.getSelected());
        }

        override public function destroy():void
        {
            this.model.selected.remove(this.setSkins);
        }

        private function setSkins(_arg1:CharacterClass):void
        {
            var _local2:Vector.<DisplayObject> = this.factory.make(_arg1.skins);
            this.view.setItems(_local2);
        }


    }
}

