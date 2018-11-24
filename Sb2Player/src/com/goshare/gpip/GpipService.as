package com.goshare.gpip
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /********************************************************
	 * 
	 * 平台Gpip通信服务
	 * 
	 ****************************************************/
	public class GpipService extends EventDispatcher
	{
		
		private var socketClient:SocketClientService;
		/**连接建立，初始化完成后，唯一Session_ID**/
		private var session_id:String = "";
		/**流水号，每次发起请求时更新 **/
		private var serial_number:String = "0000000000";
		
		public function GpipService(target:IEventDispatcher=null)
		{
			super(target);
			
			socketClient = new SocketClientService();
			socketClient.serviceType = "1";
			socketClient.addEventListener(LocalSocketConnectEvent.CONNECT,  gpip_connectHandler);
			socketClient.addEventListener(LocalSocketConnectEvent.DISCONNECT, gpip_disconnectHandler);
			socketClient.addEventListener(LocalSocketConnectEvent.ERROR, gpip_errorHandler);
			socketClient.addEventListener(LocalSocketConnectEvent.RECEIVE_MESSAGE, gpip_dataHandler);
			socketClient.addEventListener(ConnectLibLogEvent.LOG_MESSAGE, connectLibLog_Handler);
		}
		
		/**
		 * 与Gpip平台进程连接状态
		 */
		public function get connected():Boolean
		{
			return socketClient.connected;
		}
		
		/**
		 * 连接Gpip进程
		 * @param host Gpip服务器主机
		 * @param port Gpip服务器端口
		 */
		public function connectGpip(host:String, port:int):void
		{
			log("连接Gpip平台Socket服务: ", host, port);
			
			if (connected) {
				log("Gpip平台已经连接，无需重连");
			} else {
				socketClient.connect(host, port);
			}
		}
		
		/**
		 * 断开Gpip进程连接
		 */
		public function disconnectGpip():void
		{
			if (connected)
			{
				log("主动断开Gpip平台Socket服务！ ");
				// 停止心跳
				stopHearbeat();
				// 断开连接
				socketClient.disconnect();
			}
		}
		
		// ------------------------------------------------ Gpip连接成功后处理 --------------------------------------
		/**
		 * 连接Gpip服务器成功
		 */
		private function gpip_connectHandler(event:LocalSocketConnectEvent):void
		{
			log("Gpip连接成功!!!");
			
			var evt:GpipServiceEvent = new GpipServiceEvent(GpipServiceEvent.GPIP_CONNECT_SUC);
			this.dispatchEvent(evt);
		}
		
		/**
		 * 断开Gpip进程
		 */
		private function gpip_disconnectHandler(event:LocalSocketConnectEvent):void
		{
			log("Gpip断开连接!!!");
			
			// 停止心跳
			stopHearbeat();
		}
		
		/**
		 * 与Gpip进程通信异常
		 */
		private function gpip_errorHandler(event:LocalSocketConnectEvent):void
		{
			log("Gpip连接异常：" + event.descript);
			
			disconnectGpip();
		}
		
		// ------------------------------------------------ Gpip消息处理 --------------------------------------
		/**
		 * 收到Gpip进程发送信息
		 */
		private function gpip_dataHandler(event:LocalSocketConnectEvent):void
		{
			 var gpipData:Object = JSON.parse(event.data);
			 
			 log("收到Gpip进程消息： " + JSON.stringify(gpipData));
			
			 if(session_id == "" || session_id != gpipData.header.session_id){
				 session_id = gpipData.header.session_id;
				 log("更新SessionID值： " + session_id);
			 }
			 
			 var evt:GpipServiceEvent = new GpipServiceEvent(GpipServiceEvent.RECEIVE_MESSAGE_GPIP);
			 evt.gpipMessage = gpipData.content.param;
			 this.dispatchEvent(evt);
		}
		
		/**
		 * 向Gpip进程发送消息
		 * @param message 要发送的消息
		 */
		public function sendMessage(serviceName:String, cmdType:String, serviceParam:Object=null):void
		{
			serial_number = addPreZero(parseInt(serial_number) + 1);
			
			var header:Object = new Object();
			header.type = cmdType;
			header.time_stamp = DateTimeUtil.formatDateTime(new Date());
			header.session_id = session_id;
			header.serial_number = serial_number;
			
			var param:Object = new Object();
			param.service_name = serviceName;
			param.service_param = serviceParam?serviceParam:{};
			
			var content:Object = new Object();
			content.from = "127.0.0.1:9089";
			content.to = "127.0.0.1:9090";
			content.verb = "DoService";
			content.param = param;
			
			var message:Object = new Object();
			message.header = header;
			message.content = content;
			
			var messageJsonString:String = JSON.stringify(message);
			log("向Gpip进程发送消息： " + messageJsonString);
			socketClient.sendMessage(messageJsonString);
		}
		
		private function addPreZero(onum:int):String
		{
			var temp:String=onum+"";
			var str:String="";
			for(var i:int=0;i<(10-temp.length);i++){
				str+="0";
			}
			return str + onum;
		}
		
		//--------------------------------------------------------------------------
		//
		//  心跳逻辑代码
		//
		//--------------------------------------------------------------------------
		/** 心跳计时器 - 默认30s */
		private var _heartbeatTimer:Timer;
		/** 心跳间隔 */
		private var _heartInterval:int = 30000;
		/** 上一个心跳包是否被响应 */
		private var heartbeatResponsed:Boolean;
		
		private function get heartbeatTimer():Timer
		{
			if (!_heartbeatTimer)
			{
				_heartbeatTimer = new Timer(_heartInterval);
				_heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeatTimer_TimerHandler);
			}
			
			return _heartbeatTimer;
		}
		
		/**
		 * 开始心跳
		 */
		public function startHearbeat():void
		{
			if (!heartbeatTimer.running)
			{
				log("启动心跳处理");
				heartbeatResponsed = true;
				heartbeatTimer.start();
			}
		}
		
		/**
		 * 停止心跳
		 */
		public function stopHearbeat():void
		{
			if (_heartbeatTimer && _heartbeatTimer.running)
			{
				log("停止心跳处理");
				heartbeatResponsed = false;
				_heartbeatTimer.stop();
				_heartbeatTimer.reset();
			}
			
			// 停止心跳时候重置掉session
			session_id = "";
			serial_number = "0000000000";
		}
		
		private function heartbeatTimer_TimerHandler(event:TimerEvent):void
		{
			if (!heartbeatResponsed)
			{
				// 上一个心跳包没有被响应 - 断开与平台连接
				log("Gpip服务心跳异常");
				disconnectGpip();
			} else {
				// 上一个心跳包成功响应 - 发送此次心跳消息
				sendHeartbeatMessage();
			}
		}
		
		/**
		 * 发送心跳消息
		 */
		public function sendHeartbeatMessage():void
		{
			heartbeatResponsed = false;
			
			var param:Object = {"interval":_heartInterval.toString(), heartdesc:"心跳请求" + new Date().time};
			sendMessage(GpipDataParam.CMD_HEART, GpipDataParam.CMD_HEART_TYPE, param);
		}
		
		/**
		 * 收到心跳消息
		 */
		public function receiveHeartbeatMessage():void
		{
			heartbeatResponsed = true;
		}
		
		// ------------------------------------------------ 日志记录 --------------------------------------
		private function connectLibLog_Handler(event:ConnectLibLogEvent):void
		{
//			log("+++++++++++++++" + event.logText);
		}
		
		/**
		 * 输出日志
		 */
		protected function log(...args):void
		{
			var arg:Array = args as Array;
			if (arg.length > 0)
			{
//				AppManager.log("[GpipService] " + args.join(" "));
			}
		}
		
	}
}