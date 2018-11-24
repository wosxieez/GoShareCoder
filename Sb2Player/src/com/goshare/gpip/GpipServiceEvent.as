package com.goshare.gpip
{
	import flash.events.Event;
	
	public class GpipServiceEvent extends Event
	{
		/**
		 * 连接建立成功时候派发 
		 */		
		public static const GPIP_CONNECT_SUC:String = "gpipConnectSuccess";
		
		/**
		 * 连接断开时候派发 
		 */		
		public static const GPIP_DISCONNECT_EVENT:String = "gpipDisconnectEvent";
		
		/**
		 * 收到消息的时候派发 
		 */		
		public static const RECEIVE_MESSAGE_GPIP:String = "receiveMessageGpip";
		
		public function GpipServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public var gpipMessage:Object;
		
	}
}