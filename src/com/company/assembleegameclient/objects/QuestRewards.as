package com.company.assembleegameclient.objects
{
    import kabam.rotmg.questrewards.view.QuestRewardsPanel;
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.ui.panels.Panel;

    public class QuestRewards extends GameObject implements IInteractiveObject 
    {

        public function QuestRewards(_arg1:XML)
        {
            super(_arg1);
            isInteractive_ = true;
        }

        public function getPanel(_arg1:GameSprite):Panel
        {
            return (new QuestRewardsPanel(_arg1));
        }


    }
}

