package com.junkbyte.console
{
    import flash.display.Sprite;
    import com.junkbyte.console.view.PanelsManager;
    import com.junkbyte.console.core.CommandLine;
    import com.junkbyte.console.core.KeyBinder;
    import com.junkbyte.console.core.LogReferences;
    import com.junkbyte.console.core.MemoryMonitor;
    import com.junkbyte.console.core.Graphing;
    import com.junkbyte.console.core.Remoting;
    import com.junkbyte.console.core.ConsoleTools;
    import com.junkbyte.console.core.Logs;
    import flash.net.SharedObject;
    import flash.system.Capabilities;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.IEventDispatcher;
    import flash.display.LoaderInfo;
    import flash.events.ErrorEvent;
    import flash.geom.Rectangle;
    import com.junkbyte.console.view.RollerPanel;
    import flash.display.DisplayObjectContainer;
    import flash.utils.getTimer;
    import com.junkbyte.console.vos.Log;

    public class Console extends Sprite 
    {

        public static const VERSION:Number = 2.6;
        public static const VERSION_STAGE:String = "";
        public static const BUILD:int = 611;
        public static const BUILD_DATE:String = "2012/02/22 00:11";
        public static const LOG:uint = 1;
        public static const INFO:uint = 3;
        public static const DEBUG:uint = 6;
        public static const WARN:uint = 8;
        public static const ERROR:uint = 9;
        public static const FATAL:uint = 10;
        public static const GLOBAL_CHANNEL:String = " * ";
        public static const DEFAULT_CHANNEL:String = "-";
        public static const CONSOLE_CHANNEL:String = "C";
        public static const FILTER_CHANNEL:String = "~";

        private var _config:ConsoleConfig;
        private var _panels:PanelsManager;
        private var _cl:CommandLine;
        private var _kb:KeyBinder;
        private var _refs:LogReferences;
        private var _mm:MemoryMonitor;
        private var _graphing:Graphing;
        private var _remoter:Remoting;
        private var _tools:ConsoleTools;
        private var _topTries:int = 50;
        private var _paused:Boolean;
        private var _rollerKey:KeyBind;
        private var _logs:Logs;
        private var _so:SharedObject;
        private var _soData:Object;

        public function Console(password:String="", config:ConsoleConfig=null)
        {
            this._soData = {};
            super();
            name = "Console";
            if (config == null)
            {
                config = new ConsoleConfig();
            };
            this._config = config;
            if (password)
            {
                this._config.keystrokePassword = password;
            };
            this._remoter = new Remoting(this);
            this._logs = new Logs(this);
            this._refs = new LogReferences(this);
            this._cl = new CommandLine(this);
            this._tools = new ConsoleTools(this);
            this._graphing = new Graphing(this);
            this._mm = new MemoryMonitor(this);
            this._kb = new KeyBinder(this);
            this.cl.addCLCmd("remotingSocket", function (_arg1:String=""):void
            {
                var _local2:Array = _arg1.split(/\s+|\:/);
                remotingSocket(_local2[0], _local2[1]);
            }, "Connect to socket remote. /remotingSocket ip port");
            if (this._config.sharedObjectName)
            {
                try
                {
                    this._so = SharedObject.getLocal(this._config.sharedObjectName, this._config.sharedObjectPath);
                    this._soData = this._so.data;
                }
                catch(e:Error)
                {
                };
            };
            this._config.style.updateStyleSheet();
            this._panels = new PanelsManager(this);
            if (password)
            {
                this.visible = false;
            };
            this.report(((((((((("<b>Console v" + VERSION) + VERSION_STAGE) + "</b> build ") + BUILD) + ". ") + Capabilities.playerType) + " ") + Capabilities.version) + "."), -2);
            addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
        }

        public static function MakeChannelName(_arg1:*):String
        {
            if ((_arg1 is String))
            {
                return ((_arg1 as String));
            };
            if (_arg1)
            {
                return (LogReferences.ShortClassName(_arg1));
            };
            return (DEFAULT_CHANNEL);
        }


        private function stageAddedHandle(_arg1:Event=null):void
        {
            if (this._cl.base == null)
            {
                this._cl.base = parent;
            };
            if (loaderInfo)
            {
                this.listenUncaughtErrors(loaderInfo);
            };
            removeEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            addEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            stage.addEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler, false, 0, true);
        }

        private function stageRemovedHandle(_arg1:Event=null):void
        {
            this._cl.base = null;
            removeEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            stage.removeEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler);
        }

        private function onStageMouseLeave(_arg1:Event):void
        {
            this._panels.tooltip(null);
        }

        public function listenUncaughtErrors(_arg1:LoaderInfo):void
        {
            var _local2:IEventDispatcher;
            try
            {
                _local2 = _arg1["uncaughtErrorEvents"];
                if (_local2)
                {
                    _local2.addEventListener("uncaughtError", this.uncaughtErrorHandle, false, 0, true);
                };
            }
            catch(err:Error)
            {
            };
        }

        private function uncaughtErrorHandle(_arg1:Event):void
        {
            var _local3:String;
            var _local2:* = ((_arg1.hasOwnProperty("error")) ? _arg1["error"] : _arg1);
            if ((_local2 is Error))
            {
                _local3 = this._refs.makeString(_local2);
            }
            else
            {
                if ((_local2 is ErrorEvent))
                {
                    _local3 = ErrorEvent(_local2).text;
                };
            };
            if (!_local3)
            {
                _local3 = String(_local2);
            };
            this.report(_local3, FATAL, false);
        }

        public function addGraph(_arg1:String, _arg2:Object, _arg3:String, _arg4:Number=-1, _arg5:String=null, _arg6:Rectangle=null, _arg7:Boolean=false):void
        {
            this._graphing.add(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
        }

        public function fixGraphRange(_arg1:String, _arg2:Number=NaN, _arg3:Number=NaN):void
        {
            this._graphing.fixRange(_arg1, _arg2, _arg3);
        }

        public function removeGraph(_arg1:String, _arg2:Object=null, _arg3:String=null):void
        {
            this._graphing.remove(_arg1, _arg2, _arg3);
        }

        public function bindKey(_arg1:KeyBind, _arg2:Function, _arg3:Array=null):void
        {
            if (_arg1)
            {
                this._kb.bindKey(_arg1, _arg2, _arg3);
            };
        }

        public function addMenu(_arg1:String, _arg2:Function, _arg3:Array=null, _arg4:String=null):void
        {
            this.panels.mainPanel.addMenu(_arg1, _arg2, _arg3, _arg4);
        }

        public function get displayRoller():Boolean
        {
            return (this._panels.displayRoller);
        }

        public function set displayRoller(_arg1:Boolean):void
        {
            this._panels.displayRoller = _arg1;
        }

        public function setRollerCaptureKey(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Boolean=false):void
        {
            if (this._rollerKey)
            {
                this.bindKey(this._rollerKey, null);
                this._rollerKey = null;
            };
            if (((_arg1) && ((_arg1.length == 1))))
            {
                this._rollerKey = new KeyBind(_arg1, _arg2, _arg3, _arg4);
                this.bindKey(this._rollerKey, this.onRollerCaptureKey);
            };
        }

        public function get rollerCaptureKey():KeyBind
        {
            return (this._rollerKey);
        }

        private function onRollerCaptureKey():void
        {
            if (this.displayRoller)
            {
                this.report(("Display Roller Capture:<br/>" + RollerPanel(this._panels.getPanel(RollerPanel.NAME)).getMapString(true)), -1);
            };
        }

        public function get fpsMonitor():Boolean
        {
            return (this._graphing.fpsMonitor);
        }

        public function set fpsMonitor(_arg1:Boolean):void
        {
            this._graphing.fpsMonitor = _arg1;
        }

        public function get memoryMonitor():Boolean
        {
            return (this._graphing.memoryMonitor);
        }

        public function set memoryMonitor(_arg1:Boolean):void
        {
            this._graphing.memoryMonitor = _arg1;
        }

        public function watch(_arg1:Object, _arg2:String=null):String
        {
            return (this._mm.watch(_arg1, _arg2));
        }

        public function unwatch(_arg1:String):void
        {
            this._mm.unwatch(_arg1);
        }

        public function gc():void
        {
            this._mm.gc();
        }

        public function store(_arg1:String, _arg2:Object, _arg3:Boolean=false):void
        {
            this._cl.store(_arg1, _arg2, _arg3);
        }

        public function map(_arg1:DisplayObjectContainer, _arg2:uint=0):void
        {
            this._tools.map(_arg1, _arg2, DEFAULT_CHANNEL);
        }

        public function mapch(_arg1:*, _arg2:DisplayObjectContainer, _arg3:uint=0):void
        {
            this._tools.map(_arg2, _arg3, MakeChannelName(_arg1));
        }

        public function inspect(_arg1:Object, _arg2:Boolean=true):void
        {
            this._refs.inspect(_arg1, _arg2, DEFAULT_CHANNEL);
        }

        public function inspectch(_arg1:*, _arg2:Object, _arg3:Boolean=true):void
        {
            this._refs.inspect(_arg2, _arg3, MakeChannelName(_arg1));
        }

        public function explode(_arg1:Object, _arg2:int=3):void
        {
            this.addLine(new Array(this._tools.explode(_arg1, _arg2)), 1, null, false, true);
        }

        public function explodech(_arg1:*, _arg2:Object, _arg3:int=3):void
        {
            this.addLine(new Array(this._tools.explode(_arg2, _arg3)), 1, _arg1, false, true);
        }

        public function get paused():Boolean
        {
            return (this._paused);
        }

        public function set paused(_arg1:Boolean):void
        {
            if (this._paused == _arg1)
            {
                return;
            };
            if (_arg1)
            {
                this.report("Paused", 10);
            }
            else
            {
                this.report("Resumed", -1);
            };
            this._paused = _arg1;
            this._panels.mainPanel.setPaused(_arg1);
        }

        override public function get width():Number
        {
            return (this._panels.mainPanel.width);
        }

        override public function set width(_arg1:Number):void
        {
            this._panels.mainPanel.width = _arg1;
        }

        override public function set height(_arg1:Number):void
        {
            this._panels.mainPanel.height = _arg1;
        }

        override public function get height():Number
        {
            return (this._panels.mainPanel.height);
        }

        override public function get x():Number
        {
            return (this._panels.mainPanel.x);
        }

        override public function set x(_arg1:Number):void
        {
            this._panels.mainPanel.x = _arg1;
        }

        override public function set y(_arg1:Number):void
        {
            this._panels.mainPanel.y = _arg1;
        }

        override public function get y():Number
        {
            return (this._panels.mainPanel.y);
        }

        override public function set visible(_arg1:Boolean):void
        {
            super.visible = _arg1;
            if (_arg1)
            {
                this._panels.mainPanel.visible = true;
            };
        }

        private function _onEnterFrame(_arg1:Event):void
        {
            var _local4:Array;
            var _local2:int = getTimer();
            var _local3:Boolean = this._logs.update(_local2);
            this._refs.update(_local2);
            this._mm.update();
            if (this.remoter.remoting != Remoting.RECIEVER)
            {
                _local4 = this._graphing.update(((stage) ? stage.frameRate : 0));
            };
            this._remoter.update();
            if (((visible) && (parent)))
            {
                if (((((this.config.alwaysOnTop) && (!((parent.getChildAt((parent.numChildren - 1)) == this))))) && ((this._topTries > 0))))
                {
                    this._topTries--;
                    parent.addChild(this);
                    this.report((("Moved console on top (alwaysOnTop enabled), " + this._topTries) + " attempts left."), -1);
                };
                this._panels.update(this._paused, _local3);
                if (_local4)
                {
                    this._panels.updateGraphs(_local4);
                };
            };
        }

        public function get remoting():Boolean
        {
            return ((this._remoter.remoting == Remoting.SENDER));
        }

        public function set remoting(_arg1:Boolean):void
        {
            this._remoter.remoting = ((_arg1) ? Remoting.SENDER : Remoting.NONE);
        }

        public function remotingSocket(_arg1:String, _arg2:int):void
        {
            this._remoter.remotingSocket(_arg1, _arg2);
        }

        public function setViewingChannels(... _args):void
        {
            this._panels.mainPanel.setViewingChannels.apply(this, _args);
        }

        public function setIgnoredChannels(... _args):void
        {
            this._panels.mainPanel.setIgnoredChannels.apply(this, _args);
        }

        public function set minimumPriority(_arg1:uint):void
        {
            this._panels.mainPanel.priority = _arg1;
        }

        public function report(_arg1:*, _arg2:int=0, _arg3:Boolean=true, _arg4:String=null):void
        {
            if (!_arg4)
            {
                _arg4 = this._panels.mainPanel.reportChannel;
            };
            this.addLine([_arg1], _arg2, _arg4, false, _arg3, 0);
        }

        public function addLine(_arg1:Array, _arg2:int=0, _arg3:*=null, _arg4:Boolean=false, _arg5:Boolean=false, _arg6:int=-1):void
        {
            var _local7 = "";
            var _local8:int = _arg1.length;
            var _local9:int;
            while (_local9 < _local8)
            {
                _local7 = (_local7 + (((_local9) ? " " : "") + this._refs.makeString(_arg1[_local9], null, _arg5)));
                _local9++;
            };
            if ((((_arg2 >= this._config.autoStackPriority)) && ((_arg6 < 0))))
            {
                _arg6 = this._config.defaultStackDepth;
            };
            if (((!(_arg5)) && ((_arg6 > 0))))
            {
                _local7 = (_local7 + this._tools.getStack(_arg6, _arg2));
            };
            this._logs.add(new Log(_local7, MakeChannelName(_arg3), _arg2, _arg4, _arg5));
        }

        public function set commandLine(_arg1:Boolean):void
        {
            this._panels.mainPanel.commandLine = _arg1;
        }

        public function get commandLine():Boolean
        {
            return (this._panels.mainPanel.commandLine);
        }

        public function addSlashCommand(_arg1:String, _arg2:Function, _arg3:String="", _arg4:Boolean=true, _arg5:String=";"):void
        {
            this._cl.addSlashCommand(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function add(_arg1:*, _arg2:int=2, _arg3:Boolean=false):void
        {
            this.addLine([_arg1], _arg2, DEFAULT_CHANNEL, _arg3);
        }

        public function stack(_arg1:*, _arg2:int=-1, _arg3:int=5):void
        {
            this.addLine([_arg1], _arg3, DEFAULT_CHANNEL, false, false, (((_arg2 >= 0)) ? _arg2 : this._config.defaultStackDepth));
        }

        public function stackch(_arg1:*, _arg2:*, _arg3:int=-1, _arg4:int=5):void
        {
            this.addLine([_arg2], _arg4, _arg1, false, false, (((_arg3 >= 0)) ? _arg3 : this._config.defaultStackDepth));
        }

        public function log(... _args):void
        {
            this.addLine(_args, LOG);
        }

        public function info(... _args):void
        {
            this.addLine(_args, INFO);
        }

        public function debug(... _args):void
        {
            this.addLine(_args, DEBUG);
        }

        public function warn(... _args):void
        {
            this.addLine(_args, WARN);
        }

        public function error(... _args):void
        {
            this.addLine(_args, ERROR);
        }

        public function fatal(... _args):void
        {
            this.addLine(_args, FATAL);
        }

        public function ch(_arg1:*, _arg2:*, _arg3:int=2, _arg4:Boolean=false):void
        {
            this.addLine([_arg2], _arg3, _arg1, _arg4);
        }

        public function logch(_arg1:*, ... _args):void
        {
            this.addLine(_args, LOG, _arg1);
        }

        public function infoch(_arg1:*, ... _args):void
        {
            this.addLine(_args, INFO, _arg1);
        }

        public function debugch(_arg1:*, ... _args):void
        {
            this.addLine(_args, DEBUG, _arg1);
        }

        public function warnch(_arg1:*, ... _args):void
        {
            this.addLine(_args, WARN, _arg1);
        }

        public function errorch(_arg1:*, ... _args):void
        {
            this.addLine(_args, ERROR, _arg1);
        }

        public function fatalch(_arg1:*, ... _args):void
        {
            this.addLine(_args, FATAL, _arg1);
        }

        public function addCh(_arg1:*, _arg2:Array, _arg3:int=2, _arg4:Boolean=false):void
        {
            this.addLine(_arg2, _arg3, _arg1, _arg4);
        }

        public function addHTML(... _args):void
        {
            this.addLine(_args, 2, DEFAULT_CHANNEL, false, this.testHTML(_args));
        }

        public function addHTMLch(_arg1:*, _arg2:int, ... _args):void
        {
            this.addLine(_args, _arg2, _arg1, false, this.testHTML(_args));
        }

        private function testHTML(args:Array):Boolean
        {
            try
            {
                new XML((("<p>" + args.join("")) + "</p>"));
            }
            catch(err:Error)
            {
                return (false);
            };
            return (true);
        }

        public function clear(_arg1:String=null):void
        {
            this._logs.clear(_arg1);
            if (!this._paused)
            {
                this._panels.mainPanel.updateToBottom();
            };
            this._panels.updateMenu();
        }

        public function getAllLog(_arg1:String="\r\n"):String
        {
            return (this._logs.getLogsAsString(_arg1));
        }

        public function get config():ConsoleConfig
        {
            return (this._config);
        }

        public function get panels():PanelsManager
        {
            return (this._panels);
        }

        public function get cl():CommandLine
        {
            return (this._cl);
        }

        public function get remoter():Remoting
        {
            return (this._remoter);
        }

        public function get graphing():Graphing
        {
            return (this._graphing);
        }

        public function get refs():LogReferences
        {
            return (this._refs);
        }

        public function get logs():Logs
        {
            return (this._logs);
        }

        public function get mapper():ConsoleTools
        {
            return (this._tools);
        }

        public function get so():Object
        {
            return (this._soData);
        }

        public function updateSO(_arg1:String=null):void
        {
            if (this._so)
            {
                if (_arg1)
                {
                    this._so.setDirty(_arg1);
                }
                else
                {
                    this._so.clear();
                };
            };
        }


    }
}

