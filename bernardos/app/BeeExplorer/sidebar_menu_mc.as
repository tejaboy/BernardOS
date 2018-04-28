package
{
	import flash.display.MovieClip;

	public class sidebar_menu_mc extends MovieClip 
	{
		var BeeExplorer;
		var main;
		var menu = new Object();
		var menuVisible = new Object();
		
		public function sidebar_menu_mc(_BeeExplorer)
		{
			BeeExplorer = _BeeExplorer;
			main = BeeExplorer.window.main;
			
			addLink("Desktop", "data/desktop");
			addLink("Applications", "app");
			addLink("BernardOS Drive", "");
			addLink("Bernard Folder", "data/desktop/Bernard Folder");
			
			showMenu();
		}
		
		private function showMenu()
		{
			var increaseY = 36;
			
			for (var i = 0; i < main.getObjectLength(menu); i++)
			{
				menuVisible[i] = new sidebar_menu_list(this, menu[i]["linkName"], menu[i]["linkLocation"]);
				menuVisible[i].y = i * increaseY;
				
				menuLoader_mc.addChild(menuVisible[i]);
			}
		}
		
		private function addLink(linkName, linkLocation)
		{
			var count = String(main.getObjectLength(menu));
			
			menu[count] = new Object;
			menu[count]["linkName"] = linkName;
			menu[count]["linkLocation"] = linkLocation;
		}
	}
}
