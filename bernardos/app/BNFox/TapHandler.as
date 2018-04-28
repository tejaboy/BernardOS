package
{
	import flash.display.MovieClip;
	import flash.filesystem.File;
	
	public class TapHandler extends MovieClip
	{
		var main;
		var BNFox;
		var WebView;
		var tabs = new Object;
		const tabWidth = 160;
		
		public function TapHandler(_main, _BNFox)
		{
			main = _main;
			BNFox = _BNFox;
			WebView = BNFox.WebView;
			
			loadStartTab();
		}
		
		private function loadStartTab()
		{
			if (BNFox.openLocation == undefined)
			{
				newTab("about:BNFox");
				return;
			}
			else
			{
				var nativeLocation = File.applicationDirectory.resolvePath("bernardos/" + BNFox.openLocation);
				nativeLocation = File.desktopDirectory.resolvePath(nativeLocation.nativePath).url;
				
				newTab(nativeLocation);
			}
		}
		
		private function newTab(tabURL)
		{
			var tabCount = main.getObjectLength(tabs);
			
			tabs[tabCount] = new tab_class(tabURL);
			tabs[tabCount].x = tabCount * tabWidth;
			
			tabsContainer_mc.addChild(tabs[tabCount]);
			
			BNFox.currentTab = tabs[tabCount];
			BNFox.loadWeb(tabURL);
		}
	}
}
