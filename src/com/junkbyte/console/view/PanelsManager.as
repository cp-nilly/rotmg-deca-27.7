package com.junkbyte.console.view
{
    import com.junkbyte.console.Console;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.geom.Rectangle;
    import com.junkbyte.console.vos.GraphGroup;
    import flash.events.Event;

    public class PanelsManager 
    {

        private var console:Console;
        private var _mainPanel:MainPanel;
        private var _ruler:Ruler;
        private var _chsPanel:ChannelsPanel;
        private var _fpsPanel:GraphingPanel;
        private var _memPanel:GraphingPanel;
        private var _graphsMap:Object;
        private var _graphPlaced:uint = 0;
        private var _tooltipField:TextField;
        private var _canDraw:Boolean;

        public function PanelsManager(_arg1:Console)
        {
            this._graphsMap = {};
            super();
            this.console = _arg1;
            this._mainPanel = new MainPanel(this.console);
            this._tooltipField = this.mainPanel.makeTF("tooltip", true);
            this._tooltipField.mouseEnabled = false;
            this._tooltipField.autoSize = TextFieldAutoSize.CENTER;
            this._tooltipField.multiline = true;
            this.addPanel(this._mainPanel);
        }

        public function addPanel(_arg1:ConsolePanel):void
        {
            if (this.console.contains(this._tooltipField))
            {
                this.console.addChildAt(_arg1, this.console.getChildIndex(this._tooltipField));
            }
            else
            {
                this.console.addChild(_arg1);
            };
            _arg1.addEventListener(ConsolePanel.DRAGGING_STARTED, this.onPanelStartDragScale, false, 0, true);
            _arg1.addEventListener(ConsolePanel.SCALING_STARTED, this.onPanelStartDragScale, false, 0, true);
        }

        public function removePanel(_arg1:String):void
        {
            var _local2:ConsolePanel = (this.console.getChildByName(_arg1) as ConsolePanel);
            if (_local2)
            {
                _local2.close();
            };
        }

        public function getPanel(_arg1:String):ConsolePanel
        {
            return ((this.console.getChildByName(_arg1) as ConsolePanel));
        }

        public function get mainPanel():MainPanel
        {
            return (this._mainPanel);
        }

        public function panelExists(_arg1:String):Boolean
        {
            return ((((this.console.getChildByName(_arg1) as ConsolePanel)) ? true : false));
        }

        public function setPanelArea(_arg1:String, _arg2:Rectangle):void
        {
            var _local3:ConsolePanel = this.getPanel(_arg1);
            if (_local3)
            {
                _local3.x = _arg2.x;
                _local3.y = _arg2.y;
                if (_arg2.width)
                {
                    _local3.width = _arg2.width;
                };
                if (_arg2.height)
                {
                    _local3.height = _arg2.height;
                };
            };
        }

        public function updateMenu():void
        {
            this._mainPanel.updateMenu();
            var _local1:ChannelsPanel = (this.getPanel(ChannelsPanel.NAME) as ChannelsPanel);
            if (_local1)
            {
                _local1.update();
            };
        }

        public function update(_arg1:Boolean, _arg2:Boolean):void
        {
            this._canDraw = !(_arg1);
            this._mainPanel.update(((!(_arg1)) && (_arg2)));
            if (!_arg1)
            {
                if (((_arg2) && (!((this._chsPanel == null)))))
                {
                    this._chsPanel.update();
                };
            };
        }

        public function updateGraphs(_arg1:Array):void
        {
            var _local2:Object;
            var _local3:GraphGroup;
            var _local4:GraphGroup;
            var _local5:GraphGroup;
            var _local6:String;
            var _local7:String;
            var _local8:GraphingPanel;
            var _local9:Rectangle;
            var _local10:Number;
            var _local11:Number;
            var _local12:int;
            var _local13:int;
            this._graphPlaced = 0;
            for each (_local5 in _arg1)
            {
                if (_local5.type == GraphGroup.FPS)
                {
                    _local3 = _local5;
                }
                else
                {
                    if (_local5.type == GraphGroup.MEM)
                    {
                        _local4 = _local5;
                    }
                    else
                    {
                        _local7 = _local5.name;
                        _local8 = (this._graphsMap[_local7] as GraphingPanel);
                        if (!_local8)
                        {
                            _local9 = _local5.rect;
                            if (_local9 == null)
                            {
                                _local9 = new Rectangle(NaN, NaN, 0, 0);
                            };
                            _local10 = 100;
                            if (((isNaN(_local9.x)) || (isNaN(_local9.y))))
                            {
                                if (this._mainPanel.width < 150)
                                {
                                    _local10 = 50;
                                };
                                _local11 = (Math.floor((this._mainPanel.width / _local10)) - 1);
                                if (_local11 <= 1)
                                {
                                    _local11 = 2;
                                };
                                _local12 = (this._graphPlaced % _local11);
                                _local13 = Math.floor((this._graphPlaced / _local11));
                                _local9.x = ((this._mainPanel.x + _local10) + (_local12 * _local10));
                                _local9.y = ((this._mainPanel.y + (_local10 * 0.6)) + (_local13 * _local10));
                                this._graphPlaced++;
                            };
                            if ((((_local9.width <= 0)) || (isNaN(_local9.width))))
                            {
                                _local9.width = _local10;
                            };
                            if ((((_local9.height <= 0)) || (isNaN(_local9.height))))
                            {
                                _local9.height = _local10;
                            };
                            _local8 = new GraphingPanel(this.console, _local9.width, _local9.height);
                            _local8.x = _local9.x;
                            _local8.y = _local9.y;
                            _local8.name = ("graph_" + _local7);
                            this._graphsMap[_local7] = _local8;
                            this.addPanel(_local8);
                        };
                        if (_local2 == null)
                        {
                            _local2 = {};
                        };
                        _local2[_local7] = true;
                        _local8.update(_local5, this._canDraw);
                    };
                };
            };
            for (_local6 in this._graphsMap)
            {
                if ((((_local2 == null)) || (!(_local2[_local6]))))
                {
                    this._graphsMap[_local6].close();
                    delete this._graphsMap[_local6];
                };
            };
            if (_local3 != null)
            {
                if (this._fpsPanel == null)
                {
                    this._fpsPanel = new GraphingPanel(this.console, 80, 40, GraphingPanel.FPS);
                    this._fpsPanel.name = GraphingPanel.FPS;
                    this._fpsPanel.x = ((this._mainPanel.x + this._mainPanel.width) - 160);
                    this._fpsPanel.y = (this._mainPanel.y + 15);
                    this.addPanel(this._fpsPanel);
                    this._mainPanel.updateMenu();
                };
                this._fpsPanel.update(_local3, this._canDraw);
            }
            else
            {
                if (this._fpsPanel != null)
                {
                    this.removePanel(GraphingPanel.FPS);
                    this._fpsPanel = null;
                };
            };
            if (_local4 != null)
            {
                if (this._memPanel == null)
                {
                    this._memPanel = new GraphingPanel(this.console, 80, 40, GraphingPanel.MEM);
                    this._memPanel.name = GraphingPanel.MEM;
                    this._memPanel.x = ((this._mainPanel.x + this._mainPanel.width) - 80);
                    this._memPanel.y = (this._mainPanel.y + 15);
                    this.addPanel(this._memPanel);
                    this._mainPanel.updateMenu();
                };
                this._memPanel.update(_local4, this._canDraw);
            }
            else
            {
                if (this._memPanel != null)
                {
                    this.removePanel(GraphingPanel.MEM);
                    this._memPanel = null;
                };
            };
            this._canDraw = false;
        }

        public function removeGraph(_arg1:GraphGroup):void
        {
            var _local2:GraphingPanel;
            if (((this._fpsPanel) && ((_arg1 == this._fpsPanel.group))))
            {
                this._fpsPanel.close();
                this._fpsPanel = null;
            }
            else
            {
                if (((this._memPanel) && ((_arg1 == this._memPanel.group))))
                {
                    this._memPanel.close();
                    this._memPanel = null;
                }
                else
                {
                    _local2 = this._graphsMap[_arg1.name];
                    if (_local2)
                    {
                        _local2.close();
                        delete this._graphsMap[_arg1.name];
                    };
                };
            };
        }

        public function get displayRoller():Boolean
        {
            return ((((this.getPanel(RollerPanel.NAME) as RollerPanel)) ? true : false));
        }

        public function set displayRoller(_arg1:Boolean):void
        {
            var _local2:RollerPanel;
            if (this.displayRoller != _arg1)
            {
                if (_arg1)
                {
                    if (this.console.config.displayRollerEnabled)
                    {
                        _local2 = new RollerPanel(this.console);
                        _local2.x = ((this._mainPanel.x + this._mainPanel.width) - 180);
                        _local2.y = (this._mainPanel.y + 55);
                        this.addPanel(_local2);
                    }
                    else
                    {
                        this.console.report("Display roller is disabled in config.", 9);
                    };
                }
                else
                {
                    this.removePanel(RollerPanel.NAME);
                };
                this._mainPanel.updateMenu();
            };
        }

        public function get channelsPanel():Boolean
        {
            return (!((this._chsPanel == null)));
        }

        public function set channelsPanel(_arg1:Boolean):void
        {
            if (this.channelsPanel != _arg1)
            {
                this.console.logs.cleanChannels();
                if (_arg1)
                {
                    this._chsPanel = new ChannelsPanel(this.console);
                    this._chsPanel.x = ((this._mainPanel.x + this._mainPanel.width) - 332);
                    this._chsPanel.y = (this._mainPanel.y - 2);
                    this.addPanel(this._chsPanel);
                    this._chsPanel.update();
                    this.updateMenu();
                }
                else
                {
                    this.removePanel(ChannelsPanel.NAME);
                    this._chsPanel = null;
                };
                this.updateMenu();
            };
        }

        public function get memoryMonitor():Boolean
        {
            return (!((this._memPanel == null)));
        }

        public function get fpsMonitor():Boolean
        {
            return (!((this._fpsPanel == null)));
        }

        public function tooltip(_arg1:String=null, _arg2:ConsolePanel=null):void
        {
            var _local3:Array;
            var _local4:Rectangle;
            var _local5:Rectangle;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            if (((_arg1) && (!(this.rulerActive))))
            {
                _local3 = _arg1.split("::");
                _arg1 = _local3[0];
                if (_local3.length > 1)
                {
                    _arg1 = (_arg1 + (("<br/><low>" + _local3[1]) + "</low>"));
                };
                this.console.addChild(this._tooltipField);
                this._tooltipField.wordWrap = false;
                this._tooltipField.htmlText = (("<tt>" + _arg1) + "</tt>");
                if (this._tooltipField.width > 120)
                {
                    this._tooltipField.width = 120;
                    this._tooltipField.wordWrap = true;
                };
                this._tooltipField.x = (this.console.mouseX - (this._tooltipField.width / 2));
                this._tooltipField.y = (this.console.mouseY + 20);
                if (_arg2)
                {
                    _local4 = this._tooltipField.getBounds(this.console);
                    _local5 = new Rectangle(_arg2.x, _arg2.y, _arg2.width, _arg2.height);
                    _local6 = (_local4.bottom - _local5.bottom);
                    if (_local6 > 0)
                    {
                        if ((this._tooltipField.y - _local6) > (this.console.mouseY + 15))
                        {
                            this._tooltipField.y = (this._tooltipField.y - _local6);
                        }
                        else
                        {
                            if ((((_local5.y < (this.console.mouseY - 24))) && ((_local4.y > _local5.bottom))))
                            {
                                this._tooltipField.y = ((this.console.mouseY - this._tooltipField.height) - 15);
                            };
                        };
                    };
                    _local7 = (_local4.left - _local5.left);
                    _local8 = (_local4.right - _local5.right);
                    if (_local7 < 0)
                    {
                        this._tooltipField.x = (this._tooltipField.x - _local7);
                    }
                    else
                    {
                        if (_local8 > 0)
                        {
                            this._tooltipField.x = (this._tooltipField.x - _local8);
                        };
                    };
                };
            }
            else
            {
                if (this.console.contains(this._tooltipField))
                {
                    this.console.removeChild(this._tooltipField);
                };
            };
        }

        public function startRuler():void
        {
            if (this.rulerActive)
            {
                return;
            };
            this._ruler = new Ruler(this.console);
            this._ruler.addEventListener(Event.COMPLETE, this.onRulerExit, false, 0, true);
            this.console.addChild(this._ruler);
            this._mainPanel.updateMenu();
        }

        public function get rulerActive():Boolean
        {
            return (((((this._ruler) && (this.console.contains(this._ruler)))) ? true : false));
        }

        private function onRulerExit(_arg1:Event):void
        {
            if (((this._ruler) && (this.console.contains(this._ruler))))
            {
                this.console.removeChild(this._ruler);
            };
            this._ruler = null;
            this._mainPanel.updateMenu();
        }

        private function onPanelStartDragScale(_arg1:Event):void
        {
            var _local3:Array;
            var _local4:Array;
            var _local5:int;
            var _local6:int;
            var _local7:ConsolePanel;
            var _local2:ConsolePanel = (_arg1.currentTarget as ConsolePanel);
            if (this.console.config.style.panelSnapping)
            {
                _local3 = [0];
                _local4 = [0];
                if (this.console.stage)
                {
                    _local3.push(this.console.stage.stageWidth);
                    _local4.push(this.console.stage.stageHeight);
                };
                _local5 = this.console.numChildren;
                _local6 = 0;
                while (_local6 < _local5)
                {
                    _local7 = (this.console.getChildAt(_local6) as ConsolePanel);
                    if (((_local7) && (_local7.visible)))
                    {
                        _local3.push(_local7.x, (_local7.x + _local7.width));
                        _local4.push(_local7.y, (_local7.y + _local7.height));
                    };
                    _local6++;
                };
                _local2.registerSnaps(_local3, _local4);
            };
        }


    }
}

