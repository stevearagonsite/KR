package engine
{
	import flash.events.Event;
	
	public class ScreenEvent extends Event
	{
		public static const ENTER:String = "enter";
		public static const EXIT:String = "exit";
		public static const UPDATE:String = "update";
		public static const CHANGE:String = "change";
		
		public var targetScreen:String;
		public var params:Array;
		
		public function ScreenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return this;
		}
	}
}