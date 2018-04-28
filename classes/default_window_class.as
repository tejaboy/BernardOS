package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.filesystem.*;
	import flash.filesystem.FileStream;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class default_window_class extends MovieClip
	{
		var main;
		var app;
		var appName;
		var appInstance;
		var appLayer;
		var fileLocation;
		var appSettings;
		var AppLoader:SWFLoader;
		var minimized = false;
		const MAX_WIDTH = 1140;
		const MAX_HEIGHT = 600;
		const MIN_WIDTH = 230;
		const MIN_HEIGHT = 200;
		
		var updateWindowSizeParams = new Object;
		var dynamicSize = new Object;
		
		var loader = new Loader();
		
		public function default_window_class(_main, _appName, _appInstance, _fileLocation = null)
		{
			main = _main;
			appName = _appName;
			appInstance = _appInstance;
			appLayer = appInstance;
			fileLocation = _fileLocation;
			resetDynamicValues(true);
			resetNavbar();
			
			// Self clicked
			this.addEventListener(MouseEvent.CLICK, clickSelfHandler);
			
			// Resizing
			default_window_navbar_mc.maximize_mc.addEventListener(MouseEvent.CLICK, clickMaximizeHandler);
			//default_window_navbar_mc.minimize_mc.addEventListener(MouseEvent.CLICK, clickMinimizeHandler);
			
			// Resizing - border hovers
			border_top_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBorderHorizontalHandler);
			border_top_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBorderHandler);
			border_bottom_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBorderHorizontalHandler);
			border_bottom_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBorderHandler);
			border_left_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBorderVerticalHandler);
			border_left_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBorderHandler);
			border_right_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBorderVerticalHandler);
			border_right_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBorderHandler);
			
			// Resizing - border clicks
			border_top_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBorderTopHandler);
			border_bottom_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBorderBottomHandler);
			border_left_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBorderLeftHandler);
			border_right_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBorderRightHandler);
			
			// Resizing - border mouse up
			border_top_mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpBorderHandler);
			border_bottom_mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpBorderHandler);
			border_left_mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpBorderHandler);
			border_right_mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpBorderHandler);
			
			// Closing
			default_window_navbar_mc.close_mc.addEventListener(MouseEvent.CLICK, clickCloseHandler);
			
			// Dragging
			default_window_topbar_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDragHandler)
			default_window_topbar_mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpDragHandler)
			
			default_window_topbar_mc.buttonMode = true;
			
			loadApplication();
			
			border_top_mc.visible = false;
			border_bottom_mc.visible = false;
			border_left_mc.visible = false;
			border_right_mc.visible = false;
			
			this.x = MAX_WIDTH;
			this.y = MAX_HEIGHT;
			this.rotationX = 100;
			this.rotationY = 90;
			this.alpha = 0;
			
			TweenLite.to(this, 0.42, {x: 0, y: 0, rotationX: 0, rotationY: 0, alpha: 1, onComplete: resetBorder});
		}
		
		private function loadApplication()
		{
			main.settingHandler.getSetting("bernardos/app/" + appName + "/settings.ini", settingsLoaded);
		}
		
		private function settingsLoaded(_settings)
		{
			appSettings = _settings;
			
			// Now let's load the application!
			var loaderContext = new LoaderContext();
			
			loaderContext.parameters = {"appName": appName};
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			
			if (fileLocation != null)
			{
				loaderContext.parameters = {"appName": appName, "fileLocation": fileLocation};
			}
			
			if (appSettings.windowtype == "fla")
			{
				loader.load(new URLRequest("bernardos/app/" + appName + "/main.swf"), loaderContext);
			}
			else
			{
				loader.load(new URLRequest("bernardscript/version1.swf"), loaderContext);
			}
			
			application_loader.addChild(loader);
			
			clickSelfHandler(); // Fix a race-condition (application opened within an application will be behind the application that makes the call).
		}
		
		private function loaderComplete(evt)
		{
			app = MovieClip(evt.target.content);
		}
		
		private function clickSelfHandler(evt = null)
		{
			main.desktop_screen_obj.clickApp(appLayer);
		}
		
		// Maximize button
		private function clickMaximizeHandler(evt)
		{
			if (background_mc.width != MAX_WIDTH && background_mc.height != MAX_HEIGHT || this.y != 0)
			{
				// Maximize
				trace("Maximize");
				
				resizeWindow(MAX_WIDTH, MAX_HEIGHT);
			}
			else
			{
				// Minimize
				trace("Minimize");
				
				resizeWindow(dynamicSize["width"], dynamicSize["height"]);
			}
		}
		
		public function resizeWindow(width_, height_)
		{
			default_window_navbar_mc.visible = false;
			TweenLite.to(background_mc, 0.42, {width: width_, height: height_});
			TweenLite.to(default_window_topbar_mc, 0.42, {width: width_, onComplete: resetNavbar});
			
			// Borders
			TweenLite.to(border_top_mc, 0.42, {width: width_ + 4});
			TweenLite.to(border_bottom_mc, 0.42, {width: width_ + 4, y: height_});
			TweenLite.to(border_left_mc, 0.42, {height: height_});
			TweenLite.to(border_right_mc, 0.42, {height: height_, x: width_});
			
			if (width_ == MAX_WIDTH && height_ == MAX_HEIGHT)
			{
				TweenLite.to(this, 0.42, {x: 0, y: 0});
			}
			else
			{
				TweenLite.to(this, 0.42, {x: dynamicSize["x"], y: dynamicSize["y"], onComplete: resetDynamicValues});
			}
		}
		
		public function resetNavbar()
		{
			default_window_navbar_mc.x = background_mc.x + (background_mc.width - default_window_navbar_mc.width);
			default_window_navbar_mc.y = 0;
			default_window_navbar_mc.visible = true;
		}
		
		// Minimize
		private function clickMinimizeHandler(evt)
		{
			TweenLite.to(this, 0.42, {x: MAX_WIDTH, alpha: 0, onComplete: minimizeWindow});
		}
		
		public function minimizeWindow()
		{
			minimized = true;
			this.visible = false;
		}
		
		// Resizing via borders
		private function mouseOverBorderHorizontalHandler(evt)
		{
			if (isFullscreen()) return;
			
			main.mouseHandler.change("resizeHorizontal");
			
			main.MouseLoader_mc.y -= 16;
		}
		
		private function mouseOverBorderVerticalHandler(evt)
		{
			if (isFullscreen()) return;
			
			main.mouseHandler.change("resizeVertical");
		}
		
		private function mouseOutBorderHandler(evt)
		{
			if (isFullscreen()) return;
			
			main.mouseHandler.change("default");
		}
		
		// Border Top
		private function mouseDownBorderTopHandler(evt)
		{
			updateWindowSizeParams["startBox"] = background_mc.height;
			updateWindowSizeParams["borderType"] = "top";
			
			stage.addEventListener(Event.ENTER_FRAME, updateWindowSize);
		}
		
		// Border Bottom
		private function mouseDownBorderBottomHandler(evt)
		{
			// Took me sometime to figure out the math for resizing of windows ...
			updateWindowSizeParams["startBox"] = background_mc.height;
			updateWindowSizeParams["borderType"] = "bottom";
			
			stage.addEventListener(Event.ENTER_FRAME, updateWindowSize);
		}
		
		// Border Left
		private function mouseDownBorderLeftHandler(evt)
		{
			updateWindowSizeParams["startBox"] = background_mc.width;
			updateWindowSizeParams["borderType"] = "left";
			
			stage.addEventListener(Event.ENTER_FRAME, updateWindowSize);
		}
		
		// Border Right
		private function mouseDownBorderRightHandler(evt)
		{
			updateWindowSizeParams["startBox"] = background_mc.width;
			updateWindowSizeParams["borderType"] = "right";
			
			stage.addEventListener(Event.ENTER_FRAME, updateWindowSize);
		}
		
		// Updates for resizing via borders
		private function updateWindowSize(evt)
		{
			// Amazing. Took me a few days to get the right formula due to "pivot" point problem.
			var startBox = updateWindowSizeParams["startBox"];
			var borderType = updateWindowSizeParams["borderType"];
			
			if (borderType == "top")
			{
				background_mc.y = this.mouseY;
				default_window_topbar_mc.y = this.mouseY;
				default_window_navbar_mc.y = this.mouseY;
				background_mc.height = startBox + (this.mouseY * -1);
			}
			else if (borderType == "bottom")
			{
				background_mc.height = startBox - (startBox - this.mouseY);
			}
			else if (borderType == "left")
			{
				background_mc.x = this.mouseX;
				default_window_topbar_mc.x = this.mouseX;
				background_mc.width = startBox + (this.mouseX * -1);
				default_window_topbar_mc.width = background_mc.width;
			}
			else if (borderType == "right")
			{
				background_mc.width = startBox - (startBox - this.mouseX);
				default_window_topbar_mc.width = background_mc.width;
				
				resetNavbar();
			}
			
			resetBorder();
		}
		
		private function resetBorder(forceReset = false)
		{
			border_top_mc.visible = true;
			border_bottom_mc.visible = true;
			border_left_mc.visible = true;
			border_right_mc.visible = true;
			
			var follow = background_mc;
			
			border_top_mc.width = follow.width + 4;
			border_top_mc.x = follow.x - 2;
			border_top_mc.y = follow.y - 2;
			
			border_bottom_mc.width = follow.width + 4;
			border_bottom_mc.x = follow.x - 2;
			
			if (updateWindowSizeParams["borderType"] != "top" || forceReset == true) border_bottom_mc.y = follow.height;
			
			border_left_mc.height = follow.height;
			border_left_mc.x = follow.x - 2;
			border_left_mc.y = follow.y;
			
			border_right_mc.height = follow.height;
			
			if (updateWindowSizeParams["borderType"] != "left" || forceReset == true) border_right_mc.x = follow.width;
			
			border_right_mc.y = follow.y;
		}
		
		// Resizing via borders - mouse up
		private function mouseUpBorderHandler(evt)
		{
			stage.removeEventListener(Event.ENTER_FRAME, updateWindowSize);
			
			// Change pivot point
			this.x += background_mc.x;
			this.y += background_mc.y;
			
			background_mc.x = 0;
			default_window_topbar_mc.x = 0;
			
			background_mc.y = 0;
			default_window_topbar_mc.y = 0;
			
			resetNavbar();
			resetBorder(true);
			resetDynamicValues();
		}
		
		// Close
		private function clickCloseHandler(evt)
		{
			TweenLite.to(this, 0.42, {x: 0, y: 0, rotationX: 100, rotationY: 90, alpha: 0, onComplete: closeWindow});
			
			app.closeHandler();
		}
		
		public function closeWindow()
		{
			this.visible = false;
			
			// For efficiency
			application_loader.removeChild(loader);
			loader.unload();
			loader = null;
		}
		
		// Dragging windows
		private function mouseDownDragHandler(evt)
		{
			this.startDrag();
		}
		
		private function mouseUpDragHandler(evt)
		{
			this.stopDrag();
			resetDynamicValues();
		}
		
		// Misc functions
		public function isFullscreen()
		{
			return (background_mc.width == MAX_WIDTH && background_mc.height == MAX_HEIGHT && this.x == 0 && this.y == 0);
		}
		
		private function resetDynamicValues(initialization = false)
		{
			if (initialization)
			{
				dynamicSize["width"] = 500;
				dynamicSize["height"] = 300;
			}
			else
			{
				dynamicSize["width"] = background_mc.width;
				dynamicSize["height"] = background_mc.height;
			}
			
			dynamicSize["x"] = this.x;
			dynamicSize["y"] = this.y;
		}
		
		// Public function
		public function additionalDrag(mc)
		{
			// For applications that cover the topbar hence disabling the build in dragging functionality.
			// Application can however, call this function alongside with their own dragging mc to enable drag in certain place.
			
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDragHandler)
			mc.addEventListener(MouseEvent.MOUSE_UP, mouseUpDragHandler)
			
			// Trust me, I come up with this logic myself. BernardOS project is already so big, where do you think I will be able to find a specific stackoverflow or codes for my very own codebase?
		}
	}
}