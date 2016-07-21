package com.google.analytics.debug
{
    import flash.display.Graphics;

    public class Background 
    {


        public static function drawRounded(_arg1:*, _arg2:Graphics, _arg3:uint=0, _arg4:uint=0):void
        {
            var _local5:uint;
            var _local6:uint;
            var _local7:uint = Style.roundedCorner;
            if ((((_arg3 > 0)) && ((_arg4 > 0))))
            {
                _local5 = _arg3;
                _local6 = _arg4;
            }
            else
            {
                _local5 = _arg1.width;
                _local6 = _arg1.height;
            };
            if (((_arg1.stickToEdge) && (!((_arg1.alignement == Align.none)))))
            {
                switch (_arg1.alignement)
                {
                    case Align.top:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, 0, 0, _local7, _local7);
                        break;
                    case Align.topLeft:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, 0, 0, 0, _local7);
                        break;
                    case Align.topRight:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, 0, 0, _local7, 0);
                        break;
                    case Align.bottom:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, _local7, _local7, 0, 0);
                        break;
                    case Align.bottomLeft:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, 0, _local7, 0, 0);
                        break;
                    case Align.bottomRight:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, _local7, 0, 0, 0);
                        break;
                    case Align.left:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, 0, _local7, 0, _local7);
                        break;
                    case Align.right:
                        _arg2.drawRoundRectComplex(0, 0, _local5, _local6, _local7, 0, _local7, 0);
                        break;
                    case Align.center:
                        _arg2.drawRoundRect(0, 0, _local5, _local6, _local7, _local7);
                        break;
                };
            }
            else
            {
                _arg2.drawRoundRect(0, 0, _local5, _local6, _local7, _local7);
            };
        }


    }
}

