package engine
{
	import flash.events.Event;

	public class Key
	{
		public var isPress:Boolean;
		public var code:int;
		public var wasPressed:Boolean;
		public var wasReleased:Boolean;
		
		public var speed:Number = 0.01;
		public var currentValue:Number = 0;
		
		public function Key(code:int){
			this.code = code;	
		}
		
		public function Press():void{
			isPress = true;
			wasPressed = true;
			Locator.updateManager.AddFunction(EvMarkWasPressed);
			Locator.updateManager.AddFunction(EvIncreaseValue);
			Locator.updateManager.RemoveFunction(EvDecreaseValue);
			//Locator.mainStage.addEventListener(Event.ENTER_FRAME, EvMarkWasPressed);
		}
		
		private function EvIncreaseValue(event:Event):void{
			currentValue += speed;
			if (currentValue >= 1){
				currentValue = 1;
				Locator.updateManager.RemoveFunction(EvIncreaseValue);
			}
		}
		
		protected function EvMarkWasPressed(event:Event):void{
			wasPressed = false;
			Locator.updateManager.RemoveFunction(EvMarkWasPressed);
			//Locator.mainStage.removeEventListener(Event.ENTER_FRAME, EvMarkWasPressed);
		}
		
		public function Release():void{
			isPress = false;
			wasReleased = true
			Locator.updateManager.AddFunction(EvMarkWasRelease);
			Locator.updateManager.AddFunction(EvDecreaseValue);
			Locator.updateManager.RemoveFunction(EvIncreaseValue);
			//Locator.mainStage.addEventListener(Event.ENTER_FRAME, EvMarkWasRelease);
		}
		
		private function EvDecreaseValue(event:Event):void{
			currentValue -= speed;
			if (currentValue <= 0){
				currentValue = 0;
				Locator.updateManager.RemoveFunction(EvDecreaseValue);
			}
		}
		
		protected function EvMarkWasRelease(event:Event):void{
			wasPressed = false;
			Locator.updateManager.RemoveFunction(EvMarkWasRelease);
			//Locator.mainStage.removeEventListener(Event.ENTER_FRAME, EvMarkWasRelease);
		}
		
		
		public function toString():String{
			return code.toString();
		}
	}
}