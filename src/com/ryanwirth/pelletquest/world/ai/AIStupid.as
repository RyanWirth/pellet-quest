package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIStupid extends AI
	{
		public function AIStupid(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * The STUPID AI type is very similar to the SIMPLE type, but when the entity comes to a corner it may go backwards.
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
					return RANDOM_PATH;
				}
			}
			else
			{
				// There are three or more possible paths
				return RANDOM_PATH;
			}
		
		}
	
	}

}