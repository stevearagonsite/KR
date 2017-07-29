package engine
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.system.fscommand;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public class Console
	{
		public var model:MCconsole;//This is the model for the console.
		public var keyForOpenConsole:int;//Save the key for call console.
		public var isOpened:Boolean;//Here i know if console is opened or closed.
		
		//This is the position in the stage.
		public var posX:int = 0;
		public var posY:int = 768;
		
		public var allCommands:Dictionary = new Dictionary;//It save all commands for my game
		
		public function Console(){
			trace("Loading Console...");
			model = new MCconsole;
			
			keyForOpenConsole = Keyboard.F8;//This is the key for the call in the console.
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, EvKeyUp);//This event create the console and remove this.
			
			RegisterCommand("help", Help, "Is the command information for all commands or one command.");//The first command register.
			RegisterCommand("cls", Clear, "This command clean the text box in the console.");
			RegisterCommand("exit", Exit, "Execute this command for close the game.");
		}
		
		//Here i can exit for the program.
		private function Exit():void{
			fscommand("quit");//Use a .exe format.
			NativeApplication.nativeApplication.exit();//Use the AIR.
		}
		
		//Here clean the counter in console.
		private function Clear():void{
			model.tb_textOut.text = "";
		}
		
		//I put the text here and over the counter.
		public function Write(text:String):void{
			model.tb_textOut.text += text+"\n";
		}
		
		//This creates spacing.
		public function WriteLn(text:String):void{
			Write(text + "\n");
		}
		
		//This register all commands for my console and others parameters.
		public function RegisterCommand(name:String, command:Function, description:String = "Dont have description."):void{
			var myData:CommandData = new CommandData();
			myData.name = name.toLowerCase();//the all comands for the register is in lower case.
			myData.command = command;
			myData.description = description;
			
			allCommands[name] = myData;
		}
		
		//This delete a command for my console.
		public function UnRegisterCommand(name:String):void{
			delete allCommands[name];
		}
		
		//This event execute the console or close the console.
		protected function EvKeyUp(event:KeyboardEvent):void{
			if (event.keyCode == keyForOpenConsole){
				!isOpened ? Open() : Close();
				isOpened = !isOpened;
			}else if (isOpened && event.keyCode == Keyboard.ENTER){//Here execute the command.
				ExeCommand(model.tb_textIn.text.toLowerCase());//Execute the command in lower case.
				model.tb_textIn.text = "";
			}
		}
		
		//Here execute the command and check if this exist.
		private function ExeCommand(name:String):void{
			var allCuts:Array = name.split(" ");//For each space saves an item.
			var commandName:String = allCuts[0];//Here save the command in the String.
			allCuts.splice(0, 1);

			var myCommand:CommandData = allCommands[commandName];
			
			//Check errors.
			Write("Execute: " + name);
			if(myCommand != null)
			{
				if(allCuts.length == 0)
				{
					try
					{
						myCommand.command();						
					}catch(e1:ArgumentError)
					{
						Write("You need more arguments.");
					}
				}else
				{
					try
					{
						myCommand.command.apply(null, allCuts);
					}catch(e2:ArgumentError)
					{
						Write("The number of parameters is greater than is needed.");
					}
				}
			}else
			{
				Write("The command does not exist.");
			}
		}
		
		//Open the console.
		public function Open():void{
			Locator.mainStage.addChild(model);
			Locator.mainStage.focus = model.tb_textIn;
			model.tb_textIn.text = "";
			model.tb_textOut.text = "";
			model.x = posX;
			model.y = posY;
		}
		
		//Clouse the console.
		public function Close():void{
			Locator.mainStage.removeChild(model);
			Locator.mainStage.focus = Locator.mainStage;
		}
		
		//it is the user information.
		private function Help():void{
			for each(var cData:CommandData in allCommands){
				Write(cData.name + " : " + cData.description);
			}
		}
	}
}