package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class QuestionCommand extends Command
	{
		private var _dialogueName:String;
		private var _dialogueNameColor:uint;
		private var _question:String;
		private var _answers:Array;
		
		public function QuestionCommand(dialogueName:String, dialogueNameColor:uint, question:String, answers:Array) 
		{
			_dialogueName = dialogueName;
			_dialogueNameColor = dialogueNameColor;
			_question = question;
			_answers = answers;
			
			super(CommandType.QUESTION);
		}
		
		private var _entity:Entity;
		override public function execute(entity:Entity):void
		{
			_entity = entity;
			
			var answers:Array = [];
			for (var i:int = 0; i < _answers.length; i++)
			{
				var answerData:Array = String(_answers[i]).split("-");
				answers.push(answerData[0]);
			}
			
			UIManager.createQuestionBox(_dialogueName, _dialogueNameColor, _question, answers, answerQuestion);
		}
		
		private function answerQuestion(answer:String):void
		{
			for (var i:int = 0; i < _answers.length; i++)
			{
				var answerData:Array = String(_answers[i]).split("-");
				if (answer == answerData[0])
				{
					// This is the answer we got!
					CommandManager.decodeCommandString(_entity, MapManager.getObjectProperty(answerData[1], answerData[2]));
					CommandManager.nextCommand(_entity);
				}
			}
			
			_entity = null;
			_answers = null;
		}
		
	}

}