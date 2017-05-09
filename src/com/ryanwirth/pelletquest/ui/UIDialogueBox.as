package com.ryanwirth.pelletquest.ui 
{
	import starling.display.Sprite;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIDialogueBox extends Sprite implements UIElement
	{
		private var _dialogueName:String;
		private var _dialogueNameColor:uint;
		private var _messages:Vector.<String>;
		private var _finishCallback:Function;
		private var _afterFinishCallback:Function;
		private var _windowHeight:int;
		
		private var _window:UIScrollPopup;
		
		public function UIDialogueBox(dialogueName:String, dialogueNameColor:uint, messages:Vector.<String>, finishCallback:Function, afterFinishCallback:Function, windowHeight:int = 3) 
		{
			_dialogueName = dialogueName;
			_dialogueNameColor = dialogueNameColor;
			_messages = messages;
			_finishCallback = finishCallback;
			_afterFinishCallback = afterFinishCallback;
			_windowHeight = windowHeight;
			
			construct();
		}
		
		public function construct():void
		{
			nextMessage();
		}
		
		private var _currentMessage:String;
		private var _currentPointer:int = 0;
		private function nextMessage():void
		{
			if (_currentMessage && _currentPointer != _currentMessage.length)
			{
				_window.updateContent(_currentMessage);
				_currentPointer = _currentMessage.length;
				TweenLite.killDelayedCallsTo(nextCharacter);
				return;
			}
			
			if (_messages.length == 0)
			{
				destroy();
				return;
			}
			
			_currentMessage = LocalizationManager.parseLabel(_messages[0]);
			_currentPointer = 0;
			
			if (!_window)
			{
				_window = new UIScrollPopup(4, _windowHeight, _dialogueName + ":", _messages.length == 1 ? Language.MENU_TAP_TO_CLOSE : Language.MENU_TAP_TO_CONTINUE, "", nextMessage, _dialogueNameColor);
				this.addChild(_window);
			} else
			{
				if (_messages.length == 1) _window.updateBottomTitle(Language.MENU_TAP_TO_CLOSE);
				_window.updateContent("");
			}
			
			TweenLite.delayedCall(0.025, nextCharacter);
			
			_messages.shift();
		}
		
		private function nextCharacter():void
		{
			if (_currentPointer == _currentMessage.length)
			{
				return;
			}
			
			_currentPointer++;
			_window.updateContent(_currentMessage.substr(0, _currentPointer));
			
			TweenLite.delayedCall(0.025, nextCharacter);
		}
		
		public function destroy():void
		{
			this.removeChild(_window);
			_window.destroy();
			_window = null;
			
			_messages = null;
			
			if (_finishCallback != null) _finishCallback(_afterFinishCallback);
			_finishCallback = null;
			_afterFinishCallback = null;
			
			this.removeFromParent(true);
		}
		
	}

}