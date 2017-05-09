package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class MoveCommand extends Command
	{
		private var _direction:String;
		
		public function MoveCommand(directionType:String) 
		{
			_direction = directionType;
			
			super(CommandType.MOVE);
		}
		
		override public function execute(entity:Entity):void
		{
			//EntityManager.interruptMoveEntity(entity);
			
			if (entity.IS_PLAYER) 
			{
				PlayerManager.setPlayerCantMoveDirection("");
				PlayerManager.setPlayerMoveDirection("");
			}
			
			EntityManager.moveEntity(entity, _direction);
		}
		
	}

}