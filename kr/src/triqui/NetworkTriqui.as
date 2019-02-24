package triqui
{

	import flash.utils.Dictionary;
	
	import engine.Locator;
	
	import net.Client;
	import net.ClientData;
	
	public class NetworkTriqui
	{
		public static var client:Client;
		public static var clientPartner:String;
		public static var allClientsEnables:Vector.<String> = new Vector.<String>();
		
		private static var _inGame:Boolean = false;
		private static var _actionByMessage:Dictionary = new Dictionary();
		
		public function NetworkTriqui()
		{
			// Execution when client receiver message!!
			_actionByMessage["request"] = requestGame;
			_actionByMessage["responseRequest"] = responseRequestGame;
			_actionByMessage["changeState"] = playerChangeState;
			_actionByMessage["move"] = moveGame;
			
			Locator.console.RegisterCommand("triqui", evTriqui, "Online game triqui!!.");
		}
		
		private function evTriqui():void
		{
			Locator.console.UnRegisterCommand("triqui");
			Locator.screenManager.LoadScreen("TriquiWaiting");

			client = new Client("ThePlayer" + Math.random());
			client.connect("127.0.0.1",8087);
			
			client.addEventListener(Client.EVENT_CONNECTED, connectedWithServer);
			client.addEventListener(Client.EVENT_GET_ALL_CLIENTS, evGetAllClient);
			client.addEventListener(Client.EVENT_NEW_CLIENT, newPlayer);
			client.addEventListener(Client.EVENT_CLIENT_DISCONNECTED, evClientDisconnected);
			client.addEventListener(Client.EVENT_RECEIVE_MESSAGE, evReceiveMessage);
			client.getAllClient();
			isEnablePlay();
		}
		
		
		/** Execute action with receive message  **/
		private function evReceiveMessage(message:String, params:Object):void{
			trace("message: "+ message);
			_actionByMessage[message](params);
		}
		
		/** Diccionary Action [key] = request; parameters (client);**/
		public function requestGame(params:Object):void{
			client.sendMessageTo(params.client,"responseRequest",{response:!_inGame, client: client.data.name});
			if (!_inGame){
				
				_inGame = true;
				clientPartner = params.client;
				trace("clientPartner: " + clientPartner);
				client.sendMessageTo("*","changeState",{state:_inGame, client: client.data.name});
			}
		}
		
		/** Diccionary Acction [key] = responseRequest; parameters(response, client);**/
		public function responseRequestGame(params:Object):void{
			if (params.response == true){
				_inGame = true;
				clientPartner = params.client;
				// Update all users that this client is in game.
				client.sendMessageTo("*","changeState",{state:_inGame, client: client.data.name});
				trace("clientPartner: " + clientPartner);
			}else{
				trace("refuse!!");
				removeEnablePlayer(params.client);
			}
		}
		
		/** Diccionary Acction [key] = changeState; parameters(state, client);**/
		public function playerChangeState(params: Object):void{
			
			if (params.state){
				// Remove player in vector becouse is in game.
				removeEnablePlayer(params.client);
			}else{
				// Add player in vector becouse is finished the game.
				addEnablePlayer(params.client);
			}
		}
		
		/** Diccionary Acction [key] = move; parameters();**/
		public function moveGame(params:Object):void{
			trace("move game");
		}
		
		public function removeEnablePlayer(name:String):void{
			for each (var i:int in allClientsEnables) 
			{
				if (allClientsEnables[i] == name){
					trace("remove");
					allClientsEnables.splice(i,1);
				}
			}
		}
		
		public function addEnablePlayer(name:String):void{
			for each (var i:int in allClientsEnables) 
			{
				if(name != client.data.name && 
					name != allClientsEnables[i] && 
					name.indexOf("NoName", 2) == -1 )
				{
					trace("add");
					allClientsEnables.push(name);
				}
			}

		}
		
		/** Events-client **/
		private function connectedWithServer():void
		{
			ScreenTriquiWaiting.instance.evWaitingPlayer();
		}
		
		/** Events-client  **/
		public function newPlayer(data:ClientData):void
		{
			if (allClientsEnables){
				
				for each (var i:int in allClientsEnables) 
				{
					if (allClientsEnables[i] == data.name){
						return;
					}
				}
				allClientsEnables.push(new String(data.name));
				if (!_inGame) isEnablePlay();
			}
		}
		
		/** Events-client **/
		public function evGetAllClient(allData:Vector.<ClientData>):void
		{
			for (var i:int = 0; i < allData.length; i++) 
			{
				if(allData[i] != client.data.name && allData[i].name.indexOf("NoName", 2) == -1)
				{
					allClientsEnables.push(allData[i].name);
				}
			}
		}
		
		/** Events-client **/
		public function evClientDisconnected(data:ClientData):void
		{
			for (var i:int = allClientsEnables.length; i < 0; i--) 
			{
				if(allClientsEnables[i] == client.data.name)
				{
					allClientsEnables.splice(allClientsEnables[i], i);
				}
			}
		}
		
		public function isEnablePlay():void
		{
			if (allClientsEnables.length > 0){
				client.sendMessageTo(allClientsEnables[0],"request",{client: client.data.name})
			}
		}
		
		public function game():void
		{
			
		}

		private function leave():void
		{
			Locator.console.RegisterCommand("triqui", evTriqui, "Online game triqui!!.");
						
			client.removeEventListener(Client.EVENT_CONNECTED, connectedWithServer);
			client.removeEventListener(Client.EVENT_GET_ALL_CLIENTS, evGetAllClient);
			client.removeEventListener(Client.EVENT_NEW_CLIENT, newPlayer);
			client.removeEventListener(Client.EVENT_CLIENT_DISCONNECTED, evClientDisconnected);
		}
	}
}