package
{
	import flash.display.MovieClip;
	
	// Third Party Classes
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class tab_class extends MovieClip
	{
		var loadingCircle = new tab_loadingCircle_class;
		
		public function tab_class(tabURL)
		{
			loadingCircle.x = loadingCircle.width / 2;
			loadingCircle.y = loadingCircle.height / 2;
			loadingCircle.visible = false;
			
			icon_loader.addChild(loadingCircle);
			
			title_txt.text = tabURL;
		}
		
		public function setTitle(title)
		{
			title_txt.text = title;
		}
		
		public function showLoadingCircle()
		{
			loadingCircle.visible = true;
		}
		
		public function hideLoadingCircle()
		{
			loadingCircle.visible = false;
		}
		
		public function showIcon(location)
		{
			var rootLocation = location.split("/");
			rootLocation = rootLocation[0] + "//" + rootLocation[2];
			
			// var iconLoader:ImageLoader = new ImageLoader("https://www.google.com/favicon.ico", {onComplete: iconLoaded});
			// iconLoader.load();
		}
		
		private function iconLoaded(evt)
		{
			icon_loader.addChild(evt.target.rawContent);
		}
	}
}
