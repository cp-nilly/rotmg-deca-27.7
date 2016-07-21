package kabam.rotmg.pets.data
{
    public class PetFamilyKeys 
    {

        private static const keys:Object = {
            "Humanoid":"Pets.humanoid",
            "Feline":"Pets.feline",
            "Canine":"Pets.canine",
            "Avian":"Pets.avian",
            "Exotic":"Pets.exotic",
            "Farm":"pets.Farm",
            "Woodland":"Pets.woodland",
            "Reptile":"Pets.reptile",
            "Insect":"pets.Insect",
            "Penguin":"pets.Penguin",
            "Aquatic":"Pets.aquatic",
            "Spooky":"Pets.spooky",
            "Automaton":"Pets.automaton"
        };


        public static function getTranslationKey(_arg1:String):String
        {
            var _local2:String = keys[_arg1];
            return (((_local2) || ((((_arg1 == "? ? ? ?")) ? "Pets.miscellaneous" : ""))));
        }


    }
}

