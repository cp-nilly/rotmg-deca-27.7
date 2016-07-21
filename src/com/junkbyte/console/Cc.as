package com.junkbyte.console
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.display.LoaderInfo;
    import flash.geom.Rectangle;

    public class Cc 
    {

        private static var _console:Console;
        private static var _config:ConsoleConfig;


        public static function get config():ConsoleConfig
        {
            if (!_config)
            {
                _config = new ConsoleConfig();
            };
            return (_config);
        }

        public static function start(_arg1:DisplayObjectContainer, _arg2:String=""):void
        {
            if (_console)
            {
                if (((_arg1) && (!(_console.parent))))
                {
                    _arg1.addChild(_console);
                };
            }
            else
            {
                _console = new Console(_arg2, config);
                if (_arg1)
                {
                    _arg1.addChild(_console);
                };
            };
        }

        public static function startOnStage(_arg1:DisplayObject, _arg2:String=""):void
        {
            if (_console)
            {
                if (((((_arg1) && (_arg1.stage))) && (!((_console.parent == _arg1.stage)))))
                {
                    _arg1.stage.addChild(_console);
                };
            }
            else
            {
                if (((_arg1) && (_arg1.stage)))
                {
                    start(_arg1.stage, _arg2);
                }
                else
                {
                    _console = new Console(_arg2, config);
                    if (_arg1)
                    {
                        _arg1.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
                    };
                };
            };
        }

        public static function add(_arg1:*, _arg2:int=2, _arg3:Boolean=false):void
        {
            if (_console)
            {
                _console.add(_arg1, _arg2, _arg3);
            };
        }

        public static function ch(_arg1:*, _arg2:*, _arg3:int=2, _arg4:Boolean=false):void
        {
            if (_console)
            {
                _console.ch(_arg1, _arg2, _arg3, _arg4);
            };
        }

        public static function log(... _args):void
        {
            if (_console)
            {
                _console.log.apply(null, _args);
            };
        }

        public static function info(... _args):void
        {
            if (_console)
            {
                _console.info.apply(null, _args);
            };
        }

        public static function debug(... _args):void
        {
            if (_console)
            {
                _console.debug.apply(null, _args);
            };
        }

        public static function warn(... _args):void
        {
            if (_console)
            {
                _console.warn.apply(null, _args);
            };
        }

        public static function error(... _args):void
        {
            if (_console)
            {
                _console.error.apply(null, _args);
            };
        }

        public static function fatal(... _args):void
        {
            if (_console)
            {
                _console.fatal.apply(null, _args);
            };
        }

        public static function logch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.LOG);
            };
        }

        public static function infoch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.INFO);
            };
        }

        public static function debugch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.DEBUG);
            };
        }

        public static function warnch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.WARN);
            };
        }

        public static function errorch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.ERROR);
            };
        }

        public static function fatalch(_arg1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg1, _args, Console.FATAL);
            };
        }

        public static function stack(_arg1:*, _arg2:int=-1, _arg3:int=5):void
        {
            if (_console)
            {
                _console.stack(_arg1, _arg2, _arg3);
            };
        }

        public static function stackch(_arg1:*, _arg2:*, _arg3:int=-1, _arg4:int=5):void
        {
            if (_console)
            {
                _console.stackch(_arg1, _arg2, _arg3, _arg4);
            };
        }

        public static function inspect(_arg1:Object, _arg2:Boolean=true):void
        {
            if (_console)
            {
                _console.inspect(_arg1, _arg2);
            };
        }

        public static function inspectch(_arg1:*, _arg2:Object, _arg3:Boolean=true):void
        {
            if (_console)
            {
                _console.inspectch(_arg1, _arg2, _arg3);
            };
        }

        public static function explode(_arg1:Object, _arg2:int=3):void
        {
            if (_console)
            {
                _console.explode(_arg1, _arg2);
            };
        }

        public static function explodech(_arg1:*, _arg2:Object, _arg3:int=3):void
        {
            if (_console)
            {
                _console.explodech(_arg1, _arg2, _arg3);
            };
        }

        public static function addHTML(... _args):void
        {
            if (_console)
            {
                _console.addHTML.apply(null, _args);
            };
        }

        public static function addHTMLch(_arg1:*, _arg2:int, ... _args):void
        {
            if (_console)
            {
                _console.addHTMLch.apply(null, new Array(_arg1, _arg2).concat(_args));
            };
        }

        public static function map(_arg1:DisplayObjectContainer, _arg2:uint=0):void
        {
            if (_console)
            {
                _console.map(_arg1, _arg2);
            };
        }

        public static function mapch(_arg1:*, _arg2:DisplayObjectContainer, _arg3:uint=0):void
        {
            if (_console)
            {
                _console.mapch(_arg1, _arg2, _arg3);
            };
        }

        public static function clear(_arg1:String=null):void
        {
            if (_console)
            {
                _console.clear(_arg1);
            };
        }

        public static function bindKey(_arg1:KeyBind, _arg2:Function=null, _arg3:Array=null):void
        {
            if (_console)
            {
                _console.bindKey(_arg1, _arg2, _arg3);
            };
        }

        public static function addMenu(_arg1:String, _arg2:Function, _arg3:Array=null, _arg4:String=null):void
        {
            if (_console)
            {
                _console.addMenu(_arg1, _arg2, _arg3, _arg4);
            };
        }

        public static function listenUncaughtErrors(_arg1:LoaderInfo):void
        {
            if (_console)
            {
                _console.listenUncaughtErrors(_arg1);
            };
        }

        public static function store(_arg1:String, _arg2:Object, _arg3:Boolean=false):void
        {
            if (_console)
            {
                _console.store(_arg1, _arg2, _arg3);
            };
        }

        public static function addSlashCommand(_arg1:String, _arg2:Function, _arg3:String="", _arg4:Boolean=true, _arg5:String=";"):void
        {
            if (_console)
            {
                _console.addSlashCommand(_arg1, _arg2, _arg3, _arg4, _arg5);
            };
        }

        public static function watch(_arg1:Object, _arg2:String=null):String
        {
            if (_console)
            {
                return (_console.watch(_arg1, _arg2));
            };
            return (null);
        }

        public static function unwatch(_arg1:String):void
        {
            if (_console)
            {
                _console.unwatch(_arg1);
            };
        }

        public static function addGraph(_arg1:String, _arg2:Object, _arg3:String, _arg4:Number=-1, _arg5:String=null, _arg6:Rectangle=null, _arg7:Boolean=false):void
        {
            if (_console)
            {
                _console.addGraph(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
            };
        }

        public static function fixGraphRange(_arg1:String, _arg2:Number=NaN, _arg3:Number=NaN):void
        {
            if (_console)
            {
                _console.fixGraphRange(_arg1, _arg2, _arg3);
            };
        }

        public static function removeGraph(_arg1:String, _arg2:Object=null, _arg3:String=null):void
        {
            if (_console)
            {
                _console.removeGraph(_arg1, _arg2, _arg3);
            };
        }

        public static function setViewingChannels(... _args):void
        {
            if (_console)
            {
                _console.setViewingChannels.apply(null, _args);
            };
        }

        public static function setIgnoredChannels(... _args):void
        {
            if (_console)
            {
                _console.setIgnoredChannels.apply(null, _args);
            };
        }

        public static function set minimumPriority(_arg1:uint):void
        {
            if (_console)
            {
                _console.minimumPriority = _arg1;
            };
        }

        public static function get width():Number
        {
            if (_console)
            {
                return (_console.width);
            };
            return (0);
        }

        public static function set width(_arg1:Number):void
        {
            if (_console)
            {
                _console.width = _arg1;
            };
        }

        public static function get height():Number
        {
            if (_console)
            {
                return (_console.height);
            };
            return (0);
        }

        public static function set height(_arg1:Number):void
        {
            if (_console)
            {
                _console.height = _arg1;
            };
        }

        public static function get x():Number
        {
            if (_console)
            {
                return (_console.x);
            };
            return (0);
        }

        public static function set x(_arg1:Number):void
        {
            if (_console)
            {
                _console.x = _arg1;
            };
        }

        public static function get y():Number
        {
            if (_console)
            {
                return (_console.y);
            };
            return (0);
        }

        public static function set y(_arg1:Number):void
        {
            if (_console)
            {
                _console.y = _arg1;
            };
        }

        public static function get visible():Boolean
        {
            if (_console)
            {
                return (_console.visible);
            };
            return (false);
        }

        public static function set visible(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.visible = _arg1;
            };
        }

        public static function get fpsMonitor():Boolean
        {
            if (_console)
            {
                return (_console.fpsMonitor);
            };
            return (false);
        }

        public static function set fpsMonitor(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.fpsMonitor = _arg1;
            };
        }

        public static function get memoryMonitor():Boolean
        {
            if (_console)
            {
                return (_console.memoryMonitor);
            };
            return (false);
        }

        public static function set memoryMonitor(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.memoryMonitor = _arg1;
            };
        }

        public static function get commandLine():Boolean
        {
            if (_console)
            {
                return (_console.commandLine);
            };
            return (false);
        }

        public static function set commandLine(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.commandLine = _arg1;
            };
        }

        public static function get displayRoller():Boolean
        {
            if (_console)
            {
                return (_console.displayRoller);
            };
            return (false);
        }

        public static function set displayRoller(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.displayRoller = _arg1;
            };
        }

        public static function setRollerCaptureKey(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Boolean=false):void
        {
            if (_console)
            {
                _console.setRollerCaptureKey(_arg1, _arg4, _arg2, _arg3);
            };
        }

        public static function get remoting():Boolean
        {
            if (_console)
            {
                return (_console.remoting);
            };
            return (false);
        }

        public static function set remoting(_arg1:Boolean):void
        {
            if (_console)
            {
                _console.remoting = _arg1;
            };
        }

        public static function remotingSocket(_arg1:String, _arg2:int):void
        {
            if (_console)
            {
                _console.remotingSocket(_arg1, _arg2);
            };
        }

        public static function remove():void
        {
            if (_console)
            {
                if (_console.parent)
                {
                    _console.parent.removeChild(_console);
                };
                _console = null;
            };
        }

        public static function getAllLog(_arg1:String="\r\n"):String
        {
            if (_console)
            {
                return (_console.getAllLog(_arg1));
            };
            return ("");
        }

        public static function get instance():Console
        {
            return (_console);
        }

        private static function addedToStageHandle(_arg1:Event):void
        {
            var _local2:DisplayObjectContainer = (_arg1.currentTarget as DisplayObjectContainer);
            _local2.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
            if (((_console) && ((_console.parent == null))))
            {
                _local2.stage.addChild(_console);
            };
        }


    }
}

