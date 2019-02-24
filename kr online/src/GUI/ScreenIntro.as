package GUI{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import engine.Screen;
	
	public class ScreenIntro extends Screen{
		
		public function ScreenIntro(){
			super("MCIntro");
			Main.RemoveStartEvents();
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			model.addEventListener(MouseEvent.CLICK, EvSkip);
			model.addEventListener("EndIntro", EvEndIntro);
		}
		
		protected function EvEndIntro(event:Event):void{
			changeScreen("Menu");
		}
		
		protected function EvSkip(event:MouseEvent):void{
			changeScreen("Menu");
		}
		
		override public function EvOnExit():void{
			model.removeEventListener(MouseEvent.CLICK, EvSkip);
			model.removeEventListener("EndIntro", EvEndIntro);
			model.stop();
			super.EvOnExit();
		}
	}
}