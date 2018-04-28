package bernardos
{
	import flash.ui.Mouse;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class MouseHandler
	{
		var main;
		
		public function MouseHandler(_main)
		{
			main = _main;
		}
		
		public function change(type)
		{
			// Reference: http://www.republicofcode.com/tutorials/flash/as3customcursor/
			// Only the .startDrag() method. The rest of the codes, I write it by myself to make it works with my OS.
			
			if (type == "default")
			{
				Mouse.show();
				main.MouseLoader_mc.visible = false;
				
				return;
			}
			
			while (main.MouseLoader_mc.numChildren > 0)
			{
				main.MouseLoader_mc.removeChildAt(0);
			}
			
			Mouse.hide();
			main.MouseLoader_mc.visible =  true;
			
			var mouseIconLoader:ImageLoader = new ImageLoader(main.bernardosPath + "data/images/customMouse/" + type + ".png", {onComplete:onMouseIconLoaded});
			mouseIconLoader.load();
			
			function onMouseIconLoaded(event:LoaderEvent)
			{
				main.MouseLoader_mc.x = main.stage.mouseX;
				main.MouseLoader_mc.y = main.stage.mouseY;
				
				main.MouseLoader_mc.addChild(event.target.rawContent);
				main.MouseLoader_mc.startDrag();
			}
		}
	}
}
