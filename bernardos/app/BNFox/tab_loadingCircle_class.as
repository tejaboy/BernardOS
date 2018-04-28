package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class tab_loadingCircle_class extends MovieClip
	{
		public function tab_loadingCircle_class()
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(evt)
		{
			this.rotation += 2.2;
		}
	}
}
