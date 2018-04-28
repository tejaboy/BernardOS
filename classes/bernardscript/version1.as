/* The best of BernardOS? Its own programming language! */
/* Finally I am able to make use of my experience making TrueHackie Premium (hacking simulator game) into this project! */

package
{
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class version1 extends MovieClip
	{
		var appName;
		var scripts = new Object();
		
		public function version1()
		{
			trace("BernardScript Loaded");
			
			appName = loaderInfo.parameters.appName;
			
			loadMainScript();
		}
		
		private function loadMainScript()
		{
			var loader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, mainScriptLoaded)
			
			loader.load(new URLRequest("../" + "bernardos/app/" + appName + "/main.bs"));
		}
		
		private function mainScriptLoaded(evt)
		{
			scripts["main"] = evt.target.data;
			
			processScript(scripts["main"]);
		}
		
		private function processScript(script)
		{
			var lines = script.split(/\n/);
			var line;
			var tempLine;
			var processVars = new Object();
			
			// Language required variables
			var BernardGiga = new Object();
			var Rex = new Object();
			Rex["whitespace"] = /[\s\r\n]+/gim;
			
			// Processing script line by line
			for (var i = 0; i < lines.length; i++)
			{
				line = lines[i];
				tempLine = "";
				
				// Single-line comment
				if (line.substr(0, 2) == "//")
				{
					continue;
				}
				
				// Variable
				if (line.substr(0, 3) == "var")
				{
					tempLine = line.substr(4); // Remove "var "
					tempLine = tempLine.split("=");
					tempLine[0] = tempLine[0].replace(Rex["whitespace"], ''); // Fix user declared variables name if got whitespace
					tempLine[1] = removeFrontWhitespace(tempLine[1]);
					
					processVars["varName"] = tempLine[0];
					processVars["varValue"] = tempLine[1];
					processVars["startQuote"] = tempLine[1].charAt(0);
					
					if (processVars["startQuote"] == "\"" || processVars["startQuote"] == "'")
					{
						// Allow. String.
					}
					else if (!isNaN(Number(tempLine[1])))
					{
						// Allow. Number.
					}
					else
					{
						trace("Script Error: Invalid values for variable " + processVars["varName"] + " at line " + i + ".");
						break;
					}
					
					BernardGiga[processVars["varName"]] = processVars["varValue"];
					
					trace(tempLine);
				}
			}
		}
		
		private function removeFrontWhitespace(string)
		{
			var charBefore = 0;
			var char;
			
			for (var i = 0; i < string.length; i++)
			{
				char = string.charAt(i);
				
				if (char == " ")
				{
					charBefore++;
				}
				else
				{
					break;
				}
			}
			
			return string.substr(charBefore);
		}
	}
}
