package com.goshare.manager
{
	import com.goshare.service.HttpTradeService;
	import com.goshare.util.UrlLoader;
	
	import flash.net.SharedObject;
	
	/************************************************************
	 ********************************************
	 * 
	 * 全局数据管理
	 * 
	 ********************************************
	 *************************************************************/
	public class AppDataManager
	{
		public function AppDataManager()
		{
		}
		
		private static  var _instance:AppDataManager;
		
		public static function getInstance():AppDataManager
		{
			if (!_instance) {
				_instance = new AppDataManager();
			}
			return _instance;
		}
		
		// -------------------------------------------------------- parameter --------------------------------------------
		/** 视频服务器地址 **/
		public var fmsService:String = "";
		/** 应用运行模式：0-编辑器模式; 1-播放器模式 **/
		public var projectType:int = 0;
		
		/**
		 * 当前来人人脸信息
		 */
		public var currFaceInfo:Object;
		
		// ------------------------------------------ method ---------------------------------
		public function init():void
		{
			loadCfgFile();
		}
		
		public function destory():void
		{
			
		}
		
		/********************
		 * 
		 *  初始化各配置信息 
		 * 
		 ********************/
		private function loadCfgFile():void
		{
			// 加载系统配置文件sysconfig.xml
			var sceneLoader:UrlLoader = new UrlLoader(sysConfigInfoLoadSuc, sysConfigInfoLoadFail, 10000);
			sceneLoader.loadCfgFile("com/goshare/conf/Sysconfig.xml");
		}
		
		private function sysConfigInfoLoadSuc(sysCfg:Object):void
		{
			log("系统配置文件[sysconfig.xml] 加载成功..");
			
			// 场景布局配置信息解析
			if (sysCfg) {
				var cfgXML:XML = XML(sysCfg);
				var paramList:XMLList = cfgXML.Param;
				for each(var item:XML in paramList) {
					if (item.@name == "FMS_SERVER") {
						fmsService = item.@value;
					}
					if (item.@name == "HTTP_SERVER") {
						HttpTradeService.getInstance().httpServerUrl = item.@value;
					}
					if (item.@name == "PROJECT_TYPE") {
						projectType = item.@value;
						// 设置当前页面显示模式
						if (projectType == 0) {
							Scratch.app.setEditMode(true);
						} else {
							Scratch.app.setEditMode(false);
						}
					}
				}
			}
		}
		
		private function sysConfigInfoLoadFail(failReason:String):void
		{
			log("系统配置文件[sysconfig.xml] 加载失败.." + failReason);
		}
		
		
		// ------------------------------------------ tool  function start ---------------------------------
		/**
		 * 写入配置信息到flash缓存中
		 */
		private static function setShareObjectValue(key:String, value:String):void
		{
			SharedObject.getLocal("goshareEduRobot").data[key] = value;
			SharedObject.getLocal("goshareEduRobot").flush();
		}
		
		/**
		 * 从flash缓存中读取配置信息
		 */
		private static function getShareObjectValue(key:String):String
		{
			if (SharedObject.getLocal("goshareEduRobot").data[key] != undefined) {
				return SharedObject.getLocal("goshareEduRobot").data[key];
			} else {
				return "";
			}
		}
		
		/**
		 * 存放全局数据 - 非缓存
		 */ 
		private static var _pubProperty_data:Object = new Object;
		
		/**
		 * 获取公用属性
		 */ 
		public static function getPubProperty(name:String):Object{
			return _pubProperty_data[name]
		}
		
		/**
		 * 设置公用属性
		 */ 
		public static function setPubProperty(key:String,value:Object):void{
			_pubProperty_data[key] = value;
		}
		// ------------------------------------------ tool  function end ---------------------------------
		
		/**
		 * 输出日志
		 */
		protected function log(...args):void
		{
			var arg:Array = args as Array;
			if (arg.length > 0)
			{
				AppManager.log("[AppDataManager]  " + args.join(" "));
			}
		}
		
	}
}