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
		
		override public function EvOnExit():void{
			super.EvOnExit();
		}
	}
}