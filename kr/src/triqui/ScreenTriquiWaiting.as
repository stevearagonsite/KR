package triqui
{
	import flash.display.MovieClip;
	
	import engine.Locator;
	import engine.Screen;
	import net.Client;

	public class ScreenTriquiWaiting extends Screen
	{
		public var screenWaitingConnection: MovieClip;
		public var screenWaitingPlayer: MovieClip;
		
		public function ScreenTriquiWaiting()
		{
			super("");
			Locator.client.addEventListener(Client.EVENT_CONNECTED, evWaitingPlayer);
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		private function Spawn():void
		{
			screenWaitingConnection = Locator.assetsManager.GetMovieClip("MCWaitingConnection");
			Locator.mainStage.addChild(screenWaitingConnection);
		}
		
		private function evWaitingPlayer():void
		{	
			screenWaitingPlayer = Locator.assetsManager.GetMovieClip("MCWaitingPlayer");
			Locator.mainStage.addChild(screenWaitingPlayer);
		}
		
		
	}
}
