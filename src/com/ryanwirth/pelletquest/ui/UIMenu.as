package com.ryanwirth.pelletquest.ui 
{
	import com.greensock.TweenNano;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIMenu extends Sprite implements UIElement
	{
		public static const PADDING:int = 1;
		
		private var _destroyCallback:Function;
		private var _destroyCallbackParams:Array;
		protected var _window:UIScrollSmall;
		protected var _elements:Vector.<UISprite> = new Vector.<UISprite>();
		protected var _windowCenterXAxis:int;
		
		public function UIMenu(destroyCallback:Function, destroyCallbackParams:Array) 
		{
			_destroyCallback = destroyCallback;
			_destroyCallbackParams = destroyCallbackParams;
		}
		
		public function construct():void { }
	
		protected function callCallback():void
		{
			if (_destroyCallback != null)
			{
				if (_destroyCallbackParams) TweenNano.delayedCall(0, _destroyCallback, _destroyCallbackParams, true);
				else _destroyCallback();
				
				_destroyCallback = null;
			}
			
			_destroyCallbackParams = null;
		}
		
		protected function get DESTROY_CALLBACK():Function
		{
			return _destroyCallback;
		}
		
		protected function get DESTROY_CALLBACK_PARAMS():Array
		{
			return _destroyCallbackParams;
		}
		
		protected function NULL_CALLBACK():void
		{
			_destroyCallback = null;
			_destroyCallbackParams = null;
		}
		
		protected function createButton(callback:Function, buttonLabel:String):void
		{
			var _button:UIButtonLarge = new UIButtonLarge(callback, buttonLabel);
			_button.x = _windowCenterXAxis - _button.width / 2;
			this.addChild(_button);
			_elements.push(_button);
		}
		
		protected function createCheckBox(callback:Function, checkBoxLabel:String, initialState:Boolean = true):void
		{
			var _checkBox:UICheckBoxSmall = new UICheckBoxSmall(callback, checkBoxLabel, initialState);
			_checkBox.x = _windowCenterXAxis - _checkBox.width / 2;
			this.addChild(_checkBox);
			_elements.push(_checkBox);
		}
		
		protected function alignElements():void
		{
			var availableHeight:int = _window.TILE_HEIGHT * MapManager.TILE_SIZE - 54;
			var totalHeight:int = _elements.length * (MapManager.TILE_SIZE + PADDING) - PADDING;
			var startingY:int;
			var startingX:int = _windowCenterXAxis;
			var i:int;
			
			if (totalHeight <= availableHeight)
			{
				// Create a single stack
				startingY = GameManager.stageHeight / 2 - totalHeight / 2;
				for (i = 0; i < _elements.length; i++)
				{
					_elements[i].y = startingY + i * (MapManager.TILE_SIZE + PADDING);
					_elements[i].x = startingX - (_elements[i].width > 3 * MapManager.TILE_SIZE + PADDING ? _elements[i].width : 3 * MapManager.TILE_SIZE + PADDING ) / 2;
				}
			}
			else
			{
				// Split the stack into two columns
				totalHeight /= 2;
				startingX -= _elements[i].width / 2 - PADDING;
				startingY = GameManager.stageHeight / 2 - totalHeight / 2;
				
				for (i = 0; i < _elements.length; i++)
				{
					_elements[i].y = startingY + (Math.floor(i / 2) * (_elements[i].height + PADDING));
					_elements[i].x = startingX - _elements[i].width / 2;
					if ((i + 1) % 2 == 0) _elements[i].x += _elements[i].width + PADDING;
				}
			}
		}
		
		protected function closeMenu():void
		{
			if (UIManager.HUD) UIManager.HUD.visible = true;
			if (UIManager.DIALOGUE_BOXES_OPEN == 0) GameManager.resumeGame();
			
			destroy();
		}
		
		public function destroy():void
		{
			destroyElements();
			_elements = null;
			
			this.removeChild(_window);
			_window.destroy();
			_window = null;
			
			this.removeFromParent(true);
			
			callCallback();
		}
		
		protected function destroyElements():void 
		{
			if (!_elements) return;
			
			for (var i:int = 0; i < _elements.length; i++)
			{
				_elements[i].destroy();
				_elements[i] = null;
				_elements.splice(i, 1);
				i--;
			}
		}
		
	}

}