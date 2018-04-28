package bernardos
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class SettingHandler
	{
		public function SettingHandler()
		{
		}
		
		public function getSetting(path, returnFunction)
		{
			var returnObject:Object = new Object();
			var settingLoader = new URLLoader();
			
			settingLoader.addEventListener(Event.COMPLETE, settingHandler);
			settingLoader.load(new URLRequest(path));
			
			function settingHandler(evt:Event)
			{
				var tempArray = evt.target.data.split(/\n/);
				
				for (var i = 0; i < tempArray.length; i++)
				{
					tempArray[i] = tempArray[i].replace(/\R$/, ""); // Remove \n - actually replace it
					
					var tempObject = tempArray[i].split("=");
					returnObject[tempObject[0]] = tempObject[1];
				}
				
				returnFunction(returnObject);
			}
		}
	}
}
