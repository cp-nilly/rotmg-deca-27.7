package com.company.assembleegameclient.objects
{
    import kabam.rotmg.arena.view.ArenaQueryPanel;
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.ui.panels.Panel;

    public class ArenaGuard extends GameObject implements IInteractiveObject 
    {

        public function ArenaGuard(_arg1:XML)
        {
            super(_arg1);
            isInteractive_ = true;
        }

        public function getPanel(_arg1:GameSprite):Panel
        {
            return (new ArenaQueryPanel(_arg1, objectType_));
        }


    }
}

