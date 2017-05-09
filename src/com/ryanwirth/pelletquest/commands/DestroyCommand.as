package com.ryanwirth.pelletquest.commands
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class DestroyCommand extends Command
	{
		private var _entityName:String;
		
		public function DestroyCommand(entityName:String)
		{
			_entityName = entityName;
			
			super(CommandType.DESTROY);
		}
		
		override public function execute(entity:Entity):void
		{
			EntityManager.destroyEntity(EntityManager.getEntityByName(_entityName), true);
			CommandManager.nextCommand(entity);
		}
	
	}

}