package laya.qg.mini {
	import laya.events.Event;
	import laya.net.URL;
	import laya.resource.HTMLImage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/** @private **/
	public class MiniImage {
		
		/**@private **/
		protected function _loadImage(url:String):void {
			var thisLoader:* = this;
			
			var urlHeader:String = QGMiniAdapter.window.qg.env.USER_DATA_PATH;
			if (url.indexOf(urlHeader) != -1 || url.indexOf(urlHeader) != -1)
			{
				//磁盘路径资源直接使用
				onCreateImage(url, thisLoader, true);//直接读取本地文件，非加载缓存的图片
				return;
			}
			
			//这里要预处理磁盘文件的读取,带layanative目录标识的视为本地磁盘文件，不进行路径转换操作
			if (QGMiniAdapter.isZiYu)
			{
				onCreateImage(url, thisLoader, true);//直接读取本地文件，非加载缓存的图片
				return;
			}
			
			var isTransformUrl:Boolean;
			//非本地文件处理
			if (!MiniFileMgr.isLocalNativeFile(url)) {
				isTransformUrl = true;
				url = URL.formatURL(url);
			}else
			{
				//xiaosong20190301
				if (url.indexOf('http://usr/') == -1&&(url.indexOf("http://") != -1 || url.indexOf("https://") != -1))
				{
					if(MiniFileMgr.loadPath != "")
					{
						url = url.split(MiniFileMgr.loadPath)[1];//去掉http头
					}else
					{
						var tempStr:String = URL.rootPath != "" ? URL.rootPath : URL.basePath;
						var tempUrl:String = url;
						if(tempStr != "")
							url = url.split(tempStr)[1];//去掉http头
						if(!url)
						{
							url = tempUrl;
						}
					}
					
				}
				if (QGMiniAdapter.subNativeFiles && QGMiniAdapter.subNativeheads.length == 0)
				{
					for (var key:* in QGMiniAdapter.subNativeFiles)
					{
						var tempArr:Array = QGMiniAdapter.subNativeFiles[key];
						QGMiniAdapter.subNativeheads = QGMiniAdapter.subNativeheads.concat(tempArr);
						for (var aa:int = 0; aa < tempArr.length;aa++)
						{
							QGMiniAdapter.subMaps[tempArr[aa]] = key + "/" + tempArr[aa];
						}
					}
				}
				//判断当前的url是否为分包映射路径
				if(QGMiniAdapter.subNativeFiles && url.indexOf("/") != -1)
				{
					var curfileHead:String = url.split("/")[0] + "/";//文件头
					if(curfileHead && QGMiniAdapter.subNativeheads.indexOf(curfileHead) != -1)
					{
						var newfileHead:String = QGMiniAdapter.subMaps[curfileHead];
						url = url.replace(curfileHead,newfileHead);
					}
				}
			}
			if (!MiniFileMgr.getFileInfo(url)) {
				//xiaosong20190301
				if (url.indexOf('http://usr/') == -1&&(url.indexOf("http://") != -1 || url.indexOf("https://") != -1))
				{
					//小游戏在子域里不能远端加载图片资源
					if(QGMiniAdapter.isZiYu)
					{
						onCreateImage(url, thisLoader, true);//直接读取本地文件，非加载缓存的图片
					}else
					{
						//xiaosong add 临时修复oppo空格路径的bug
						MiniFileMgr.downOtherFiles(encodeURI(url), new Handler(MiniImage, onDownImgCallBack, [url, thisLoader]), url);
					}
				}
				else
					onCreateImage(url, thisLoader, true);//直接读取本地文件，非加载缓存的图片
			} else {
				onCreateImage(url, thisLoader, !isTransformUrl);//外网图片加载
			}
		}
		
		/**
		 * @private 
		 * 下载图片文件回调处理
		 * @param sourceUrl 图片实际加载地址
		 * @param thisLoader 加载对象
		 * @param errorCode 回调状态码，0成功 1失败
		 * @param tempFilePath 加载返回的临时地址 
		 */
		private static function onDownImgCallBack(sourceUrl:String, thisLoader:*, errorCode:int,tempFilePath:String= ""):void {
			if (!errorCode)
				onCreateImage(sourceUrl, thisLoader,false,tempFilePath);
			else {
				thisLoader.onError(null);
			}
		}
		
		/**
		 * @private 
		 * 创建图片对象
		 * @param sourceUrl
		 * @param thisLoader
		 * @param isLocal 本地图片(没有经过存储的,实际存在的图片，需要开发者自己管理更新)
		 * @param tempFilePath 加载的临时地址
		 */
		private static function onCreateImage(sourceUrl:String, thisLoader:*, isLocal:Boolean = false,tempFilePath:String= ""):void {
			
			var fileNativeUrl:String;
			if(QGMiniAdapter.autoCacheFile)
			{
				if (!isLocal) {
					if(tempFilePath != "")
					{
						fileNativeUrl = tempFilePath;
					}else
					{
						var fileObj:Object = MiniFileMgr.getFileInfo(sourceUrl);
						var fileMd5Name:String = fileObj.md5;
						fileNativeUrl = MiniFileMgr.getFileNativePath(fileMd5Name);
					}
				} else
					if(QGMiniAdapter.isZiYu)
					{
						//子域里需要读取主域透传过来的信息，然后这里获取一个本地磁盘图片路径，然后赋值给fileNativeUrl
						var tempUrl:String = URL.formatURL(sourceUrl);
						if(MiniFileMgr.ziyuFileTextureData[tempUrl])
						{
							fileNativeUrl = MiniFileMgr.ziyuFileTextureData[tempUrl];
						}else
							fileNativeUrl = sourceUrl;
					}else
						fileNativeUrl = sourceUrl;
			}else
			{
				if(!isLocal)
					fileNativeUrl = tempFilePath;
				else
					fileNativeUrl = sourceUrl;
			}
			if (thisLoader.imgCache == null)
				thisLoader.imgCache = {};
			var image:*;
			function clear():void {
				image.onload = null;
				image.onerror = null;
				delete thisLoader.imgCache[sourceUrl]
			}
			var onload:Function = function():void {
				clear();
				//xiaosong20190301
				//thisLoader._url = URL.formatURL(thisLoader._url);
				thisLoader.onLoaded(image);
			};
			var onerror:Function = function():void {
				clear();
				thisLoader.event(Event.ERROR, "Load image failed");
			}
			if (thisLoader._type == "nativeimage") {
				image = new Browser.window.Image();
				image.crossOrigin = "";
				image.onload = onload;
				image.onerror = onerror;
				image.src = fileNativeUrl;
				//增加引用，防止垃圾回收
				thisLoader.imgCache[sourceUrl] = image;
			} else {
				new HTMLImage.create(fileNativeUrl, {onload: onload, onerror: onerror, onCreate: function(img:*):void {
					image = img;
					//增加引用，防止垃圾回收
					thisLoader.imgCache[sourceUrl] = img;
				}});
			}
		}
	}
}

