package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.entity.SpawnManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIManager
	{
		
		public function AIManager()
		{
		
		}
		
		/**
		 * Given a type of AI and the calling entity, moves the entity in the determined direction.
		 * @param	aiType The type of AI.
		 * @param	entity The entity to be moved.
		 * @param	getInitialDirection If true, will simply choose a random direction.
		 */
		public static function findPath(aiType:String, entity:Entity, getInitialDirection:Boolean):void
		{
			var ai:AI;
			var direction:String;
			
			// If the player is already dead, revert back to a simple AI type (that is, don't go towards the player's corpse)
			if (PlayerManager.PLAYER.EXPLODED) aiType = AIType.SIMPLE;
			
			// Check to see if the entity is out of range.
			if (AI.findDistanceToPlayer(entity) >= GameManager.MAXIMUM_SPAWN_DISTANCE)
			{
				trace("AIManager: " + entity.ENTITY_TYPE + " too far from player; destroyed.");
				
				// Try to spawn another entity to make up for it.
				SpawnManager.spawnEntityInRegion(MapManager.getRegionFromName(entity.FROM_REGION));
				
				EntityManager.destroyEntity(entity, true);
				return;
			}
			
			// Create an instance of the indicated AI type.
			switch (aiType)
			{
			case AIType.STRAIGHT_PATH: 
				ai = new AIStraightPath(entity);
				break;
			case AIType.LIMITED_PATHFINDER: 
				ai = new AILimitedPathfinder(entity);
				break;
			case AIType.PATHFINDER: 
				getInitialDirection = false;
				ai = new AIPathfinder(entity);
				break;
			case AIType.APPROXIMATE_PATHFINDING: 
				ai = new AIApproximatePathfinding(entity, 0, "");
				break;
			case AIType.STUPID: 
				ai = new AIStupid(entity);
				break;
			case AIType.PLAYER_FOLLOWER: 
				ai = new AIPlayerFollower(entity);
				break;
			case AIType.SIMPLE: 
			default: 
				ai = new AISimple(entity);
				break;
			}
			
			if (!getInitialDirection) direction = ai.findPath();
			else direction = ai.RANDOM_PATH;
			
			if (direction == "") entity.prepareForRunningAI();
			else
				EntityManager.moveEntity(entity, direction);
			
			// Dispose of the AI object
			ai.destroy();
			ai = null;
		}
	
	}

}