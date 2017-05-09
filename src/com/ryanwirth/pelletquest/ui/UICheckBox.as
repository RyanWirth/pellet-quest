package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.ui.ButtonType;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UICheckBox extends UISprite
	{
		private var _atlas:TextureAtlas;
		private var _button:Image;
		private var _callback:Function;
		private var _label:TextField;
		private var _state:Boolean;
		private var _labelText:String = "";
		
		public function UICheckBox(atlas:TextureAtlas, callback:Function = null, labelText:String = "Check Box", initialState:Boolean = true)
		{
			_callback = callback;
			_atlas = atlas;
			_labelText = labelText;
			_state = initialState;
			
			construct();
		}
		
		private function drawText():void
		{
			if (_labelText != "")
			{
				if (_label) _label.text = LocalizationManager.parseLabel(_labelText);
				else
				{
					_label = new TextField(400, _button.height, LocalizationManager.parseLabel(_labelText), LocalizationManager.getFontName(), 16 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
					_label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					_label.y = _button.height / 2 - _label.height / 2;
					_label.x = _button.width + 2;
					this.addChild(_label);
				}
				
				_label.fontSize = 18;
				
				do
				{
					_label.fontSize -= 1;
					_label.y = _button.height / 2 - _label.height / 2;
				} while (_label.width + _button.width > 3 * MapManager.TILE_SIZE);
				
				this.setChildIndex(_label, this.numChildren - 1);
			}
			else
			{
				destroyText();
			}
		}
		
		override public function construct():void
		{
			drawButton(ButtonType.UP);
			
			this.addEventListener(TouchEvent.TOUCH, hitButton);
		}
		
		private function hitButton(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			
			var beganTouch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var endedTouch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if (beganTouch)
			{
				drawButton(ButtonType.DOWN);
			}
			
			if (endedTouch)
			{
				_state = !_state;
				drawButton(ButtonType.UP);
				
				if (_callback != null) _callback(_state);
			}
		}
		
		private function destroyButton():void
		{
			if (_button)
			{
				this.removeChild(_button, true);
				_button = null;
			}
		}
		
		private function destroyText():void
		{
			if (_label)
			{
				this.removeChild(_label, true);
				_label = null;
			}
		}
		
		public function drawButton(buttonType:String):void
		{
			destroyButton();
			
			_button = new Image(_atlas.getTexture((_state ? "on" : "off") + "_" + buttonType));
			_button.smoothing = TextureSmoothing.NONE;
			this.addChild(_button);
			
			drawText();
		}
		
		override public function destroy():void
		{
			destroyButton();
			destroyText();
			
			this.removeEventListener(TouchEvent.TOUCH, hitButton);
			
			_atlas = null;
			_callback = null;
			
			this.removeFromParent(true);
		}
	}

}