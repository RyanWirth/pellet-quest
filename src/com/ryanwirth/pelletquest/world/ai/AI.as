package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AI
	{
		private var _canMoveUp:Boolean = false;
		private var _canMoveDown:Boolean = false;
		private var _canMoveLeft:Boolean = false;
		private var _canMoveRight:Boolean = false;
		private var _possiblePaths:Vector.<String> = new Vector.<String>();
		private var _entity:Entity;
		private var _xTileOverride:int;
		private var _yTileOverride:int;
		private var _includeEntities:Boolean = true;
		
		/**
		 * A base class for a type of AI. Given an entity, the AI class will automatically determine all possible paths before being instructed to find a specific one.
		 * @param	entity The entity to find a path for.
		 * @param 	xTileOverride A x-coordinate to override the entity's if not set to -1.
		 * @param	yTileOverride A y-coordinate to override the entity's if not set to -1.
		 * @param	includeEntities	True if entities should be included in finding possible paths, false if not.
		 */
		public function AI(entity:Entity, xTileOverride:int = -1, yTileOverride:int = -1, includeEntities:Boolean = true)
		{
			_entity = entity;
			_xTileOverride = xTileOverride;
			_yTileOverride = yTileOverride;
			_includeEntities = includeEntities;
			
			findPossiblePaths();
		}
		
		/**
		 * Disposes of all AI-related resources/references.
		 */
		public function destroy():void
		{
			_entity = null;
			_possiblePaths = null;
		}
		
		/**
		 * Designed to be overridden by a specific type of AI.
		 * @return A direction to move.
		 */
		public function findPath():String
		{
			throw(new Error("AI: findPath() method needs to be overridden."));
		}
		
		/**
		 * Checks all four cardinal directions for walkable tiles and a) sets that direction's Boolean flag and b) adds the direction to the _possiblePaths vector.
		 */
		private function findPossiblePaths():void
		{
			var xTile:int = _xTileOverride != -1 ? _xTileOverride : _entity.X_TILE;
			var yTile:int = _yTileOverride != -1 ? _yTileOverride : _entity.Y_TILE;
			
			if (MapManager.isTileWalkable(xTile - 1, yTile, _includeEntities))
			{
				_canMoveLeft = true;
				_possiblePaths.push(Direction.LEFT);
			}
			if (MapManager.isTileWalkable(xTile + 1, yTile, _includeEntities))
			{
				_canMoveRight = true;
				_possiblePaths.push(Direction.RIGHT);
			}
			if (MapManager.isTileWalkable(xTile, yTile - 1, _includeEntities))
			{
				_canMoveUp = true;
				_possiblePaths.push(Direction.UP);
			}
			if (MapManager.isTileWalkable(xTile, yTile + 1, _includeEntities))
			{
				_canMoveDown = true;
				_possiblePaths.push(Direction.DOWN);
			}
		}
		
		protected function get CAN_MOVE_LEFT():Boolean
		{
			return _canMoveLeft;
		}
		
		protected function get CAN_MOVE_RIGHT():Boolean
		{
			return _canMoveRight;
		}
		
		protected function get CAN_MOVE_UP():Boolean
		{
			return _canMoveUp;
		}
		
		protected function get CAN_MOVE_DOWN():Boolean
		{
			return _canMoveDown;
		}
		
		protected function get CURRENT_DIRECTION():String
		{
			return _entity.DIRECTION;
		}
		
		protected function get POSSIBLE_PATHS():Vector.<String>
		{
			return _possiblePaths;
		}
		
		/**
		 * Determines if the entity can move in its current direction.
		 */
		protected function get CAN_MOVE_CURRENT_DIRECTION():Boolean
		{
			return CAN_MOVE(CURRENT_DIRECTION);
		}
		
		/**
		 * Given a direction, determines if the entity can move that way.
		 * @param	direction The direction in question.
		 * @return True if the entity can move in that direction, false if not.
		 */
		public function CAN_MOVE(direction:String):Boolean
		{
			switch (direction)
			{
			case Direction.LEFT: 
				return CAN_MOVE_LEFT;
				break;
			case Direction.RIGHT: 
				return CAN_MOVE_RIGHT;
				break;
			case Direction.UP: 
				return CAN_MOVE_UP;
				break;
			case Direction.DOWN: 
				return CAN_MOVE_DOWN;
				break;
			default: 
				throw(new Error("AI: Unknown Direction '" + direction + "'."));
				break;
			}
			
			return false;
		}
		
		/**
		 * Removes the unwanted direction if doing so does not eliminate all other paths, then returns a random path from the remaining options.
		 * @param	direction The unwanted direction.
		 * @return A randomly chosen direction.
		 */
		public function RANDOM_PATH_EXCEPT(direction:String):String
		{
			if (POSSIBLE_PATHS.length > 1) REMOVE_PATH(direction);
			return RANDOM_PATH;
		}
		
		/**
		 * Finds and removes the provided direction for the POSSIBLE_PATHS vector. Fails silently if the direction is not found.
		 * @param	direction The direction to remove.
		 */
		protected function REMOVE_PATH(direction:String):void
		{
			// Remove the unwanted direction.
			for (var i:int = 0; i < POSSIBLE_PATHS.length; i++)
				if (POSSIBLE_PATHS[i] == direction) POSSIBLE_PATHS.splice(i, 1);
		}
		
		/**
		 * Returns a random path from the POSSIBLE_PATHS.
		 */
		public function get RANDOM_PATH():String
		{
			if (POSSIBLE_PATHS.length == 0) return "";
			
			// Calculate a random number between 0 and POSSIBLE_PATHS.length - 1, then return the path with that index.
			var rand:int = Math.floor(Math.random() * POSSIBLE_PATHS.length);
			return POSSIBLE_PATHS[rand];
		}
		
		/**
		 * Returns the X_TILE of the entity.
		 */
		protected function get X_TILE():int
		{
			return _xTileOverride != -1 ? _xTileOverride : _entity.X_TILE;
		}
		
		/**
		 * Returns the Y_TILE of the entity.
		 */
		protected function get Y_TILE():int
		{
			return _yTileOverride != -1 ? _yTileOverride : _entity.Y_TILE;
		}
		
		/**
		 * Provides the number of possible paths to take.
		 */
		public function get NUMBER_OF_POSSIBLE_PATHS():int
		{
			return POSSIBLE_PATHS.length;
		}
		
		/**
		 * Provides direct access to the AI's subject entity.
		 */
		protected function get ENTITY():Entity
		{
			return _entity;
		}
		
		/**
		 * Given a pair of coordinates, translates them by the provided direction and returns the coordinates as a Point object.
		 * @param	xTile The starting x-coordinate.
		 * @param	yTile The starting y-coordinate.
		 * @param	direction The direction to translate by.
		 * @return The translated coordinates as a Point.
		 */
		protected function translateCoordinatesByDirection(xTile:int, yTile:int, direction:String):Point
		{
			switch (direction)
			{
			case Direction.LEFT: 
				xTile--;
				break;
			case Direction.RIGHT: 
				xTile++;
				break;
			case Direction.UP: 
				yTile--;
				break;
			case Direction.DOWN: 
				yTile++;
				break;
			default: 
				throw(new Error("AI: Unknown Direction '" + direction + "'."));
				break;
			}
			
			return new Point(xTile, yTile);
		}
		
		/**
		 * Determines the distance from the current tile to the player.
		 * @param	distanceAlgorithmType The algorithm used to calculate the distance.
		 * @return Distance measured in tiles.
		 */
		public static function findDistanceToPlayer(entity:Entity, distanceAlgorithmType:String = DistanceAlgorithmType.EUCLIDIAN, xTileOverride:int = -1, yTileOverride:int = -1):Number
		{
			var dX:int = PlayerManager.PLAYER.X_TILE - (entity ? entity.X_TILE : xTileOverride);
			var dY:int = PlayerManager.PLAYER.Y_TILE - (entity ? entity.Y_TILE : yTileOverride);
			
			if (distanceAlgorithmType == DistanceAlgorithmType.MANHATTAN)
			{
				if (dX < 0) dX *= -1;
				if (dY < 0) dY *= -1;
				return dX + dY;
			}
			else if (distanceAlgorithmType == DistanceAlgorithmType.EUCLIDIAN) return Math.sqrt(dX * dX + dY * dY);
			else if (distanceAlgorithmType == DistanceAlgorithmType.EUCLIDIAN_NON_ROOT) return dX * dX + dY * dY;
			else
			{
				throw(new Error("AI: Unknown DistanceALgorithmType '" + distanceAlgorithmType + "'."));
				return 0;
			}
		}
		
		/**
		 * Determines the distance between the given entity and the player in pixels.
		 * @param	entity The entity to check.
		 * @param	distanceAlgorithmType The algorithm used to determine the distance.
		 * @return The distance between the entity and the player in pixels.
		 */
		public static function findPixelDistanceToPlayer(entity:Entity, distanceAlgorithmType:String = DistanceAlgorithmType.EUCLIDIAN):Number
		{
			var dX:Number = PlayerManager.PLAYER.x - entity.x;
			var dY:Number = PlayerManager.PLAYER.y - entity.y;
			
			if (distanceAlgorithmType == DistanceAlgorithmType.EUCLIDIAN) return Math.sqrt(dX * dX + dY * dY);
			else if (distanceAlgorithmType == DistanceAlgorithmType.EUCLIDIAN_NON_ROOT) return dX * dX + dY * dY;
			else if (distanceAlgorithmType == DistanceAlgorithmType.MANHATTAN) return (dX > 0 ? dX : -dX) + (dY > 0 ? dY : -dY);
			else
			{
				throw(new Error("AI: Unknown DistanceAlgorithmType '" + distanceAlgorithmType + "'."));
				return 0;
			}
		}
	
	}

}