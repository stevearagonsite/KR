package engine{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class AssetsManager extends EventDispatcher
	{
		public var linksLoader:URLLoader;
		
		public var allAssets:Dictionary = new Dictionary();
		public var allSWFs:Vector.<Loader> = new Vector.<Loader>();
		
		public var namesForLoad:Array = new Array();
		public var linksForLoad:Array = new Array();
		
		public var myXML:XML;
		public var preload:MCpreload = new MCpreload();
		public var assetsLoaded:int;
		public var assetsTotal:int;
		
		public function AssetsManager(){
			trace("Loading Assets Manager...");
		}
		
		//Give me a XML for load.
		public function LoadXML(url:String):void{
			linksLoader = new URLLoader();
			linksLoader.load( new URLRequest(url) );
			linksLoader.addEventListener(Event.COMPLETE, EvXMLComplete);
		}
		
		//When i am completed dispatch an event.
		protected function EvXMLComplete(event:Event):void{
			myXML = new XML(linksLoader.data);
			dispatchEvent(new Event("xml_ready"));
		}
		
		//I am loading links.(according group XML)
		public function LoadLinks(name:String):void{
			//Create the preload feedback.
			Locator.mainStage.addChild(preload);
			preload.mc_currentPercentage.stop();
			preload.mc_overallPercentage.stop();
			
			preload.x = Locator.mainStage.stageWidth;
			preload.y = Locator.mainStage.stageHeight;
			
			for each(var x:XML in myXML.links.(@name == name).asset){
				linksForLoad.push(x.@url);//Save the link.
				namesForLoad.push(x.@name);//Save the name asset.
			}
			
			//Define the amount of assets to charge.
			assetsTotal = linksForLoad.length;
			LoadAsset(linksForLoad[0], namesForLoad[0]);
		}
		
		//I can load a level or a scene.
		private function LoadAsset(links:String,name:String):void{
			
			var realLink:String = "engine/" + links;//Keep the link that each element.
			var folder:String = links.split("/")[0];//I save the forder link.
			
			switch(folder){//Load diferent folder.
				case "images":
					var loaderImage:Loader = new Loader();
					loaderImage.load(new URLRequest(realLink));
					loaderImage.contentLoaderInfo.addEventListener(Event.COMPLETE, EvAssetComplete);
					loaderImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderImage.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderImage;
					break;
				
				case "sounds":
					var loaderSound:Sound = new Sound();
					loaderSound.load(new URLRequest(realLink));
					loaderSound.addEventListener(Event.COMPLETE, EvAssetComplete);
					loaderSound.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSound.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderSound;
					break;
				
				case "texts":
					var loaderText:URLLoader = new URLLoader();
					loaderText.load(new URLRequest(realLink));
					loaderText.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderText.addEventListener(ProgressEvent.PROGRESS, evProgress);
					loaderText.addEventListener(Event.COMPLETE, EvAssetComplete);
					allAssets[name] = loaderText;
					break;
				
				case "swfs":
					var loaderSWF:Loader = new Loader();
					loaderSWF.load(new URLRequest(realLink));
					loaderSWF.contentLoaderInfo.addEventListener(Event.COMPLETE, EvAssetComplete);
					loaderSWF.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSWF.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allSWFs.push(loaderSWF);
					break;
			}
		}
		
		//I have the feedback check progress.
		protected function evProgress(event:ProgressEvent):void{
			var percentage:int = event.bytesLoaded * 100 / event.bytesTotal;
			preload.mc_currentPercentage.gotoAndStop(percentage);
		}
		
		//Write in console info error.
		protected function evError(event:IOErrorEvent):void{
			Locator.console.Open();
			Locator.console.WriteLn("there was an error loading...");
		}
		
		//I element being loaded.
		protected function EvAssetComplete(event:Event):void{
			linksForLoad.shift(); //Remove the first element.
			namesForLoad.shift(); //Remove the first element.
			
			assetsLoaded++;
			var percentage:int = assetsLoaded * 100 / assetsTotal;
			preload.mc_overallPercentage.gotoAndStop(percentage);
			
			if(linksForLoad.length > 0){ //Ask if all assets are loaded.
				LoadAsset(linksForLoad[0], namesForLoad[0]);
			}else{
				//I know when all assets is loaded.
				Locator.mainStage.removeChild(preload);
				dispatchEvent( new Event("all_assets_complete") );
			}
		}
		
		//I get an instance image.
		public function GetImage(name:String):Bitmap{
			//Search in all diccionary.
			var myLoader:Loader = allAssets[name];
			if(myLoader != null){ //To be?
				var bmpTemp:Bitmap;
				var bmpDataTemp:BitmapData;
				
				bmpDataTemp = new BitmapData(myLoader.width, myLoader.height, true, 0x000000);
				bmpDataTemp.draw(myLoader);
				
				bmpTemp = new Bitmap(bmpDataTemp);
				
				return bmpTemp;
			}
			
			return null;
		}
		
		//I get an instance image.
		public function GetSound(name:String):Sound{
			//Search in all vector.
			var mySound:Sound = allAssets[name];
			if(mySound != null){//To be ?
				return mySound;
			}
			
			return null;
		}
		
		//Here i can get to text for someting. (example: dialog)
		public function GetText(name:String):String{
			//Search in all diccionary.
			var myText:String = allAssets[name];
			if(myText != null){
				return myText;
			}
			
			return null;
		}
		
		public function GetMovieClip(mcName:String):MovieClip{
			for (var i:int = 0; i <= allSWFs.length; i++) {
				try{
					//Creating a class, i can return movieclip.
					var mcClass:Class = allSWFs[i].contentLoaderInfo.applicationDomain.getDefinition(mcName);
					return new mcClass();
				}catch(e:ReferenceError){
					//Locator.console.Open();
					//Locator.console.WriteLn("It is not the MovieClip: " + mcName + ".");
				}
			}
			return null;
		}
	}
}