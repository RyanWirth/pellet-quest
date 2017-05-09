package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIApproximatePathfinding extends AI
	{
		private var _depth:int;
		private var _directionToGetHere:String;
		
		public function AIApproximatePathfinding(entity:Entity, depth:int, directionToGetHere:String, xTileOverride:int = -1, yTileOverride:int = -1)
		{
			_depth = depth;
			_directionToGetHere = directionToGetHere;
			
			super(entity, xTileOverride, yTileOverride);
		}
		
		/**
		 * In the APPROXIMATE_PATHFINDING AI type, the root object will recursively create new objects of itself (up to a maximum depth of 5) which each
		 */
		override public function findPath():String
		{
			var lowestDistance:int = int.MAX_VALUE;
			var lowestDistancePath:String = "";
			for (var i:int = 0; i < POSSIBLE_PATHS.length; i++)
			{
				var newCoordinates:Point = translateCoordinatesByDirection(X_TILE, Y_TILE, POSSIBLE_PATHS[i]);
				var choice:AIApproximatePathfinding = new AIApproximatePathfinding(ENTITY, _depth + 1, POSSIBLE_PATHS[i], newCoordinates.x, newCoordinates.y);
				var distanceToPlayer:Number = choice.findRecursiveDistance();
				
				// The player has been found! Return this direction.
				if (distanceToPlayer == 0) return POSSIBLE_PATHS[i];
				
				if (distanceToPlayer < lowestDistance)
				{
					lowestDistance = distanceToPlayer;
					lowestDistancePath = POSSIBLE_PATHS[i];
				}
			}
			
			return lowestDistancePath;
		}
		
		public function findRecursiveDistance():int
		{
			// We found the player! Return zero distance.
			if (X_TILE == PlayerManager.PLAYER.X_TILE && Y_TILE == PlayerManager.PLAYER.Y_TILE) return 0;
			
			// This is the deepest we can go, find the distance and return!
			if (_depth >= 5) return findDistanceToPlayer(ENTITY);
			
			// Make sure we can't go backwards.
			var lowestDistance:int = int.MAX_VALUE;
			if (_directionToGetHere != "") REMOVE_PATH(_directionToGetHere);
			
			// If this is a dead end (nowhere to go except backwards), return a huge number to make sure this path isn't chosen.
			if (POSSIBLE_PATHS.length == 0) return int.MAX_VALUE;
			
			for (var i:int = 0; i < POSSIBLE_PATHS.length; i++)
			{
				var newCoordinates:Point = translateCoordinatesByDirection(X_TILE, Y_TILE, POSSIBLE_PATHS[i]);
				var choice:AIApproximatePathfinding = new AIApproximatePathfinding(ENTITY, _depth + 1, POSSIBLE_PATHS[i], newCoordinates.x, newCoordinates.y);
				var distanceToPlayer:Number = choice.findRecursiveDistance();
				if (distanceToPlayer < lowestDistance) lowestDistance = distanceToPlayer;
			}
			
			return lowestDistance;
		}
	
	}

}