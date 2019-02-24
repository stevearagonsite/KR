package engine
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ScreenManager
	{
		public var allScreens:Dictionary = new Dictionary();
		public var container:Sprite = new Sprite();
		public var currentScreen:Screen;
		public var transition:MovieClip;
		public var lastEvent:ScreenEvent;
		
		public function ScreenManager(){
			trace("Starting ScreenManager...");
			Locator.mainStage.addChild(container);
		}
		
		/** This method i can register the class, this class have screen objects and actios. */
		public function RegisterScreen(name:String, scr:Class):void{
			allScreens[name] = scr;
		}
		
		/** This method i can to load a screen with transition */
		public function LoadScreen(name:String, params:Array = null):void{
			
			if(transition == null){//Create the movieclip transition.
				transition = Locator.assetsManager.GetMovieClip("MCTransition");
				transition.stop();
			}
			
			if(currentScreen != null){
				currentScreen.removeEventListener(ScreenEvent.CHANGE, EvPlayTransition);
				currentScreen.EvOnExit();
				currentScreen = null;
			}
			
			var scrClass:Class = allScreens[name];//Creates an index for the dictionary.
			currentScreen = new scrClass();//Create the class.
			currentScreen.addEventListener(ScreenEvent.CHANGE, EvPlayTransition);//Play FX transition.
			currentScreen.EvOnEnter();//This is the first function i should to use.
		}
		
		/** Here i can control the FX transition and create new screen. */
		protected function EvPlayTransition(event:ScreenEvent):void{
			
			//The transition if it does not end can never pass to the other screen, as it may have a stop.
			if(transition != null && transition.currentFrame == 1){
				Locator.mainStage.addChild(transition);
				transition.play();
				
				//The movieclip dispacht this event.
				transition.addEventListener("change screen", EvTransitionEndLoadScreen);
				lastEvent = event;
			}else
				LoadScreen(event.targetScreen, event.params);
		}
		
		/** All transition events are removed and the screen is created. */
		protected function EvTransitionEndLoadScreen(event:Event):void{
			transition.removeEventListener("change screen", EvTransitionEndLoadScreen);
			LoadScreen(lastEvent.targetScreen, lastEvent.params);
			transition.play();
		}
	}
}