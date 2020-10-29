package {
	import com.data.Configs;
	
	import laya.display.Stage;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class LayaUISample {
		
		public function LayaUISample() {
			//初始化引擎
			Laya.init(750,1280,WebGL);
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			//			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			//激活资源版本控制
			ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Laya.loader.load("res/atlas/comp.atlas", Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			//初始化配置
			Configs.init();
		}
	}
}


