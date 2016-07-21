package com.company.assembleegameclient.objects.animation
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class AnimationsData 
    {

        public var animations:Vector.<AnimationData>;

        public function AnimationsData(_arg1:XML)
        {
            var _local2:XML;
            this.animations = new Vector.<AnimationData>();
            super();
            for each (_local2 in _arg1.Animation)
            {
                this.animations.push(new AnimationData(_local2));
            };
        }

    }
}

