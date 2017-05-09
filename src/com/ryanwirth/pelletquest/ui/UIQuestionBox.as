package com.ryanwirth.pelletquest.ui 
{
	import com.greensock.TweenLite;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import starling.display.Sprite;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIQuestionBox extends Sprite implements UIElement
	{
		private var _dialogueName:String;
		private var _dialogueNameColor:uint;
		private var _question:String;
		private var _callback:Function;
		private var _callingFunction:Function;
		private var _answers:Array;
		private var _windowHeight:int;
		private var _currentMessage:String;
		private var _currentPointer:int = 0;
		
		private var _window:UIScrollPopup;
		private var _buttons:Vector.<UIButton>;
		
		public function UIQuestionBox(dialogueName:String, dialogueNameColor:uint, question:String, answers:Array, callback:Function, callingFunction:Function, windowHeight:int) 
		{
			_dialogueName = dialogueName;
			_dialogueNameColor = dialogueNameColor;
			_question = question;
			_answers = answers;
			_windowHeight = windowHeight;
			_callback = callback;
			_callingFunction = callingFunction;
			
			construct();
		}
		
		public function construct():void
		{
			nextMessage();
		}
		
		private function nextMessage():void
		{
			if (_currentMessage && _currentPointer != _currentMessage.length)
			{
				_window.updateContent(_currentMessage);
				_currentPointer = _currentMessage.length;
				TweenLite.killDelayedCallsTo(nextCharacter);
				drawButtons();
				return;
			} else
			if (_currentMessage && _currentPointer == _currentMessage.length) return;
			
			_currentMessage = LocalizationManager.parseLabel(_question);
			_currentPointer = 0;
			
			if (!_window)
			{
				_window = new UIScrollPopup(4, _windowHeight, _dialogueName + ":", "", "", nextMessage, _dialogueNameColor);
				this.addChild(_window);
			} else
			{
				_window.updateContent("");
			}
			
			TweenLite.delayedCall(0.025, nextCharacter);
		}
		
		private function drawButtons():void
		{
			_buttons = new Vector.<UIButton>();
			
			for (var i:int = 0; i < _answers.length; i++)
			{
				var button:UIButtonSmall = new UIButtonSmall(i == 0 ? button1 : button2, _answers[i]);
				button.x = ((_window.TILE_WIDTH * MapManager.TILE_SIZE - 16) / _answers.length) * i + 4 + button.width / 2;
				button.y = _window.TILE_HEIGHT * MapManager.TILE_SIZE - button.height - 8;
				this.addChild(button);
				_buttons.push(button);
			}
		}
		
		private function button1():void
		{
			_callback(_callingFunction, _answers[0]);
			destroy();
		}
		
		private function button2():void
		{
			_callback(_callingFunction, _answers[1]);
			destroy();
		}
		
		private function nextCharacter():void
		{
			if (_currentPointer == _currentMessage.length)
			{
				drawButtons();
				return;
			}
			
			_currentPointer++;
			_window.updateContent(_currentMessage.substr(0, _currentPointer));
			
			TweenLite.delayedCall(0.025, nextCharacter);
		}
		
		public function destroy():void
		{
			_callingFunction = _callback = null;
			
			for (var i:int = 0; i < _buttons.length; i++)
			{
				this.removeChild(_buttons[i]);
				_buttons[i].destroy();
				_buttons[i].dispose();
				_buttons[i] = null;
			}
			_buttons = null;
			
			_answers = null;
			
			this.removeChild(_window);
			_window.destroy();
			_window.dispose();
			_window = null;
			
			this.removeFromParent(true);
		}
		
	}

}