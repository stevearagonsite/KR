package Elements
{
	import flash.display.MovieClip;
	
	import engine.Locator;

	public class PlatformsMove
	{
		public var model:MovieClip;
		public const velocity:Number = 0.9;
		public var direction:int = 1;
		public var isDestroyed:Boolean = false;
		public var type:String = "none";//verticalDestroy, horizontalDestroy , verticarMove, horizontalMove
		
		public function PlatformsMove(){
		}
		/** i need a movieclip of a position(posX and posY), type: verticalDestroy, horizontalDestroy (set this value)*/
		public function Spawn(posX:int, posY:int):void{
			model = Locator.assetsManager.GetMovieClip("MCplataformMove");
			Locator.layer1.addChild(model);
			model.x = posX;
			model.y = posY;
			model.alpha = 0.5;
			model.mc_floor.visible = false;
			Locator.allPlatforms.push(model.mc_floor);
			type = "verticalDestroy";
		}
		
		/** i need a movieclip of type platformMove, type: verticarMove, horizontalMove(set this value)*/
		public function SetPlatform(model:MovieClip, type:String = "none"):void{
			this.model = model;
			this.type = type;
			model.alpha = 0.5;
			model.mc_floor.visible = false;
			Locator.allPlatforms.push(model.mc_floor);
		}
		
		public function EvUpdate():void{
			if (model != null){
				switch(type){
					case "verticalDestroy":{
						EvMovePlaformVerticalDestroy();
						break;
					}
						
					case "horizontalDestroy":{
						
						break;
					}
						
					case "verticarMove":{
						EvMovePlaformVerticalMove();
						break;
					}
						
					case "horizontalMove":{
						EvMovePlaformHorizontalMove();
						break;
					}
				}
			}
		}
		
		private function EvMovePlaformHorizontalMove():void{
			model.x += velocity * direction;
		
			if (model.hitTestObject(Locator.characterBlue.model.mc_hitCenter))
				Locator.characterBlue.model.x += velocity * direction;

			for (var i:int = Locator.allPlataformsMoveReference.length-1; i >= 0; i--) {
				if (Locator.platforms != null && model.hitTestObject(Locator.allPlataformsMoveReference[i]))
					direction *= -1;
			}
		}
		
		private function EvMovePlaformVerticalMove():void{
			model.y += velocity * direction;
			for (var i:int = Locator.allPlataformsMoveReference.length-1; i >= 0; i--) {
				if (Locator.platforms != null && model.hitTestObject(Locator.allPlataformsMoveReference[i]))
					direction *= -1;
			}
		}
		
		private function EvMovePlaformVerticalDestroy():void{
			model.y += velocity;
			if (Locator.platforms != null && model.hitTestObject(Locator.platforms.mc_referenceEnd))
				Remove();
		}
		
		public function Remove():void{
			if (!isDestroyed){
				var i:int = Locator.allPlatforms.indexOf(model.mc_floor);
				//Delete Locator.allPlatforms[i];//this method delted an element for vector.
				Locator.allPlatforms.splice(i,1);
				if (Locator.currentLevel == "level-1"){
					Locator.layer1.removeChild(model);
					model = null;
				}
				isDestroyed = true;
				//Locator.allPlatforms[i] = null;
			}
		}		
	}
}