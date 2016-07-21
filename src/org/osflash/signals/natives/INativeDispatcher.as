package org.osflash.signals.natives
{
    import org.osflash.signals.IPrioritySignal;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public interface INativeDispatcher extends IPrioritySignal 
    {

        function get eventType():String;
        function get eventClass():Class;
        function get target():IEventDispatcher;
        function set target(_arg1:IEventDispatcher):void;
        function dispatchEvent(_arg1:Event):Boolean;

    }
}

