package LANgame{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import engine.Locator;
	
	public class MiniGame{
		
		public var cells:MovieClip;
		public var circle:MovieClip;
		public var cross:Boolean;
		public var allCross:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var allCircle:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var allValues:Vector.<String> = new Vector.<String>();
		public var user:String;
		
		public function MiniGame(){
			spawn();
		}
		
		private function spawn():void{
			cells = Locator.assetsManager.GetMovieClip("MCcells");
			Locator.mainStage.addChild(cells);
			cells.x = Locator.mainStage.stageWidth/2;
			cells.y = Locator.mainStage.stageHeight/2;
			
			cells.mc_trigger0x0.alpha = 0;
			cells.mc_trigger0x1.alpha = 0;
			cells.mc_trigger0x2.alpha = 0;
			cells.mc_trigger1x0.alpha = 0;
			cells.mc_trigger1x1.alpha = 0;
			cells.mc_trigger1x2.alpha = 0;
			cells.mc_trigger2x0.alpha = 0;
			cells.mc_trigger2x1.alpha = 0;
			cells.mc_trigger2x2.alpha = 0;
			
			cells.mc_trigger0x0.addEventListener(MouseEvent.CLICK, EvTrigger0x0);
			cells.mc_trigger0x1.addEventListener(MouseEvent.CLICK, EvTrigger0x1);
			cells.mc_trigger0x2.addEventListener(MouseEvent.CLICK, EvTrigger0x2);
			cells.mc_trigger1x0.addEventListener(MouseEvent.CLICK, EvTrigger1x0);
			cells.mc_trigger1x1.addEventListener(MouseEvent.CLICK, EvTrigger1x1);
			cells.mc_trigger1x2.addEventListener(MouseEvent.CLICK, EvTrigger1x2);
			cells.mc_trigger2x0.addEventListener(MouseEvent.CLICK, EvTrigger2x0);
			cells.mc_trigger2x1.addEventListener(MouseEvent.CLICK, EvTrigger2x1);
			cells.mc_trigger2x2.addEventListener(MouseEvent.CLICK, EvTrigger2x2);
		}
		
		public function EvTrigger0x0(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger0x1(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger0x2(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger1x0(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger1x1(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger1x2(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger2x0(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger2x1(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
		
		public function EvTrigger2x2(event:Event):void{
			if (allValues[0] == null){
				allValues[0] = user;
			}
		}
	}
}