// Got from my FYP Group Project's Pet Companions game. In which, I read online tutorials regrading communicating with HTTPs via AS3.
// Most of the codes here is written by me for my project - other than AS3 core libs and functions.

package game_classes.HTTP
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;

	public class HTTPCallback
	{
		var main;

		public function HTTPCallback_POST(URLPage, URLParms, _main, onComplete:Function)
		{
			main = _main;
			
			var request:URLRequest = new URLRequest();
			request.url = URLPage;
			request.method = URLRequestMethod.POST;
			request.data = URLParms;

			var requestLoader:URLLoader = new URLLoader();
			requestLoader.addEventListener(Event.COMPLETE, completeLoading);
			var test = requestLoader.load(request);

			function completeLoading(evt:Event):void
			{
				// trace(requestLoader.data);
				onComplete(requestLoader.data);
			}
		}
	}
}