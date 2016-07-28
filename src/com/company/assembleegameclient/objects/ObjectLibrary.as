package com.company.assembleegameclient.objects
{
    import com.company.assembleegameclient.objects.animation.AnimationsData;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.ConversionUtil;

    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.messaging.impl.data.StatData;

    public class ObjectLibrary
    {
        public static const IMAGE_SET_NAME:String = "lofiObj3";
        public static const IMAGE_ID:int = 0xFF;
        public static const propsLibrary_:Dictionary = new Dictionary();
        public static const xmlLibrary_:Dictionary = new Dictionary();
        public static const idToType_:Dictionary = new Dictionary();
        public static const typeToDisplayId_:Dictionary = new Dictionary();
        public static const typeToTextureData_:Dictionary = new Dictionary();
        public static const typeToTopTextureData_:Dictionary = new Dictionary();
        public static const typeToAnimationsData_:Dictionary = new Dictionary();
        public static const petXMLDataLibrary_:Dictionary = new Dictionary();
        public static const skinSetXMLDataLibrary_:Dictionary = new Dictionary();
        public static const defaultProps_:ObjectProperties = new ObjectProperties(null);
        public static const TYPE_MAP:Object = {
            "ArenaGuard": ArenaGuard,
            "ArenaPortal": ArenaPortal,
            "CaveWall": CaveWall,
            "Character": Character,
            "CharacterChanger": CharacterChanger,
            "ClosedGiftChest": ClosedGiftChest,
            "ClosedVaultChest": ClosedVaultChest,
            "ConnectedWall": ConnectedWall,
            "Container": Container,
            "DoubleWall": DoubleWall,
            "FortuneGround": FortuneGround,
            "FortuneTeller": FortuneTeller,
            "GameObject": GameObject,
            "GuildBoard": GuildBoard,
            "GuildChronicle": GuildChronicle,
            "GuildHallPortal": GuildHallPortal,
            "GuildMerchant": GuildMerchant,
            "GuildRegister": GuildRegister,
            "Merchant": Merchant,
            "MoneyChanger": MoneyChanger,
            "MysteryBoxGround": MysteryBoxGround,
            "NameChanger": NameChanger,
            "ReskinVendor": ReskinVendor,
            "OneWayContainer": OneWayContainer,
            "Player": Player,
            "Portal": Portal,
            "Projectile": Projectile,
            "QuestRewards": QuestRewards,
            "Sign": Sign,
            "SpiderWeb": SpiderWeb,
            "Stalagmite": Stalagmite,
            "Wall": Wall,
            "Pet": Pet,
            "PetUpgrader": PetUpgrader,
            "YardUpgrader": YardUpgrader
        };
        public static var textureDataFactory:TextureDataFactory = new TextureDataFactory();
        public static var playerChars_:Vector.<XML> = new Vector.<XML>();
        public static var hexTransforms_:Vector.<XML> = new Vector.<XML>();
        public static var playerClassAbbr_:Dictionary = new Dictionary();

        public static function parseFromXML(_arg1:XML):void
        {
            var _local2:XML;
            var _local3:String;
            var _local4:String;
            var _local5:int;
            var _local6:Boolean;
            var _local7:int;
            for each (_local2 in _arg1.Object)
            {
                _local3 = String(_local2.@id);
                _local4 = _local3;
                if (_local2.hasOwnProperty("DisplayId"))
                {
                    _local4 = _local2.DisplayId;
                }
                if (_local2.hasOwnProperty("Group"))
                {
                    if (_local2.Group == "Hexable")
                    {
                        hexTransforms_.push(_local2);
                    }
                }
                _local5 = int(_local2.@type);
                if (((_local2.hasOwnProperty("PetBehavior")) || (_local2.hasOwnProperty("PetAbility"))))
                {
                    petXMLDataLibrary_[_local5] = _local2;
                }
                else
                {
                    propsLibrary_[_local5] = new ObjectProperties(_local2);
                    xmlLibrary_[_local5] = _local2;
                    idToType_[_local3] = _local5;
                    typeToDisplayId_[_local5] = _local4;
                    if (String(_local2.Class) == "Player")
                    {
                        playerClassAbbr_[_local5] = String(_local2.@id).substr(0, 2);
                        _local6 = false;
                        _local7 = 0;
                        while (_local7 < playerChars_.length)
                        {
                            if (int(playerChars_[_local7].@type) == _local5)
                            {
                                playerChars_[_local7] = _local2;
                                _local6 = true;
                            }
                            _local7++;
                        }
                        if (!_local6)
                        {
                            playerChars_.push(_local2);
                        }
                    }
                    typeToTextureData_[_local5] = textureDataFactory.create(_local2);
                    if (_local2.hasOwnProperty("Top"))
                    {
                        typeToTopTextureData_[_local5] = textureDataFactory.create(XML(_local2.Top));
                    }
                    if (_local2.hasOwnProperty("Animation"))
                    {
                        typeToAnimationsData_[_local5] = new AnimationsData(_local2);
                    }
                }
            }
        }

        public static function getIdFromType(_arg1:int):String
        {
            var _local2:XML = xmlLibrary_[_arg1];
            if (_local2 == null)
            {
                return (null);
            }
            return (String(_local2.@id));
        }

        public static function getPropsFromId(_arg1:String):ObjectProperties
        {
            var _local2:int = idToType_[_arg1];
            return (propsLibrary_[_local2]);
        }

        public static function getXMLfromId(_arg1:String):XML
        {
            var _local2:int = idToType_[_arg1];
            return (xmlLibrary_[_local2]);
        }

        public static function getObjectFromType(_arg1:int):GameObject
        {
            var _local2:XML = xmlLibrary_[_arg1];
            var _local3:String = _local2.Class;
            var _local4:Class = ((TYPE_MAP[_local3]) || (makeClass(_local3)));
            return (new _local4(_local2));
        }

        private static function makeClass(_arg1:String):Class
        {
            var _local2:String = ("com.company.assembleegameclient.objects." + _arg1);
            return ((getDefinitionByName(_local2) as Class));
        }

        public static function getTextureFromType(_arg1:int):BitmapData
        {
            var _local2:TextureData = typeToTextureData_[_arg1];
            if (_local2 == null)
            {
                return (null);
            }
            return (_local2.getTexture());
        }

        public static function getBitmapData(_arg1:int):BitmapData
        {
            var _local2:TextureData = typeToTextureData_[_arg1];
            var _local3:BitmapData = ((_local2) ? _local2.getTexture() : null);
            if (_local3)
            {
                return (_local3);
            }
            return (AssetLibrary.getImageFromSet(IMAGE_SET_NAME, IMAGE_ID));
        }

        public static function getRedrawnTextureFromType(
                _arg1:int, _arg2:int, _arg3:Boolean, _arg4:Boolean = true, _arg5:Number = 5
        ):BitmapData
        {
            var _local6:BitmapData = getBitmapData(_arg1);
            var _local7:TextureData = typeToTextureData_[_arg1];
            var _local8:BitmapData = ((_local7) ? _local7.mask_ : null);
            if (_local8 == null)
            {
                return (TextureRedrawer.redraw(_local6, _arg2, _arg3, 0, _arg4, _arg5));
            }
            var _local9:XML = xmlLibrary_[_arg1];
            var _local10:int = ((_local9.hasOwnProperty("Tex1")) ? int(_local9.Tex1) : 0);
            var _local11:int = ((_local9.hasOwnProperty("Tex2")) ? int(_local9.Tex2) : 0);
            _local6 = TextureRedrawer.resize(_local6, _local8, _arg2, _arg3, _local10, _local11, _arg5);
            _local6 = GlowRedrawer.outlineGlow(_local6, 0);
            return (_local6);
        }

        public static function getSizeFromType(_arg1:int):int
        {
            var _local2:XML = xmlLibrary_[_arg1];
            if (!_local2.hasOwnProperty("Size"))
            {
                return (100);
            }
            return (int(_local2.Size));
        }

        public static function getSlotTypeFromType(_arg1:int):int
        {
            var _local2:XML = xmlLibrary_[_arg1];
            if (!_local2.hasOwnProperty("SlotType"))
            {
                return (-1);
            }
            return (int(_local2.SlotType));
        }

        public static function isEquippableByPlayer(_arg1:int, _arg2:Player):Boolean
        {
            if (_arg1 == ItemConstants.NO_ITEM)
            {
                return (false);
            }
            var _local3:XML = xmlLibrary_[_arg1];
            var _local4:int = int(_local3.SlotType.toString());
            var _local5:uint;
            while (_local5 < GeneralConstants.NUM_EQUIPMENT_SLOTS)
            {
                if (_arg2.slotTypes_[_local5] == _local4)
                {
                    return (true);
                }
                _local5++;
            }
            return (false);
        }

        public static function getMatchingSlotIndex(_arg1:int, _arg2:Player):int
        {
            var _local3:XML;
            var _local4:int;
            var _local5:uint;
            if (_arg1 != ItemConstants.NO_ITEM)
            {
                _local3 = xmlLibrary_[_arg1];
                _local4 = int(_local3.SlotType);
                _local5 = 0;
                while (_local5 < GeneralConstants.NUM_EQUIPMENT_SLOTS)
                {
                    if (_arg2.slotTypes_[_local5] == _local4)
                    {
                        return (_local5);
                    }
                    _local5++;
                }
            }
            return (-1);
        }

        public static function isUsableByPlayer(_arg1:int, _arg2:Player):Boolean
        {
            if (_arg2 == null)
            {
                return (true);
            }
            var _local3:XML = xmlLibrary_[_arg1];
            if ((((_local3 == null)) || (!(_local3.hasOwnProperty("SlotType")))))
            {
                return (false);
            }
            var _local4:int = _local3.SlotType;
            if ((((_local4 == ItemConstants.POTION_TYPE)) || ((_local4 == ItemConstants.EGG_TYPE))))
            {
                return (true);
            }
            var _local5:int;
            while (_local5 < _arg2.slotTypes_.length)
            {
                if (_arg2.slotTypes_[_local5] == _local4)
                {
                    return (true);
                }
                _local5++;
            }
            return (false);
        }

        public static function isSoulbound(_arg1:int):Boolean
        {
            var _local2:XML = xmlLibrary_[_arg1];
            return (((!((_local2 == null))) && (_local2.hasOwnProperty("Soulbound"))));
        }

        public static function usableBy(_arg1:int):Vector.<String>
        {
            var _local5:XML;
            var _local6:Vector.<int>;
            var _local7:int;
            var _local2:XML = xmlLibrary_[_arg1];
            if ((((_local2 == null)) || (!(_local2.hasOwnProperty("SlotType")))))
            {
                return (null);
            }
            var _local3:int = _local2.SlotType;
            if ((((((_local3 == ItemConstants.POTION_TYPE)) || ((_local3 == ItemConstants.RING_TYPE)))) || ((_local3 == ItemConstants.EGG_TYPE))))
            {
                return (null);
            }
            var _local4:Vector.<String> = new Vector.<String>();
            for each (_local5 in playerChars_)
            {
                _local6 = ConversionUtil.toIntVector(_local5.SlotTypes);
                _local7 = 0;
                while (_local7 < _local6.length)
                {
                    if (_local6[_local7] == _local3)
                    {
                        _local4.push(typeToDisplayId_[int(_local5.@type)]);
                        break;
                    }
                    _local7++;
                }
            }
            return (_local4);
        }

        public static function playerMeetsRequirements(_arg1:int, _arg2:Player):Boolean
        {
            var _local4:XML;
            if (_arg2 == null)
            {
                return (true);
            }
            var _local3:XML = xmlLibrary_[_arg1];
            for each (_local4 in _local3.EquipRequirement)
            {
                if (!playerMeetsRequirement(_local4, _arg2))
                {
                    return (false);
                }
            }
            return (true);
        }

        public static function playerMeetsRequirement(_arg1:XML, _arg2:Player):Boolean
        {
            var _local3:int;
            if (_arg1.toString() == "Stat")
            {
                _local3 = int(_arg1.@value);
                switch (int(_arg1.@stat))
                {
                    case StatData.MAX_HP_STAT:
                        return ((_arg2.maxHP_ >= _local3));
                    case StatData.MAX_MP_STAT:
                        return ((_arg2.maxMP_ >= _local3));
                    case StatData.LEVEL_STAT:
                        return ((_arg2.level_ >= _local3));
                    case StatData.ATTACK_STAT:
                        return ((_arg2.attack_ >= _local3));
                    case StatData.DEFENSE_STAT:
                        return ((_arg2.defense_ >= _local3));
                    case StatData.SPEED_STAT:
                        return ((_arg2.speed_ >= _local3));
                    case StatData.VITALITY_STAT:
                        return ((_arg2.vitality_ >= _local3));
                    case StatData.WISDOM_STAT:
                        return ((_arg2.wisdom_ >= _local3));
                    case StatData.DEXTERITY_STAT:
                        return ((_arg2.dexterity_ >= _local3));
                }
            }
            return (false);
        }

        public static function getPetDataXMLByType(_arg1:int):XML
        {
            return (petXMLDataLibrary_[_arg1]);
        }
    }
}

