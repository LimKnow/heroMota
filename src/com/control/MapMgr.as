package com.control
{
	import com.control.event.EventCent;
	import com.control.event.GameEvents;
	
	import PathFinding.core.Grid;
	
	import laya.map.GridSprite;
	import laya.map.MapLayer;
	import laya.map.TiledMap;
	import laya.maths.Point;
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
		/**通行层*/
		public var hallLayer:MapLayer;
		/**通行层网格数据*/
		public var grids:Grid;
		/**角色层*/
		public var unitLayer:MapLayer;
		/**道具层*/
		public var propLayer:MapLayer;
		/**瓦片宽*/
		public var tileWidth:int;
		/**瓦片高*/
		public var tileHeight:int;
		/**瓦宽Num*/
		public var tileWnum:int;
		/**瓦高Num*/
		public var tileHnum:int;
		/**出生点*/
		public var bornPo:Point;
		public function MapMgr()
		{
			bornPo = new Point();
		}
		
		public function changeMap(_pass:int):void{
			tmap = new TiledMap();
			var vrect:Rectangle = new Rectangle(0,0,Browser.width,Browser.height);
			tmap.createMap("res/tiledMap/pass" + _pass + ".json",vrect,Handler.create(this,loadCom,[_pass]));
		}
		
		private function loadCom(_pass:int):void{
			
			hallLayer = tmap.getLayerByName("hall");
			unitLayer = tmap.getLayerByName("unit");
			propLayer = tmap.getLayerByName("prop");
			
			tileWidth = tmap.tileWidth;
			tileHeight = tmap.tileHeight;
			tileWnum = tmap.numColumnsTile;
			tileHnum = tmap.numRowsTile;
			var ary:Array = hallLayer._mapData;
			var tary:Array = [];
			var len:int = ary.length / tileWnum;
			
			for (var i:int = 0; i < len; i++) 
			{
				tary[i] = ary.slice(i * tileWnum, (i + 1) * tileWnum);
			}
			grids = new Grid(tary,64);
			
			var t:GridSprite = tmap.getLayerObject("unit","born");
			var a:Array = globalToGrid(t.x - t.pivotX, t.y + t.y);
			a = gridToGlobal(a[0],a[1]);
			bornPo.x = a[0];
			bornPo.y = a[1];
			
			GameDataMgr.ins.passNum = _pass;
			EventCent.ins.event(GameEvents.MapLoadCom,[_pass,bornPo]);
		}
		
		public function getLayer(name:String):MapLayer{
			var sp:MapLayer = tmap.getLayerByName(name);
			return sp;
		}
		
		/**全局坐标转网格坐标 */
		public function globalToGrid(x:Number,y:Number):Array
		{
			var gridX:Number =Math.floor(x/tileWidth);
			var gridY:Number =Math.floor(y/tileHeight);
			if(gridX<0){
				gridX = 0;
			}
			else if(gridX >= tileWnum){
				gridX = tileWnum-1;
			}
			if(gridY<0){
				gridY = 0;
			}else if(gridY >= tileHnum){
				gridY = tileHnum-1;
			}
			return [gridX,gridY];
		}
		/**网格坐标转全局坐标*/
		public function gridToGlobal(gx:Number,gy:Number):Array
		{
			var x:Number = Math.round(gx * tileWidth) + tileWidth * 0.5;
			var y:Number = Math.round(gy * tileHeight) + tileHeight * 0.5;
			return [x,y];
		}
	}
}