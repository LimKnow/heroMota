package com.control
{
	import com.View.player.Hero;
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	
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
		private var speed:int = 500;
		private var mapMgr:MapMgr;
		public function MoveAction()
		{
			mapMgr = MapMgr.ins
			hero = GameControl.ins.game.hero;
		}
		
		/**
		 * 准备移动
		 */
		public function readyMove(_path:Array):void{
			path = _path;
			move();
		}
		
		/**移动*/
		private function move():void{
			var node:Array = path.pop();
			node = mapMgr.gridToGlobal(node[0],node[1]);
			Tween.to(hero,{x:node[0],y:node[1]},speed,null,Handler.create(this,end));
		}
		
		private function end():void{
			if(path.length > 0){
				move();
			}
			else{
				EventCent.ins.event(GameEvents.MoveEnd);
				trace("移动结束");
			}
		}
	}
}