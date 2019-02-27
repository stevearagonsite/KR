package engine{
	import flash.events.Event;
	
	public class UpdateManger{
		
		public var allUpdates:Vector.<Function> = new Vector.<Function>();
		
		public function UpdateManger(){
			
			trace("Starting Update Manager...");
			
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, EvUpdate);
		}
		
		public function AddFunction(f:Function):void{
			var index:int = allUpdates.indexOf(f);
			if (index == -1){
				allUpdates.push(f);
			} 
		}
		
		public function RemoveFunction(f:Function):void{
			var index:int = allUpdates.indexOf(f);
			if (index != -1){
				allUpdates.splice(index,1);
			} 
		}
		
		protected function EvUpdate(event:Event):void{
			for (var i:int = 0; i < allUpdates.length; i ++){
				allUpdates[i](event);
			}
		}
	}
}