package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	// Third Party Classes
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class login_screen extends MovieClip
	{
		var main;
		var input_password;
		
		public function login_screen(_main)
		{
			main = _main;
			
			this.alpha = 0;
			this.rotationX = -100;
			
			animation();
		}
		
		private function animation()
		{
			setupLoginScreen();
			TweenLite.to(this, 1.4, {alpha: 1, rotationX: 0});
		}
		
		private function setupLoginScreen()
		{
			input_password = new form_input(this, true, 0x000000, true, "Your Password");
			form_loader_mc.addChild(input_password);
			
			/* Random background image - not in use for FYP presentation as I do not own the images from Unsplash.com */
			/* However the code here will be uncommented when I release this as an open source project on Github. */
			/* *************************************************************************************************************************
			// Get a random background image from unsplash - to be replaced with my own unsplash account
			var randomImage:ImageLoader = new ImageLoader("https://source.unsplash.com/random/1280x600", {onComplete:onImageLoad});
			
			randomImage.load();
			************************************************************************************************************************* */
			
			var randomImage:ImageLoader = new ImageLoader("bernardos/data/images/loginpaper01.jpg", {onComplete:onImageLoad});
			
			randomImage.load();
			
			// Avatar
			var avatarLoader:ImageLoader = new ImageLoader("bernardos/data/images/avatar.png", {onComplete:avatarLoaded});
			
			avatarLoader.load();
			
			// Set-up enter handler
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
		}
		
		public function onImageLoad(event:LoaderEvent)
		{
			var bitmapData = event.target.rawContent;
			background_loader_mc.addChild(bitmapData);
		}
		
		private function avatarLoaded(event)
		{
			var bitmapData = event.target.rawContent;
			avatarLoader_mc.addChild(bitmapData);
		}
		
		private function keyboardHandler(evt:KeyboardEvent)
		{
			if (evt.charCode == 13)
			{
				validateLogin();
			}
		}
		
		private function validateLogin()
		{
			// For now, we do not want any login mechendise as it will prevent people from viewing my awesome operating system.
			if (input_password.getText() == "")
			{
				infoText_mc.infoText.text = "Bernard's password will never be empty. -.-''";
			}
			else
			{
				infoText_mc.infoText.text = "Successfully logged in! Opening Desktop ...";
				
				main.settingHandler.getSetting("bernardos/data/settings/desktop.ini", settingsLoaded);
			}
		}
		
		public function settingsLoaded(desktopSettings)
		{
			main.loadDesktop(desktopSettings);
			
			TweenLite.to(this, 1.4, {alpha: 0, rotationX: -100, onComplete: deleteSelf});
		}
		
		private function deleteSelf()
		{
			main.ScreenLoader_mc.removeChild(this);
		}
	}
}
