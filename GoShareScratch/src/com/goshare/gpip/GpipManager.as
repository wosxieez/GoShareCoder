package com.goshare.gpip
{
    /********************************************************
     *
     * 平台Gpip交互管理
     *
     ****************************************************/
    public class GpipManager
    {

        private static var instance:GpipManager=null;
        public static function getInstance():GpipManager
        {
            if (!instance){
                instance = new GpipManager();
            }
            return instance;
        }

        /** Gpip平台通信服务 **/
        private var gpipService:GpipService;
        /** Gpip平台host、端口号 **/
        private var _host:String = "127.0.0.1";
        private var _port:int = 9090;
        /** 当前Gpip平台所处状态 **/
        public var curGpipState:String = "";
        /** 当前Gpip平台所处场景 **/
        public var curGpipScene:String = "";
        /** Gpip平台场景清单 **/
        public var gpipSceneList:Array = [];

        public function GpipManager()
        {
            gpipService = new GpipService();
            gpipService.addEventListener(GpipServiceEvent.GPIP_CONNECT_SUC, connectHandler);
            gpipService.addEventListener(GpipServiceEvent.RECEIVE_MESSAGE_GPIP, analysisHandler);
        }

        private static var interval:uint=0;

        /**
         * 初始化
         */
        public function init(host:String, port:int):void
        {
            // 30s检查一次连接Mina服务器连接情况
//            AppRunLoopManager.getInstance().addRunLoop(connectGpipService, 30000);

            // 当前立刻建立连接
            _host = host;
            _port = port;
            connectGpipService();
        }

        /**
         * 数据销毁
         */
        public function dispose():void
        {
            gpipService.removeEventListener(GpipServiceEvent.GPIP_CONNECT_SUC, connectHandler);
            gpipService.removeEventListener(GpipServiceEvent.RECEIVE_MESSAGE_GPIP, analysisHandler);
            gpipService.disconnectGpip();
            gpipService = null;
        }

        /**
         * 连接Gpip进程
         */
        private function connectGpipService():void
        {
            if (gpipService.connected) {
                return;
            }
            gpipService.connectGpip(_host, _port);
        }

        /**
         * Gpip连接成功
         */
        private function 	connectHandler(evt:GpipServiceEvent):void
        {
            log("接Gpip平台服务连接成功，激活新平台服务");
            open();
        }

        /**
         * Gpip返回信息解析
         */
        private function 	analysisHandler(evt:GpipServiceEvent):void
        {
            var param:Object = evt.gpipMessage;

            log(" 解析平台返回消息：" + JSON.stringify(param));

            switch(param.service_name)
            {
                case GpipDataParam.CMD_INIT:  //平台初始化服务完成 - Init
                    if (param.result.status_code == "0") {
                        log("平台初始化完成，启动心跳！");
                        gpipService.startHearbeat();
                        gpipService.sendHeartbeatMessage();
                    } else {
                        log("平台初始化失败！ - " + param.result.description);
                    }
                    break;
                case GpipDataParam.CMD_UNINIT: // 平台注销回应 - Unint
                    log("平台注销服务完成");
                    break;
                case GpipDataParam.CMD_HEART: // 平台心跳回应 - HeartBeat
                    if (param.result.status_code == "0") {
                        gpipService.receiveHeartbeatMessage();
                    } else {
                        log("平台心跳回应异常！" + param.result.description);
                    }
                    break;
                case GpipDataParam.CMD_SWITCHNOTIFY:  // 平台通知前端，由前端发起状态切换请求 - SwitchNotify
                    if(param.hasOwnProperty("service_param") && param.service_param.state_name != null && param.service_param.state_name != ""){
                        doSwitchPage( param.service_param.state_name);
                    } else {
                        log("要跳转的状态字段为空，不作处理！");
                    }
                    break;
                case GpipDataParam.CMD_EVENTNOTIFY:  // 平台事件通知服务 - EventNotify
                    handleEventNotify(param.service_param);
                    break;
                case GpipDataParam.CMD_SWITCH:   // 平台状态切换回应 (平台切换已完成) - Switch
                    handleSwitchDispatch(param.result);
                    break;
                case GpipDataParam.CMD_READY:   //  Ready
                    // 平台状态切换完毕后 ， 前端会进行一次场景状态同步
                    switchGpipScene(curGpipScene);
                    break;
                case GpipDataParam.CMD_GETDATA:  // 获取数据结果 - GetData
                    getDataResultHandler(param);
                    break;
                case GpipDataParam.CMD_SETDATA:  // 存储数据结果 - SetData
                    setDataResultHandler(param);
                    break;
                default:
                    break;
            }
        }

        /**
         * 处理平台发出来的事件
         */
        private function handleEventNotify(data:Object):void
        {
            log("收到平台EventNotify：- "+data.event_name+"]");

            var callbackData:Object = {};
            if (typeof data.data == "object") {
                callbackData = data.data;
            } else {
                if (data.hasOwnProperty("data") && data.data != null && data.data != "") {
                    callbackData = JSON.parse(data.data);
                }
            }
            this.dispatchTDOSEvent(data.event_name, callbackData);
        }

        /**
         * 平台切换状态后返回信息：前端开始进行页面更新（更新结束后，通知平台Ready以激活新状态）
         **/
        private function handleSwitchDispatch(result:Object):void
        {
            if(result.status_code == "0")
            {
                var curStateName:String = result.detail.cur_state;
                curGpipState = curStateName;
                log("平台状态切换完毕，当前平台状态: [" + curStateName + "]");

//				if (gpipStateList.getItemIndex(curStateName) > -1) {
//					if (curStateName=="PrepareService") {
//						// 平台初始化进行中
//						log("平台默认状态已切换完毕!！);
//						AppControlManager.ApiEvtDispatcher(GlobalEventSet.TDOS_INIT_EVENT, {status:"S"},GlobalEventSet.TDOS_OCX_SPACE);
//					} else if (curStateName=="OnService") {
//						// 检测到人来，需要通知应用切换到首页状态
//						var data:Object = TDOSUtil.getPage(result.detail.cur_state);
//						var menuId:String = data.menu;
//						log("前端需切换状态，对应menuId：["+menuId+"]");
//						AppControlManager.ApiEvtDispatcher(AppEventConst.TDOS_STATE_CHANGE, data, GlobalEventSet.APP_SPACE);
//	 					// 通知首页进行页面状态更新
//						AppControlManager.ApiEvtDispatcher(ActionSet.USERCOME_INDEXINFO_EVENT, null, GlobalEventSet.APP_SPACE);
//					} else {
//						trace("----------- 待定状态处理 ---------");
//					}
//				} else {
//					log("【warn】未定义的平台状态！！！")
//				}

                //处理状态切换服务(切换完成事件)
                log("前端页面切换完成，通知平台Ready");
                gpipService.sendMessage(GpipDataParam.CMD_READY, GpipDataParam.CMD_READY_TYPE, {});
            }
        }

        /**
         * 平台数据读取服务回调处理
         * 签到结果key: signin_result，
         *  value:
         *    0表示签到（授权）成功
         *    1表示签到失败（终端号不可用）
         *    2表示授权失败
         */
        private function getDataResultHandler(data:Object):void{

            log("平台数据查询结果 GetData：["+ JSON.stringify(data.result) +"]");

//			var signin_result:String =""; //平台签到结果
            if(data.result.status_code == "0"){
                log("getData - 数据查询成功！");
                //转换数据类型
                var queryData:Object = new Object();
                var temp:Array = data.result.detail.data as Array;
                for each(var item:Object in temp){
                    if(!queryData.hasOwnProperty(item.key)){
                        queryData[item.key] = item.value;
//						if(item.key == "signin_result"){
//							signin_result= item.value + "";
//						}
                    }
                }
//				if(queryData.hasOwnProperty("signin_termid")){
//					Global.setSessionValue(SessionKeySet.HEAD_DEVID_KEY, queryData.signin_termid);
//					Global.setSessionValue(SessionKeySet.HEAD_ORGID_KEY, queryData.signin_orgid);
//					AppControlManager.ApiEvtDispatcher(GlobalEventSet.TDOS_SIGN_EVENT, {status:"S",signin_result:signin_result},GlobalEventSet.TDOS_OCX_SPACE);
//				}
//				else{
//					AppControlManager.ApiEvtDispatcher(GlobalEventSet.TDOS_SIGN_EVENT, {status:"F",signin_result:signin_result},GlobalEventSet.TDOS_OCX_SPACE);
//				}
                this.dispatchTDOSEvent(GlobalEventDict.GPIP_DATA_GET_CALLBACK, {result:true, data:queryData});
            }
            else{
                var failReason:String = data.result.description + "：" + data.result.detail;
                log("getData - 数据查询失败" + failReason);
                this.dispatchTDOSEvent(GlobalEventDict.GPIP_DATA_GET_CALLBACK, {result:false, failReason:failReason});
            }
        }

        /**
         * 平台数据存储服务回调处理
         */
        private function setDataResultHandler(data:Object):void{

            log("平台数据存储结果 SetData：["+ JSON.stringify(data.result)+"]");

            if (data.result.status_code == "0") {
                log("setData - 数据存储成功！");
                this.dispatchTDOSEvent(GlobalEventDict.GPIP_DATA_SET_CALLBACK, {result:true});
            }else{
                var failReason:String = data.result.description + "：" + data.result.detail;
                log("setData - 数据存储失败！" + failReason);
                this.dispatchTDOSEvent(GlobalEventDict.GPIP_DATA_SET_CALLBACK, {result:false, failReason:failReason});
            }
        }

        /**
         * 触发全局事件
         */
        private function dispatchTDOSEvent(event:String, data:Object = null):void
        {
            data = data || {};
            log("触发全局事件 ["+event+"], data["+JSON.stringify(data)+"]");
//            AppManager.ApiEvtDispatcher(event, data, GlobalEventDict.APP_SPACE);
        }

        // --------------------------------------------------------------- 对外调用方法清单 -------------------------------------------------
        /**
         * 打开新平台服务，init初始化
         */
        public function open():void
        {
            var param:Object = new Object();
            param.app_name = "edu_bot_app";
            param.strategy_name = "strategy_of_edu_bot_app";
            gpipService.sendMessage(GpipDataParam.CMD_INIT, GpipDataParam.CMD_INIT_TYPE, param);
        }

        /**
         * 断开新平台服务连接
         */
        public function close():void
        {
            gpipService.sendMessage(GpipDataParam.CMD_UNINIT, GpipDataParam.CMD_UNINIT_TYPE);
        }

        /**
         * 状态切换服务
         */
        public function doSwitchPage(state:String):void
        {
            var param:Object = new Object();
            param.state_name = state;
            gpipService.sendMessage(GpipDataParam.CMD_SWITCH, GpipDataParam.CMD_SWITCH_TYPE, param);
        }

        /**
         * 向平台发送获取数据请求(获取数据)
         * 数据格式：
         * 	 [{"key": "XXXXXXXX"},	{"key": "XXXXXXXX"}]
         */
        public function doGetDataService(keyArray:Array):void
        {
            var param:Object = new Object();
            param.data = keyArray;
            gpipService.sendMessage(GpipDataParam.CMD_GETDATA, GpipDataParam.CMD_GETDATA_TYPE, param);
        }

        /**
         * 向平台发送设置数据请求(保存数据)
         * 数据格式：
         * 	 [{"key": "XXXXXXXX", "value": "YYYYYYYY"},	{"key": "XXXXXXXX","value": "YYYYYYYY"}]
         */
        public function doSetDataService(dataArray:Array):void
        {
            var param:Object = new Object();
            param.data = dataArray;
            gpipService.sendMessage(GpipDataParam.CMD_SETDATA, GpipDataParam.CMD_SETDATA_TYPE, param);
        }

        /**
         * 调用平台自定义服务
         * @param serviceName 服务名(由后台指定告知)
         * @param serviceParam 该服务的传入参数
         */
        public function doServiceEx(serviceName:String, serviceParam:Object=null):void
        {
            var param:Object = new Object();
            param.service_name = serviceName;
            param.service_param = serviceParam;
            gpipService.sendMessage(GpipDataParam.CMD_CUSTOM, GpipDataParam.CMD_CUSTOM_TYPE, param);
        }

        /**
         * 同步当前Gpip场景
         * @param state Gpip场景
         * @param param 该服务的传入参数
         */
        public function switchGpipScene(scene:String, param:Object=null):void
        {
            if (scene && scene.length > 0) {
                curGpipScene = scene;

                function convertFunc(element:*, index:int, arr:Array):Object {
                    var temp:Object = {};
                    temp["robotState"] = String(element);
                    temp["stateLevel"] = String(index+1);
                    return temp;
                }
                var stateList:Array = curGpipScene.split("@");
                var robotState:Array = stateList.map(convertFunc);
//				var robotState:Array = [{robotState: scene, stateLevel: 0}];

                var paramData:Object = { robotStateSet: robotState, parameterSet: param };
                doServiceEx(GpipDataParam.GPIP_SCENE_SYNCHRO, {data:paramData});
            }
        }

        /**
         * 平台tts语音合成
         * @param sentence 语句
         */
        public function tts(sentence: String): void {
            doServiceEx(GpipDataParam.TTS_SPEAK_SERVICE, {text: sentence})
        }

        /**
         * 根据name获取对应的Gpip场景
         */
        public function getGpipSceneByName(name:String=""):String
        {
            var scene:String = "";

            if (name && gpipSceneList && gpipSceneList.length > 0) {
                for each(var item:Object in gpipSceneList) {
                    if (item["name"] == name) {
                        scene = item["scene"];
                        break;
                    }
                }
            }
            return scene;
        }
        // ---------------------------- log --------------------------------
        /**
         * 输出日志
         */
        protected function log(...args):void
        {
            var arg:Array = args as Array;
            if (arg.length > 0)
            {
//                AppManager.log("[GpipManager]  " + args.join(" "));
            }
        }

    }
}