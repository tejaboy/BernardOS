package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	
	public class BeeExplorer_App_class extends MovieClip
	{
		var BeeExplorer;
		var info;
		var iconLoader;
		var colour:Color = new Color();
		
		public function BeeExplorer_App_class(_BeeExplorer, _info)
		{
			BeeExplorer = _BeeExplorer;
			info = _info;
			
			this.buttonMode = true;
			this.x = info["pos_x"];
			this.y = info["pos_y"];
			
			text_txt.text = info["name"];
			
			iconLoader = new Loader();
			iconLoader.load(new URLRequest("../../" + info["icon"]));
			iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoaded);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		private function iconLoaded(evt)
		{
			iconLoader_mc.addChild(iconLoader);
		}
		
		private function mouseOverHandler(evt)
		{
			colour.setTint(0x3BF73E, 0.8);
			background_mc.transform.colorTransform = colour;
		}
		
		private function mouseOutHandler(evt)
		{
			colour.setTint(0xFFAAFF, 0);
			background_mc.transform.colorTransform = colour;
		}
		
		private function mouseClickHandler(evt)
		{
			if (info["extension"] == "folder")
			{
				BeeExplorer.beeTo(BeeExplorer.currentFolder + "/" + info["name"]);
			}
			else if (info["extension"] == undefined)
			{
				trace("Bee 'call popup'");
				BeeExplorer.main.popupHandler.popup("ok", "There is no default application associated with this file extension. Please contact your system administrator for more information.");
			}
			else
			{
				BeeExplorer.main.loadApp(BeeExplorer.main.settings["defaultApps"][info["extension"]], info["location"]);
			}
		}
	}
}