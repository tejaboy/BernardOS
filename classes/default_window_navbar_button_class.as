package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	
	public class default_window_navbar_button_class extends MovieClip
	{
		var colour:Color = new Color();
		
		public function default_window_navbar_button_class()
		{
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOverHandler(evt)
		{
			colour.setTint(0x2768D1, 0.8);
			this.transform.colorTransform = colour;
		}
		
		private function mouseOutHandler(evt)
		{
			colour.setTint(0xFFAAFF, 0);
			this.transform.colorTransform = colour;
		}
	}
}
