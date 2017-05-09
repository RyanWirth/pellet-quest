package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AILimitedPathfinder extends AI
	{
		public function AILimitedPathfinder(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * Differs from the regular AIPathfinder in that it will revert to AISimple if the player is more than 15 tiles away.
		 */
		override public function findPath():String
		{
			var ai:AI;
			if (findDistanceToPlayer(ENTITY) >= 5) ai = new AISimple(ENTITY);
			else ai = new AIPathfinder(ENTITY);
			
			// Find a path for us to take, given some type of AI
			var path:String = ai.findPath();
			
			// Clean up the AI we created.
			ai.destroy();
			ai = null;
			
			// Return the path we found.
			return path;
		}
	
	}

}