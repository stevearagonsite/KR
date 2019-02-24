package Characters
{
	import flash.display.MovieClip;
	
	import engine.Locator;

	public class Bullet{
		public var damage:int = 15;
		public const speed:int = 5;
		public const rotation:int = 1;
		public var color:String;
		public var model:MovieClip;
		public var isDestroyed:Boolean;
		public var direction:int;
		
		public function Bullet(){
			trace("bullet ready");
		}
		
		public function Spawn(color:String, direction:int, posX, posY):void{
			this.color = color;
			this.direction = direction;
			EvModel();
			Locator.layer3.addChild(model);
			model.mc_trigger.visible = false;
			model.x = posX;
			model.y = posY;
		}
		
		public function EvUpdate():void{
			if (model != null && !isDestroyed){
				model.x += speed * direction;
				model.rotation += rotation;
				if (model.x > Locator.mainStage.stageWidth + model.width/2 || model.x < 0 - model.width/2)
					EvRemove();
			}
		}
		
		private function EvModel():MovieClip{
			if (color == "blue"){
				model = Locator.assetsManager.GetMovieClip("MCbulletBlue");
				return model;
			}else if (color == "red"){
				model = Locator.assetsManager.GetMovieClip("MCbulletRed");
				return model;
			}
			return null;
		}
		
		public function EvRemove():void{
			if (!isDestroyed){
				Locator.layer3.removeChild(model);
				isDestroyed = true;
				model = null;
			}
		}
	}
}