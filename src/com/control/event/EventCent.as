package com.control.event
{
	import laya.events.EventDispatcher;
	
	/**
	 * 
	 * @author ZLM
	 * @date 2020-10-28下午8:27:39
	 */
	public class EventCent extends EventDispatcher{
		private static var _ins:EventCent;
		public static function get ins():EventCent{
			return _ins ||= new EventCent();
		}
		
		public function EventCent(){
			super();
		}
	}
}