package com.View
{
	import com.View.player.Hero;
	import com.control.GameDataMgr;
	import com.control.MapMgr;
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	import com.data.GameInfo;
	
	import laya.display.Sprite;
	import laya.map.MapLayer;
	
	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午8:53:20
	 */
	public class Game extends Sprite
	{
		private var gmMgr:GameDataMgr;
		private var hero:Hero;
		private var mapLayer:MapLayer;
		public function Game()
		{
			super();
			gmMgr = GameDataMgr.ins;
			addEvent();
		}
		
		private function addEvent():void
		{
			EventCent.ins.on(GameEvents.MapLoadCom,this,changeMapCom);
		}
		
		private function changeMapCom(pass:int):void{
			trace("地图切换完成，当前关卡是" + pass);
			if(!hero){
				hero = new Hero();
			}
			this.addChild(hero);
//			var info:GameInfo = gmMgr.gmInfo;
//			mapLayer = MapMgr.ins.getLayer("background");
//			mapLayer.addChild(hero);
		}
		
		public function gc():void{
			if(gc){
				hero.removeSelf();
			}
			trace("执行了一次Gc");
		}
	}
}