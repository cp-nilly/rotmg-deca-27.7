package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.WeakObject;
    import com.junkbyte.console.vos.WeakRef;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import com.junkbyte.console.Console;
    import flash.utils.getQualifiedClassName;
    import flash.display.DisplayObjectContainer;

    public class CommandLine extends ConsoleCore 
    {

        private static const DISABLED:String = "<b>Advanced CommandLine is disabled.</b>\nEnable by setting `Cc.config.commandLineAllowed = true;´\nType <b>/commands</b> for permitted commands.";
        private static const RESERVED:Array = [Executer.RETURNED, "base", "C"];

        private var _saved:WeakObject;
        private var _scope;
        private var _prevScope:WeakRef;
        private var _scopeStr:String = "";
        private var _slashCmds:Object;
        public var localCommands:Array;

        public function CommandLine(m:Console)
        {
            this.localCommands = new Array("filter", "filterexp");
            super(m);
            this._saved = new WeakObject();
            this._scope = m;
            this._slashCmds = new Object();
            this._prevScope = new WeakRef(m);
            this._saved.set("C", m);
            remoter.registerCallback("cmd", function (_arg1:ByteArray):void
            {
                run(_arg1.readUTF());
            });
            remoter.registerCallback("scope", function (_arg1:ByteArray):void
            {
                handleScopeEvent(_arg1.readUnsignedInt());
            });
            remoter.registerCallback("cls", this.handleScopeString);
            remoter.addEventListener(Event.CONNECT, this.sendCmdScope2Remote);
            this.addCLCmd("help", this.printHelp, "How to use command line");
            this.addCLCmd("save|store", this.saveCmd, "Save current scope as weak reference. (same as Cc.store(...))");
            this.addCLCmd("savestrong|storestrong", this.saveStrongCmd, "Save current scope as strong reference");
            this.addCLCmd("saved|stored", this.savedCmd, "Show a list of all saved references");
            this.addCLCmd("string", this.stringCmd, "Create String, useful to paste complex strings without worrying about \" or '", false, null);
            this.addCLCmd("commands", this.cmdsCmd, "Show a list of all slash commands", true);
            this.addCLCmd("inspect", this.inspectCmd, "Inspect current scope");
            this.addCLCmd("explode", this.explodeCmd, "Explode current scope to its properties and values (similar to JSON)");
            this.addCLCmd("map", this.mapCmd, "Get display list map starting from current scope");
            this.addCLCmd("function", this.funCmd, "Create function. param is the commandline string to create as function. (experimental)");
            this.addCLCmd("autoscope", this.autoscopeCmd, "Toggle autoscoping.");
            this.addCLCmd("base", this.baseCmd, "Return to base scope");
            this.addCLCmd("/", this.prevCmd, "Return to previous scope");
        }

        public function set base(_arg1:Object):void
        {
            if (this.base)
            {
                report(((("Set new commandLine base from " + this.base) + " to ") + _arg1), 10);
            }
            else
            {
                this._prevScope.reference = this._scope;
                this._scope = _arg1;
                this._scopeStr = LogReferences.ShortClassName(_arg1, false);
            };
            this._saved.set("base", _arg1);
        }

        public function get base():Object
        {
            return (this._saved.get("base"));
        }

        public function handleScopeString(_arg1:ByteArray):void
        {
            this._scopeStr = _arg1.readUTF();
        }

        public function handleScopeEvent(_arg1:uint):void
        {
            var _local2:ByteArray;
            var _local3:*;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local2 = new ByteArray();
                _local2.writeUnsignedInt(_arg1);
                remoter.send("scope", _local2);
            }
            else
            {
                _local3 = console.refs.getRefById(_arg1);
                if (_local3)
                {
                    console.cl.setReturned(_local3, true, false);
                }
                else
                {
                    console.report("Reference no longer exist.", -2);
                };
            };
        }

        public function store(_arg1:String, _arg2:Object, _arg3:Boolean=false):void
        {
            if (!_arg1)
            {
                report("ERROR: Give a name to save.", 10);
                return;
            };
            if ((_arg2 is Function))
            {
                _arg3 = true;
            };
            _arg1 = _arg1.replace(/[^\w]*/g, "");
            if (RESERVED.indexOf(_arg1) >= 0)
            {
                report((("ERROR: The name [" + _arg1) + "] is reserved"), 10);
                return;
            };
            this._saved.set(_arg1, _arg2, _arg3);
        }

        public function getHintsFor(str:String, max:uint):Array
        {
            var X:String;
            var canadate:Array;
            var cmd:Object;
            var Y:String;
            var all:Array = new Array();
            for (X in this._slashCmds)
            {
                cmd = this._slashCmds[X];
                if (((config.commandLineAllowed) || (cmd.allow)))
                {
                    all.push([(("/" + X) + " "), ((cmd.d) ? cmd.d : null)]);
                };
            };
            if (config.commandLineAllowed)
            {
                for (Y in this._saved)
                {
                    all.push([("$" + Y), LogReferences.ShortClassName(this._saved.get(Y))]);
                };
                if (this._scope)
                {
                    all.push(["this", LogReferences.ShortClassName(this._scope)]);
                    all = all.concat(console.refs.getPossibleCalls(this._scope));
                };
            };
            str = str.toLowerCase();
            var hints:Array = new Array();
            for each (canadate in all)
            {
                if (canadate[0].toLowerCase().indexOf(str) == 0)
                {
                    hints.push(canadate);
                };
            };
            hints = hints.sort(function (_arg1:Array, _arg2:Array):int
            {
                if (_arg1[0].length < _arg2[0].length)
                {
                    return (-1);
                };
                if (_arg1[0].length > _arg2[0].length)
                {
                    return (1);
                };
                return (0);
            });
            if ((((max > 0)) && ((hints.length > max))))
            {
                hints.splice(max);
                hints.push(["..."]);
            };
            return (hints);
        }

        public function get scopeString():String
        {
            return (((config.commandLineAllowed) ? this._scopeStr : ""));
        }

        public function addCLCmd(_arg1:String, _arg2:Function, _arg3:String, _arg4:Boolean=false, _arg5:String=";"):void
        {
            var _local6:Array = _arg1.split("|");
            var _local7:int;
            while (_local7 < _local6.length)
            {
                _arg1 = _local6[_local7];
                this._slashCmds[_arg1] = new SlashCommand(_arg1, _arg2, _arg3, false, _arg4, _arg5);
                if (_local7 > 0)
                {
                    this._slashCmds.setPropertyIsEnumerable(_arg1, false);
                };
                _local7++;
            };
        }

        public function addSlashCommand(_arg1:String, _arg2:Function, _arg3:String="", _arg4:Boolean=true, _arg5:String=";"):void
        {
            var _local6:SlashCommand;
            _arg1 = _arg1.replace(/[^\w]*/g, "");
            if (this._slashCmds[_arg1] != null)
            {
                _local6 = this._slashCmds[_arg1];
                if (!_local6.user)
                {
                    throw (new Error((("Can not alter build-in slash command [" + _arg1) + "]")));
                };
            };
            if (_arg2 == null)
            {
                delete this._slashCmds[_arg1];
            }
            else
            {
                this._slashCmds[_arg1] = new SlashCommand(_arg1, _arg2, LogReferences.EscHTML(_arg3), true, _arg4, _arg5);
            };
        }

        public function run(str:String, saves:Object=null)
        {
            var bytes:ByteArray;
            var exe:Executer;
            var X:String;
            if (!str)
            {
                return;
            };
            str = str.replace(/\s*/, "");
            if (remoter.remoting == Remoting.RECIEVER)
            {
                if (str.charAt(0) == "~")
                {
                    str = str.substring(1);
                }
                else
                {
                    if (str.search(new RegExp(("/" + this.localCommands.join("|/")))) != 0)
                    {
                        report(("Run command at remote: " + str), -2);
                        bytes = new ByteArray();
                        bytes.writeUTF(str);
                        if (!console.remoter.send("cmd", bytes))
                        {
                            report("Command could not be sent to client.", 10);
                        };
                        return (null);
                    };
                };
            };
            report(("&gt; " + str), 4, false);
            var v:* = null;
            try
            {
                if (str.charAt(0) == "/")
                {
                    this.execCommand(str.substring(1));
                }
                else
                {
                    if (!config.commandLineAllowed)
                    {
                        report(DISABLED, 9);
                        return (null);
                    };
                    exe = new Executer();
                    exe.addEventListener(Event.COMPLETE, this.onExecLineComplete, false, 0, true);
                    if (saves)
                    {
                        for (X in this._saved)
                        {
                            if (!saves[X])
                            {
                                saves[X] = this._saved[X];
                            };
                        };
                    }
                    else
                    {
                        saves = this._saved;
                    };
                    exe.setStored(saves);
                    exe.setReserved(RESERVED);
                    exe.autoScope = config.commandLineAutoScope;
                    v = exe.exec(this._scope, str);
                };
            }
            catch(e:Error)
            {
                reportError(e);
            };
            return (v);
        }

        private function onExecLineComplete(_arg1:Event):void
        {
            var _local2:Executer = (_arg1.currentTarget as Executer);
            if (this._scope == _local2.scope)
            {
                this.setReturned(_local2.returned);
            }
            else
            {
                if (_local2.scope == _local2.returned)
                {
                    this.setReturned(_local2.scope, true);
                }
                else
                {
                    this.setReturned(_local2.returned);
                    this.setReturned(_local2.scope, true);
                };
            };
        }

        private function execCommand(str:String):void
        {
            var slashcmd:SlashCommand;
            var restStr:String;
            var endInd:int;
            var brk:int = str.search(/[^\w]/);
            var cmd:String = str.substring(0, (((brk > 0)) ? brk : str.length));
            if (cmd == "")
            {
                this.setReturned(this._saved.get(Executer.RETURNED), true);
                return;
            };
            var param:String = (((brk > 0)) ? str.substring((brk + 1)) : "");
            if (this._slashCmds[cmd] != null)
            {
                try
                {
                    slashcmd = this._slashCmds[cmd];
                    if (((!(config.commandLineAllowed)) && (!(slashcmd.allow))))
                    {
                        report(DISABLED, 9);
                        return;
                    };
                    if (slashcmd.endMarker)
                    {
                        endInd = param.indexOf(slashcmd.endMarker);
                        if (endInd >= 0)
                        {
                            restStr = param.substring((endInd + slashcmd.endMarker.length));
                            param = param.substring(0, endInd);
                        };
                    };
                    if (param.length == 0)
                    {
                        slashcmd.f();
                    }
                    else
                    {
                        slashcmd.f(param);
                    };
                    if (restStr)
                    {
                        this.run(restStr);
                    };
                }
                catch(err:Error)
                {
                    reportError(err);
                };
            }
            else
            {
                report("Undefined command <b>/commands</b> for list of all commands.", 10);
            };
        }

        public function setReturned(_arg1:*, _arg2:Boolean=false, _arg3:Boolean=true):void
        {
            if (!config.commandLineAllowed)
            {
                report(DISABLED, 9);
                return;
            };
            if (_arg1 !== undefined)
            {
                this._saved.set(Executer.RETURNED, _arg1, true);
                if (((_arg2) && (!((_arg1 === this._scope)))))
                {
                    this._prevScope.reference = this._scope;
                    this._scope = _arg1;
                    if (remoter.remoting != Remoting.RECIEVER)
                    {
                        this._scopeStr = LogReferences.ShortClassName(this._scope, false);
                        this.sendCmdScope2Remote();
                    };
                    report(("Changed to " + console.refs.makeRefTyped(_arg1)), -1);
                }
                else
                {
                    if (_arg3)
                    {
                        report(("Returned " + console.refs.makeString(_arg1)), -1);
                    };
                };
            }
            else
            {
                if (_arg3)
                {
                    report("Exec successful, undefined return.", -1);
                };
            };
        }

        public function sendCmdScope2Remote(_arg1:Event=null):void
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeUTF(this._scopeStr);
            console.remoter.send("cls", _local2);
        }

        private function reportError(_arg1:Error):void
        {
            var _local10:String;
            var _local2:String = console.refs.makeString(_arg1);
            var _local3:Array = _local2.split(/\n\s*/);
            var _local4:int = 10;
            var _local5:int;
            var _local6:int = _local3.length;
            var _local7:Array = [];
            var _local8:RegExp = new RegExp((((("\\s*at\\s+(" + Executer.CLASSES) + "|") + getQualifiedClassName(this)) + ")"));
            var _local9:int;
            while (_local9 < _local6)
            {
                _local10 = _local3[_local9];
                if (_local10.search(_local8) == 0)
                {
                    if ((((_local5 > 0)) && ((_local9 > 0)))) break;
                    _local5++;
                };
                _local7.push((((((("<p" + _local4) + "> ") + _local10) + "</p") + _local4) + ">"));
                if (_local4 > 6)
                {
                    _local4--;
                };
                _local9++;
            };
            report(_local7.join("\n"), 9);
        }

        private function saveCmd(_arg1:String=null):void
        {
            this.store(_arg1, this._scope, false);
        }

        private function saveStrongCmd(_arg1:String=null):void
        {
            this.store(_arg1, this._scope, true);
        }

        private function savedCmd(... _args):void
        {
            var _local4:String;
            var _local5:WeakRef;
            report("Saved vars: ", -1);
            var _local2:uint;
            var _local3:uint;
            for (_local4 in this._saved)
            {
                _local5 = this._saved.getWeakRef(_local4);
                _local2++;
                if (_local5.reference == null)
                {
                    _local3++;
                };
                report(((((((_local5.strong) ? "strong" : "weak") + " <b>$") + _local4) + "</b> = ") + console.refs.makeString(_local5.reference)), -2);
            };
            report((((("Found " + _local2) + " item(s), ") + _local3) + " empty."), -1);
        }

        private function stringCmd(_arg1:String):void
        {
            report((("String with " + _arg1.length) + " chars entered. Use /save <i>(name)</i> to save."), -2);
            this.setReturned(_arg1, true);
        }

        private function cmdsCmd(... _args):void
        {
            var _local4:SlashCommand;
            var _local2:Array = [];
            var _local3:Array = [];
            for each (_local4 in this._slashCmds)
            {
                if (((config.commandLineAllowed) || (_local4.allow)))
                {
                    if (_local4.user)
                    {
                        _local3.push(_local4);
                    }
                    else
                    {
                        _local2.push(_local4);
                    };
                };
            };
            _local2 = _local2.sortOn("n");
            report(("Built-in commands:" + ((config.commandLineAllowed) ? "" : " (limited permission)")), 4);
            for each (_local4 in _local2)
            {
                report((((("<b>/" + _local4.n) + "</b> <p-1>") + _local4.d) + "</p-1>"), -2);
            };
            if (_local3.length)
            {
                _local3 = _local3.sortOn("n");
                report("User commands:", 4);
                for each (_local4 in _local3)
                {
                    report((((("<b>/" + _local4.n) + "</b> <p-1>") + _local4.d) + "</p-1>"), -2);
                };
            };
        }

        private function inspectCmd(... _args):void
        {
            console.refs.focus(this._scope);
        }

        private function explodeCmd(_arg1:String="0"):void
        {
            var _local2:int = int(_arg1);
            console.explodech(console.panels.mainPanel.reportChannel, this._scope, (((_local2 <= 0)) ? 3 : _local2));
        }

        private function mapCmd(_arg1:String="0"):void
        {
            console.mapch(console.panels.mainPanel.reportChannel, (this._scope as DisplayObjectContainer), int(_arg1));
        }

        private function funCmd(_arg1:String=""):void
        {
            var _local2:FakeFunction = new FakeFunction(this.run, _arg1);
            report("Function created. Use /savestrong <i>(name)</i> to save.", -2);
            this.setReturned(_local2.exec, true);
        }

        private function autoscopeCmd(... _args):void
        {
            config.commandLineAutoScope = !(config.commandLineAutoScope);
            report((("Auto-scoping <b>" + ((config.commandLineAutoScope) ? "enabled" : "disabled")) + "</b>."), 10);
        }

        private function baseCmd(... _args):void
        {
            this.setReturned(this.base, true);
        }

        private function prevCmd(... _args):void
        {
            this.setReturned(this._prevScope.reference, true);
        }

        private function printHelp(... _args):void
        {
            report("____Command Line Help___", 10);
            report("/filter (text) = filter/search logs for matching text", 5);
            report("/commands to see all slash commands", 5);
            report("Press up/down arrow keys to recall previous line", 2);
            report("__Examples:", 10);
            report("<b>stage.stageWidth</b>", 5);
            report("<b>stage.scaleMode = flash.display.StageScaleMode.NO_SCALE</b>", 5);
            report("<b>stage.frameRate = 12</b>", 5);
            report("__________", 10);
        }


    }
}

class FakeFunction 
{

    /*private*/ var line:String;
    /*private*/ var run:Function;

    public function FakeFunction(_arg1:Function, _arg2:String):void
    {
        this.run = _arg1;
        this.line = _arg2;
    }

    public function exec(... _args)
    {
        return (this.run(this.line, _args));
    }


}
class SlashCommand 
{

    public var n:String;
    public var f:Function;
    public var d:String;
    public var user:Boolean;
    public var allow:Boolean;
    public var endMarker:String;

    public function SlashCommand(_arg1:String, _arg2:Function, _arg3:String, _arg4:Boolean, _arg5:Boolean, _arg6:String)
    {
        this.n = _arg1;
        this.f = _arg2;
        this.d = ((_arg3) ? _arg3 : "");
        this.user = _arg4;
        this.allow = _arg5;
        this.endMarker = _arg6;
    }

}

