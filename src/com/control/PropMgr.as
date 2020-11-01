package com.control
{
	import com.enum.GameEnum;

	/**
	 * 道具管理类
	 * @autor 张利民
	 * 2020-11-2
	 */
	public class PropMgr
	{
		private static var _ins:PropMgr;
		public static function get ins():PropMgr{
			return _ins;
		}
		public function PropMgr()
		{
		}
		
		public function check(mark:int):Boolean{
			var bo:Boolean = true;
			switch(mark)
			{
				case GameEnum.YellowDoorUp:
				case GameEnum.YellowDoorLeft:
				case GameEnum.BlueDoorUp:
				case GameEnum.BlueDoorLeft:
				case GameEnum.RedDoorUp:
				case GameEnum.RedDoorLeft:  //门
					parseDoor(mark);
					bo = false;
					break;
				
				case GameEnum.YellowKey: //钥匙
				case GameEnum.RedKey:
				case GameEnum.BlueKey:
					parseKey(mark);
					break;
				
				case GameEnum.BlueGem: //宝石
				case GameEnum.RedGem:
					parseGem(mark);
					break;
				
				case GameEnum.SmallBlood: //血瓶
				case GameEnum.MiddleBlood:
				case GameEnum.BigBlood:
					parseBlood(mark);
					break;
				
				case GameEnum.ElevatorDown: //电梯
				case GameEnum.ElevatorUp:
					parseDoor(mark);
					bo = false;
					break;
				
			}
			return bo;
		}
		
		/**解析门*/
		private function parseDoor(type:int):void{
		}
		/**解析血瓶*/
		private function parseBlood(type:int):void{
			
		}
		/**解析宝石*/
		private function parseGem(type:int):void{
			
		}
		/**解析钥匙*/
		private function parseKey(type:int):void{
			
		}
	}
}