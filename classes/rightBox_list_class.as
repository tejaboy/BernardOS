package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class rightBox_list_class extends MovieClip
	{
		var desktop_screen_rightBox;
		var info;
		
		public function rightBox_list_class(_desktop_screen_rightBox, _info, _pos_y)
		{
			desktop_screen_rightBox = _desktop_screen_rightBox;
			info = _info;
			
			this.y = _pos_y;
			this.buttonMode = true;
			
			this.text_txt.text = info["title"];
			this.text_txt.selectable = false;
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(evt)
		{
			// I feel that there is a need to do this for security purpose.
			info["handler"]();
		}
	}
}
