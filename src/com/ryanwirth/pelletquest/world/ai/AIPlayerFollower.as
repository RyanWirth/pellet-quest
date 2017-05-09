package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIPlayerFollower extends AI
	{
		public function AIPlayerFollower(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * In the PLAYER_FOLLOWER AI type, the entity will always attempt to move in the direction of the player
		 * @param	entity
		 */
		override public function findPath():String
		{
			// Positive dX = player is to the right, negative dX = player is to the left
			// Positive dY = player downwards, negative dY = player upwards
			var dX:int = PlayerManager.PLAYER.X_TILE - X_TILE;
			var dY:int = PlayerManager.PLAYER.Y_TILE - Y_TILE;
			
			if (dX > 0 && CAN_MOVE(Direction.RIGHT)) return Direction.RIGHT;
			else if (dX < 0 && CAN_MOVE(Direction.LEFT)) return Direction.LEFT;
			else if (dY > 0 && CAN_MOVE(Direction.DOWN)) return Direction.DOWN;
			else if (dY < 0 && CAN_MOVE(Direction.UP)) return Direction.UP;
			else
			{
				// There is no direction we can go that will be closer to the player - pick a random direction
				if (POSSIBLE_PATHS.length == 1) return POSSIBLE_PATHS[0];
				else return RANDOM_PATH_EXCEPT(Direction.reverse(CURRENT_DIRECTION));
			}
		
		}
	
	}

}