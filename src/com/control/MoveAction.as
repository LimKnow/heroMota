package com.control
{
	import com.View.player.Hero;
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	import com.enum.GameEnum;
	
	import laya.utils.Handler;
	import laya.utils.Tween;

	/**
	 * @autor 张利民
	 * 2020-10-30
	 */
	public class MoveAction
	{
		private var hero:Hero;
		private var path:Array;
		private var speed:int = 300;
		private var mapMgr:MapMgr;
		private var gm:GameControl;
		private var ppMgr:PropMgr;
		public function MoveAction()
		{
			gm = GameControl.ins
			mapMgr = MapMgr.ins;
			ppMgr = PropMgr.ins;
			hero = gm.game.hero;
		}
		
		/**
		 * 准备移动
		 */
		public function readyMove(_path:Array):void{
			Tween.clearAll(hero);
			path = _path;
			move();
		}
		
		/**移动*/
		private function move():void{
			var grid:Array = path.pop();
			var node:Array = mapMgr.gridToGlobal(grid[0],grid[1]);
			Tween.to(hero,{x:node[0],y:node[1]},speed,null,Handler.create(this,end,grid));
		}
		
		private function end(gx:int,gy:int):void{
			if(chekProp(gx,gy)){
				if(path.length > 0){
					move();
				}
				else{
					EventCent.ins.event(GameEvents.MoveEnd);
					trace("移动结束");
				}
			}
		}
		
		/**
		 * 道具检查，是否可以移动
		 */
		private function chekProp(gx:int,gy:int):Boolean
		{
			var mark:int = mapMgr.propLayer.getTileData(gx,gy);
			return ppMgr.check(mark);
		}
	}
}