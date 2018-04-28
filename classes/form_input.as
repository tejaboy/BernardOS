package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;

	public class form_input extends MovieClip 
	{
		var main;
		var onEnter;
		var placeholder:String;
		
		public function form_input(_main, hasOpacity = false, colour = 0x0000FF, isPassword = false, _placeholder = null)
		{
			main = _main;
			placeholder = _placeholder;
			
			textbox.textColor = colour;
			
			if (hasOpacity)
			{
				this.alpha = 0.6;
				
				this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			}
			
			if (isPassword)
			{
				textbox.displayAsPassword = true;
			}
			
			if (placeholder != null)
			{
				if (textbox.text == "")
				{
					textbox.displayAsPassword = false;
					textbox.text = placeholder;
				}
			}
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
			this.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		private function overHandler(evt:MouseEvent)
		{
			this.alpha = 1;
		}
		
		private function outHandler(evt:MouseEvent)
		{
			this.alpha = 0.8;
		}
		
		private function keyboardHandler(evt)
		{
			updatePlaceholder();
		}
		
		private function mouseHandler(evt)
		{
			updatePlaceholder();
		}
		
		private function updatePlaceholder()
		{
			if (placeholder != null)
			{
				if (textbox.text == placeholder)
				{
					textbox.displayAsPassword = true;
					textbox.text = "";
				}
			}
		}
		
		public function getText()
		{
			return textbox.text;
		}
	}
}
