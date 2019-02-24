package engine{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import engine.com.lia.crypto.AES;
	
	public class SaveManagerPro{
		
		public var dataLoaded:Dictionary;
		public var saver:FileStream//----->Ask about that??????.
		public var file:File;
		public var haveSave:Boolean;
		
		public const LOCATION:String = "KR/saves";//defult path for the savegames.
		public const SAVE_NAME:String = "save.dat";
		
		public function SaveManagerPro(){
			
			trace("Starting SaveManagerPro ►");
			file = File.documentsDirectory.resolvePath(LOCATION+"/mysave.sav");//Documents is the path to our savegame.
		}
		
		public function Save(allData:Dictionary):void{
			
			saver = new FileStream;
			saver.open(file, FileMode.WRITE);
			
			var parsed:String = "";
			for(var varName:String in allData){
				parsed += varName + "=" + allData[varName] + ";\n";
			}
			
			saver.writeUTF(parsed);
			saver.close();
		}
		
		public function Load():void{
			
			saver = new FileStream();
			saver.open(file, FileMode.READ);
			
			var parsed:String = saver.readUTFBytes(saver.bytesAvailable);
			var splittedText:Array = escape(parsed).split("%3B%0A");
			
			dataLoaded = new Dictionary();
			for (var i:int = 0; i < splittedText.length; i++){
				var lineSplitted:Array = splittedText[i].split("%3D");
				var varName:String = lineSplitted[0];
				var value:String = lineSplitted[1];
				
				dataLoaded[varName] = value;
			}
			saver.close();
		}
		
		public function SaveObject(allData:Dictionary):void{
			
			saver = new FileStream();
			saver.open(file, FileMode.WRITE);
			saver.writeObject(allData);
			saver.close();
		}
		
		public function LoadObject():void{
			//If you do not have save game will result in an error.
			try{
				saver = new FileStream();
				saver.open(file, FileMode.READ);
				dataLoaded = saver.readObject();
				saver.close();
				haveSave = true;
			}catch(error:Error){
				haveSave = false;
			}
		}
		
		public function SaveEncrypted(allData:Dictionary):void
		{
			var tempData:Dictionary = new Dictionary();
			for(var varName:String in allData)
			{
				var encryptedVarName:String = AES.encrypt(varName, "1234567", AES.BIT_KEY_256);
				var encryptedValue:String = AES.encrypt(allData[varName], "1234567", AES.BIT_KEY_256);
				
				tempData[encryptedVarName] = encryptedValue;
			}
			
			SaveObject(tempData);
		}
		
		public function LoadEncrypted():void
		{
			LoadObject();
			
			var tempData:Dictionary = new Dictionary();
			
			for(var varName:String in dataLoaded)
			{
				var decryptedVarName:String = AES.decrypt(varName, "1234567", AES.BIT_KEY_256);
				var decryptedValue:String = AES.decrypt(dataLoaded[varName], "1234567", AES.BIT_KEY_256);
				
				tempData[decryptedVarName] = decryptedValue;
			}
			
			dataLoaded = tempData;
		}
		
	}
}