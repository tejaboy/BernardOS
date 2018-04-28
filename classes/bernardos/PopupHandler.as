package bernardos
{
	import flash.events.MouseEvent;
	import fl.motion.Color;
	
	// Greensock
	import com.greensock.*;
	
	public class PopupHandler
	{
		var main;
		var box;
		
		var colour:Color = new Color();
		
		public function PopupHandler(_main)
		{
			main = _main;
			main.PopupLoader_mc.visible = true;
		}
		
		public function popup(type, msg)
		{
			closePopupLoader();
			
			popupType(type, msg);
		}
		
		private function popupType(type, msg)
		{
			if (type == "ok")
			{
				box = new POP_OK_class();
			}
			
			setupPopup(type, msg);
		}
		
		private function setupPopup(type, msg)
		{
			box.POP_msg.text = msg;
			box.POP_default_button_mc.buttonMode = true;
			
			box.x = -100;
			box.y = (main.stage.stageHeight / 2) - (box.height / 1.3);
			box.alpha = 0;
			box.rotationY = -60;
			
			main.PopupLoader_mc.addChild(new POP_PopupBackground());
			main.PopupLoader_mc.addChild(box);
			
			TweenLite.to(box, 0.33, {x: (main.stage.stageWidth / 2) - (box.width / 2), alpha: 1, rotationY: 0});
			
			box.POP_default_button_mc.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			box.POP_default_button_mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			box.POP_default_button_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseClickHandler(evt)
		{
			// Remove the background only
			if (main.PopupLoader_mc.numChildren > 0)
				main.PopupLoader_mc.removeChildAt(0);
				
			TweenLite.to(box, 0.33, {x: main.stage.stageWidth, alpha: 0, onComplete: closePopupLoader});
		}
		
		private function mouseOverHandler(evt)
		{
			colour.setTint(0x3BF73E, 0.8);
			
			box.POP_default_button_mc.background_mc.transform.colorTransform = colour;
		}
		
		private function mouseOutHandler(evt)
		{
			colour.setTint(0x3BF73E, 0);
			
			box.POP_default_button_mc.background_mc.transform.colorTransform = colour;
		}
		
		private function closePopupLoader()
		{
			while (main.PopupLoader_mc.numChildren > 0)
				main.PopupLoader_mc.removeChildAt(0);
		}
	}
}