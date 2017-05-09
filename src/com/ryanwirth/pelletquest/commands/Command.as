package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Command 
	{
		private var _commandType:String;
		
		public function Command(commandType:String) 
		{
			_commandType = commandType;
		}
		
		public function execute(entity:Entity):void
		{
			CommandManager.nextCommand(entity);
		}
		
		public function get TYPE():String
		{
			return _commandType;
		}
		
	}

}