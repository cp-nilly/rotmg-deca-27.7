package com.junkbyte.console.core
{
    import com.junkbyte.console.Console;
    import com.junkbyte.console.KeyBind;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;

    public class KeyBinder extends ConsoleCore 
    {

        private var _passInd:int;
        private var _binds:Object;
        private var _warns:uint;

        public function KeyBinder(_arg1:Console)
        {
            this._binds = {};
            super(_arg1);
            _arg1.cl.addCLCmd("keybinds", this.printBinds, "List all keybinds used");
        }

        public function bindKey(_arg1:KeyBind, _arg2:Function, _arg3:Array=null):void
        {
            if (((config.keystrokePassword) && (((!(_arg1.useKeyCode)) && ((_arg1.key.charAt(0) == config.keystrokePassword.charAt(0)))))))
            {
                report((("Error: KeyBind [" + _arg1.key) + "] is conflicting with Console password."), 9);
                return;
            };
            if (_arg2 == null)
            {
                delete this._binds[_arg1.key];
            }
            else
            {
                this._binds[_arg1.key] = [_arg2, _arg3];
            };
        }

        public function keyDownHandler(_arg1:KeyboardEvent):void
        {
            this.handleKeyEvent(_arg1, false);
        }

        public function keyUpHandler(_arg1:KeyboardEvent):void
        {
            this.handleKeyEvent(_arg1, true);
        }

        private function handleKeyEvent(_arg1:KeyboardEvent, _arg2:Boolean):void
        {
            var _local4:KeyBind;
            var _local3:String = String.fromCharCode(_arg1.charCode);
            if (((((((_arg2) && (!((config.keystrokePassword == null))))) && (_local3))) && ((_local3 == config.keystrokePassword.substring(this._passInd, (this._passInd + 1))))))
            {
                this._passInd++;
                if (this._passInd >= config.keystrokePassword.length)
                {
                    this._passInd = 0;
                    if (this.canTrigger())
                    {
                        if (((console.visible) && (!(console.panels.mainPanel.visible))))
                        {
                            console.panels.mainPanel.visible = true;
                        }
                        else
                        {
                            console.visible = !(console.visible);
                        };
                        if (((console.visible) && (console.panels.mainPanel.visible)))
                        {
                            console.panels.mainPanel.visible = true;
                            console.panels.mainPanel.moveBackSafePosition();
                        };
                    }
                    else
                    {
                        if (this._warns < 3)
                        {
                            this._warns++;
                            report("Password did not trigger because you have focus on an input TextField.", 8);
                        };
                    };
                };
            }
            else
            {
                if (_arg2)
                {
                    this._passInd = 0;
                };
                _local4 = new KeyBind(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey, _arg1.altKey, _arg2);
                this.tryRunKey(_local4.key);
                if (_local3)
                {
                    _local4 = new KeyBind(_local3, _arg1.shiftKey, _arg1.ctrlKey, _arg1.altKey, _arg2);
                    this.tryRunKey(_local4.key);
                };
            };
        }

        private function printBinds(... _args):void
        {
            var _local3:String;
            report("Key binds:", -2);
            var _local2:uint;
            for (_local3 in this._binds)
            {
                _local2++;
                report(_local3, -2);
            };
            report(("--- Found " + _local2), -2);
        }

        private function tryRunKey(_arg1:String):void
        {
            var _local2:Array = this._binds[_arg1];
            if (((config.keyBindsEnabled) && (_local2)))
            {
                if (this.canTrigger())
                {
                    (_local2[0] as Function).apply(null, _local2[1]);
                }
                else
                {
                    if (this._warns < 3)
                    {
                        this._warns++;
                        report((("Key bind [" + _arg1) + "] did not trigger because you have focus on an input TextField."), 8);
                    };
                };
            };
        }

        private function canTrigger():Boolean
        {
            var _local1:TextField;
            try
            {
                if (((console.stage) && ((console.stage.focus is TextField))))
                {
                    _local1 = (console.stage.focus as TextField);
                    if (_local1.type == TextFieldType.INPUT)
                    {
                        return (false);
                    };
                };
            }
            catch(err:Error)
            {
            };
            return (true);
        }


    }
}

