package triqui
{
	import flash.display.Bitmap;
	import flash.utils.setTimeout;
	
	import engine.Locator;
	import engine.Screen;

	public class ScreenTriquiLostPartner extends Screen{
		
		public var screenLostPartner: Bitmap;
		
		public function ScreenTriquiLostPartner(){
			super("");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		private function Spawn():void
		{
			screenLostPartner = Locator.assetsManager.GetImage("LostPartner");
			screenLostPartner.width = Locator.mainStage.stageWidth;
			screenLostPartner.height = Locator.mainStage.stageHeight;
			model.addChild(screenLostPartner);
			setTimeout(executionByTime, 3000);
		}
		
		private function executionByTime():void
		{
			changeScreen("Menu");
		}
		
		private function evRemove():void
		{
			if (screenLostPartner){
				model.removeChild(screenLostPartner);
				screenLostPartner = null;
			}
		}
				
		override public function EvOnExit():void{
			evRemove();
			super.EvOnExit();
		}
	}
}