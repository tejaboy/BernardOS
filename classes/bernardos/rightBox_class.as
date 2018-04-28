package bernardos
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class rightBox_class extends MovieClip
	{
		var main;
		var desktop_screen;
		var rightBox = new Sprite();
		var list = new Object();
		
		public function rightBox_class(_main)
		{
			main = _main;
			
			main.addEventListener(MouseEvent.CLICK, leftClickHandler);
			main.addChild(rightBox);
		}
		
		private function leftClickHandler(evt)
		{
			clearMenu();
		}
		
		public function addList(_title, handler)
		{
			var listCount = String(main.getObjectLength(list) + 1);
			list[listCount] = new Object();
			list[listCount]["title"] = _title;
			list[listCount]["handler"] = handler;
		}
		
		public function drawMenu()
		{
			rightBox.visible = true;
			
			// Draw the list
			var currentY = 0;
			var increaseY = 30;
			
			for (var i = 1; i <= main.getObjectLength(list); i++)
			{
				var rightBox_list = new rightBox_list_class(this, list[String(i)], currentY);
				rightBox.addChild(rightBox_list);
				
				currentY += increaseY;
			}
			
			// Draw the box
			rightBox.x = main.stage.mouseX;
			rightBox.y = main.stage.mouseY;
			rightBox.graphics.clear();
			rightBox.graphics.beginFill(0xBBFF99, 0.8);
			rightBox.graphics.lineStyle(2, 0xC0C0C0, 1);
			rightBox.graphics.drawRect(0, 0, 200, currentY);
		}
		
		public function clearMenu()
		{
			list = new Object();
			rightBox.visible = false;
			rightBox.graphics.clear();
			
			while (rightBox.numChildren > 0)
			{
				rightBox.removeChildAt(0);
			}
		}
	}
}
