package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class sidebar_menu_list extends MovieClip
	{
		var sidebar_menu_mc;
		var menuTitle;
		var folderLocation;
		
		public function sidebar_menu_list(_sidebar_menu_mc, _menuTitle, _folderLocation)
		{
			sidebar_menu_mc = _sidebar_menu_mc;
			menuTitle = _menuTitle;
			folderLocation = _folderLocation;
			
			this.buttonMode = true;
			
			menuText_txt.text = menuTitle;
			menuText_txt.selectable = false;
			
			this.addEventListener(MouseEvent.CLICK, clickMenuHandler);
		}
		
		private function clickMenuHandler(evt)
		{
			sidebar_menu_mc.BeeExplorer.beeTo(folderLocation);
		}
	}
}
