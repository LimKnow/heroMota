package com.data
{
	import com.control.GameControl;
	import com.control.GameDataMgr;
	import com.control.MapMgr;

	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午8:58:05
	 */
	public class Configs
	{
		public function Configs()
		{
		}
		
		public static function init():void{
			GameDataMgr.ins.gmInfo = new GameInfo();
			GameControl.ins.changeScene(GameDataMgr.ins.gmInfo.curPass,true);
		}
	}
}