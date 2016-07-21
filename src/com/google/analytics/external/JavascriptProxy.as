package com.google.analytics.external
{
    import com.google.analytics.debug.DebugConfiguration;
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;

    public class JavascriptProxy 
    {

        public static var hasProperty_js:XML = <script>
                <![CDATA[
                    function( path )
                    {
                        var paths;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                        }
                        else
                        {
                            paths = [path];
                        }
                        var target = window ;
                        var len    = paths.length ;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            target = target[ paths[i] ] ;
                        }
                        if( target )
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                ]]>
            </script>
        ;
        public static var setProperty_js:XML = <script>
                <![CDATA[
                    function( path , value )
                    {
                        var paths;
                        var prop;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                            prop  = paths.pop() ;
                        }
                        else
                        {
                            paths = [];
                            prop  = path;
                        }
                        var target = window ;
                        var len    = paths.length ;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            target = target[ paths[i] ] ;
                        }
                        
                        target[ prop ] = value ;
                    }
                ]]>
            </script>
        ;
        public static var setPropertyRef_js:XML = <script>
                <![CDATA[
                    function( path , target )
                    {
                        var paths;
                        var prop;
                        if( path.indexOf(".") > 0 )
                        {
                            paths = path.split(".");
                            prop  = paths.pop() ;
                        }
                        else
                        {
                            paths = [];
                            prop  = path;
                        }
                        alert( "paths:"+paths.length+", prop:"+prop );
                        var targets;
                        var name;
                        if( target.indexOf(".") > 0 )
                        {
                            targets = target.split(".");
                            name    = targets.pop();
                        }
                        else
                        {
                            targets = [];
                            name    = target;
                        }
                        alert( "targets:"+targets.length+", name:"+name );
                        var root = window;
                        var len  = paths.length;
                        for( var i = 0 ; i < len ; i++ )
                        {
                            root = root[ paths[i] ] ;
                        }
                        var ref   = window;
                        var depth = targets.length;
                        for( var j = 0 ; j < depth ; j++ )
                        {
                            ref = ref[ targets[j] ] ;
                        }
                        root[ prop ] = ref[name] ;
                    }
                ]]>
            </script>
        ;

        private var _notAvailableWarning:Boolean = true;
        private var _debug:DebugConfiguration;

        public function JavascriptProxy(_arg1:DebugConfiguration)
        {
            _debug = _arg1;
        }

        public function getProperty(_arg1:String)
        {
            return (call((_arg1 + ".valueOf")));
        }

        public function hasProperty(_arg1:String):Boolean
        {
            return (call(hasProperty_js, _arg1));
        }

        public function setProperty(_arg1:String, _arg2:*):void
        {
            call(setProperty_js, _arg1, _arg2);
        }

        public function executeBlock(data:String):void
        {
            if (isAvailable())
            {
                try
                {
                    ExternalInterface.call(data);
                }
                catch(e:SecurityError)
                {
                    if (_debug.javascript)
                    {
                        _debug.warning('ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to "always" in the Flash embed HTML.');
                    };
                }
                catch(e:Error)
                {
                    if (_debug.javascript)
                    {
                        _debug.warning(("ExternalInterface failed to make the call\nreason: " + e.message));
                    };
                };
            };
        }

        public function getPropertyString(_arg1:String):String
        {
            return (call((_arg1 + ".toString")));
        }

        public function setPropertyByReference(_arg1:String, _arg2:String):void
        {
            call(setPropertyRef_js, _arg1, _arg2);
        }

        public function call(functionName:String, ... args)
        {
            var output:String;
            if (isAvailable())
            {
                try
                {
                    if (((_debug.javascript) && (_debug.verbose)))
                    {
                        output = "";
                        output = ("Flash->JS: " + functionName);
                        output = (output + "( ");
                        if (args.length > 0)
                        {
                            output = (output + args.join(","));
                        };
                        output = (output + " )");
                        _debug.info(output);
                    };
                    args.unshift(functionName);
                    return (ExternalInterface.call.apply(ExternalInterface, args));
                }
                catch(e:SecurityError)
                {
                    if (_debug.javascript)
                    {
                        _debug.warning('ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to "always" in the Flash embed HTML.');
                    };
                }
                catch(e:Error)
                {
                    if (_debug.javascript)
                    {
                        _debug.warning(("ExternalInterface failed to make the call\nreason: " + e.message));
                    };
                };
            };
            return (null);
        }

        public function isAvailable():Boolean
        {
            var _local1:Boolean = ExternalInterface.available;
            if (((_local1) && ((Capabilities.playerType == "External"))))
            {
                _local1 = false;
            };
            if (((((!(_local1)) && (_debug.javascript))) && (_notAvailableWarning)))
            {
                _debug.warning("ExternalInterface is not available.");
                _notAvailableWarning = false;
            };
            return (_local1);
        }


    }
}

