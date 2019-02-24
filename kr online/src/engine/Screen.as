package engine
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	[Event(name="change", type="engine.ScreenEvent")]
	[Event(name="enter", type="engine.ScreenEvent")]
	[Event(name="exit", type="engine.ScreenEvent")]
	[Event(name="update", type="engine.ScreenEvent")]
	public class Screen extends EventDispatcher
	{
		public var model:MovieClip;//Here i put element in the screen.
		public var mcName:String;//This is the name of the screen.
		
		/** For each screen execute this buider. */
		public function Screen(mcName:String){
			this.mcName = mcName;
			if (mcName == ""){
				model = new MovieClip();
			}else
				model = Locator.assetsManager.GetMovieClip(mcName);
		}
		
		/** When i need change the screen i should to call this function. */
		public function changeScreen(name:String, params:Array = null):void{
			
			//I built a package.
			var ev:ScreenEvent = new ScreenEvent( ScreenEvent.CHANGE );
			ev.targetScreen = name;
			ev.params = params;
			
			//I send a package.
			this.dispatchEvent(ev);
		}
		
		/** Here i put a screen element in the general container. */
		public function EvOnEnter():void{
			if (model != null){
				Locator.screenManager.container.addChild(model);
			}
		}
		
		public function EvOnUpdate():void{
		}
		
		/** Here i take out the screen in the general container. */
		public function EvOnExit():void{
			if (model != null){
				Locator.screenManager.container.removeChild(model);
				model = null;
			}
		}
	}
}