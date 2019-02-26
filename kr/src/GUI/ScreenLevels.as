package GUI{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import engine.Locator;
	import engine.Screen;
	
	public class ScreenLevels extends Screen{
		
		public var background:Bitmap;
		public var triggers:MovieClip;
		
		public function ScreenLevels(){
			super("");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Main.instance.addEventListener("FinishedLevel", EvEndLevel);
			Spawn();
		}
		
		private function Spawn():void{
			background = Locator.assetsManager.GetImage("MenuLevels");
			model.addChild(background);
			background.width = Locator.mainStage.stageWidth;
			background.height = Locator.mainStage.stageHeight;
			
			triggers = Locator.assetsManager.GetMovieClip("MCtriggerMenuLevels");
			Locator.mainStage.addChild(triggers);
			triggers.blendMode = BlendMode.DIFFERENCE;
			triggers.filters = [new BlurFilter(5, 5, 5)];
			triggers.mc_Level1.alpha = 0;
			triggers.mc_Level2.alpha = 0;
			triggers.mc_Level3.alpha = 0;
			
			triggers.mc_Level1.addEventListener(MouseEvent.MOUSE_OVER, EvLevel1Over);
			triggers.mc_Level1.addEventListener(MouseEvent.MOUSE_OUT, EvLevel1Out);
			triggers.mc_Level1.addEventListener(MouseEvent.CLICK, EvLevel1Go);
			
			triggers.mc_Level2.addEventListener(MouseEvent.MOUSE_OVER, EvLevel2Over);
			triggers.mc_Level2.addEventListener(MouseEvent.MOUSE_OUT, EvLevel2Out);
			triggers.mc_Level2.addEventListener(MouseEvent.CLICK, EvLevel2Go);
			
			triggers.mc_Level3.addEventListener(MouseEvent.MOUSE_OVER, EvLevel3Over);
			triggers.mc_Level3.addEventListener(MouseEvent.MOUSE_OUT, EvLevel3Out);
			triggers.mc_Level3.addEventListener(MouseEvent.CLICK, EvLevel3Go);
		}
		
		private function EvLevel1Over(event:Event):void{
			triggers.mc_Level1.alpha = 1;
		}
		
		private function EvLevel1Out(event:Event):void{
			triggers.mc_Level1.alpha = 0;
		}
		
		private function EvLevel1Go(event:Event):void{
			EvRemover();
			Main.instance.EvLoadGame("level-1");
		}
		
		private function EvLevel2Over(event:Event):void{
			triggers.mc_Level2.alpha = 1;
		}
		
		private function EvLevel2Out(event:Event):void{
			triggers.mc_Level2.alpha = 0;
		}
		
		private function EvLevel2Go(event:Event):void{
			EvRemover();
			Main.instance.EvLoadGame("level-2");
		}
		
		private function EvLevel3Over(event:Event):void{
			triggers.mc_Level3.alpha = 1;
		}
		
		private function EvLevel3Out(event:Event):void{
			triggers.mc_Level3.alpha = 0;
		}
		
		private function EvLevel3Go(event:Event):void{
			EvRemover();
			Main.instance.EvLoadGame("level-3");
		}
		
		public function EvRemover():void{
			if (triggers != null){
				triggers.mc_Level1.removeEventListener(MouseEvent.MOUSE_OVER, EvLevel1Over);
				triggers.mc_Level1.removeEventListener(MouseEvent.MOUSE_OUT, EvLevel1Out);
				triggers.mc_Level1.removeEventListener(MouseEvent.CLICK, EvLevel1Go);
				
				triggers.mc_Level2.removeEventListener(MouseEvent.MOUSE_OVER, EvLevel2Over);
				triggers.mc_Level2.removeEventListener(MouseEvent.MOUSE_OUT, EvLevel2Out);
				triggers.mc_Level2.removeEventListener(MouseEvent.CLICK, EvLevel2Go);
				
				triggers.mc_Level3.removeEventListener(MouseEvent.MOUSE_OVER, EvLevel3Over);
				triggers.mc_Level3.removeEventListener(MouseEvent.MOUSE_OUT, EvLevel3Out);
				triggers.mc_Level3.removeEventListener(MouseEvent.CLICK, EvLevel3Go);
				
				Locator.mainStage.removeChild(triggers);
				triggers = null;
				
				model.removeChild(background);
				background = null;
			}
		}
		
		override public function EvOnExit():void{
			Locator.mainStage.removeEventListener("FinishedLevel", EvEndLevel);
			EvRemover();
			super.EvOnExit();
		}
		
		
		public function EvEndLevel(event:Event):void{
			changeScreen("Menu");
		}
		
	}
}