package Characters
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import Ambient.SoundController;
	
	import engine.Locator;

	public class Characters{
		
		public var speed:int;
		public var model:MovieClip;
		public var color:String;
		public var damage:int;
		
		public var isDestroyed:Boolean = false;
		protected var collisionUp:Boolean = false;
		protected var collisionDown:Boolean = false;
		public var isLocked:Boolean;
		public var isJumping:Boolean;
		public var currentScale:Number = 1;
		public var weight:Number = 0.2;
		public var jumpForce:Number = 35;
		public var direction:int;
		
		public const ANIM_IDLE:String = "idle";
		public const ANIM_RUN:String = "run";
		public const ANIM_SHOOT:String = "shoot";
		public const ANIM_JUMP:String = "jump";
		public const ANIM_FALL:String = "fall";
		public const ANIM_ATTACK:String = "hit";
		public const ANIM_DIE:String = "die";
		
		public var velocity:Point = new Point(0, 0);
		public var gravity:Point = new Point(0, 1);
		
		public var bullet:Bullet;
		public var audioHitFloor:SoundController;
		public var audioShoot:SoundController;
		public var audioDamage:SoundController;
		public var audioDie:SoundController;
		public var audioLoop:SoundController;
		public var audioAttack:SoundController;
		public var audioJump:SoundController;
		
		public function Characters(){
			trace("Ready character...");
		}
		
		//Initials parameters
		public function Spawn(speed:int, color:String, posX:int, posY:int, direction:int, damage:int,
							  audioAttack:Sound, audioLoop:Sound):void{
			this.speed = speed;
			this.model = model;
			this.color = color.toLowerCase();
			this.direction = direction;
			this.damage = damage;
			this.audioLoop = new SoundController(audioLoop);
			this.audioAttack = new SoundController(audioAttack);
			audioHitFloor = new SoundController(Locator.assetsManager.GetSound("SNDhitFloor"));
			audioShoot = new SoundController(Locator.assetsManager.GetSound("SNDshoot"));
			audioDamage = new SoundController(Locator.assetsManager.GetSound("SNDdamage"));
			audioDie = new SoundController(Locator.assetsManager.GetSound("SNDdie"));
			audioJump = new SoundController(Locator.assetsManager.GetSound("SNDjump"));
				
			modelAwake();
			
			Locator.layer2.addChild(model);
			model.scaleX = this.direction * currentScale;
			
			model.mc_hitCenter.visible = false;
			model.mc_hitFoot.visible = false;
			model.mc_hitUp.visible = false;
			model.mc_hitFront.visible = false;
			
			model.x = posX;
			model.y = posY;
			
			model.scaleX = model.scaleY = currentScale;
			model.addEventListener("unlock", EvUnlock);
		}
		
		private function modelAwake():MovieClip{
			if (color == "red"){
				model = Locator.assetsManager.GetMovieClip("MCrobotRed");
				return model;
			}else if(color == "blue"){
				model = Locator.assetsManager.GetMovieClip("MCrobotBlue");
				return model;
			}
			return null;
		}
		
		public function EvUpdate():void{
			if (model != null){
				
				model.x += velocity.x;
				model.y += velocity.y;
				/*velocity.x += gravity.x * weight;*/
				velocity.y += gravity.y * weight;
				
				if(velocity.y > 0){
					CheckCollisionWithFoots();
					if(velocity.y != 0 && model.currentLabel != ANIM_ATTACK){
						changeAnimation(ANIM_FALL);
						isLocked = false;
					}
					
				}else
					CheckCollisionWithUp()
				
				if(velocity.x == 0 && velocity.y == 0 && !isLocked)
					changeAnimation(ANIM_IDLE);
				
				CheckCollisionWithFront();
				EvUpdatePositionTravel();
				EvCheckWithPlataformDamage();
				
				if(!isJumping)
					velocity.x = 0;
				if(model.y > Locator.mainStage.stageHeight + model.height)
					EvDamage(99);
				if(collisionDown && collisionUp){
					EvDamage(99);
				}else{collisionDown = collisionUp = false;}
			}
		}
		
		public function Move(direction:int):void{
			if (!isDestroyed && model.currentLabel != ANIM_ATTACK){
				this.direction = direction;
		
				if (direction > 0){
					model.scaleX = 1 * currentScale;
				}else if (direction < 0){
					model.scaleX = -1 * currentScale;
				}
					
				velocity.x = speed *  direction;
				if(!isJumping){
					changeAnimation(ANIM_RUN);
				}
			}
		}
		
		public function Attack():void{
			if (!isDestroyed && model.currentLabel != ANIM_ATTACK){
				isLocked = true;
				changeAnimation(ANIM_ATTACK);
				audioAttack.play();
				audioAttack.volume = 0.5;
				audioAttack.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
			}
		}
		
		public function Shoot(direction:int):void{
			if (!isDestroyed){
				isLocked = true;
				changeAnimation(ANIM_SHOOT);
				model.addEventListener("newBullet", NewBullet);
			}
		}
		
		protected function NewBullet(event:Event):void{
			model.mc_reference.visible = false;
			audioShoot.play();
			audioShoot.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
			EvBullet(direction * model.mc_reference.x + model.x, model.y + model.mc_hitCenter.y/2);
		}
		
		protected function EvUnlock(event:Event):void{
			isLocked = false;
		}
		
		private function EvBullet(posX:int, posY:int):void{
			bullet = new Bullet;
			bullet.Spawn(color,direction,posX,posY);
			Locator.allBullets.push(bullet);
		}
		
		public function changeAnimation(name:String):void{
			if(model.currentLabel != name){
				model.gotoAndPlay(name);
			}
		}
		
		public function EvDamage(damage:Number):void{
			if (!isDestroyed){
				if (color == "red"){	
					Locator.lifeRed -= damage;
					if(Locator.lifeRed < 1)
						Die();
				}else if (color == "blue"){
					Locator.lifeBlue -= damage;
					if(Locator.lifeBlue < 1)
						Die();
				}
			}
		}
		
		public function Die():void{
			audioDie.play();
			audioDie.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
			changeAnimation(ANIM_DIE);
			isLocked = true;
			isDestroyed = true;
		}
		
		public function Jump():void{
			if(!isJumping && !isLocked && !isDestroyed){
				velocity.y = -jumpForce * weight;
				isJumping = true;
				changeAnimation(ANIM_JUMP);
				audioJump.play();
				audioJump.volume = 0.04;
				audioJump.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
			}
		}
		
		private function EvUpdatePositionTravel():void{
			if (model != null){
				if(model.hitTestObject(Locator.platforms.mc_positionRed)){
					model.x = Locator.platforms.mc_positionBlue.x + Locator.platforms.mc_positionBlue.parent.x + model.width;
				}else if(model.hitTestObject(Locator.platforms.mc_positionBlue)){
					model.x = Locator.platforms.mc_positionRed.x +Locator.platforms.mc_positionRed.parent.x - model.width;
				}
			}
		}
		
		private function EvCheckWithPlataformDamage():void{
			if (model != null){
				for (var i:int = Locator.allDamages.length-1; i >= 0; i--) {
					if (model.mc_hitCenter.hitTestObject(Locator.allDamages[i])){
						EvDamage(0.1);
						if (audioDamage != null && !audioDamage.isPlay){
							audioDamage.play();
							audioDamage.volume = 0.3;
							audioDamage.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
						}
					}
				}
			}
		}
		
		private function CheckCollisionWithFront():void{
			for (var i:int = 0; i < Locator.allPlatforms.length; i++) {
				if(model.mc_hitFront.hitTestObject(Locator.allPlatforms[i])){
					if (direction > 0){
						model.x = Locator.allPlatforms[i].x + Locator.allPlatforms[i].parent.x  -
							(model.mc_hitCenter.width/2 * currentScale);
					}else if(direction < 0){
						model.x = Locator.allPlatforms[i].x + Locator.allPlatforms[i].parent.x +
							Locator.allPlatforms[i].width  + (model.mc_hitCenter.width/2 * currentScale);
					}
					velocity.x = 0;
				}
			}
		}
		
		private function CheckCollisionWithUp():void{
			for (var i:int = 0; i < Locator.allPlatforms.length; i++) {
				if(model.mc_hitUp.hitTestObject(Locator.allPlatforms[i])){
					velocity.y = 0;
					collisionUp = true;
					audioHitFloor.play();
					audioHitFloor.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;	
				}
			}
		}
		
		public function CheckCollisionWithFoots():void{
			for (var i:int = 0; i < Locator.allPlatforms.length; i++) {
				if(model.mc_hitFoot.hitTestObject(Locator.allPlatforms[i])){
					
					model.y = (Locator.allPlatforms[i].y + Locator.allPlatforms[i].parent.y) -
						model.mc_hitCenter.height * currentScale;
					
					velocity.y = 0;
					isJumping = false;
					collisionDown = true;
					
					if (audioLoop != null && !audioLoop.isPlay){
						audioLoop.play();
						audioLoop.volume = 0.03;
						audioLoop.pan = model.x * 2 / Locator.mainStage.stageWidth - 1;
					}
				}
			}
		}
		
		public function EvDestroyed():void{
			if (model != null){
				
				isDestroyed = true;
				if (audioLoop.isPlay)
					audioLoop.stop();
				
				audioLoop = audioAttack = audioHitFloor = audioShoot = audioDamage = audioDie = null;
				
				Locator.layer2.removeChild(model);
				model = null;
			}
		}
	}
}