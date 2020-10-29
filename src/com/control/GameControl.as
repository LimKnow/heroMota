package com.control
{
	import com.View.Game;
	

	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午9:03:18
	 */
	public class GameControl
	{
		private static var _ins:GameControl;
		public static function get ins():GameControl{
			return _ins ||= new GameControl();
		}
		private var mapMgr:MapMgr;
		private var game:Game;
		public function GameControl()
		{
			mapMgr = MapMgr.ins;
			
			game = new Game();
			Laya.stage.addChild(game);
		}
		
		public function changeScene(_pass:int,isInit:Boolean = false):void{
			if(!isInit){
				game.gc();
			}
			mapMgr.changeMap(_pass);
		}
	}
}