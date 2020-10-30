package com.View
{
	import com.View.player.Hero;
	import com.control.GameDataMgr;
	import com.control.MapMgr;
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	
	import PathFinding.finders.AStarFinder;
	
	import laya.display.Sprite;
	import laya.maths.Point;
	
	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午8:53:20
	 */
	public class Game extends Sprite
	{
		
		public var hero:Hero;
		private var gmMgr:GameDataMgr;
		private var mapMgr:MapMgr;
		/**A星寻路*/
		private var astart:AStarFinder;
		
		public function Game()
		{
			super();
			gmMgr = GameDataMgr.ins;
			mapMgr = MapMgr.ins;
			addEvent();
		}
		
		private function addEvent():void
		{
			EventCent.ins.on(GameEvents.MapLoadCom,this,changeMapCom);
		}
		
		private function changeMapCom(pass:int,po:Point):void{
			trace("地图切换完成，当前关卡是" + pass);
			if(!hero){
				hero = new Hero();
			}
			hero.pos(po.x,po.y);
			Laya.stage.addChild(hero);
		}
		
		public function gc():void{
			if(gc){
				hero.removeSelf();
			}
			trace("执行了一次Gc");
		}
	}
}