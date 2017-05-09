package com.ryanwirth.pelletquest.ui
{
	import com.greensock.TweenNano;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.ui.ButtonType;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIButton extends UISprite
	{
		private var _atlas:TextureAtlas;
		private var _button:Image;
		private var _callback:Function;
		private var _callbackParams:Array;
		private var _flattenCallback:Function;
		private var _label:TextField;
		private var _labelText:String = "";
		
		public function UIButton(atlas:TextureAtlas, callback:Function = null, callbackParams:Array = null, flattenCallback:Function = null, labelText:String = "")
		{
			_callback = callback;
			_atlas = atlas;
			_callbackParams = callbackParams;
			_flattenCallback = flattenCallback;
			_labelText = labelText;
			
			construct();
		}
		
		private function drawText(makeSmaller:Boolean):void
		{
			if (_labelText != "")
			{
				if (_label) _label.text = LocalizationManager.parseLabel(_labelText);
				else
				{
					_label = new TextField(this.width, 16, LocalizationManager.parseLabel(_labelText), LocalizationManager.getFontName(), 16 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
					_label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					_label.hAlign = HAlign.CENTER;
					this.addChild(_label);
				}
				
				this.setChildIndex(_label, this.numChildren - 1);
				
				_label.fontSize = 16;
				do
				{
					decreaseTextSize();
				} while (_label.width > (_button.width - 8));
				
				if (makeSmaller) decreaseTextSize();
			}
			else
			{
				destroyText();
			}
		}
		
		public function updateLabel(labelText:String):void
		{
			_labelText = labelText;
			drawText(false);
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
				
				if (_flattenCallback != null) _flattenCallback();
			}
			
			if (endedTouch)
			{
				drawButton(ButtonType.UP);
				
				if (_flattenCallback != null) _flattenCallback();
				
				if (_callback != null)
				{
					if (_callbackParams != null) TweenNano.delayedCall(0, _callback, _callbackParams, true);
					else _callback();
				}
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
		
		private function decreaseTextSize():void 
		{
			_label.fontSize -= 1;
			_label.y = _button.height / 2 - _label.fontSize / 2 - 3;
			_label.x = _button.width / 2 - _label.width / 2;
		}
		
		public function drawButton(buttonType:String):void
		{
			destroyButton();
			
			_button = new Image(_atlas.getTexture(buttonType));
			_button.smoothing = TextureSmoothing.NONE;
			this.addChild(_button);
			
			drawText(buttonType == ButtonType.DOWN ? true : false);
		}
		
		override public function destroy():void
		{
			destroyButton();
			destroyText();
			
			this.removeEventListener(TouchEvent.TOUCH, hitButton);
			
			_atlas = null;
			_callback = null;
			_flattenCallback = null;
			_callbackParams = null;
			
			this.removeFromParent(true);
		}
	}

}