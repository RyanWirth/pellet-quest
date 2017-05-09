package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;

	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class CreateCommand extends Command
	{
		private var _entityName:String;
		
		public function CreateCommand(entityName:String) 
		{
			_entityName = entityName;
			
			super(CommandType.CREATE);
		}
		
		override public function execute(entity:Entity):void
		{
			MapManager.createEntity(_entityName);
			CommandManager.nextCommand(entity);
		}
		
	}

}