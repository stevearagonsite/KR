package Ambient
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import engine.Locator;

	public class Camera2D
	{
		public var view:Sprite = new Sprite();
		public var targetZoom:Number;
		public var delayZoom:Number = 20;
		public var isActive:Boolean = false;
		
		public function Camera2D(){
			trace("Ready camera ...");
		}
		
		public function on():void{
			Locator.mainStage.addChild(view);
			isActive = true;
		}
		
		public function off():void{
			Locator.mainStage.removeChild(view);
			isActive = false;
		}
		
		public function addToView(obj:Sprite):void{
			view.addChild(obj);
		}
		
		public function removeFromView(obj:Sprite):void{
			view.removeChild(obj);
		}
		
		public function set zoom(value:Number):void{
			if(value > 0){
				view.scaleX = view.scaleY = value;
			}else{
				throw new Error("the zoom cant be < 0 ... " + "value: " + value);
			}
		}
		
		public function get zoom():Number{
			return view.scaleX;
		}
		
		public function set smoothZoom(value:Number):void{
			targetZoom = value;
			Locator.updateManager.AddFunction(evUpdateSmoothZoom);
		}
		
		protected function evUpdateSmoothZoom(event:Event):void{
			if (true){
				zoom += (targetZoom - zoom) / delayZoom;
				if(Math.abs((targetZoom - zoom)) <= 0.1){
					zoom = targetZoom;
					smoothZoom = 1;
					Locator.updateManager.RemoveFunction(evUpdateSmoothZoom);
				}
			}
		}
		protected function evUpdateSmoothOut(event:Event):void{
			if (true){
				view.x -= view.x/10;
				view.y -= view.y/10;
				zoom += (targetZoom - zoom) / delayZoom;
				if (Locator.mainStage.frameRate <= 60){
					Locator.mainStage.frameRate += Locator.mainStage.frameRate/5;
				}
				if(Math.abs((targetZoom - zoom)) <= 0.001 && Locator.mainStage.frameRate >= 60)
				{
					zoom = targetZoom;
					Locator.mainStage.frameRate = 60;
					evDestroyedSmooth();
				}
			}
		}
		
		private function evDestroyedSmooth():void{
			Locator.mainStage.removeEventListener(Event.ENTER_FRAME, evUpdateSmoothZoom);
			Locator.mainStage.removeEventListener(Event.ENTER_FRAME, evUpdateSmoothOut);
		}
		
		public function set x(value:Number):void{
			view.x = -value;
		}
		
		public function get x():Number{
			return -view.x;
		}
		
		public function set y(value:Number):void{
			view.y = -value;
		}
		
		public function get y():Number{
			return -view.y;
		}
		
		public function lookAt(target:Sprite):void{
			var pLocal:Point = new Point(target.x, target.y);
			var pGlobal:Point = target.parent.localToGlobal(pLocal);
			var pView:Point = view.globalToLocal(pGlobal);
			
			x = pView.x * zoom - Locator.mainStage.stageWidth/2;
			y = pView.y * zoom - Locator.mainStage.stageHeight/2;
		}
	}
}