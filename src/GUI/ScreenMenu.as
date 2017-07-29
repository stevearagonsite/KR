package GUI {
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Ambient.SoundController;
	import engine.Locator;
	import engine.Screen;

	public final class ScreenMenu extends Screen{
		
		public var background:Bitmap;
		public var buttonStart:Bitmap;
		public var buttonStartOver:Bitmap;
		public var buttonHowToPlay:Bitmap;
		public var buttonHowToPlayOver:Bitmap;
		public var buttonCredits:Bitmap;
		public var buttonCreditsOver:Bitmap;
		public var triggerMenu:MovieClip;
		public static var audioBackground:SoundController;//in the menu is the ambient soundtrack
		public static var audioClick:SoundController;//in the menu is the ambient soundtrack
		
		public function ScreenMenu(){
			super("");
			trace("starting menu...");
		}
		
		override public function EvOnEnter():void{
			super.EvOnEnter();
			Spawn();
		}
		
		/**createSND is a boolean for creating sounds, menuEvents = this is a string for GUI(deleted events)*/
		public function Spawn(createSND:Boolean = true, menuEvents:String = "Noting"):void{
			
			triggerMenu = Locator.assetsManager.GetMovieClip("MCtriggerMenu");//Generate an instance of movieclip.
			Locator.mainStage.addChild(triggerMenu);
			triggerMenu.alpha = 0;
			
			background = Locator.assetsManager.GetImage("BackgroundMenu");
			model.addChild(background);
			background.width = Locator.mainStage.stageWidth;
			background.height = Locator.mainStage.stageHeight;
			
			buttonStart = Locator.assetsManager.GetImage("ButtonStart");
			model.addChild(buttonStart);
			buttonStartOver = Locator.assetsManager.GetImage("ButtonStartOVER");
			model.addChild(buttonStartOver);
			buttonStart.x = buttonStartOver.x = 287;
			buttonStart.y = buttonStartOver.y = 203;
			
			buttonHowToPlay = Locator.assetsManager.GetImage("ButtonHowToPlay");
			model.addChild(buttonHowToPlay);
			buttonHowToPlayOver = Locator.assetsManager.GetImage("ButtonHowToPlayOVER");
			model.addChild(buttonHowToPlayOver);
			buttonHowToPlay.x = buttonHowToPlayOver.x = 287;
			buttonHowToPlay.y = buttonHowToPlayOver.y = 330;
			
			buttonCredits = Locator.assetsManager.GetImage("ButtonCredits");
			model.addChild(buttonCredits);
			buttonCreditsOver = Locator.assetsManager.GetImage("ButtonCreditsOVER");
			model.addChild(buttonCreditsOver);
			buttonCredits.x = buttonCreditsOver.x = 287;
			buttonCredits.y = buttonCreditsOver.y = 440;
			
			buttonStartOver.visible = buttonHowToPlayOver.visible = buttonCreditsOver.visible = false;
			
			triggerMenu.mc_triggerStart.addEventListener(MouseEvent.MOUSE_OVER, EvStartOver);
			triggerMenu.mc_triggerStart.addEventListener(MouseEvent.MOUSE_OUT, EvStartOut);
			triggerMenu.mc_triggerStart.addEventListener(MouseEvent.CLICK, EvStartGo);
			
			triggerMenu.mc_triggerHowToPlay.addEventListener(MouseEvent.MOUSE_OVER, EvHowToPlayOver);
			triggerMenu.mc_triggerHowToPlay.addEventListener(MouseEvent.MOUSE_OUT, EvHowToPlayOut);
			triggerMenu.mc_triggerHowToPlay.addEventListener(MouseEvent.CLICK, EvHowToPlayGo);
			
			triggerMenu.mc_triggerCredits.addEventListener(MouseEvent.MOUSE_OVER, EvCreditsOver);
			triggerMenu.mc_triggerCredits.addEventListener(MouseEvent.MOUSE_OUT, EvCreditsOut);
			triggerMenu.mc_triggerCredits.addEventListener(MouseEvent.CLICK, EvCreditsGo);
			
			
			if (audioBackground == null){
				audioBackground = new SoundController( Locator.assetsManager.GetSound("SNDintro"));
				audioClick = new SoundController (Locator.assetsManager.GetSound("SNDclick"));
				audioBackground.EvPlayLoop();		
				audioBackground.volume = 1;
			}
		}
		
		//----------------------------------------------------------Menu buttons and events.
		
		protected function EvCreditsOut(event:Event):void{
			buttonCredits.visible = true;
			buttonCreditsOver.visible = false;
		}
		
		protected function EvCreditsOver(event:Event):void{
			buttonCredits.visible = false;
			buttonCreditsOver.visible = true;
		}		
		
		protected function EvHowToPlayOut(event:Event):void{
			buttonHowToPlay.visible = true;
			buttonHowToPlayOver.visible = false;
		}
		
		protected function EvHowToPlayOver(event:Event):void{
			buttonHowToPlay.visible = false;
			buttonHowToPlayOver.visible = true;
		}
		
		protected function EvStartOut(event:Event):void{
			buttonStart.visible = true;
			buttonStartOver.visible = false;
		}
		
		protected function EvStartOver(event:Event):void{
			buttonStart.visible = false;
			buttonStartOver.visible = true;
		}
		//---------------------Events Go--------------------
		protected function EvStartGo(event:Event):void{
			audioClick.play(500);
			EvRemover(true);
			changeScreen("MenuLevels");
			//Main.instance.EvLoadGame();//--------------------------------------------------CHANGE......VERY IMPORNT--------------------------------------------------
		}
		
		protected function EvHowToPlayGo(event:Event):void{
			audioClick.play(500);
			changeScreen("HowToPlay");
		}
		
		protected function EvCreditsGo(event:Event):void{
			audioClick.play(500);
			changeScreen("Credits");
		}
		//---------------------End Events Go----------------
		//-----------------------------------------------------------End menu buttons and events.
		
		public function EvRemover (removeSND:Boolean = false):void{
			
			if (triggerMenu != null){
				if (removeSND){
					audioBackground.stop();
					audioClick.stop();
					audioBackground = null;
					audioClick = null;
				}
				
				triggerMenu.mc_triggerStart.removeEventListener(MouseEvent.MOUSE_OVER, EvStartOver);
				triggerMenu.mc_triggerStart.removeEventListener(MouseEvent.MOUSE_OUT, EvStartOut);
				triggerMenu.mc_triggerStart.removeEventListener(MouseEvent.CLICK, EvStartGo);
				
				triggerMenu.mc_triggerHowToPlay.removeEventListener(MouseEvent.MOUSE_OVER, EvHowToPlayOver);
				triggerMenu.mc_triggerHowToPlay.removeEventListener(MouseEvent.MOUSE_OUT, EvHowToPlayOut);
				triggerMenu.mc_triggerHowToPlay.removeEventListener(MouseEvent.CLICK, EvHowToPlayGo);
				
				triggerMenu.mc_triggerCredits.removeEventListener(MouseEvent.MOUSE_OVER, EvCreditsOver);
				triggerMenu.mc_triggerCredits.removeEventListener(MouseEvent.MOUSE_OUT, EvCreditsOut);
				triggerMenu.mc_triggerCredits.removeEventListener(MouseEvent.CLICK, EvCreditsGo);
				
				model.removeChild(buttonStart);
				model.removeChild(buttonStartOver);
				model.removeChild(buttonCredits);
				model.removeChild(buttonCreditsOver);
				model.removeChild(buttonHowToPlay);
				model.removeChild(buttonHowToPlayOver);
				model.removeChild(background);
				
				buttonStart = null;
				buttonStartOver = null;
				buttonCredits = null;
				buttonCreditsOver = null;
				buttonHowToPlay = null;
				buttonHowToPlayOver = null;
				background = null;
				
				Locator.mainStage.removeChild(triggerMenu);
				triggerMenu = null;
			}
		}
		
		override public function EvOnExit():void{
			EvRemover();
			super.EvOnExit();
		}
	}
}