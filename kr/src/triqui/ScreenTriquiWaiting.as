package triqui
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenTriquiWaiting extends Screen
	{
		public var screenWaiting: MovieClip;
		public function ScreenTriquiWaiting()
		{
			super("");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		private function Spawn():void
		{
			screenWaiting = Locator.assetsManager.GetMovieClip("MCwaiting");
			Locator.mainStage.addChild(screenWaiting);
		}
	}
}
