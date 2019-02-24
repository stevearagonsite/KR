package triqui
{
	import flash.display.MovieClip;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenTriquiWaiting extends Screen
	{
		public var screenWaitingConnection: MovieClip;
		public var screenWaitingPlayer: MovieClip;
		public static var instance:ScreenTriquiWaiting;
		
		public function ScreenTriquiWaiting()
		{
			super("");
			instance = this;
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		public function Spawn():void
		{
			screenWaitingConnection = Locator.assetsManager.GetMovieClip("MCWaitingConnection");
			Locator.mainStage.addChild(screenWaitingConnection);
		}
		
		public function evWaitingPlayer():void
		{	
			// Clean screen.
			Locator.mainStage.removeChild(screenWaitingConnection);
			screenWaitingConnection = null;
			// Re-painting
			screenWaitingPlayer = Locator.assetsManager.GetMovieClip("MCWaitingPlayer");
			Locator.mainStage.addChild(screenWaitingPlayer);
		}
	}
}
