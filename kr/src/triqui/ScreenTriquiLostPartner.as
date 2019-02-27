package triqui
{
	import flash.display.Bitmap;
	
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
			changeScreen("TriquiGame");
		}
		
		override public function EvOnExit():void{
			super.EvOnExit();
		}
	}
}