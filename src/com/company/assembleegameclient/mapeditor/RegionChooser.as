package com.company.assembleegameclient.mapeditor
{
    import com.company.assembleegameclient.map.RegionLibrary;

    public class RegionChooser extends Chooser 
    {

        public function RegionChooser()
        {
            var _local1:XML;
            var _local2:RegionElement;
            super(Layer.REGION);
            for each (_local1 in RegionLibrary.xmlLibrary_)
            {
                _local2 = new RegionElement(_local1);
                addElement(_local2);
            };
        }

    }
}

