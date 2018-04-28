package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class nativeTop_class extends MovieClip
	{
		var nativeTime;
		var nativeTimeCreation;
		
		public function nativeTop_class()
		{
			// Time reference: https://stackoverflow.com/questions/18927696/as3-get-current-time-without-creating-new-object
			nativeTime = new Date();
			nativeTimeCreation = getTimer();
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this.buttonMode = true;
		}
		
		private function update(evt)
		{
			var readable = new Object();
			
			readable["endText"] = "AM";
			readable["hours"] = nativeTime.hours;
			readable["minutes"] = nativeTime.minutes;
			
			nativeTime.time += (getTimer() - nativeTimeCreation);
			nativeTimeCreation = getTimer();
			
			if (nativeTime.hours > 12)
			{
				readable.endText = "PM";
			}
			
			if (nativeTime.hours < 10)
			{
				readable.hours = "0" + String(nativeTime.hours);
			}
			
			if (nativeTime.minutes < 10)
			{
				readable.minutes = "0" + String(nativeTime.minutes);
			}
			
			nativeTime_text.text = readable.hours + ":" + readable.minutes + " " + readable.endText;
		}
	}
}
