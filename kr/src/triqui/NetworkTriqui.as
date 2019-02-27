package triqui
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import engine.Locator;
	
	import net.Client;
	import net.ClientData;
	
	public class NetworkTriqui
	{
		public static var client:Client;
		public static var clientPartner:String;
		public static var allClientsEnables:Vector.<String> = new Vector.<String>();
		private var _inGame:Boolean = false;
		private var _myTurn:Boolean = false;
		private var _actionByMessage:Dictionary = new Dictionary();
		private var _cells:Dictionary = new Dictionary();
		private var _myMovements:Vector.<String> = new Vector.<String>(); 
		private var _partnerMovements:Vector.<String> = new Vector.<String>(); 
		private var _triquiCells:MovieClip;
		private var _myShape:String = "O";
		private var _partnerShape:String = "X";
		private var _shapes:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _winnerState:String = "";
		private var _win:MovieClip;
		
		private static const _WINNING_MOVEMENTS:Array = [
			//Horizontal
			["mc_trigger0x0","mc_trigger1x0","mc_trigger2x0"],
			["mc_trigger0x1","mc_trigger1x1","mc_trigger2x1"],
			["mc_trigger0x2","mc_trigger1x2","mc_trigger2x2"],
			//Vertical
			["mc_trigger0x0","mc_trigger0x1","mc_trigger0x2"],
			["mc_trigger1x0","mc_trigger1x1","mc_trigger1x2"],
			["mc_trigger2x0","mc_trigger2x1","mc_trigger2x2"],
			//Diagonal
			["mc_trigger0x0","mc_trigger1x1","mc_trigger2x2"],
			["mc_trigger0x2","mc_trigger1x1","mc_trigger2x0"]
		];
		
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
			Locator.screenManager.LoadScreen("TriquiWaiting");

			if (client){
				connectedWithServer();
			}
			if (!client){		
				client = new Client("ThePlayer" + Math.random());
			}
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
			//trace("message: "+ message);
			_actionByMessage[message](params);
		}
		
		/** Diccionary Action [key] = request; parameters (client);**/
		public function requestGame(params:Object):void{
			client.sendMessageTo(params.client,"responseRequest",{response:!_inGame, client: client.data.name});
			if (!_inGame){
				_inGame = true;
				clientPartner = params.client;
				client.sendMessageTo("*","changeState",{state:_inGame, client: client.data.name});
				onGame();
			}
		}
		
		/** Diccionary Acction [key] = responseRequest; parameters(response, client);**/
		public function responseRequestGame(params:Object):void{
			if (params.response == true){
				_inGame = true;
				clientPartner = params.client;
				// Update all users that this client is in game.
				client.sendMessageTo("*","changeState",{state:_inGame, client: client.data.name});
				//trace("clientPartner: " + clientPartner);
				_myTurn = true;
				onGame();
			}else{
				//trace("refuse!!");
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
			_myTurn = true;
			_partnerMovements.push(params.cell);
			createShape(_partnerShape, params.posX, params.posY);
			//VERIFY!!!!!
			if (evaluationGameState(_partnerMovements)){
				evFinalState("loser");
			}
			var countCells:int = _myMovements.length + _partnerMovements.length;
			if (countCells >= 9 && _winnerState.length == 0){
				evFinalState("tie");
			}
		}
		
		public function removeEnablePlayer(name:String):void{
			for each (var i:int in allClientsEnables) 
			{
				if (allClientsEnables[i] == name){
					//trace("remove");
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
					//trace("add");
					allClientsEnables.push(name);
				}
			}

		}
		
		/** Events-client **/
		private function connectedWithServer():void
		{
			Locator.console.Close();
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
			for (var i:int = allClientsEnables.length - 1; i >= 0; i--) 
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
		
		public function onGame():void
		{
			ScreenTriquiWaiting.instance.havePartner();
			setTimeout(game,1000);
		}
		
		public function game():void{
			Locator.cam.on();
			Locator.cam.addToView(Locator.level);
			_triquiCells = Locator.assetsManager.GetMovieClip("MCcells");
			_triquiCells.x = Locator.mainStage.stageWidth/2;
			_triquiCells.y = Locator.mainStage.stageHeight/2;
			Locator.layer1.addChild(_triquiCells);
			
			for(var i:int = 0; i <= 2;i++ ){
				for(var j:int = 0; j <= 2;j++ ){
					var name:String = "mc_trigger"+i+"x"+j;
					var cell:DisplayObject = _triquiCells.getChildByName(name);
					cell.addEventListener(MouseEvent.CLICK,evTrigger);
					cell.alpha = 0;
					_cells[name] = cell;
				}
			}
		}
		
		private function evTrigger(event:Event):void{
			var target:MovieClip = (event.target as MovieClip);
			if (_myTurn && _winnerState.length == 0){
				for(var i:int = 0; i < _myMovements.length;i++ ){
					if (_myMovements[i] == target.name){
						return;
					}
				}
				for(var j:int = 0; j < _partnerMovements.length;j++ ){
					if (_partnerMovements[j] == target.name){
						return;
					}
				}
				_myMovements.push(target.name);
				var referenceX:Number = _triquiCells.x + target.x;
				var referenceY:Number = _triquiCells.y + target.y;
				client.sendMessageTo(clientPartner,"move",{cell: target.name, posX: referenceX, posY: referenceY});
				_myTurn = false;
				createShape(_myShape, referenceX, referenceY);
				trace(target.name);
				//VERIFY STATE!!!!!
				if (evaluationGameState(_myMovements)){
					evFinalState("winner");
				}
				var countCells:int = _myMovements.length + _partnerMovements.length;
				if (countCells >= 9){
					evFinalState("tie");
				}
			}
		}
		
		public function createShape(key:String, positionX:int, positionY:int):void{
			var numRandom:int = Locator.instance.GetRandom(0,2);
			var shape:MovieClip = Locator.assetsManager.GetMovieClip("MC-"+key+"-0"+numRandom);
			Locator.layer2.addChild(shape);
			_shapes.push(shape);
			shape.x = positionX;
			shape.y = positionY;
		}
		
		private function evFinalState(state:String):void{
			_win = Locator.assetsManager.GetMovieClip("MCwinTriqui");
			Locator.mainStage.addChild(_win);
			_win.x = Locator.mainStage.stageWidth/2;
			_win.y = Locator.mainStage.stageHeight/2;
			
			//var colorInfo:ColorTransform;
			//colorInfo = new ColorTransform();
			
			if ("winner" == state){
				//colorInfo.color = 0xff0000;
				_win.tb_winner.text = state;
			}else if ("loser" == state){
				//colorInfo.color = 0x0000ff;
				_win.tb_winner.text = state;
			}
			
			
			//_win.mc_colorWin.transform.colorTransform = colorInfo;
			_win.tb_winner.text = state;
			//OUT GAME
			setTimeout(leave,3000);
		}
		
		private function evaluationGameState(listMovements:Vector.<String>):Boolean{
			var count:int = 0;
			
			for each(var caseToWin:Array in _WINNING_MOVEMENTS){
				for(var i:int = 0; i < caseToWin.length; i++){
					for(var j:int = 0; j < listMovements.length; j++){
						if (listMovements[j] == caseToWin[i]){
							count += 1;
						}
					}
				}
				if (count > 2){
					return true;
				}else{
					count = 0;
				}
			}
			return false;
		}

		public function leave():void{
			cleanGame();
			cleanNetwork();
			Locator.screenManager.LoadScreen("Menu");
		}
		
		private function cleanNetwork():void{
			
			if (allClientsEnables && allClientsEnables.length > 0){
				for (var i:int = allClientsEnables.length - 1; i >= 0; i--)
				{
					allClientsEnables[i] = null;
					allClientsEnables.splice(i,1);
				}
				allClientsEnables = null;
				allClientsEnables = new Vector.<String>();
			}
			
			client.removeEventListener(Client.EVENT_CONNECTED, connectedWithServer);
			client.removeEventListener(Client.EVENT_GET_ALL_CLIENTS, evGetAllClient);
			client.removeEventListener(Client.EVENT_NEW_CLIENT, newPlayer);
			client.removeEventListener(Client.EVENT_CLIENT_DISCONNECTED, evClientDisconnected);
			
			client.connect("0.0.0.0",0);
			clientPartner = null;
			_inGame = false;
		}
		
		private function cleanGame():void{
			
			for ( var key: Object in _cells ){
				_cells[key].removeEventListener(MouseEvent.CLICK,evTrigger);
				_cells[key] = null;
				delete _cells[key];
			}
			
			if (_myMovements && _myMovements.length > 0){
				for (var j:int = _myMovements.length - 1; j >= 0; j--){
					_myMovements[j] = null;
					_myMovements.splice(j,1);
				}
				_myMovements = null;
				_myMovements = new Vector.<String>();
			}
			
			if (_partnerMovements && _partnerMovements.length > 0){
				for (var k:int = _partnerMovements.length - 1; k >= 0; k--){
					_partnerMovements[k] = null;
					_partnerMovements.splice(k,1);
				}
				_partnerMovements = null;
				_partnerMovements = new Vector.<String>();
			}
			
			if (_shapes && _shapes.length > 0){
				for (var z:int = _shapes.length - 1; z >= 0; z--){
					Locator.layer2.removeChild(_shapes[z]);
					_shapes[z] = null;
					_shapes.splice(z,1);
				}
				_shapes = null;
				_shapes = new Vector.<MovieClip>();
			}
			
			Locator.layer1.removeChild(_triquiCells);
			Locator.mainStage.removeChild(_win);
			Locator.cam.removeFromView(Locator.level);
			Locator.cam.off();
			_triquiCells = null;
			_win = null;
			_myTurn = false;
			_winnerState = "";
		}
	}
}