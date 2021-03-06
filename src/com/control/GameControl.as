package com.control
{
	import com.View.Game;
	
	import PathFinding.core.Heuristic;
	import PathFinding.finders.AStarFinder;
	
	import laya.events.Event;
	

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
		public var game:Game;
		/**A星寻路*/
		private var astart:AStarFinder;
		/**移动*/
		private var moveAct:MoveAction;
		
		public function GameControl()
		{
			mapMgr = MapMgr.ins;
			
			game = new Game();
			Laya.stage.addChild(game);
			
			//寻路对象
			var opt:Object = {allowDiagonal: false,diagonalMovement:0,dontCrossCorners: false, heuristic: Heuristic["manhattan"], weight: 1};
			astart = new AStarFinder(opt);
			
			Laya.stage.on(Event.CLICK,this,onClick);
		}
		
		private function onClick():void{
			var x:int = Laya.stage.mouseX;
			var y:int = Laya.stage.mouseY;
			var a:Array = mapMgr.globalToGrid(x,y);
			x = game.hero.x;
			y = game.hero.y;
			var b:Array = mapMgr.globalToGrid(x,y);
			mapMgr.grids.reset();
			var pathArr:Array = astart.findPath(b[0],b[1],a[0],a[1],mapMgr.grids);
			if(pathArr.length > 0){
				if(!moveAct){
					moveAct = new MoveAction();
				}
				pathArr.reverse();
				moveAct.readyMove(pathArr);
			}
		}
		
		public function changeScene(_pass:int,isInit:Boolean = false):void{
			if(!isInit){
				game.gc();
			}
			mapMgr.changeMap(_pass);
		}
	}
}