package com.company.assembleegameclient.mapeditor
{
    import com.company.assembleegameclient.mapeditor.Layer;
    import __AS3__.vec.Vector;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.MoreStringUtil;
    import __AS3__.vec.*;
    import com.company.assembleegameclient.mapeditor.*;

    class ObjectChooser extends Chooser 
    {

        public function ObjectChooser()
        {
            var _local1:String;
            var _local3:int;
            var _local4:XML;
            var _local5:ObjectElement;
            super(Layer.OBJECT);
            var _local2:Vector.<String> = new Vector.<String>();
            for (_local1 in ObjectLibrary.idToType_)
            {
                _local2.push(_local1);
            };
            _local2.sort(MoreStringUtil.cmp);
            for each (_local1 in _local2)
            {
                _local3 = ObjectLibrary.idToType_[_local1];
                _local4 = ObjectLibrary.xmlLibrary_[_local3];
                if (!((((_local4.hasOwnProperty("Item")) || (_local4.hasOwnProperty("Player")))) || ((_local4.Class == "Projectile"))))
                {
                    _local5 = new ObjectElement(_local4);
                    addElement(_local5);
                };
            };
        }

    }
}

