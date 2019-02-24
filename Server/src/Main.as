package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.Client;
	import net.ClientData;
	import net.GameServer;
	import net.ServerEvent;
	
	[SWF(frameRate="60")]
	public class Main extends Sprite{
		
		public var server:GameServer;
		public var client:Client;
		
		public var serverInfo:MC_ServerInfo;
		
		public function Main()
		{
			server = new GameServer();
			serverInfo = new MC_ServerInfo();
			stage.addChild(serverInfo);
			
			serverInfo.tb_ip.text = "192.168.0.248";
			serverInfo.tb_port.text = "8087";
			serverInfo.btn_start.addEventListener(MouseEvent.CLICK, evToggleServer);
			
			server.addEventListener(ServerEvent.UPDATE_CLIENT_DATA, evConnect);
			server.addEventListener(ServerEvent.DISCONNECTED, evDisconnect);
			/*client = new Client("User1");
			client.addEventListener(Client.EVENT_CONNECTED, evConnected);
			client.addEventListener(Client.EVENT_RECEIVE_MESSAGE, evMessage);
			client.addEventListener(Client.EVENT_CLIENT_DISCONNECTED, evClientDesconnected);
			client.connect();*/
		}
		
		protected function evConnect(event:ServerEvent):void
		{
			serverInfo.tb_clientsList.text = "";
			for(var i:int=0; i<server.allClients.length; i++)
			{
				serverInfo.tb_clientsList.text += server.allClients[i].name + " - " + server.allClients[i].ip + "\n";
			}
		}
		
		protected function evDisconnect(event:Event):void
		{
			serverInfo.tb_clientsList.text = "";
			for(var i:int=0; i<server.allClients.length; i++)
			{
				serverInfo.tb_clientsList.text += server.allClients[i].name + " - " + server.allClients[i].ip + "\n";
			}
		}
		
		protected function evToggleServer(event:MouseEvent):void
		{
			if(!server.isOnline)
			{
				server.start(serverInfo.tb_ip.text, int(serverInfo.tb_port.text));
				serverInfo.btn_start.label = "Stop";
			}else{
				server.stop();
				serverInfo.btn_start.label = "Start";
			}
		}
		
		private function evClientDesconnected(client:ClientData):void
		{
			trace("Se desconectó:", client.name);
		}
		
		private function evMessage($message:String, $params:*):void
		{
			trace("RECIBIENDO...", $message);
			for(var obj:* in $params)
			{
				trace(obj, $params[obj]);
			}
		}
		
		private function evConnected():void
		{
			/*trace("CONECTADO...");
			client.sendMessageTo("*", "SARASA", {x:10, y:50});*/
		}
	}
}