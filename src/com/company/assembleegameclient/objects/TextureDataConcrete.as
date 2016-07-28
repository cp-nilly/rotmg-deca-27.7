package com.company.assembleegameclient.objects
{
    import com.company.assembleegameclient.appengine.RemoteTexture;
    import com.company.assembleegameclient.objects.particles.EffectProperties;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.AssetLoader;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.util.AssetLibrary;

    import flash.display.BitmapData;
    import flash.utils.Dictionary;

    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.core.StaticInjectorContext;

    public class TextureDataConcrete extends TextureData
    {
        public static var remoteTexturesUsed:Boolean = false;
        private var isUsingLocalTextures:Boolean;

        public function TextureDataConcrete(_arg1:XML)
        {
            var _local2:XML;
            super();
            this.isUsingLocalTextures = this.getWhetherToUseLocalTextures();
            if (_arg1.hasOwnProperty("Texture"))
            {
                this.parse(XML(_arg1.Texture));
            }
            else
            {
                if (_arg1.hasOwnProperty("AnimatedTexture"))
                {
                    this.parse(XML(_arg1.AnimatedTexture));
                }
                else
                {
                    if (_arg1.hasOwnProperty("RemoteTexture"))
                    {
                        this.parse(XML(_arg1.RemoteTexture));
                    }
                    else
                    {
                        if (_arg1.hasOwnProperty("RandomTexture"))
                        {
                            this.parse(XML(_arg1.RandomTexture));
                        }
                        else
                        {
                            this.parse(_arg1);
                        }
                    }
                }
            }
            for each (_local2 in _arg1.AltTexture)
            {
                this.parse(_local2);
            }
            if (_arg1.hasOwnProperty("Mask"))
            {
                this.parse(XML(_arg1.Mask));
            }
            if (_arg1.hasOwnProperty("Effect"))
            {
                this.parse(XML(_arg1.Effect));
            }
        }

        override public function getTexture(_arg1:int = 0):BitmapData
        {
            if (randomTextureData_ == null)
            {
                return (texture_);
            }
            var _local2:TextureData = randomTextureData_[(_arg1 % randomTextureData_.length)];
            return (_local2.getTexture(_arg1));
        }

        override public function getAltTextureData(_arg1:int):TextureData
        {
            if (altTextures_ == null)
            {
                return (null);
            }
            return (altTextures_[_arg1]);
        }

        private function getWhetherToUseLocalTextures():Boolean
        {
            var _local1:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
            return (_local1.useLocalTextures());
        }

        private function parse(_arg1:XML):void
        {
            var _local2:MaskedImage;
            var _local3:RemoteTexture;
            var _local4:XML;
            switch (_arg1.name().toString())
            {
                case "Texture":
                    texture_ = AssetLibrary.getImageFromSet(String(_arg1.File), int(_arg1.Index));
                    return;
                case "Mask":
                    mask_ = AssetLibrary.getImageFromSet(String(_arg1.File), int(_arg1.Index));
                    return;
                case "Effect":
                    effectProps_ = new EffectProperties(_arg1);
                    return;
                case "AnimatedTexture":
                    animatedChar_ = AnimatedChars.getAnimatedChar(String(_arg1.File), int(_arg1.Index));
                    _local2 = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0);
                    texture_ = _local2.image_;
                    mask_ = _local2.mask_;
                    return;
                case "RemoteTexture":
                    texture_ = AssetLibrary.getImageFromSet("lofiObj3", 0xFF);
                    if (this.isUsingLocalTextures)
                    {
                        _local3 = new RemoteTexture(_arg1.Id, _arg1.Instance, this.onRemoteTexture);
                        _local3.run();
                        if (!AssetLoader.currentXmlIsTesting)
                        {
                            remoteTexturesUsed = true;
                        }
                    }
                    remoteTextureDir_ = ((_arg1.hasOwnProperty("Right")) ? AnimatedChar.RIGHT : AnimatedChar.DOWN);
                    return;
                case "RandomTexture":
                    randomTextureData_ = new Vector.<TextureData>();
                    for each (_local4 in _arg1.children())
                    {
                        randomTextureData_.push(new TextureDataConcrete(_local4));
                    }
                    return;
                case "AltTexture":
                    if (altTextures_ == null)
                    {
                        altTextures_ = new Dictionary();
                    }
                    altTextures_[int(_arg1.@id)] = new TextureDataConcrete(_arg1);
                    return;
            }
        }

        private function onRemoteTexture(_arg1:BitmapData):void
        {
            if (_arg1.width > 16)
            {
                AnimatedChars.add(
                        "remoteTexture",
                        _arg1,
                        null,
                        (_arg1.width / 7),
                        _arg1.height,
                        _arg1.width,
                        _arg1.height,
                        remoteTextureDir_
                );
                animatedChar_ = AnimatedChars.getAnimatedChar("remoteTexture", 0);
                texture_ = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0).image_;
            }
            else
            {
                texture_ = _arg1;
            }
        }
    }
}

