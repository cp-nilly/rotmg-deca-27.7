package com.company.assembleegameclient.ui.dialogs
{
    import kabam.rotmg.text.model.TextKey;
    import flash.events.Event;

    public class NotEnoughFameDialog extends Dialog 
    {

        public function NotEnoughFameDialog()
        {
            super(TextKey.NOT_ENOUGH_FAME_DIALOG_TITLE, TextKey.NOT_ENOUGH_FAME_DIALOG_TEXT, TextKey.NOT_ENOUGH_FAME_DIALOG_LEFTBUTTON, null, "/notEnoughFame");
            addEventListener(LEFT_BUTTON, this.onOk);
        }

        public function onOk(_arg1:Event):void
        {
            parent.removeChild(this);
        }


    }
}

