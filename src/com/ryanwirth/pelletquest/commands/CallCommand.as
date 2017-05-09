package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;

	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class CallCommand extends Command
	{
		private var _commandName:String;
		private var _entityName:String;
		
		public function CallCommand(commandName:String, entityName:String) 
		{
			_commandName = commandName;
			_entityName = entityName;
			
			super(CommandType.CALL);
		}
		
		override public function execute(entity:Entity):void
		{
			CommandManager.decodeCommandString(EntityManager.getEntityByName(_entityName), MapManager.getObjectProperty(_commandName, _entityName));
			CommandManager.nextCommand(entity);
		}
		
	}

}