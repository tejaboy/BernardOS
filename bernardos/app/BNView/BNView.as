package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class BNView extends MovieClip
	{
		var main;
		var appName;
		var fileLocation;
		var window;
		var fileName;
		var colour = new Color();
		
		public function BNView()
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
			setupNavigation();
			
			setupAdditionalDrag();
		}
		
		private function setupWindow()
		{
			background_mc.y = 16;
			imageLoader_mc.y = 16;
			imageLoader_sp.y = 16;
			
			fileName_txt.x = 6;
			fileName_txt.y = -2;
			
			fileName_selection.x = 6;
			fileName_selection.y = -2;
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			loadImage();
		}
		
		private function update(evt)
		{
			this.x = window.background_mc.x;
			this.y = window.background_mc.y;
			
			background_mc.width = window.background_mc.width;
			background_mc.height = window.background_mc.height - 16 - 30;
			
			imageLoader_sp.width = window.background_mc.width;
			imageLoader_sp.height = window.background_mc.height - 16 - 30;
			
			bottomNav_mc.width = background_mc.width;
			bottomNav_mc.y = window.background_mc.height - bottomNav_mc.height;
			
			bottomNav_mask.width = bottomNav_mc.width;
			bottomNav_mask.y = bottomNav_mc.y;
			
			bottomNav_zoomIn_mc.y = bottomNav_mc.y;
			
			bottomNav_zoomOut_mc.y = bottomNav_mc.y;
			bottomNav_zoomOut_mc.x = bottomNav_zoomOut_mc.width;
		}
		
		private function loadImage()
		{
			if (fileLocation != null)
			{
				var tempFileName = fileLocation.split("/");
				fileName = tempFileName[tempFileName.length - 1];
				
				if (fileName.length > 13)
				{
					fileName = fileName.substr(0, 13) + " ...";
				}
				
				var imageLoader = new ImageLoader("bernardos/" + fileLocation, {onComplete: imageLoaded});
				
				imageLoader.load();
			}
			else
			{
				fileName_txt.text = "Nothing!";
			}
		}
		
		private function imageLoaded(event)
		{
			imageLoader_mc.addChild(event.target.rawContent);
			
			imageLoader_mc.buttonMode = true;
			
			imageLoader_sp.source = imageLoader_mc;
			
			fileName_txt.text = fileName;
			
			trace(fileName);
		}
		
		private function setupNavigation()
		{
			bottomNav_zoomIn_mc.buttonMode = true;
			bottomNav_zoomOut_mc.buttonMode = true;
			
			bottomNav_zoomIn_mc.addEventListener(MouseEvent.CLICK, zoomIn);
			bottomNav_zoomOut_mc.addEventListener(MouseEvent.CLICK, zoomOut);
			
			
			bottomNav_zoomIn_mc.addEventListener(MouseEvent.MOUSE_OVER, function(evt) { mouseOverButton(bottomNav_zoomIn_mc); });
			bottomNav_zoomOut_mc.addEventListener(MouseEvent.MOUSE_OVER, function(evt) { mouseOverButton(bottomNav_zoomOut_mc); });
			
			bottomNav_zoomIn_mc.addEventListener(MouseEvent.MOUSE_OUT, function(evt) { mouseOutButton(bottomNav_zoomIn_mc); });
			bottomNav_zoomOut_mc.addEventListener(MouseEvent.MOUSE_OUT, function(evt) { mouseOutButton(bottomNav_zoomOut_mc); });
		}
		
		private function zoomIn(evt)
		{
			imageLoader_mc.width += imageLoader_mc.width / 4;
			imageLoader_mc.height += imageLoader_mc.height / 4;
			
			imageLoader_sp.source = imageLoader_mc;
		}
		
		private function zoomOut(evt)
		{
			if (imageLoader_mc.width <= 200)
				return
			
			imageLoader_mc.width -= imageLoader_mc.width / 4;
			imageLoader_mc.height -= imageLoader_mc.height / 4;
			
			imageLoader_sp.source = imageLoader_mc;
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
		
		private function setupAdditionalDrag()
		{
			window.additionalDrag(fileName_selection);
		}
		
		public function closeHandler()
		{
			// For efficiency
			this.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
	}
}
