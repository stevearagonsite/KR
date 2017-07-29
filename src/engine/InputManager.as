package engine{
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class InputManager{
		
		public var keys:Array = new Array();
		public var keysByName:Dictionary = new Dictionary();
		
		public var sequence:Array = new Array();
		public var timeToCleanSequence:int = 500;
		public var currentTimeToCleanSequence:int = timeToCleanSequence;
		
		public function InputManager(){
			
			trace ("Starting InputManager...");
			
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, EvKeyUp);
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, EvKeyDown);
			
			Locator.updateManager.AddFunction(EvUpdate);
		}
		
		public function EvUpdate(event:Event):void{
			
			currentTimeToCleanSequence -= 1000/Locator.mainStage.frameRate;
			
			if (currentTimeToCleanSequence <= 0){
				currentTimeToCleanSequence = timeToCleanSequence;
				//sequence = new Array;
				sequence = [];
			}
		}
		
		/** I save a class for key and set special actions. */
		protected function EvKeyDown(event:KeyboardEvent):void{
			var k:Key = keys[event.keyCode];
			if (k == null){
				k = new Key(event.keyCode);
				keys[event.keyCode] = k;
			}
			if (!k.isPress){
				k.Press();
				sequence.push(k);
				currentTimeToCleanSequence = timeToCleanSequence;
			}
		}
		
		/** I save a class for key and set special actions. */
		protected function EvKeyUp(event:KeyboardEvent):void{
			//The keyboard i cant set two element at the same time.
			var k:Key = keys[event.keyCode];
			if (k == null){
				k = new Key(event.keyCode);
				keys[event.keyCode] = k;
			}
			
			k.Release();
		}
		
		public function setRelation(name:String, code:int):void{
			
			//name = name.toLocaleLowerCase();
			var k:Key = keys[code];
			
			if (k == null){
				k = new Key(code);
				keys[code] = k;
			}
			
			keysByName[name] = k;
		}
		
		public function compareteSequence(s:Array):Boolean{
			return sequence.toString().indexOf(s.toString()) != -1;
			//return sequence.toString() == s.toString();
		}
		
		public function GetKey(code:int):Boolean{
			return keys[code] != null ? keys[code].isPress : false;
		}
		
		public function GetKeyByName(name:String):Boolean{
			return keysByName[name] != null ? keysByName[name].isPress : false;
		}
		
		public function GetKeyDown(code:int):Boolean{
			return keys[code] != null ? keys[code].wasPressed : false;
		}
		
		public function GetKeyDownByName(name:String):Boolean{
			return keysByName[name] != null ? keysByName[name].wasPressed : false;
		}
		
		public function GetKeyUp(code:int):Boolean{
			return keys[code] != null ? keys[code].wasPressed : false;	
		}
		
		public function GetKeyUpByName(name:String):Boolean{
			return keysByName[name] != null ? keysByName[name].wasPressed : false;
		}
		
		public function GetKeyValue(code:int):Number{
			return keys[code] != null ? keys[code].currentValue : 0;
		}
		
		public function GetKeyValueName(name:String):Number{
			return keysByName[name] != null ? keysByName[name].currentValue : 0;
		}
		
		public function EvCleanKeys():void{
			for each (var i:int in keys){
				keys.splice(i,1);
				trace(keys.length-1);
			}
		}
	}
}