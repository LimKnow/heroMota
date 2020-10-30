package com.control
{
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	
	import laya.map.MapLayer;
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.utils.Handler;

	/**
	 *  
	 * @author ZLM
	 * @date 2020-10-28下午5:32:42
	 */
	public class MapMgr
	{
		private static var _ins:MapMgr;
		public static function get ins():MapMgr{
			return _ins ||= new MapMgr();
		}
		
		private var tmap:TiledMap;
		private var hallLaya:*
		public function MapMgr()
		{
		}
		
		public function changeMap(_pass:int):void{
			tmap = new TiledMap();
			var vrect:Rectangle = new Rectangle(0,0,Browser.width,Browser.height);
			tmap.createMap("res/tiledMap/pass" + _pass + ".json",vrect,Handler.create(this,loadCom,[_pass]));
		}
		
		private function loadCom(_pass:int):void{
			GameDataMgr.ins.passNum = _pass;
			EventCent.ins.event(GameEvents.MapLoadCom,[_pass]);
		}
		
		public function getLayer(name:String):MapLayer{
			var sp:MapLayer = tmap.getLayerByName(name);
			return sp;
		}
		
		/**全局坐标转网格坐标 */
		public function globalToGrid(x:Number,y:Number):Array
		{
			return []
			/*var gridX:Number =Math.floor(x/widthPerGrid);
			var gridY:Number =Math.floor(y/heightPerGrid);
			if(gridX<0)gridX = 0;
			if(gridX>=numGridW)gridX = numGridW-1;
			if(gridY<0)gridY = 0;
			if(gridY>=numGridH)gridY = numGridH-1;
			return [gridX,gridY];*/
		}
		/**网格坐标转全局坐标*/
		public function gridToGlobal(gx:Number,gy:Number):Array
		{
			return [];
			/*var x:Number = Math.round(gx*widthPerGrid)+widthPerGrid*0.5;
			var y:Number = Math.round(gy*heightPerGrid)+heightPerGrid*0.5;
			return [x,y];*/
		}
	}
}