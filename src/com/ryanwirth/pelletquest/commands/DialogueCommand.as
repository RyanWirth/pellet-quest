package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.AnimationType;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class DialogueCommand extends Command
	{
		private var _dialogueName:String;
		private var _dialogueNameColor:uint;
		private var _messages:Array;
		
		public function DialogueCommand(dialogueName:String, dialogueNameColor:uint, messages:Array) 
		{
			_dialogueName = dialogueName;
			_messages = messages;
			_dialogueNameColor = dialogueNameColor;
			
			super(CommandType.DIALOGUE);
		}
		
		override public function execute(entity:Entity):void
		{
			_entity = entity;
			_entity.animate(AnimationType.STAND, _entity.DIRECTION);
			UIManager.createDialogueBox(_dialogueName, _dialogueNameColor, nextCommand, _messages);
		}
		
		private var _entity:Entity;
		private function nextCommand():void
		{
			CommandManager.nextCommand(_entity);
			_entity = null;
		}
		
	}

}