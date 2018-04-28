package
{
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.media.SoundTransform;
	
	// Custom classes
	import bernardos.SettingHandler;
	import bernardos.MouseHandler;
	import bernardos.PopupHandler;
	import bernardos.rightBox_class;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;

	public class main extends MovieClip
	{
		public const bernardosPath = "bernardos/";
		var settings = new Object;
		var instancedApps = new Object;
		
		var settingHandler = new SettingHandler();
		var mouseHandler;
		var popupHandler;
		
		var desktop_screen_obj;
		
		var rightBox;
		
		var mainTransform = new SoundTransform();
		
		public function main()
		{
			mouseHandler = new MouseHandler(this);
			popupHandler = new PopupHandler(this);
			
			ScreenLoader_mc.addChild(new intro_screen(this));
			
			rightBox = new rightBox_class(this);
			this.addChild(rightBox);
			
			mainTransform.volume = 1;
		}
		
		public function showLogin()
		{
			ScreenLoader_mc.addChild(new login_screen(this));
		}
		
		public function loadDesktop(desktopSettings)
		{
			settings["desktop"] = desktopSettings;
			
			desktop_screen_obj = new desktop_screen(this);
			ScreenLoader_mc.addChild(desktop_screen_obj);
		}
		
		public function loadApp(app, fileLocation = null)
		{
			var appNum = getObjectLength(instancedApps) + 1;
			
			if (fileLocation == null)
				instancedApps[appNum] = new default_window_class(this, app, appNum);
			else
				instancedApps[appNum] = new default_window_class(this, app, appNum, fileLocation);
			
			desktop_screen_obj.instancedApp_loader_mc.addChild(instancedApps[appNum]);
		}
		
		// Misc
		
		public function getObjectLength(object:Object)
		{
			var count = 0;
			
			for (var s:String in object)
				count++;
				
			return count;
		}
		
		public function getChildrenOf(target):Array
		{
			// Reference: https://stackoverflow.com/questions/4867558/get-all-children-on-the-stage-parent-object
			// May be the same script, but it works as needed so I didn't change anything. I fully understand the concept.
			// Only used for debugging.
			
			var children:Array = [];
			for (var i:uint = 0; i < target.numChildren; i++) children.push(target.getChildAt(i));
			
			return children;
		}
	}
}