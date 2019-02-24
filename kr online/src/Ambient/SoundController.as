package Ambient
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import engine.Locator;
	
	public class SoundController
	{
		public var snd:Sound;
		public var channel:SoundChannel;
		public var settings:SoundTransform;
		public var lastPosition:Number;
		public var isPlay:Boolean = false;;
		
		public function SoundController(snd:Sound){
			this.snd = snd;
		}
		
		public function play(startTime:Number = 0):void{
			isPlay = true;
			settings = new SoundTransform(0,0);
			channel = snd.play(startTime, 0, settings);
			
			if(channel != null){
				channel.addEventListener(Event.SOUND_COMPLETE, evSoundComplete);
			}else
				throw new Error("you dont have speakers..");
		}
		
		public function EvPlayLoop():void{
			isPlay = true;
			settings = new SoundTransform(0, 0);
			channel = snd.play(0, 999999, settings);
		}
		
		protected function evSoundComplete(event:Event):void{
			isPlay = false;
		}
		
		public function stop():void{
			if (channel != null)
				channel.stop();
			
		}
		
		public function pause():void{
			if (channel != null){
				lastPosition = channel.position; //Guarda la posición en la que está el canal en milisegundos.
				channel.stop();
			}
		}
		
		public function resume():void{
			if (channel != null)
				channel = snd.play(lastPosition, 0, settings);
		}
		
		public function set volume(value:Number):void{
			if (channel != null){
				settings.volume = 0;
				channel.soundTransform = settings;
			}
		}
		
		public function get volume():Number{
			return settings.volume;
		}
		
		public function set pan(value:Number):void{
			if (channel != null){
				settings.pan = value;
				channel.soundTransform = settings;
			}
			
		}
		
		public function get pan():Number{
			return settings.pan;
		}
		
		public function set x(value:Number):void{
			pan = value * 2 / Locator.mainStage.stageWidth - 1;
		}
	}
}