package com.goshare.gpip
{
	public class GpipDataParam
	{
		public function GpipDataParam()
		{
		}
		
		// ------------------------------------ 平台通信报文内 - key -----------------------------
		/**初始化**/
		public static var CMD_INIT:String = "Init";
		public static var CMD_INIT_TYPE:String = "31018";
		
		/**注销服务**/
		public static var CMD_UNINIT:String = "Uninit";
		public static var CMD_UNINIT_TYPE:String = "31036";
		
		/**心跳包**/
		public static var CMD_HEART:String = "HeartBeat";
		public static var CMD_HEART_TYPE:String = "31000";
		
		/**平台切换服务**/
		public static var CMD_SWITCHNOTIFY:String = "SwitchNotify";
//		public static var CMD_SWITCHNOTIFY_TYPE:String = "31024";
		
		/**前端切换服务**/
		public static var CMD_SWITCH:String = "Switch";
		public static var CMD_SWITCH_TYPE:String = "31016";
		
		/**状态准备完毕**/
		public static var CMD_READY:String = "Ready";
		public static var CMD_READY_TYPE:String = "31026";
		
		/**事件通知服务**/
		public static var CMD_EVENTNOTIFY:String = "EventNotify";
//		public static var CMD_EVENTNOTIFY_TYPE:String = "31028";
		
		/**自定义服务**/
		public static var CMD_CUSTOM:String = "CustomEvent";
		public static var CMD_CUSTOM_TYPE:String = "31034";
		
		/**获取数据服务**/
		public static var CMD_GETDATA:String = "GetData";
		public static var CMD_GETDATA_TYPE:String = "31030";
		
		/**设置数据服务**/
		public static var CMD_SETDATA:String = "SetData";
		public static var CMD_SETDATA_TYPE:String = "31032";
		
		/**注册服务**/
		public static var CMD_REG:String = "RegServiceEvent";
		public static var CMD_REG_TYPE:String = "31006";
		
		/**反注册服务**/
		public static var CMD_UNREG:String = "UnregServiceEvent";
		public static var CMD_UNREG_TYPE:String = "31008";
		
		
		// ------------------------------------ 平台Service服务清单 -----------------------------
		/** ASR模式设置：在线/离线 **/
		public static var ASR_MODE_SET_SERVICE:String = "EventOfSetAsrModeService";
		/** ASR方言设置：0-普通话；1-粤语 **/
		public static var ASR_DIALECTS_SET_SERVICE:String = "EventOfSetAsrAccentService";
		/** TTS模式设置：在线/离线 **/
		public static var TTS_MODE_SET_SERVICE:String = "EventOfSetTtsModeService";
		/** TTS发音人设置：jiajia/mengmeng **/
		public static var TTS_SPEAKER_SET_SERVICE:String = "EventOfSetTtsSpeakerService";
		/** 播放指定字符串 **/
		public static var TTS_SPEAK_SERVICE:String = "EventOfPlayCustomText";
		
		/** 场景同步服务 **/
		public static var GPIP_SCENE_SYNCHRO:String = "EventOfSceneStateChanged";
		
		// ------------------------------------ 平台回应事件清单 -----------------------------
		/** 对话信息事件 **/
		public static var CHAT_INFO_BACK_EVENT:String = "EventOfAnswerType";
		/** 语音指令事件 **/
		public static var CHAT_COMMAND_EVENT:String = "EventOfBusinessPass";

	}
}