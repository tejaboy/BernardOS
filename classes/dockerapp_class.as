package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.*;
	
	// Third Party Classes
	// Greensock
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	import flash.media.SoundChannel;
	
	public class dockerapp_class extends MovieClip
	{
		var main;
		var app;
		var pos_x;
		var pos_y;
		var glowFilter = new GlowFilter();
		var hoverAnimation = false;
		var clicked = false;
		
		public function dockerapp_class(_main, _app, _pos_x, _pos_y)
		{
			main = _main;
			app = _app;
			pos_x = _pos_x;
			pos_y = _pos_y;
			
			icon_loader_mc.buttonMode = true;
			this.x = pos_x;
			this.y = pos_y;
			
			var iconLoader:ImageLoader = new ImageLoader(main.bernardosPath + "app/" + app + "/icon-64.png", {onComplete:onIconLoaded});
			iconLoader.load();
			
			setupFilters();
		}
		
		private function onIconLoaded(event:LoaderEvent)
		{
			icon_loader_mc.addChild(event.target.rawContent);
		}
		
		private function setupFilters()
		{
			glowFilter.blurX = 16;
			glowFilter.blurY = 16;
			glowFilter.strength = 2;
			glowFilter.color = 0xFFFFFF;
			
			icon_loader_mc.filters = [glowFilter];
			
			icon_loader_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverIcon);
			icon_loader_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutIcon);
			icon_loader_mc.addEventListener(MouseEvent.CLICK, mouseClickIcon);
		}
		
		private function mouseOverIcon(evt)
		{
			if (clicked)
			{
				clicked = false;
				return;
			}
			
			hoverAnimation = true;
			
			glowFilter.color = 0xFFFF14;
			
			icon_loader_mc.filters = [glowFilter];
			
			forwardAnimation();
			
			function forwardAnimation()
			{
				if (hoverAnimation)
					TweenLite.to(icon_loader_mc, 0.42, {x:"-12", onComplete: reverseAnimation});
			}
			
			function reverseAnimation()
			{
				if (hoverAnimation)
					TweenLite.to(icon_loader_mc, 0.42, {x:"+12", onComplete: forwardAnimation});
			}
		}
		
		private function mouseOutIcon(evt = null, setClick = false)
		{
			hoverAnimation = false;
			
			glowFilter.color = 0xFFFFFF;
			
			icon_loader_mc.filters = [glowFilter];
			
			if (!setClick)
			{
				TweenLite.to(icon_loader_mc, 0.4, {x:0});
			}
			else
			{
				TweenLite.to(icon_loader_mc, 0.3, {x:0, onComplete: function() { clicked = true; } });
			}
		}
		
		private function mouseClickIcon(evt)
		{
			mouseOutIcon(null, true); // Make use of this to animate the icon back once only.
			
			glowFilter.color = 0x001414;
			
			icon_loader_mc.filters = [glowFilter];
			
			main.loadApp(app);
			
			var tempSound = new mouseClick_snd();
			var tempChannel = new SoundChannel();
			tempChannel = tempSound.play();
			tempChannel.soundTransform = main.mainTransform;
		}
	}
}
