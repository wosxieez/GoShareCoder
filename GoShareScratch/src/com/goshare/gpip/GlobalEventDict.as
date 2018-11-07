package com.goshare.gpip
{
	public class GlobalEventDict
	{
		public function GlobalEventDict()
		{
		}
		
		// -------------------------------- 事件空间清单 --------------------------------------
		/** 全局事件通用空间 **/
		public static const APP_SPACE:String = "_APP_SPACE_";
		
		// -------------------------------- 事件清单 --------------------------------------
		// 表情切换相关事件
		/** 切换表情 **/
		public static const FACE_CHANGE_EVENT:String = "faceChangeEvent";
		/** 聊天对话事件 **/
		public static const CHAT_MESSAGE_EVENT:String = "chatMessageEvent";
		
		/** 教师清单及直播情况清单发生更新 **/
		public static const TEACHERS_LIST_UPDATE_EVENT:String = "teachersListUpdateEvent";
		
		/** 请求 - 准备上课事件 **/
		public static const REQUEST_CLASS_READY_EVENT:String = "requestClassReadyEvent";
		/** 请求 - 上课事件 **/
		public static const REQUEST_CLASS_BEGIN_EVENT:String = "requestClassBeginEvent";
		/** 请求 - 继续上课事件 **/
		public static const REQUEST_CLASS_CONTINUE_EVENT:String = "requestClassContinueEvent";
		/** 请求 - 下课事件 **/
		public static const REQUEST_CLASS_FINISH_EVENT:String = "requestClassFinishEvent";		
		
		/** 日程安排已走完 **/
		public static const REQUEST_PLAN_COMPLETE_EVENT:String = "requestPlanCompleteEvent";	
		
//		/** 切换场景事件 - 请求（切换条件判定） */	
//		public static const SCENE_SWITCH_REQUEST_EVENT:String = "sceneSwitchQuestEvent";
		/** 切换场景事件 - 确认（执行切换） */
		public static const SCENE_SWITCH_EVENT:String = "sceneSwitchEvent";
		/** 切换场景事件 - 完毕 （切换完毕通知）*/	
		public static const SCENE_SWITCH_PASS_EVENT:String = "sceneSwitchPassEvent";
		
		
		// 播放器动作事件 -- 表情
		/** 表情展开 **/
		public static const PLAYER_FACE_OPEN:String = "playerFaceOpenEvent";
		/** 表情收起 **/
		public static const PLAYER_FACE_PACK:String = "playerFacePackEvent";
		/** 表情布局更新 **/
		public static const PLAYER_FACE_UPDATE:String = "playerFaceUpdateEvent";
		
		public static const PLAYER_FACE_SHOW:String = "playerFaceShowEvent";
		public static const PLAYER_FACE_HIDE:String = "playerFaceHideEvent";
		// 播放器动作事件 -- 对话
		/** 对话展开 **/
		public static const PLAYER_CHAT_OPEN:String = "playerChatOpenEvent";
		/** 对话收起 **/
		public static const PLAYER_CHAT_PACK:String = "playerChatPackEvent";
		/** 对话布局更新 **/
		public static const PLAYER_CHAT_UPDATE:String = "playerChatUpdateEvent";
		
		public static const PLAYER_CHAT_SHOW:String = "playerChatShowEvent";
		public static const PLAYER_CHAT_HIDE:String = "playerChatHideEvent";
		// 播放器动作事件 -- 课件
		/** 课件展开 **/
		public static const PLAYER_CLASS_OPEN:String = "playerClassOpenEvent";
		/** 课件收起 **/
		public static const PLAYER_CLASS_PACK:String = "playerClassPackEvent";
		/** 课件布局更新 **/
		public static const PLAYER_CLASS_UPDATE:String = "playerClassUpdateEvent";
		
		public static const PLAYER_CLASS_SHOW:String = "playerClassShowEvent";
		public static const PLAYER_CLASS_HIDE:String = "playerClassHideEvent";
		// 播放器动作事件 -- 教师视频
		/** 教师视频展开 **/
		public static const PLAYER_TEACHER_OPEN:String = "playerTeacherOpenEvent";
		/** 教师视频收起 **/
		public static const PLAYER_TEACHER_PACK:String = "playerTeacherPackEvent";
		/** 教师视频布局更新 **/
		public static const PLAYER_TEACHER_UPDATE:String = "playerTeacherUpdateEvent";
		
		public static const PLAYER_TEACHER_SHOW:String = "playerTeacherShowEvent";
		public static const PLAYER_TEACHER_HIDE:String = "playerTeacherHideEvent";
		// 播放器动作事件 -- 学生视频
		/** 学生视频展开 **/
		public static const PLAYER_STUDENT_OPEN:String = "playerStudentOpenEvent";
		/** 学生视频收起 **/
		public static const PLAYER_STUDENT_PACK:String = "playerStudentPackEvent";
		/** 学生视频布局更新 **/
		public static const PLAYER_STUDENT_UPDATE:String = "playerStudentUpdateEvent";
		
		public static const PLAYER_STUDENT_SHOW:String = "playerStudentShowEvent";
		public static const PLAYER_STUDENT_HIDE:String = "playerStudentHideEvent";
		// 播放器动作事件 -- 倒计时幕布
		/** 打开倒计时幕布 **/
		public static const PLAYER_COUNT_OPEN:String = "playerCountDownOpenEvent";
		/** 关闭倒计时幕布 **/
		public static const PLAYER_COUNT_PACK:String = "playerCountDownPackEvent";
		/** 学生视频布局更新 **/
		public static const PLAYER_COUNT_UPDATE:String = "playerCountDownUpdateEvent";
		/** 倒计时幕布计时结束 **/
		public static const PLAYER_COUNT_COMPLETE:String = "playerCountDownCompleteEvent";
		
		// ------------------------------- 平台相关事件 ----------------------
		/** 查询数据结果 **/
		public static const GPIP_DATA_GET_CALLBACK:String = "gpipGetDataResultEvent";
		/** 存储数据结果 **/
		public static const GPIP_DATA_SET_CALLBACK:String = "gpipSetDataResultEvent";
		
		/** 识别到来人 **/
		public static const PEOPLE_FACE_COME_EVENT:String = "EventOfFaceInfo";
		
		/** 上课铃声响起 **/
		public static const CLASS_BEGIN_RING_EVENT:String = "classBeginRingEvent";
		/** 下课铃声响起 **/
		public static const CLASS_END_RING_EVENT:String = "classEndRingEvent";
		
		
		/** 语义库指令 - 现在上课 **/
		public static const COMMAND_CLASS_BEGIN_EVENT:String = "begin_to_be_in_class";
		/** 语义库指令 - 现在下课 **/
		public static const COMMAND_CLASS_END_EVENT:String = "begin_to_be_outside_class";
		/** 语义库指令 - 继续上课 - 二期 **/
		public static const COMMAND_CLASS_CONTINUE_EVENT:String = "commandClassContinueEvent";
		/** 语义库指令 - 开始讲课 **/
		public static const COMMAND_LESSON_BEGIN_EVENT:String = "begin_to_exe_courseware";
		/** 语义库指令 - 停止讲课 **/
		public static const COMMAND_LESSON_END_EVENT:String = "end_to_exe_courseware";
		/** 语义库指令 - 显示课件窗口 **/
		public static const COMMAND_LESSON_SHOW_EVENT:String = "open_courseware_window";
		/** 语义库指令 - 关闭课件窗口 **/
		public static const COMMAND_LESSON_HIDE_EVENT:String = "close_courseware_window";
		/** 语义库指令 - 音量变大 **/
		public static const COMMAND_VOLUME_UP_EVENT:String = "increase_volume";
		/** 语义库指令 - 音量变小 **/
		public static const COMMAND_VOLUME_DOWN_EVENT:String = "decrease_volume";
		/** 语义库指令 - 关闭表情窗口 **/
		public static const COMMAND_FACE_HIDE_EVENT:String = "close_face_window";
		/** 语义库指令 - 显示表情窗口 **/
		public static const COMMAND_FACE_SHOW_EVENT:String = "open_face_window";
        /** 全局通知 **/
        public static const NOTICE: String = 'notice'
		
	}
}