package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// Third Party Classes
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	import flash.media.SoundChannel;
	
	public class DesktopApp_class extends MovieClip
	{
		var desktop_screen;
		var info;
		var customName;
		
		var disableClick = false;
		
		public function DesktopApp_class(_desktop_screen, _info, _customName)
		{
			var iconLoader;
			
			desktop_screen = _desktop_screen;
			info = _info;
			customName = _customName;
			
			if (info["type"] == "app")
			{
				iconLoader = new ImageLoader("bernardos/app/" + info["location"] + "/icon-64.png", {onComplete: iconLoaded});
			}
			else
			{
				iconLoader = new ImageLoader("bernardos/data/images/icons/" + info["type"] + "-Icon-64.png", {onComplete: iconLoaded});
			}
			
			iconLoader.load();
			
			this.x = info["pos_x"];
			this.y = info["pos_y"];
			this.buttonMode = true;
			
			this.text_txt.text = customName;
			this.text_txt.selectable = false;
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function iconLoaded(event)
		{
			iconLoader_mc.addChild(event.target.rawContent);
		}
		
		private function clickHandler(evt = null)
		{
			if (disableClick == false)
			{
				if (info["type"] == "app")
				{
					desktop_screen.main.loadApp(info["location"]);
				}
				else if(info["type"] == "Folder")
				{
					desktop_screen.main.loadApp("BeeExplorer", info["location"]);
				}
				
				var tempSound = new mouseClick_snd();
				var tempChannel = new SoundChannel();
				tempChannel = tempSound.play();
				tempChannel.soundTransform = desktop_screen.main.mainTransform;
			}
			else
			{
				disableClick = false;
			}
		}
		
		private function rightClickHandler(evt)
		{
			trace("Right-click");
			
			var openText = "App";
			
			if (info["type"] != "app")
			{
				openText = info["type"];
			}
			
			desktop_screen.main.rightBox.clearMenu();
			desktop_screen.main.rightBox.addList("Open " + openText, clickHandler);
			desktop_screen.main.rightBox.drawMenu();
		}
		
		private function mouseDownHandler(evt)
		{
			this.startDrag();
		}
		
		private function mouseUpHandler(evt)
		{
			this.stopDrag();
			
			if (this.x != info["pos_x"] || this.y != info["pos_y"])
			{
				disableClick = true;
				
				info["pos_x"] = this.x;
				info["pos_y"] = this.y;
				
				desktop_screen.updateDesktopApps(customName, info);
			}
		}
	}
}
