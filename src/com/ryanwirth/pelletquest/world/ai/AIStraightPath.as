package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIStraightPath extends AI
	{
		public function AIStraightPath(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * The STRAIGHT PATH AI type is similar to the SIMPLE type, but when given a choice between three possible paths, the entity will keep moving forward.
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
					// We can't go forward, go any random direction
					return RANDOM_PATH_EXCEPT(Direction.reverse(CURRENT_DIRECTION));
				}
			}
			else
			{
				// There are three or more possible paths
				if (CAN_MOVE_CURRENT_DIRECTION) return CURRENT_DIRECTION;
				else return RANDOM_PATH_EXCEPT(Direction.reverse(CURRENT_DIRECTION));
				;
			}
		
		}
	
	}

}