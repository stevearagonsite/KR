package Characters{
	import engine.Locator;

	public class Brain{
		
		public var isPressing_Left:Boolean;
		public var isPressing_Right:Boolean;
		public var isPressing_Jump:Boolean;
		public var isPressing_Shoot:Boolean;
		public var isPressing_Attack:Boolean;
		
		public var objectControlled:Characters;
		public var isDestroyed:Boolean;
		public var color:String;
		
		public var keyCodeRight:int;
		public var keyCodeLeft:int;
		public var keyCodeJump:int;
		public var keyCodeAttack:int;
		public var keyCodeShoot:int;
		
		public function Brain(){
			trace("Brain ready...");
		}
		
		public function Config(objectControlled:Characters , keyCodeRight:int, keyCodeLeft:int, 
							   keyCodeJump:int, keyCodeAttack:int, keyCodeShoot:int, color:String):void{
			this.objectControlled = objectControlled;
			this.color = color;
			
			this.keyCodeRight = keyCodeRight;
			this.keyCodeLeft = keyCodeLeft;
			this.keyCodeJump = keyCodeJump;
			this.keyCodeAttack = keyCodeAttack;
			this.keyCodeShoot = keyCodeShoot;
			
			Locator.inputManager.setRelation(color+"Right",keyCodeRight);
			Locator.inputManager.setRelation(color+"Left",keyCodeLeft);
			Locator.inputManager.setRelation(color+"Jump",keyCodeJump);
			Locator.inputManager.setRelation(color+"Attack",keyCodeAttack);
			Locator.inputManager.setRelation(color+"Shoot",keyCodeShoot);
		}
		public function EvUpdate():void{
			if(Locator.inputManager.GetKey(keyCodeRight)){
				objectControlled.Move(1);
			}else if(Locator.inputManager.GetKey(keyCodeLeft))
				objectControlled.Move(-1);
			
			if(Locator.inputManager.GetKey(keyCodeJump))
				objectControlled.Jump();
			
			if(Locator.inputManager.GetKey(keyCodeShoot))
				objectControlled.Shoot(1);
			if(Locator.inputManager.GetKey(keyCodeAttack))
				objectControlled.Attack();
		}
		
		public function EvRemove():void{
			isDestroyed = true;
			objectControlled = null;
		}
	}
}