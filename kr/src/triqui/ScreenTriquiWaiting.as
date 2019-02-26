package triqui
{
	import flash.display.Bitmap;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenTriquiWaiting extends Screen
	{
		public static var instance:ScreenTriquiWaiting;
		public var screenWaitingConnection: Bitmap;
		public var screenWaitingPlayer: Bitmap;
		
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
			screenWaitingConnection = Locator.assetsManager.GetImage("ServerConnection");
			screenWaitingConnection.width = Locator.mainStage.stageWidth;
			screenWaitingConnection.height = Locator.mainStage.stageHeight;
			model.addChild(screenWaitingConnection);
		}
		
		public function evWaitingPlayer():void
		{	
			// Clean screen.
			model.removeChild(screenWaitingConnection);
			screenWaitingConnection = null;
			// Re-painting
			screenWaitingPlayer = Locator.assetsManager.GetImage("WaitingForPlay");
			screenWaitingPlayer.width = Locator.mainStage.stageWidth;
			screenWaitingPlayer.height = Locator.mainStage.stageHeight;
			model.addChild(screenWaitingPlayer);
		}
		
		public function havePartner():void{
			trace("ready online!!");
			changeScreen("TriquiGame");
		}
		
		public function evRemover():void{
			if (screenWaitingConnection || screenWaitingPlayer){
				model.removeChild(screenWaitingConnection);
				screenWaitingConnection = null;
				model.removeChild(screenWaitingPlayer);
				screenWaitingPlayer = null;
			}
		}
		
		override public function EvOnExit():void{
			//evRemover();
			super.EvOnExit();
		}
	}
}
