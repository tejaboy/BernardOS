package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	
	public class URLBar_class extends MovieClip
	{
		var BNFox;
		var WebView;
		var URLBarTxt_Selected = false;
		
		public function URLBar_class(_BNFox)
		{
			BNFox = _BNFox;
			WebView = BNFox.WebView;
			
			setupButtons();
			
			URLBar_txt.addEventListener(MouseEvent.CLICK, clickURLBarTxt);
			URLBar_txt.addEventListener(KeyboardEvent.KEY_DOWN, keyDownURLBarTxt);
		}
		
		private function setupButtons()
		{
			prev_mc.buttonMode = next_mc.buttonMode = true;
			prev_mc.stop();
			next_mc.stop();
			
			prev_mc.addEventListener(MouseEvent.CLICK, clickPrevButton);
			next_mc.addEventListener(MouseEvent.CLICK, clickNextButton);
			
			prev_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton);
			next_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton);
			
			prev_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton);
			next_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton);
		}
		
		private function clickPrevButton(evt)
		{
			if (WebView.isHistoryBackEnabled)
				WebView.historyBack();
		}
		
		private function clickNextButton(evt)
		{
			if (WebView.isHistoryForwardEnabled)
				WebView.historyForward();
		}
		
		private function mouseOverButton(evt)
		{
			var target = evt.target;
			
			target.gotoAndStop(2);
		}
		
		private function mouseOutButton(evt)
		{
			var target = evt.target;
			
			target.gotoAndStop(1);
		}
		
		private function clickURLBarTxt(evt)
		{
			if (URLBarTxt_Selected)
			{
				URLBarTxt_Selected = false;
			}
			else
			{
				URLBarTxt_Selected = true;
				URLBar_txt.setSelection(0, URLBar_txt.text.length);
			}
		}
		
		private function keyDownURLBarTxt(evt)
		{
			if (evt.charCode == 13)
			{
				BNFox.loadWeb(URLBar_txt.text);
			}
		}
		
		public function setLocation(location)
		{
			var nativeAppLocation = File.applicationDirectory.resolvePath("bernardos/app/BNFox");
			nativeAppLocation = File.desktopDirectory.resolvePath(nativeAppLocation.nativePath).url;
			
			trace(nativeAppLocation);
			
			if (location.substr(0, nativeAppLocation.length) == nativeAppLocation)
			{
				return;
			}
			else if (location.substr(0, 7) == "file://")
			{
				var nativeOSLocation = File.applicationDirectory.resolvePath("bernardos");
				nativeOSLocation = File.desktopDirectory.resolvePath(nativeOSLocation.nativePath).url;
				
				URLBar_txt.text = "files://" + location.substr(nativeOSLocation.length);
				
				return;
			}
			
			URLBar_txt.text = location;
		}
	}
}
