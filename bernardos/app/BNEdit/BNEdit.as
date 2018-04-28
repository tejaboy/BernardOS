package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	import flash.filesystem.*;
	import flash.filesystem.FileStream;
	
	public class BNEdit extends MovieClip
	{
		var main;
		var appName;
		var fileLocation;
		var nativeLocation;
		var window;
		var colour = new Color();
		
		public function BNEdit()
		{
			appName = loaderInfo.parameters.appName;
			fileLocation = loaderInfo.parameters.fileLocation;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(evt)
		{
			window = this.parent.parent.parent as Object;
			
			main = window.main;
			
			setupWindow();
		}
		
		private function setupWindow()
		{
			background_mc.y = 16;
			editor_mc.x = 0;
			editor_mc.y = 16;
			
			topbar_mc.x = 0;
			topbar_mc.y = 0;
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			setupEditor();
			setupNav();
		}
		
		private function update(evt)
		{
			this.x = window.background_mc.x;
			this.y = window.background_mc.y;
			
			background_mc.width = window.background_mc.width;
			background_mc.height = window.background_mc.height - 16;
			
			editor_mc.width = background_mc.width;
			editor_mc.height = background_mc.height;
		}
		
		// Editor and loading content
		private function setupEditor()
		{
			var textAreaFormat = new TextFormat();
			textAreaFormat.font = "Lucida Console";
			textAreaFormat.leading = -3;
			textAreaFormat.size = "12";
			
			editor_mc.setStyle("textFormat", textAreaFormat);
			
			if (fileLocation != null)
			{
				var textLoader:URLLoader = new URLLoader();
				
				textLoader.load(new URLRequest("../../" + fileLocation));
				
				textLoader.addEventListener(Event.COMPLETE, fileLoaded);
			}
		}
		
		private function fileLoaded(evt)
		{
			editor_mc.text = evt.target.data;
		}
		
		// Navigation
		private function setupNav()
		{
			topbar_mc.topbar_open_mc.buttonMode = true;
			topbar_mc.topbar_save_mc.buttonMode = true;
			
			topbar_mc.topbar_open_mc.addEventListener(MouseEvent.CLICK, clickOpenHandler);
			topbar_mc.topbar_save_mc.addEventListener(MouseEvent.CLICK, clickSaveHandler);
			
			topbar_mc.topbar_open_mc.addEventListener(MouseEvent.MOUSE_OVER, function(evt) { mouseOverButton(topbar_mc.topbar_open_mc); });
			topbar_mc.topbar_save_mc.addEventListener(MouseEvent.MOUSE_OVER, function(evt) { mouseOverButton(topbar_mc.topbar_save_mc); });
			
			topbar_mc.topbar_open_mc.addEventListener(MouseEvent.MOUSE_OUT, function(evt) { mouseOutButton(topbar_mc.topbar_open_mc); });
			topbar_mc.topbar_save_mc.addEventListener(MouseEvent.MOUSE_OUT, function(evt) { mouseOutButton(topbar_mc.topbar_save_mc); });
		}
		
		private function clickOpenHandler(evt)
		{
			main.loadApp("BeeExplorer");
		}
		
		private function clickSaveHandler(evt)
		{
			nativeLocation = File.applicationDirectory.resolvePath("bernardos/" + fileLocation);
			nativeLocation = File.desktopDirectory.resolvePath(nativeLocation.nativePath);
			
			var stream = new FileStream();
			stream.open(nativeLocation, FileMode.WRITE);
			stream.writeUTFBytes(editor_mc.text);
			stream.close();
		}
		
		private function mouseOverButton(mc)
		{
			colour.setTint(0x99CC00, 0.8);
			mc.background_mc.transform.colorTransform = colour;
		}
		
		private function mouseOutButton(mc)
		{
			colour.setTint(0x99CC00, 0);
			mc.background_mc.transform.colorTransform = colour;
		}
		
		public function closeHandler()
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
	}
}
