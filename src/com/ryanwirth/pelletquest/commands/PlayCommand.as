package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;

	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class PlayCommand extends Command
	{
		private var _entityName:String;
		
		public function PlayCommand(entityName:String) 
		{
			_entityName = entityName;
			
			super(CommandType.PLAY);
		}
		
		override public function execute(entity:Entity):void
		{
			var _entity:Entity = EntityManager.getEntityByName(_entityName);
			if (_entity) _entity.play();
			CommandManager.nextCommand(entity);
		}
		
	}

}