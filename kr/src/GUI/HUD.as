package GUI 
{
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	
	import engine.Locator;

	public class HUD{
		public var model:MovieClip
		public var lifeRed:int;
		public var lifeBlue:int;
		public var pointsRed:int = 1;
		public var pointsBlue:int = 1;
		public var minRes:int;
		public var isDestroyed:Boolean = false;
		
		public function HUD(){
			trace("Ready HUD...");
		}
		
		public function Spawn():void{
			model = Locator.assetsManager.GetMovieClip("MChud");
			Locator.layer4.addChild(model);
			model.mc_lifeBlue.gotoAndStop(100);
			model.mc_lifeRed.gotoAndStop(100);
			model.mc_pointsBlue.gotoAndStop(1);
			model.mc_pointsRed.gotoAndStop(1);
			
			model.mc_lifeBlue.blendMode = BlendMode.MULTIPLY;
			model.mc_lifeRed.blendMode = BlendMode.OVERLAY;
			model.mc_pointsBlue.blendMode = BlendMode.MULTIPLY;
			model.mc_pointsRed.blendMode = BlendMode.OVERLAY;
	
			Locator.currentTimeToFinishGame > 60000 ? minRes = Locator.currentTimeToFinishGame - 60000: minRes = 0;
		}
		
		public function EvUpdate():void{
			if (model != null){
				EvUpdateLife();
				EvUpdateTime();
				EvUpdatePoints();
			}
		}
		
		private function EvUpdatePoints():void{
			model.mc_pointsBlue.gotoAndStop(pointsBlue);
			model.mc_pointsRed.gotoAndStop(pointsRed);
		}
		
		private function EvUpdateTime():void{
			var min:int = (Locator.currentTimeToFinishGame/1000)/60;
			var seg:int = (Locator.currentTimeToFinishGame - min * 60000)/1000;
			if (min >= 1){
				model.tb_time.text = "0"+min+":"+seg;
				if (seg < 10)
					model.tb_time.text = "0"+min+":0"+seg;
			}else if (min < 1){
				model.tb_time.text = "00"+":"+seg;
				if (seg < 10)
					model.tb_time.text = "0"+min+":0"+seg;
			}
		}
		
		private function EvUpdateLife():void{
			var blue:int = Locator.lifeBlue;
			model.mc_lifeBlue.gotoAndStop(blue);
			
			var red:int = Locator.lifeRed;
			model.mc_lifeRed.gotoAndStop(red);
		}
		
		public function EvRemove():void{
			if (model != null){
				isDestroyed = true;
				Locator.layer4.removeChild(model);
				model = null;
			}
		}
		
	}
}