package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.filesystem.*;
	import flash.filesystem.FileStream;
	
	// Third Party Classes
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class desktop_screen extends MovieClip
	{
		var main;
		var DesktopAppsInfo;
		var DesktopApps = new Object;
		var DockerApp = new Object;
		var DockerAppLength;
		var nativeTop;
		
		// Initialization
		public function desktop_screen(_main)
		{
			main = _main;
			
			this.alpha = 0;
			this.rotationX = -100;
			
			TweenLite.to(this, 1.4, {alpha: 1, rotationX: 0});
			
			var backgroundLoader:ImageLoader = new ImageLoader(main.bernardosPath + main.settings.desktop.background, {onComplete:onBackgroundLoad});
			backgroundLoader.load();
			
			loadDesktop();
			loadAppDocker();
			loadNativeTop();
			loadExtensionSettings();
			
			desktopRightBox_mc.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
		}
		
		private function onBackgroundLoad(event:LoaderEvent)
		{
			background_loader_mc.addChild(event.target.rawContent);
		}
		
		private function loadDesktop()
		{
			var desktopLoader = new URLLoader();
			
			desktopLoader.addEventListener(Event.COMPLETE, desktopInfoLoaded);
			desktopLoader.load(new URLRequest("bernardos/data/desktop/desktop.json"));
		}
		
		private function desktopInfoLoaded(evt)
		{
			DesktopAppsInfo = JSON.parse(evt.target.data);
			
			for (var i in DesktopAppsInfo)
			{
				DesktopApps[i] = new DesktopApp_class(this, DesktopAppsInfo[i], i);
				desktopApp_loader_mc.addChild(DesktopApps[i]);
			}
		}
		
		private function loadAppDocker()
		{
			// My own logic - didn't get any Math/Formula reference from anywhere. I'm serious.
			
			var startX = 1190;
			var startY = 30;
			var currentY = 30;
			var increaseY = 80;
			
			trace(main.settings.desktop.dockerapps);
			
			DockerApp = JSON.parse(main.settings.desktop.dockerapps);
			DockerAppLength = main.getObjectLength(DockerApp);
			
			for (var i = 1; i <= DockerAppLength; i++)
			{
				if (i > 1) currentY += increaseY;
				
				DockerApp[i] = new dockerapp_class(main, DockerApp[i], startX, currentY);
				
				dockerapps_container_mc.addChild(DockerApp[i]);
			}
		}
		
		private function loadNativeTop()
		{
			nativeTop = new nativeTop_class();
			nativeTop_loader.addChild(nativeTop);
		}
		
		private function loadExtensionSettings()
		{
			main.settingHandler.getSetting("bernardos/data/settings/defaultapps.ini", defaultAppsHandler);
			main.settingHandler.getSetting("bernardos/data/settings/extensionicons.ini", extensionIconsHandler);
		}
		
		private function defaultAppsHandler(returnedSetting)
		{
			main.settings["defaultApps"] = returnedSetting;
		}
		
		private function extensionIconsHandler(returnedSetting)
		{
			main.settings["extensionIcons"] = returnedSetting;
		}
		
		private function rightClickHandler(evt)
		{
			trace("Right-click");
			main.rightBox.clearMenu();
			main.rightBox.addList("New Folder", newFolder);
			main.rightBox.addList("Refresh", _refresh);
			main.rightBox.drawMenu();
		}
		
		// Opened applications layer sorting
		public function clickApp(initialLayer)
		{
			// To be honest, this part is the most confusing part.
			// Reference: https://stackoverflow.com/questions/7866144/as3-layer-order
			
			var screen = instancedApp_loader_mc;
			var window = screen.getChildAt(initialLayer - 1);
			
			if (initialLayer == screen.numChildren) return; // Save processing time - noticiable if a lot of windows is opened up.
			
			screen.addChild(window);
			
			window.appLayer = screen.numChildren;
			
			resetAppChildIndexes();
		}
		
		private function resetAppChildIndexes()
		{
			var screen = instancedApp_loader_mc;
			var currentWindow;
			
			for (var i = 0; i < screen.numChildren; i++)
			{
				currentWindow = screen.getChildAt(i);
				
				currentWindow.appLayer = i + 1;
			}
		}
		
		public function newFolder()
		{
		}
		
		public function _refresh()
		{
			while (desktopApp_loader_mc.numChildren > 0)
			{
				desktopApp_loader_mc.removeChildAt(0);
			}
			
			loadDesktop();
		}
		
		public function updateDesktopApps(customName, info)
		{
			DesktopAppsInfo[customName] = info;
			
			var updatedJSON = JSON.stringify(DesktopAppsInfo);
			
			var settingPath = new File(File.applicationDirectory.resolvePath("bernardos/data/desktop/desktop.json").nativePath);
			var fileStream = new FileStream();
			
			fileStream.open(settingPath, FileMode.WRITE);
			fileStream.writeUTFBytes(updatedJSON);
			fileStream.close();
			
			_refresh();
		}
	}
}