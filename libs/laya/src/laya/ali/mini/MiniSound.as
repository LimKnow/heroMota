package laya.ali.mini
{
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundManager;
	import laya.net.URL;
	import laya.utils.Handler;
	
	/** @private **/
	public class MiniSound extends EventDispatcher {
		/**@private **/
		private static var _musicAudio:*;
		/**@private **/
		private static var _id:int = 0;
		/**@private **/
		private var _sound:*;
		/**
		 * @private
		 * 声音URL
		 */
		public var url:String;
		/**
		 * @private
		 * 是否已加载完成
		 */
		public var loaded:Boolean = false;
		/**@private **/
		public var readyUrl:String;
		/**@private **/
		private static var _audioCache:Object = {};
		
		public function MiniSound() {
			//_sound = _createSound();
		}
		
		/** @private **/
		private static function _createSound():* {
			_id++;
			return ALIMiniAdapter.window.my.createInnerAudioContext();
		}
		
		/**
		 * @private
		 * 加载声音。
		 * @param url 地址。
		 *
		 */
		public function load(url:String):void {
			if (!MiniFileMgr.isLocalNativeFile(url)) {
				url = URL.formatURL(url);
			}else
			{
				if (url.indexOf("http://") != -1 || url.indexOf("https://") != -1)
				{
					if(MiniFileMgr.loadPath != "")
					{
						url = url.split(MiniFileMgr.loadPath)[1];//去掉http头
					}else
					{
						var tempStr:String = URL.rootPath != "" ? URL.rootPath : URL.basePath;
						if(tempStr != "")
							url = url.split(tempStr)[1];//去掉http头
					}
				}
			}
			this.url = url;
			this.readyUrl = url;
			if (_audioCache[this.readyUrl]) {
				event(Event.COMPLETE);
				return;
			}
			if(ALIMiniAdapter.autoCacheFile&&MiniFileMgr.getFileInfo(url))
			{
				onDownLoadCallBack(url,0);
			}else
			{
				if(!ALIMiniAdapter.autoCacheFile)
				{
					onDownLoadCallBack(url,0);
				}else
				{
                    if (MiniFileMgr.isLocalNativeFile(url))
					{
						tempStr = URL.rootPath != "" ? URL.rootPath : URL.basePath;
                        var tempUrl:String = url;
                        if(tempStr != "")
                            url = url.split(tempStr)[1];//去掉http头
                        if (!url){
                            url = tempUrl;
                        }
						//分包目录资源加载处理
						if (ALIMiniAdapter.subNativeFiles && ALIMiniAdapter.subNativeheads.length == 0)
						{
							for (var key:* in ALIMiniAdapter.subNativeFiles)
							{
								var tempArr:Array = ALIMiniAdapter.subNativeFiles[key];
								ALIMiniAdapter.subNativeheads = ALIMiniAdapter.subNativeheads.concat(tempArr);
								for (var aa:int = 0; aa < tempArr.length;aa++)
								{
									ALIMiniAdapter.subMaps[tempArr[aa]] = key + "/" + tempArr[aa];
								}
							}
						}
						//判断当前的url是否为分包映射路径
						if(ALIMiniAdapter.subNativeFiles && url.indexOf("/") != -1)
						{
							var curfileHead:String = url.split("/")[0] + "/";//文件头
							if(curfileHead && ALIMiniAdapter.subNativeheads.indexOf(curfileHead) != -1)
							{
								var newfileHead:String = ALIMiniAdapter.subMaps[curfileHead];
								url = url.replace(curfileHead,newfileHead);
							}
						}
                        onDownLoadCallBack(url,0);
					}else
					{
						MiniFileMgr.downOtherFiles(url,Handler.create(this,onDownLoadCallBack,[url]),url);
					}
				}
			}
		}
		
		/**@private **/
		private function onDownLoadCallBack(sourceUrl:String,errorCode:int,tempFilePath:String = ""):void
		{
			if (!errorCode)
			{
				var fileNativeUrl:String;
				if(ALIMiniAdapter.autoCacheFile)
				{
					if(tempFilePath != "")
					{
						fileNativeUrl = tempFilePath;
					}else
					{
						var fileObj:Object = MiniFileMgr.getFileInfo(sourceUrl);
						if(fileObj && fileObj.md5)
						{
							var fileMd5Name:String = fileObj.md5;
							fileNativeUrl = MiniFileMgr.getFileNativePath(fileMd5Name);
						}else
						{
							fileNativeUrl = sourceUrl;
						}
					}
					_sound = _createSound();
					_sound.src = url =  fileNativeUrl;
				}else
				{
					_sound = _createSound();
					_sound.src = sourceUrl;
				}
				
				_sound.onCanPlay(bindToThis(onCanPlay,this));
				_sound.onError(bindToThis(onError,this));
			}else
			{
				this.event(Event.ERROR);
			}
		}
		
		/**@private **/
		private function onError(error:*):void
		{
			try
			{
				trace("sound error:" + error);
			} 
			catch(error:Error) 
			{
			}
			this.event(Event.ERROR);
			_sound.offError(null);
		}
			
		/**@private **/
		private function onCanPlay():void
		{
			this.loaded = true;
			this.event(Event.COMPLETE);
			_sound.offCanPlay(null);
		}
		
		/**
		 * @private
		 * 给传入的函数绑定作用域，返回绑定后的函数。
		 * @param	fun 函数对象。
		 * @param	scope 函数作用域。
		 * @return 绑定后的函数。
		 */
		public static function bindToThis(fun:Function, scope:*):Function {
			var rst:Function = fun;
			__JS__("rst=fun.bind(scope);");
			return rst;
		}
		
		/**
		 * @private
		 * 播放声音。
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return 声道 SoundChannel 对象。
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):MiniSoundChannel {
			var tSound:*;
			if (url == SoundManager._tMusic) {
				if (!_musicAudio) _musicAudio = _createSound();
				tSound = _musicAudio;
			} else {
				if(_audioCache[readyUrl])
				{
					tSound = _audioCache[readyUrl]._sound;
				}else
				{
					tSound = _createSound();
				}
			}
			if(ALIMiniAdapter.autoCacheFile&&MiniFileMgr.getFileInfo(url))
			{
				var fileNativeUrl:String;
				var fileObj:Object = MiniFileMgr.getFileInfo(url);
				var fileMd5Name:String = fileObj.md5;
				tSound.src = this.url =MiniFileMgr.getFileNativePath(fileMd5Name);
			}else
			{
				tSound.src = this.url;
			}
			var channel:MiniSoundChannel = new MiniSoundChannel(tSound,this);
			channel.url = this.url;
			channel.loops = loops;
			channel.loop = (loops === 0 ? true : false);
			channel.startTime = startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}
		
		/**
		 * @private
		 * 获取总时间。
		 */
		public function get duration():Number {
			return _sound.duration;
		}
		
		/**
		 * @private
		 * 释放声音资源。
		 *
		 */
		public function dispose():void {
			var ad:* = _audioCache[this.readyUrl];
			if (ad) {
				ad.src = "";
				if(ad._sound)
				{
					ad._sound.destroy();	
					ad._sound =null;
					ad =null;
				}
				delete _audioCache[this.readyUrl];
			}
		}
	}
}