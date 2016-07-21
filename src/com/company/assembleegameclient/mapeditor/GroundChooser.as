package com.company.assembleegameclient.mapeditor
{
    import com.company.assembleegameclient.mapeditor.Layer;
    import __AS3__.vec.Vector;
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.util.MoreStringUtil;
    import __AS3__.vec.*;
    import com.company.assembleegameclient.mapeditor.*;

    class GroundChooser extends Chooser 
    {

        public function GroundChooser()
        {
            var _local1:String;
            var _local3:int;
            var _local4:GroundElement;
            super(Layer.GROUND);
            var _local2:Vector.<String> = new Vector.<String>();
            for (_local1 in GroundLibrary.idToType_)
            {
                _local2.push(_local1);
            };
            _local2.sort(MoreStringUtil.cmp);
            for each (_local1 in _local2)
            {
                _local3 = GroundLibrary.idToType_[_local1];
                _local4 = new GroundElement(GroundLibrary.xmlLibrary_[_local3]);
                addElement(_local4);
            };
        }

    }
}

