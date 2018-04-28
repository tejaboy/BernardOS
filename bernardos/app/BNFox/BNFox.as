package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.StageWebView;
	import flash.geom.Rectangle;
	import flash.filesystem.File;
	import flash.events.LocationChangeEvent;
	import flash.events.ErrorEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class BNFox extends MovieClip
	{
		var main;
		var appName;
		var openLocation;
		var window;
		var WebView;
		var tapHandler;
		var URLBar;
		var currentTab = null;
		var disposed = false;
		
		public function BNFox()
		{
			appName = loaderInfo.parameters.appName;
			openLocation = loaderInfo.parameters.fileLocation;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(evt)
		{
			window = this.parent.parent.parent as Object;
			
			main = window.main;
			
			setupWindow();
			setupWebView();
			setupURLBar();
			setupTab();
		}
		
		private function setupWindow()
		{
			background_mc.y = 16 + tab_sp.height + URLBar_mask.height;
			tab_sp.y = 16;
			URLBar_mask.y = 16 + tab_sp.height;
			URLBar_loader.y = URLBar_mask.y;
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(evt)
		{
			background_mc.width = window.background_mc.width;
			background_mc.height = window.background_mc.height - background_mc.y;
			
			if (!disposed)
				WebView.viewPort = new Rectangle(window.x, window.y + 16 + tab_sp.height + URLBar_mask.height, background_mc.width, background_mc.height);
			
			tab_sp.width = background_mc.width;
			URLBar_mask.width = background_mc.width;
		}
		
		private function setupWebView()
		{
			WebView = new StageWebView();
			
			WebView.stage = this.stage;
			
			WebView.addEventListener(Event.COMPLETE, WebViewLoaded);
			WebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, WebViewLocationChange);
			WebView.addEventListener(ErrorEvent.ERROR, WebViewError);
		}
		
		private function setupURLBar()
		{
			// Preventive
			URLBar_mask.mouseEnabled = false;
			
			URLBar = new URLBar_class(this);
			URLBar_loader.addChild(URLBar);
		}
		
		private function setupTab()
		{
			tapHandler = new TapHandler(main, this);
			tab_sp.source = tapHandler;
		}
		
		public function loadWeb(url)
		{
			if (url.substr(0, 6) == "about:")
			{
				var page = url.substr(6);
				
				var nativeLocation = File.applicationDirectory.resolvePath("bernardos/app/BNFox/pages/about/" + page + ".html");
				nativeLocation = File.desktopDirectory.resolvePath(nativeLocation.nativePath);
				
				WebView.loadURL(nativeLocation.url);
			}
			else if (url.substr(0, 8) == "https://" || url.substr(0, 7) == "http://" || url.substr(0, 8) == "file:///")
			{
				WebView.loadURL(url);
			}
			else if (url.split(".").length > 1)
			{
				WebView.loadURL("http://" + url);
			}
			else
			{
				WebView.loadURL("https://bing.com/search?q=" + url);
			}
		}
		
		private function WebViewLoaded(evt)
		{
			if (currentTab == null)
				return;
			
			currentTab.hideLoadingCircle();
			currentTab.showIcon(WebView.location);
			currentTab.setTitle(WebView.title);
			URLBar.setLocation(WebView.location);
		}
		
		private function WebViewLocationChange(evt)
		{
			trace("Changing Location to: " + WebView.location);
			
			if (currentTab == null)
				return;
			
			URLBar.setLocation(WebView.location);
			currentTab.setTitle("Connecting ..");
			currentTab.showLoadingCircle();
		}
		
		private function WebViewError(evt)
		{
			trace("WebViewError");
			WebView.stop();
			
			// Fix race-condition: Can't loadWeb("about:NotFound").
			var tempTimer = new Timer(150, 1)
			tempTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(evt) { loadWeb("about:NotFound"); });
			
			tempTimer.start();
		}
		
		public function closeHandler()
		{
			disposed = true;
			WebView.dispose();
			
			// For efficiency
			this.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
	}
}
