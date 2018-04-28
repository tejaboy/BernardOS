package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.filesystem.FileStream;
	
	public class BeeExplorer extends MovieClip
	{
		var main;
		var appName;
		var startLocation;
		var window;
		var sidebar = new Object;
		var folder;
		var files;
		var loadedFiles = new Object;
		var currentFolder;
		
		public function BeeExplorer()
		{
			trace("Starting up BeeExplorer");
			
			appName = loaderInfo.parameters.appName;
			startLocation = loaderInfo.parameters.fileLocation;
			
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
			background_mc.y = 30 + 16;
			sidebar_sp.y = background_mc.y;
			
			topbar_mask_mc.y = 16;
			topbar_mc.y = topbar_mask_mc.y;
			
			sidebar = new sidebar_menu_mc(this);
			
			sidebar_sp.source = sidebar;
			
			explorer_sp.x = sidebar_sp.width;
			explorer_sp.y = background_mc.y;
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			if (startLocation == undefined)
				beeTo("data/desktop");
			else
				beeTo(startLocation);
		}
		
		private function update(evt)
		{
			this.x = window.background_mc.x;
			this.y = window.background_mc.y;
			background_mc.width = window.background_mc.width;
			background_mc.height = window.background_mc.height - 30 - 16;
			
			sidebar_sp.height = background_mc.height;
			
			topbar_mask_mc.width = background_mc.width;
			
			explorer_sp.height = background_mc.height;
			explorer_sp.width = background_mc.width - sidebar_sp.width;
		}
		
		// Exploring!
		public function beeTo(beeFolder)
		{
			trace("Beeing to " + beeFolder);
			
			currentFolder = beeFolder;
			
			topbar_mc.locationText_txt.text = beeFolder;
			
			while (explorer_mc.numChildren > 0)
				explorer_mc.removeChildAt(0);
			
			folder = File.applicationDirectory.resolvePath("bernardos/" + currentFolder);
			files = folder.getDirectoryListing();
			
			processFolder();
		}
		
		private function processFolder()
		{
			var currentX = 0;
			var currentY = 0;
			var increaseY = 96;
			
			for (var i = 0; i < files.length; i++)
			{
				currentY = i * increaseY;
				
				var fileName = files[i].name;
				var fileExtension = "folder";
				var lastDotIndex = fileName.lastIndexOf(".");
				
				if (lastDotIndex >= 0)
				{
					fileExtension = fileName.substr(lastDotIndex + 1);
					// fileName = fileName.substr(0, lastDotIndex) // To distinguish between folders and files.
				}
				
				var info = new Object;
				info["name"] = fileName;
				info["extension"] = fileExtension;
				info["location"] = currentFolder + "/" + fileName;
				info["pos_x"] = currentX;
				info["pos_y"] = currentY;
				info["icon"] = main.settings["extensionIcons"][fileExtension];
				
				if (info["icon"] == undefined)
				{
					info["icon"] = main.settings["extensionIcons"]["undefined"];
				}
				
				if (main.settings["defaultApps"][info["extension"]] == undefined && info["extension"] != "folder")
				{
					info["extension"] = undefined;
				}
				
				loadedFiles[i] = new BeeExplorer_App_class(this, info);
				
				explorer_mc.addChild(loadedFiles[i]);
			}
			
			explorer_sp.source = explorer_mc;
		}
		
		public function closeHandler()
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
	}
}