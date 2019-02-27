package triqui
{
	import flash.display.Bitmap;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenTriquiGame extends Screen
	{
		public var background:Bitmap;
		
		public function ScreenTriquiGame()
		{
			super("");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		private function Spawn():void
		{
			background = Locator.assetsManager.GetImage("BackgroundTriqui");
			background.width = Locator.mainStage.stageWidth;
			background.height = Locator.mainStage.stageHeight;
			model.addChild(background);
		}
		
		public function returnToMenu():void{
			changeScreen("Menu");
		}
		
		public function evRemover():void{
			model.removeChild(background);
			background = null;
		}
		
		override public function EvOnExit():void{
			evRemover();
			super.EvOnExit();
		}
	}
}