package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AISimple extends AI
	{
		public function AISimple(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * In the SIMPLE AIType, the entity will only move forwards (that is, its current direction) unless there are multiple, non-backwards paths.
		 * If this occurs, a choice is randomly selected. Of course, if only one path is available, the entity will move in that direction (dead ends).
		 */
		override public function findPath():String
		{
			// If there is only one choice, return that direction.
			if (POSSIBLE_PATHS.length == 1) return POSSIBLE_PATHS[0];
			else if (POSSIBLE_PATHS.length == 2)
			{
				// either in a corridor or a corner
				if (CAN_MOVE_CURRENT_DIRECTION) return CURRENT_DIRECTION; // If we can keep going forward, do so.
				else
				{
					// We can't go forward, go any direction except backwards.
					if (POSSIBLE_PATHS[0] == Direction.reverse(CURRENT_DIRECTION)) return POSSIBLE_PATHS[1];
					else return POSSIBLE_PATHS[0];
				}
			}
			else
			{
				// There are three or more possible paths
				return RANDOM_PATH_EXCEPT(Direction.reverse(CURRENT_DIRECTION));
			}
		
		}
	
	}

}