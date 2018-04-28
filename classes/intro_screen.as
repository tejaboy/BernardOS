package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	public class intro_screen extends MovieClip
	{
		var main;
		var mainSound = new Sound();
		var mainChannel = new SoundChannel();
		
		public function intro_screen(_main)
		{
			main = _main;
			
			BernardOSLogo_mc.alpha = 0;
			BernardOSLogo_mc.scaleX = 0;
			
			randomText_mc.alpha = 0;
			randomText_mc.scaleX = 0;
			
			introStart_mc.alpha = 0;
			introAbout_mc.alpha = 0;
			
			TweenLite.to(introMask_mc, 0.8, {x: 0, y: 0, onComplete: showLogo});
			
			awesomeMusic();
		}
		
		private function awesomeMusic()
		{
			mainSound.load(new URLRequest("bernardos/data/sounds/Automation.mp3"));
			mainChannel = mainSound.play();
			
			mainChannel.soundTransform = main.mainTransform;
		}
		
		private function showLogo()
		{
			TweenLite.to(BernardOSLogo_mc, 0.8, {alpha: 1, scaleX: 1, onComplete: animateRandomTxt});
		}
		
		private function animateRandomTxt()
		{
			startRandomDrawing();
			showMenu();
			
			randomText_mc.randomText_txt.text = generateRandomString();
			
			TweenLite.to(randomText_mc, 0.8, {alpha: 1, scaleX: 1, onComplete: animateRandomTxt02});
		}
		
		private function animateRandomTxt02()
		{
			randomText_mc.randomText_txt.text = generateRandomString();
			
			TweenLite.to(randomText_mc, 0.6, {alpha: 0.2, scaleX: 0.6, onComplete: animateRandomTxt});
		}
		
		private function startRandomDrawing()
		{
			
		}
		
		private function showMenu()
		{
			enableMenu();
			
			TweenLite.to(introStart_mc, 0.8, {alpha: 1, y: 400});
			TweenLite.to(introAbout_mc, 0.8, {alpha: 1, y: 450});
		}
		
		private function enableMenu()
		{
			introStart_mc.buttonMode = true;
			introAbout_mc.buttonMode = true;
			
			introStart_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverMenuHandler);
			introAbout_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverMenuHandler);
			
			introStart_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutMenuHandler);
			introAbout_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutMenuHandler);
			
			introStart_mc.addEventListener(MouseEvent.CLICK, startButtonHandler);
		}
		
		private function mouseOverMenuHandler(evt)
		{
			var mc = evt.target.parent;
			
			var glowFilter = new GlowFilter();
			glowFilter.blurX = 13;
			glowFilter.blurY = 13;
			glowFilter.quality = 3;
			glowFilter.strength = 2;
			glowFilter.color = 0x0099FF;
			
			mc.filters = [glowFilter];
			
			var tempSound:Sound = new mouseHover_snd();
			tempSound.play();
		}
		
		private function mouseOutMenuHandler(evt)
		{
			var mc = evt.target.parent;
			
			mc.filters = [];
		}
		
		private function startButtonHandler(evt)
		{
			main.showLogin();
			
			TweenLite.to(this, 1.4, {alpha: 0, rotationX: 100, onComplete: deleteSelf});
			
			mainChannel.stop();
			
			var tempSound:Sound = new mouseClick_snd();
			tempSound.play();
		}
		
		private function deleteSelf()
		{
			main.ScreenLoader_mc.removeChild(this);
		}
		
		// Misc
		function generateRandomString():String
		{
			var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+1234567890";
			var num_chars = chars.length - 1;
			var strlen = 16 + Math.floor(Math.random() * 11);
			var randomChar = "";
			
			for (var i:Number = 0; i < strlen; i++)
				randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
				
			return randomChar;
		}
	}
}
