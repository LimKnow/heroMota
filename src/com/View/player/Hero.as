package com.View.player
{
	import com.enum.ActionType;
	
	import laya.display.Sprite;
	
	/**
	 * 主角
	 * @author ZLM
	 * @date 2020-10-28下午9:24:07
	 */
	public class Hero extends Sprite
	{
		private var mark:Sprite;
		public function Hero(){
			super();
			mark = new Sprite();
			mark.graphics.drawCircle(0,0,50,"#d018f3");
			mark.pos(0,0);
			addChild(mark);
		}
		
		public function changeAction(actType:int):void{
			switch(actType)
			{
				case ActionType.Run: //跑
					
					break;
				default: //站立
					
					break;
			}
		}
		
		private function stop():void{
			
		}
	}
}