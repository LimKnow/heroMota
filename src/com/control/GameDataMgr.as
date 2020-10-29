package com.control
{
	import com.data.GameInfo;

	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午8:48:20
	 */
	public class GameDataMgr
	{
		private static var _ins:GameDataMgr;
		public static function get ins():GameDataMgr{
			return _ins ||= new GameDataMgr();
		}
		private var _passNum:int;
		/**游戏信息*/
		public var gmInfo:GameInfo;
		
		public function GameDataMgr()
		{
		}

		/**当前关卡*/
		public function get passNum():int
		{
			return _passNum;
		}

		public function set passNum(value:int):void
		{
			_passNum = value;
		}
		
	}
}