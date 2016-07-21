package com.gskinner.motion.easing
{
    public class Sine 
    {


        public static function easeIn(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return ((1 - Math.cos((_arg1 * (Math.PI / 2)))));
        }

        public static function easeOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return (Math.sin((_arg1 * (Math.PI / 2))));
        }

        public static function easeInOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return ((-0.5 * (Math.cos((_arg1 * Math.PI)) - 1)));
        }


    }
}

