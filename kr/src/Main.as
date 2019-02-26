package
{
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import Ambient.SoundController;
	
	import Characters.Brain;
	import Characters.Characters;
	
	import GUI.HUD;
	import GUI.ScreenCredits;
	import GUI.ScreenHowToPlay;
	import GUI.ScreenIntro;
	import GUI.ScreenLevels;
	import GUI.ScreenMenu;
	import triqui.ScreenTriquiWaiting;
	import triqui.ScreenTriquiGame;
	
	import engine.Locator;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x000000")]
	public class Main extends Locator{
		
		public static var instance:Main;
		
		public function Main(){
			instance = this;
			Locator.assetsManager.LoadXML("engine/assets.xml");
			Locator.assetsManager.addEventListener("xml_ready", EvXMLComplete);
			Locator.assetsManager.addEventListener("all_assets_complete", EvIntro);//When the level is loaded.
		}
				
		//Load the assets that i need.
		protected function EvXMLComplete(event:Event):void{
			Locator.assetsManager.LoadLinks("Menu");
		}
		
		public static function RemoveStartEvents():void{
			Locator.assetsManager.removeEventListener("all_assets_complete", EvIntro);//When the level is loaded.
		}
		
		protected static function EvIntro(event:Event):void{
			Locator.screenManager.RegisterScreen("Intro", ScreenIntro);
			Locator.screenManager.RegisterScreen("Menu", ScreenMenu);
			Locator.screenManager.RegisterScreen("HowToPlay", ScreenHowToPlay);
			Locator.screenManager.RegisterScreen("Credits", ScreenCredits);
			Locator.screenManager.RegisterScreen("MenuLevels", ScreenLevels);
			Locator.screenManager.RegisterScreen("TriquiWaiting", ScreenTriquiWaiting);
			Locator.screenManager.RegisterScreen("TriquiGame", ScreenTriquiGame);
			
			Locator.screenManager.LoadScreen("Intro");
		}
		
		//Here is coming the game.
		public function EvLoadGame(whichLevel:String = "level-1"):void{
			currentLevel = whichLevel.toLocaleLowerCase();
			Locator.assetsManager.LoadLinks(("Level"));
			Locator.assetsManager.addEventListener("all_assets_complete", EvStartGame);//When the level is loaded.
		}
		
		//here create events and painting the game.
		protected function EvStartGame(event:Event):void{
			EvCreatingGame();
		}
		
		/** Here i create the level of the users.(need parameter create which level)*/
		public function EvCreatingGame():void{
			EvBaseLevels();
			switch(currentLevel){
				case "level-1":{
					trace("Loading...Level-1");
					EvLoadingStageLevel1();
					break;
				}
					
				case "level-2":{
					trace("Loading...Level-2");
					EvLoadingStageLevel2();
					break;
				}
					
				case "level-3":{
					trace("Loading...Level-3");
					EvLoadingStageLevel3();
					break;
				}
			}
			
			collectAllPlatformsMove(platforms);
			collectAllPlatforms(platforms);
			collectAllDamages(platforms);
			collectAllPoints(platforms);
			Game();
		}
		
		/** Here i can create the level basic for all levels. */
		public function EvBaseLevels():void{
			
			cam.on();//Active the camera.
			cam.addToView(level);//Camera is parent the level(objets zoom).
			camReference = Locator.assetsManager.GetMovieClip("MCcenter");
			framework = Locator.assetsManager.GetMovieClip("MCframework");
			layer3.addChild(framework);
			layer3.addChild(camReference);
			camReference.visible = false;
			
			mainStage.addChild(layer4);
			EvAudioLevel();
			EvBackgroundRandom();
				
			characterRed = new Characters;
			characterRed.Spawn(speed,"red",924,310,-1,7,
				Locator.assetsManager.GetSound("SNDattackRed"),Locator.assetsManager.GetSound("SNDloopRed"));
			var brain:Brain = new Brain;
			brain.Config(characterRed, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.UP, Keyboard.CONTROL, Keyboard.SHIFT,"red");
			allBrains.push(brain);
			
			characterBlue = new Characters;
			characterBlue.Spawn(speed,"blue",109,310,1,7,
				Locator.assetsManager.GetSound("SNDattackBlue"),Locator.assetsManager.GetSound("SNDloopBlue"));
			 var brain2:Brain = new Brain;
			brain2.Config(characterBlue, Keyboard.D, Keyboard.A, Keyboard.W, Keyboard.Q, Keyboard.E,"blue")
			allBrains.push(brain2);	
			
			hud = new HUD;
			hud.Spawn();
			fXfront = assetsManager.GetImage("FXfront");
			layer4.addChild(fXfront);
			fXfront.height = mainStage.stageHeight - hud.model.height;
			fXfront.y = hud.model.height;
			fXfront.alpha = 0.5;
		}
		
		private function EvLoadingStageLevel1():void{
			skinPlataform = Locator.assetsManager.GetImage("Plataform-1");
			platforms = Locator.assetsManager.GetMovieClip("MCplataform_1");
			platforms.visible = false;
			
			layer2.addChild(skinPlataform);
			layer1.addChild(platforms);
			
			skinPlataform.width = mainStage.stageWidth;
			skinPlataform.height = backgroundGameRed.height;
			skinPlataform.y = (mainStage.stageHeight - skinPlataform.height);
		}
		
		private function EvLoadingStageLevel2():void{
			skinPlataform = Locator.assetsManager.GetImage("Plataform-2");
			platforms = Locator.assetsManager.GetMovieClip("MCplataform_2");
			
			layer2.addChild(skinPlataform);
			layer1.addChild(platforms);
			
			skinPlataform.width = mainStage.stageWidth;
			skinPlataform.height = backgroundGameRed.height;
			skinPlataform.y = (mainStage.stageHeight - skinPlataform.height);
		}
		
		private function EvLoadingStageLevel3():void{
			skinPlataform = Locator.assetsManager.GetImage("Plataform-3");
			platforms = Locator.assetsManager.GetMovieClip("MCplataform_3");
			
			layer2.addChild(skinPlataform);
			layer1.addChild(platforms);
			
			skinPlataform.width = mainStage.stageWidth;
			skinPlataform.height = backgroundGameRed.height;
			skinPlataform.y = (mainStage.stageHeight - skinPlataform.height);
		}
		
		private function EvAudioLevel():void{
			audioTrackBlue = new SoundController( Locator.assetsManager.GetSound("SNDsoundtrackBlue"));
			audioTrackRed = new SoundController( Locator.assetsManager.GetSound("SNDsoundtrackRed"));
			audioDamage = new SoundController(Locator.assetsManager.GetSound("SNDdamage"));
			audioDamageShoot = new SoundController(Locator.assetsManager.GetSound("SNDshootDamage"));
			audioWin = new SoundController(Locator.assetsManager.GetSound("SNDwin"));
			audioPoint = new SoundController(Locator.assetsManager.GetSound("SNDpoint"));
			
			audioTrackBlue.EvPlayLoop();
			audioTrackRed.EvPlayLoop();
			audioTrackBlue.volume = 0.5;
			audioTrackRed.volume = 0.5;
		}
		
		/** Here i can to load the background at random.*/
		private function EvBackgroundRandom():void{
			var i:Number = GetRandom(0,2);
			backgroundGameRed = Locator.assetsManager.GetImage("BackgroundRed");
			backgroundGameBlue = Locator.assetsManager.GetImage("BackgroundBlue");
			
			backgroundGameBlue.y = backgroundGameRed.y = (mainStage.stageHeight - backgroundGameRed.height);
			layer0.addChild(backgroundGameRed);
			layer0.addChild(backgroundGameBlue);
			
			if (i > 1){
				backgroundGameBlue.visible = true;
				backgroundGameRed.visible = false;
				audioTrackBlue.volume = 0.3;
				audioTrackRed.volume = 0;
			}else if(i < 1){
				backgroundGameBlue.visible = false;
				backgroundGameRed.visible = true;
				audioTrackBlue.volume = 0;
				audioTrackRed.volume = 0.4;
			}
			
		}
	}
}