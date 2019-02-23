package engine
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import Ambient.Camera2D;
	import Ambient.SoundController;
	
	import Characters.Characters;
	
	import Elements.Goal;
	import Elements.PlatformsMove;
	
	import GUI.HUD;
	import GUI.ScreenMenu;
	
	import net.Client;
	

	public class Locator extends Sprite{
		
		public static var console:Console;
		public static var assetsManager:AssetsManager;
		public static var updateManager:UpdateManger;
		public static var inputManager:InputManager;
		public static var screenManager:ScreenManager;
		public static var saveManagerPro:SaveManagerPro;
		
		public var menu:ScreenMenu;
		private var stateFullScreen:Boolean;
		private var isPause:Boolean = false;
		private var TimeRun:Boolean = true;
		public static var mainStage:Stage;
		public static var instance:Locator;
		
		public var soundController:SoundController;
		
		public static var cam:Camera2D;
		public static var camReference:MovieClip;
		public static var framework:MovieClip;
		public static var fXfront:Bitmap;
		public static var level:Sprite = new Sprite;//Here save my assets games for the camera.
		public static var layer0:Sprite = new Sprite;//it is in the stage as background and this is out from the camera.
		public static var layer1:Sprite = new Sprite;//Animation for my level and collisions checkers.
		public static var layer2:Sprite = new Sprite;//Here is my skin for plataform.
		public static var layer3:Sprite = new Sprite;//Here heros.
		public static var layer4:Sprite = new Sprite;//Here Front FX and this is out from the camera.
		public static var currentLevel:String = "Nothing";
		
		public static var backgroundGameBlue:Bitmap;
		public static var backgroundGameRed:Bitmap;
		public static var skinPlataform:Bitmap;
		public static var platforms:MovieClip;
		public static var hud:HUD;
		public static var characterBlue:Characters;
		public static var characterRed:Characters;
		public static var nameRed:String = "ROBOT RED";
		public static var nameBlue:String = "ROBOT BLUE";
		public var plataformsMove:PlatformsMove;
		public var goal:Goal;
		
		public static var lifeRed:Number = 100;
		public static var lifeBlue:Number = 100;
		public static var speed:Number = 3;
		public static var force:Number = 2;
		
		public static var allPlatforms:Vector.<MovieClip> = new Vector.<MovieClip>();
		//I save the all plataforms for the collisions.
		public static var allDamages:Vector.<MovieClip> = new Vector.<MovieClip>();
		//I save the all triggers for the collisions damage.
		public static var allPlataformsMove:Array = new Array;//I save the plataforms with be moving.
		public static var allPlataformsMoveReference:Vector.<MovieClip> = new Vector.<MovieClip>();//I save the plataformsReference for the direction platform.
		public static var allBrains:Array = new Array;//I save the all brains or control managers.
		public static var allPoints:Array = new Array;//I save the all points.
		public static var allBullets:Array = new Array;//I save the all bullets.
		
		private static var _timeToSpawnPlataforms:int = 5000;
		private static var _currentTimeToSpawnPlataforms1:Number = _timeToSpawnPlataforms;
		private static var _currentTimeToSpawnPlataforms2:Number = _timeToSpawnPlataforms;
		public static var currentTimeToFinishGame:Number = timeToFishGame;
		public static var timeToFishGame:int = 150000;
		public static var timerEnd:Timer;
		public var win:MovieClip;
		
		public static var client:Client;
		
		public static var audioTrackRed:SoundController;
		public static var audioTrackBlue:SoundController;
		public static var audioDamageShoot:SoundController;
		public static var audioDamage:SoundController;
		public static var audioWin:SoundController;
		public static var audioPoint:SoundController;
		
		public function Locator(){
			instance = this;
			mainStage = stage;
			console = new Console;
			assetsManager = new AssetsManager();
			updateManager = new UpdateManger();
			screenManager = new ScreenManager();
			inputManager = new InputManager();
			saveManagerPro = new SaveManagerPro();
			cam = new Camera2D();
						
			//mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;//here i can scale the elements
			mainStage.scaleMode = StageScaleMode.EXACT_FIT;//here scale the elements
			
			mainStage.addChild(layer0);
			level.addChild(layer1);
			level.addChild(layer2);
			level.addChild(layer3);
			
			stateFullScreen = true;//Default value state;
			console.RegisterCommand("triqui", EvTriqui, "Online game triqui!!.");
			mainStage.addEventListener(KeyboardEvent.KEY_UP, EvKeys);
		}
		
		private function EvTriqui():void
		{
			console.UnRegisterCommand("triqui");
			client = new Client("TheProfe" + Math.random());
			client.connect("192.168.0.248",8087);
			trace("Play triqui online!!");
		}
		
		public function Game():void{
			
			console.RegisterCommand("pause", EvPause, "Is the command pause the game(the animations and the controls).");
			console.RegisterCommand("resume", EvResume, "Is the command unpause the game(the animations and the controls are run now).");
			console.RegisterCommand("remove", EvRemove, "Is the command destroyed all assets(all is remove and now is null).");
			console.RegisterCommand("winner", EvWhoWin, "Who is the winner");
			console.RegisterCommand("online", EvSave, "game tic.");
			console.RegisterCommand("save", EvSave, "I save the game.");
			console.RegisterCommand("load", EvLoad, "I load the game.");
			
			updateManager.AddFunction(EvUpdates);
		}
		
		public function EvSave():void{
			if (characterBlue != null && characterRed != null){
				
				var d:Dictionary = new Dictionary();
				//d["user"] = "Pepito";
				
				d["varPositionBlueX"] = characterBlue.model.x;
				d["varPositionBlueY"] = characterBlue.model.y;
				d["varPositionRedX"] = characterRed.model.x;
				d["varPositionRedY"] = characterRed.model.y;
				d["varRedLife"] = lifeRed;
				d["varBlueLife"] = lifeBlue;
				d["varRedPoints"] = hud.pointsRed;
				d["varBluePoints"] = hud.pointsBlue;
				d["varTimeFinishGame"] = currentTimeToFinishGame;
				
				Locator.saveManagerPro.SaveEncrypted( d );
			}
		}
		
		public function EvLoad():void{
			
			Locator.saveManagerPro.LoadEncrypted();
			var d:Dictionary = Locator.saveManagerPro.dataLoaded;
			if (saveManagerPro.haveSave){
				
				characterBlue.model.x = d["varPositionBlueX"];
				characterBlue.model.y = d["varPositionBlueY"];
				characterRed.model.x = d["varPositionRedX"];
				characterRed.model.y = d["varPositionRedY"];
				lifeRed = d["varRedLife"];
				lifeBlue = d["varBlueLife"];
				hud.pointsRed = d["varRedPoints"];
				hud.pointsBlue = d["varBluePoints"];
				currentTimeToFinishGame = d["varTimeFinishGame"];
			}
		}
		
		protected function EvUpdates(event:Event):void{
			EvUpdateWinnerState();
			EvUpdateCharacters();
			EvUpdateBrains();
			EvUpdateDetails();
			EvUpdatePoints();
			EvUpdateBullets();
			EvUpdateCollisions();
			EvUpdatePlataformsMove();
			EvUpdateCam();
			EvTimeToFishGame();
			EvUpdateTimeToSpawnPlataforms();
			
		}
		
		private function EvUpdateCam():void{
			//The cam pause becouse the charaterBlue or the characterRed is null.
			if (cam != null && characterBlue != null && characterRed != null &&
				cam.isActive && !characterBlue.isDestroyed && !characterRed.isDestroyed){
				var referenceX:int;
				var referenceY:int;
				
				if (characterBlue.model.x > characterRed.model.x){
					referenceX = characterRed.model.x;
				}else
					referenceX = characterBlue.model.x;
				
				if (characterBlue.model.y > characterRed.model.y){
					referenceY = characterRed.model.y;
				}else
					referenceY = characterBlue.model.y;
				
				var x:Number = 1;
				var i:Number = referenceX + Math.abs(characterRed.model.x - characterBlue.model.x)/2;
				var j:Number = referenceY + Math.abs(characterRed.model.y - characterBlue.model.y)/2+5;
				
				x = mainStage.stageWidth / Math.abs(characterRed.model.x - characterBlue.model.x)-0.5;
				if (x >= 2)x = 2;
				if (x <= 1)x = 1;
				
				
				/*if (characterBlue.model.x > mainStage.stageWidth || characterRed.model.x > mainStage.stageWidth ||
					characterBlue.model.y > mainStage.stageHeight || characterRed.model.y > mainStage.stageHeight || 
					characterBlue.model.x < 0 || characterRed.model.x < 0 ||
					characterBlue.model.y < backgroundGameBlue.y || characterRed.model.y < backgroundGameRed.y){
					cam.smoothZoom = 1.2;
				}else{
					cam.zoom = x;
				}*/
				
				
				camReference.x = i;
				camReference.y = j;
				cam.zoom = x;
				cam.lookAt(camReference);
			}
		}
		
		private function EvUpdateTimeToSpawnPlataforms():void{
			if (currentLevel == "level-1" && TimeRun && platforms != null){
				_currentTimeToSpawnPlataforms1 -= 1000/mainStage.frameRate;
				_currentTimeToSpawnPlataforms2 -= 1000/mainStage.frameRate;
				if (_currentTimeToSpawnPlataforms1 <= 0){
					_currentTimeToSpawnPlataforms1 = _timeToSpawnPlataforms;
					plataformsMove = new PlatformsMove;
					plataformsMove.Spawn(platforms.mc_reference1.x,platforms.mc_reference1.y);
					allPlataformsMove.push(plataformsMove);
				}
				if (_currentTimeToSpawnPlataforms2 <= 0){
					_currentTimeToSpawnPlataforms2 = _timeToSpawnPlataforms;
					plataformsMove = new PlatformsMove;
					plataformsMove.Spawn(platforms.mc_reference2.x,platforms.mc_reference2.y);
					allPlataformsMove.push(plataformsMove);
				}
			}
		}
		
		private function EvUpdateWinnerState():void{
			var currentWinner:String = EvCurrentWinner();

			if (backgroundGameBlue != null &&
				backgroundGameRed != null && currentWinner == nameRed){
				backgroundGameBlue.visible = false;
				backgroundGameRed.visible = true;
				if (audioTrackRed != null && audioTrackBlue != null
					&& audioTrackBlue.volume > 0.1 || audioTrackRed.volume < 0.4){
					audioTrackBlue.volume -= 0.01;
					audioTrackRed.volume += 0.01;
				}
			}else if (backgroundGameBlue != null &&
				backgroundGameRed != null && currentWinner == nameBlue){
				backgroundGameBlue.visible = true;
				backgroundGameRed.visible = false;
				if (audioTrackRed != null && audioTrackBlue != null
				&& audioTrackRed.volume > 0.1 || audioTrackBlue.volume < 0.3){
					audioTrackBlue.volume += 0.01;
					audioTrackRed.volume -= 0.01;
				}
			}
		}
		
		private function EvTimeToFishGame():void{
			if (TimeRun){
				currentTimeToFinishGame -= 1000/Locator.mainStage.frameRate;
				if (currentTimeToFinishGame < 0)
					EvWhoWin();
				
				if (hud != null && hud.pointsBlue == 4 || hud.pointsRed ==4)	
					EvWhoWin();

				if (characterBlue.model != null && characterRed.model != null
				&& characterBlue.model.currentLabel == characterBlue.ANIM_DIE
				|| characterRed.model.currentLabel == characterRed.ANIM_DIE)
					EvWhoWin();
			}
		}
		
		private function EvUpdateCollisions():void{
			for (var i:int = allPoints.length-1; i >= 0; i--) {
				if (characterBlue != null && allPoints[i] != null && allPoints[i].color == "blue" &&
					allPoints[i].model.mc_trigger.hitTestObject(characterBlue.model.mc_hitCenter)){
					EvFxGoal(allPoints[i].model.x,allPoints[i].model.y);
					allPoints[i].EvRemove();
					hud.pointsBlue ++;
				}
				if (characterRed != null && allPoints[i] != null && allPoints[i].color == "red" &&
					allPoints[i].model.mc_trigger.hitTestObject(characterRed.model.mc_hitCenter)){
					EvFxGoal(allPoints[i].model.x,allPoints[i].model.y);
					allPoints[i].EvRemove();
					hud.pointsRed ++;
				}
			}
			
			for (var j:int = allBullets.length-1; j >= 0; j--) {
				if (allBullets[j] != null && !allBullets[j].isDestroyed){
					
					if (characterBlue != null && allBullets[j].color == "red" &&
						allBullets[j].model.mc_trigger.hitTestObject(characterBlue.model.mc_hitCenter)){
						EvFxBullet(allBullets[j].model.x,allBullets[j].model.y);
						characterBlue.EvDamage(allBullets[j].damage);
						allBullets[j].EvRemove();
					}
					
					if (characterRed != null && allBullets[j].color == "blue" &&
						allBullets[j].model.mc_trigger.hitTestObject(characterRed.model.mc_hitCenter)){
						EvFxBullet(allBullets[j].model.x,allBullets[j].model.y);
						characterRed.EvDamage(allBullets[j].damage);
						allBullets[j].EvRemove();
					}
					
					for (var k:int = allBullets.length-1; k >= 0; k--) {
						if (k != j && allBullets[k] != null && !allBullets[k].isDestroyed &&
							allBullets[j] != null && !allBullets[j].isDestroyed &&
							allBullets[j].model.mc_trigger.hitTestObject(allBullets[k].model.mc_trigger)){
							EvFxBullet(allBullets[j].model.x,allBullets[j].model.y);
							allBullets[j].EvRemove();
							allBullets[k].EvRemove();
						}
					}
				}
			}
			if (characterBlue != null && characterBlue.model.currentLabel == characterBlue.ANIM_ATTACK
				&& characterBlue.model.mc_reference != null){
				characterBlue.model.mc_reference.visible = false;
				if (characterBlue.model.mc_reference.hitTestObject(characterRed.model.mc_hitCenter)){
					characterRed.EvDamage(characterBlue.damage);
				}
			}
			if (characterRed != null && characterRed.model.currentLabel == characterRed.ANIM_ATTACK
				&& characterRed.model.mc_reference != null){
				characterRed.model.mc_reference.visible = false;
				if (characterRed.model.mc_reference.hitTestObject(characterBlue.model.mc_hitCenter)){
					characterBlue.EvDamage(characterRed.damage);
				}
			}
		}
		
		private function EvFxGoal(posX:int, posY:int):void{
			audioPoint.play();
			audioPoint.volume = 0.5;
			audioPoint.pan = posX *2/ mainStage.stageWidth-1;
			var i:MovieClip = Locator.assetsManager.GetMovieClip("MCgoal");
			Locator.layer3.addChild(i);
			i.x = posX;
			i.y = posY;
		}
		
		private function EvFxBullet(posX:int, posY:int):void{
			audioDamageShoot.play();
			audioDamageShoot.volume = 0.5;
			audioDamageShoot.pan = posX * 2 / mainStage.stageWidth - 1;
			var i:MovieClip = Locator.assetsManager.GetMovieClip("MCdamage");
			Locator.layer3.addChild(i);
			i.blendMode = BlendMode.LIGHTEN;
			i.x = posX;
			i.y = posY;
		}
		
		public function EvWhoWin():void{
			TimeRun = false;
			timerEnd = new Timer(6000,0);
			currentTimeToFinishGame = timeToFishGame;
			win = Locator.assetsManager.GetMovieClip("MCwin");
			var currentWinner:String = EvCurrentWinner();
			
			Locator.mainStage.addChild(win);
			win.x = mainStage.stageWidth/2;
			win.y = mainStage.stageHeight/2;
			
			var colorInfo:ColorTransform;
			colorInfo = new ColorTransform();
			
			if (currentWinner == nameBlue){
				colorInfo.color = 0x0000ff;
			}else if (currentWinner == nameRed)
				colorInfo.color = 0xff0000;
			
			audioTrackBlue.stop();
			audioTrackRed.stop();
			audioWin.play();
			timerEnd.start();
			
			win.tb_winner.text = currentWinner;
			win.mc_colorWin.transform.colorTransform = colorInfo;
			timerEnd.addEventListener(TimerEvent.TIMER, EvFinshedGame);
		}
		private function EvFinshedGame(event:TimerEvent):void{EvRemove();}
		
		private function EvUpdateDetails():void{
			if (hud != null){
				hud.EvUpdate();
			}
		}	
		
		private function EvUpdateCharacters():void{
			if (characterBlue != null)
				characterBlue.EvUpdate();
			if (characterRed != null)
				characterRed.EvUpdate();
		}
		
		private function EvUpdateBrains():void{
			for(var i:int=allBrains.length-1; i >= 0; i--)
				allBrains[i].EvUpdate();
		}
		
		private function EvUpdatePoints():void{
			if (allPoints != null){
				for (var i:int = allPoints.length - 1; i >= 0; i--){
					if (allPoints[i] != null){
						if (allPoints[i].isDestroyed){
							allPoints[i] = null;
							allPoints.splice(i,1);
						}else
							allPoints[i].EvUpdate();
					}
				}
			}	
		}
		
		private function EvUpdateBullets():void{
			if (allBullets != null){
				for (var i:int = allBullets.length-1; i >= 0; i--){
					if (allBullets[i] != null){
						if (allBullets[i].isDestroyed){
							allBullets[i] = null;
							allBullets.splice(i,1);
						}else
							allBullets[i].EvUpdate();
					}
				}
			}	
		}
		
		private function EvUpdatePlataformsMove():void{
			if (allPlataformsMove != null){
				for (var i:int = allPlataformsMove.length -1; i >= 0; i--){
					if (allPlataformsMove[i] != null){
						if (allPlataformsMove[i].isDestroyed){
							allPlataformsMove[i] = null;
							allPlataformsMove.splice(i,1);
						}else
							allPlataformsMove[i].EvUpdate();
					}
				}
			}
		}
		
		protected function EvKeys(event:KeyboardEvent):void{
			if (event.keyCode == Keyboard.ESCAPE && stateFullScreen){
				mainStage.nativeWindow.x = mainStage.nativeWindow.y = 0;//I can control the windows position.
				//mainStage.nativeWindow.width = 800;//I can control size width.
				//mainStage.nativeWindow.height = 600;//I can control size height.
				stateFullScreen = false;//Value state screen.
			}
			if (event.keyCode == Keyboard.F4 && !stateFullScreen){
				mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;//here i can scale the elements
				mainStage.scaleMode = StageScaleMode.SHOW_ALL;//here scale the elements
				stateFullScreen = true;//value state screen.
			}
			if (event.keyCode == Keyboard.F2 && platforms != null){
				if (!isPause){
					EvPause();
				}else if (isPause){
					EvResume();
				}
			}
		}
		
		//Here i can get the all plataform of the movieclip.(allplatformsMove)
		protected function collectAllPlatformsMove(model:MovieClip):void{
			
			for(var i:int=0; i<model.numChildren; i++){
				if(model.getChildAt(i).name == "mc_floorMoveY"){
					plataformsMove = new PlatformsMove;
					plataformsMove.SetPlatform( model.getChildAt(i) as MovieClip,"verticarMove" );
					allPlataformsMove.push(plataformsMove);
				}
				if(model.getChildAt(i).name == "mc_floorMoveX"){
					plataformsMove = new PlatformsMove;
					plataformsMove.SetPlatform( model.getChildAt(i) as MovieClip,"horizontalMove" );
					allPlataformsMove.push(plataformsMove);
				}
			}
			
			for(var j:int=0; j < model.numChildren; j++){
				if(model.getChildAt(j).name == "mc_reference"){
					allPlataformsMoveReference.push( model.getChildAt(j) );
					model.getChildAt(j).visible = false;
				}
			}
		}
		
		//Here i can get the all plataform of the movieclip.(allplatforms)
		protected function collectAllPlatforms(model:MovieClip):void{
			for(var i:int=0; i<model.numChildren; i++){
				if(model.getChildAt(i).name == "mc_floor"){
					allPlatforms.push( model.getChildAt(i) );
					model.getChildAt(i).visible = false;
				}
			}
		}
		
		//Here i can get the all triggers for the collisions damage of the movieclip.
		protected function collectAllDamages(model:MovieClip):void{
			for(var i:int=0; i<model.numChildren; i++){
				if(model.getChildAt(i).name == "mc_damage"){
					model.x = model.x;
					model.y = model.y;
					allDamages.push( model.getChildAt(i) );
					model.getChildAt(i).visible = false;
				}
			}
		}
		
		//Here i can get the all plataform of the movieclip.
		protected function collectAllPoints(model:MovieClip):void{
			
			for(var i:int=0; i<model.numChildren; i++){
				if(model.getChildAt(i).name == "mc_pointRed"){
					goal = new Goal;
					goal.Spawn(model.getChildAt(i).x, model.getChildAt(i).y,"red");
					
					model.getChildAt(i).visible = false;
					allPoints.push(goal);
				}else if(model.getChildAt(i).name == "mc_pointBlue"){
					goal = new Goal;
					goal.Spawn(model.getChildAt(i).x, model.getChildAt(i).y,"blue");
					
					model.getChildAt(i).visible = false;
					allPoints.push(goal);
				}
			}
		}
		
		public function EvCurrentWinner():String{
			if (hud != null){
				var win:String;
				
				if (characterBlue != null && characterRed != null){
					if (characterBlue.model.currentLabel == characterBlue.ANIM_DIE){
						win = nameRed;
						return win;
					}else if (characterRed.model.currentLabel == characterRed.ANIM_DIE){
						win = nameBlue;
						return win;
					}
				}
				
				if (hud.pointsBlue > hud.pointsRed){
					win = nameBlue;
					return win;
				}else if (hud.pointsBlue < hud.pointsRed){
					win = nameRed;
					return win;
				}
				
				if (hud.pointsBlue == hud.pointsRed){
					if (lifeBlue > lifeRed){
						win = nameBlue;
						return win;
					}else if (lifeBlue < lifeRed){
						win = nameRed;
						return win;
					}
					
					if (lifeBlue == lifeRed){
						win = "TIE";
						return win;
					}
				}
			}
			return null
		}
		
		//Here i can get a ramdom number with i am need.
		public function GetRandom(min:int , max:int):Number{
			return Math.random() * (max - min) + min;
		}
		
		public function EvPause():void{
			updateManager.RemoveFunction(EvUpdates);
			isPause = true;
			
			characterBlue.model.stop();
			characterRed.model.stop();
			for (var i:int = 0; i < allBullets.length; i++) {
				if (!allBullets[i].isDestroyed){
					allBullets[i].model.stop();
				}
			}
			
		}
		
		public function EvResume():void{
			
			updateManager.AddFunction(EvUpdates);
			isPause = false;
			
			characterBlue.model.play();
			characterRed.model.play();
			for (var i:int = 0; i < allBullets.length; i++) {
				if (!allBullets[i].isDestroyed){
					allBullets[i].model.play();
				}
			}
		}
		
		public function EvRemove():void{
			updateManager.RemoveFunction(EvUpdates);
			
			console.UnRegisterCommand("pause");
			console.UnRegisterCommand("resume");
			console.UnRegisterCommand("remove");
			console.UnRegisterCommand("winner");
			console.UnRegisterCommand("save");
			console.UnRegisterCommand("load");
			
			if (timerEnd != null && win != null){
				mainStage.removeChild(win);
				timerEnd.removeEventListener(TimerEvent.TIMER, EvFinshedGame);
				
				win = null;
				timerEnd = null;
			}
			
			if (audioTrackBlue != null && audioTrackRed != null){
				audioTrackBlue.stop();
				audioTrackRed.stop();
				audioTrackBlue = null;
				audioTrackRed = null;
			}
			
			for (var i_brains:int = allBrains.length-1; i_brains >= 0; i_brains--){
				if (allBrains[i_brains] != null){
					allBrains[i_brains].isDestroyed = true;
					allBrains[i_brains].EvRemove();
					allBrains[i_brains] = null;
					allBrains.splice(i_brains,1);
				}
			}
			
			if (characterBlue != null && characterRed != null){
				characterBlue.model.stop();
				characterRed.model.stop();
				characterBlue.EvDestroyed();
				characterRed.EvDestroyed();
				characterRed = characterBlue = null;
			}

			for (var i_platformsMove:int = allPlataformsMove.length-1; i_platformsMove >= 0; i_platformsMove--){
				if(!allPlataformsMove[i_platformsMove].isDestroyed)
					allPlataformsMove[i_platformsMove].Remove();
			}
			
			for (var i_plataforms:int = allPlatforms.length-1; i_plataforms >= 0; i_plataforms--){
				allPlatforms[i_plataforms] = null;
				allPlatforms.splice(i_plataforms,1);
			}
			
			for (var i:int = allDamages.length-1; i >= 0; i--) {
				allDamages[i] = null;
				allDamages.splice(i,1);
			}
			
			if (platforms != null){
				layer1.removeChild(platforms); 
				platforms = null;
			}
			
			for (var i_bullets:int = allBullets.length-1; i_bullets >= 0; i_bullets--){
				if(allBullets[i_bullets] != null)
					allBullets[i_bullets].EvRemove();
			}

			for (var i_points:int = allPoints.length-1; i_points >= 0; i_points--) {
				if(allPoints[i_points] != null)
					allPoints[i_points].EvRemove();
			}
			
			if (backgroundGameBlue != null && backgroundGameRed != null){
				layer0.removeChild(backgroundGameBlue);
				layer0.removeChild(backgroundGameRed);
				layer2.removeChild(skinPlataform);
				skinPlataform = backgroundGameRed = backgroundGameBlue = null;
			}
			
			if (hud != null){
				hud.EvRemove();
				hud = null;
			}
			
			if (cam != null){
				cam.off();
				layer3.removeChild(camReference);
				layer3.removeChild(framework);
				layer4.removeChild(fXfront);
				fXfront = null; 
				framework = camReference = null;
			}
			
			inputManager.EvCleanKeys();
			EvUpdatePlataformsMove();
			EvUpdatePoints();
			EvUpdateBullets();
			System.gc();//------------->Only call i when the pc need memory.
			EvReset();
		}
		
		public function EvReset():void{
			lifeBlue = 100;
			lifeRed = 100;
			isPause = false;
			TimeRun = true;
			this.dispatchEvent(new Event("FinishedLevel"));
		}
	}
}