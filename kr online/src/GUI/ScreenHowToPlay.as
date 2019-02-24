package GUI
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenHowToPlay extends Screen{
		
		public var background:Bitmap;
		
		public function ScreenHowToPlay(){
			super("");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();	
			Spawn();
		}
		
		private function Spawn():void{
			background = Locator.assetsManager.GetImage("BackgroundHowToPlay");
			model.addChild(background);
			background.width = Locator.mainStage.stageWidth;
			background.height = Locator.mainStage.stageHeight;
			Locator.mainStage.addEventListener(MouseEvent.MOUSE_DOWN, EvSkip);
		}
		
		protected function EvSkip(event:MouseEvent):void{
			changeScreen("Menu");
		}
		
		override public function EvOnExit():void{
			Locator.mainStage.removeEventListener(MouseEvent.MOUSE_DOWN, EvSkip);
			model.removeChild(background);
			background = null;
			super.EvOnExit();
		}
	}
}