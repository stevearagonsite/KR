package Elements {
	import flash.display.MovieClip;
	
	import engine.Locator;

	public class Goal{
		
		public const rotation:int = 3; 
		public var color:String;
		public var model:MovieClip;
		public var isDestroyed:Boolean;
		
		public function Goal(){
			trace("Ready point");
		}
		
		public function Spawn(posX:int, posY:int, color:String):void{
			this.color = color;
			modelPainting();
			model.mc_trigger.visible = false;
			model.mc_rotation.alpha = 0.5;
			model.x = posX;
			model.y = posY;
		}
		
		private function modelPainting():void{
			if (color == "red"){
				model = Locator.assetsManager.GetMovieClip("MCgoalRed");			
			}else if (color == "blue")
				model = Locator.assetsManager.GetMovieClip("MCgoalBlue");			
			Locator.layer1.addChild(model);
		}
		
		public function EvUpdate():void{
			if (model != null)
				model.mc_rotation.rotation += rotation;
		}
		
		public function EvRemove():void{
			if (model != null){
				Locator.layer1.removeChild(model);
				
				model = null;
				isDestroyed = true;
			}
		}
		
	}
}