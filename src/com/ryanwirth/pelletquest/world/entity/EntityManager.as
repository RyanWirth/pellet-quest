package com.ryanwirth.pelletquest.world.entity
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.world.ai.AI;
	import com.ryanwirth.pelletquest.world.ai.DistanceAlgorithmType;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import com.ryanwirth.pelletquest.world.tile.TileType;
	import flash.utils.getDefinitionByName;
	import io.arkeus.tiled.TiledObject;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class EntityManager
	{
		// The class must maintain references to entities in order to ensure they are compiled in the SWF.
		private static const ENTITY_REFERENCES:Array = [ECoin, ESkeleton, EMale, EClothArmorMale, EDeer, EOldMan, EDoor1, EFurnace, ETorch, ECandle, ECandleFixture];
		private static const PART_REFERENCES:Array = [PBlondHair, PBrownShoes, PGreenPants, PClothArmor];
		
		private static var _entities:Vector.<Entity>;
		private static var _coins:Vector.<Entity>;
		
		private static var _activateEntities:Boolean = false;
		
		public function EntityManager()
		{
			throw(new Error("EntityManager: Do not instantiate."));
		}
		
		/**
		 * Moves the provided entity in the specified direction. Fails silently if the destination tile is "unwalkable."
		 * @param	entity
		 * @param	directionType
		 */
		public static function moveEntity(entity:Entity, directionType:String):void
		{
			if (entity.IS_MOVING || entity.EXPLODED) return;
			
			var newXTile:int = entity.X_TILE;
			var newYTile:int = entity.Y_TILE;
			
			// Determine the updated x- and y-coordinates from the provided directionType.
			if (directionType == Direction.LEFT) newXTile--;
			else if (directionType == Direction.RIGHT) newXTile++;
			else if (directionType == Direction.UP) newYTile--;
			else if (directionType == Direction.DOWN) newYTile++;
			
			// Calculate the distance between the entity and his destination
			var distanceX:Number = Math.abs(entity.x - newXTile * MapManager.TILE_SIZE);
			var distanceY:Number = Math.abs(entity.y - newYTile * MapManager.TILE_SIZE);
			var distanceMultiplier:Number = distanceX > distanceY ? distanceX : distanceY;
			distanceMultiplier /= MapManager.TILE_SIZE;
			
			// If the entity cannot move to this new tile, fail silently.
			if (!MapManager.isTileWalkable(newXTile, newYTile))
			{
				// Reset the entity's animation state to be standing still.
				entity.animate(AnimationType.STAND, directionType);
				
				// If the entity is the player and we cannot move in this direction, set the desired player move direction to an empty string.
				if (entity.IS_PLAYER) PlayerManager.setPlayerMoveDirection("");
				else entity.prepareForRunningAI();
				
				// Stop processing, return.
				return;
			}
			
			// Update the entity's location
			entity.updateLocation(newXTile, newYTile);
			
			// Make sure the entity knows it's moving
			entity.setMoving(true);
			
			// Animate the entity
			entity.animate(AnimationType.WALK, directionType);
			
			// If the entity is the player, pan the world with it! Also, check for entities with onWalkInto properties.
			if (entity.IS_PLAYER)
			{
				GameManager.RENDERER.pan(directionType, distanceMultiplier);
				
				var entityObj:TiledObject = MapManager.getObjectAt(newXTile, newYTile);
				if (entityObj && entityObj.properties.properties.hasOwnProperty("onWalkInto")) CommandManager.decodeCommandString(entity, entityObj.properties.properties.onWalkInto);
			}
			
			// Tween the entity to its new x and y location.
			TweenMax.to(entity, 1 / entity.WALK_SPEED * distanceMultiplier, {x: newXTile * MapManager.TILE_SIZE, y: newYTile * MapManager.TILE_SIZE, ease: Linear.easeNone, onComplete: finishMovingEntity, onCompleteParams: [entity]});
			TweenMax.delayedCall((1 / entity.WALK_SPEED) * 0.5 * distanceMultiplier, checkForEntityCollisions, [entity]);
			TweenMax.delayedCall(3, fixEntitiesLayering, [entity], true);
		}
		
		/**
		 * Checks for entity collisions and fixes the entity layering in the WorldRenderer.
		 * @param	entity
		 */
		private static function fixEntitiesLayering(entity:Entity):void
		{
			checkForEntityCollisions(entity);
			
			GameManager.RENDERER.fixEntitiesLayering();
		}
		
		/**
		 * Interrupts an entity's current movement.
		 * @param	entity The entity to interrupt the movement of.
		 */
		public static function interruptMoveEntity(entity:Entity):void
		{
			TweenMax.killTweensOf(entity);
			
			GameManager.RENDERER.interruptPan();
			entity.setMoving(false);
		}
		
		/**
		 * If the provided entity is the player, iterates through all other entities and searches for collisions.
		 * If the provided entity is not the player, checks for a direct collision with the player.
		 * A collision is defined as two entities having the same x- and y-coordinates.
		 * Should a collision occur with the player, PlayerManager.playerHitBy(entity2); is called.
		 * @param	entity The source entity to check.
		 */
		private static function checkForEntityCollisions(entity:Entity):void
		{
			// The player is already "dead", don't bother checking.
			if (entity.EXPLODED || PlayerManager.PLAYER.EXPLODED) return;
			
			if (entity.IS_PLAYER)
			{
				// Check for the player touching other entities!
				var dist:Number = Number.MAX_VALUE;
				for (var i:int = 0; i < _entities.length; i++)
				{
					if (_entities[i].IS_PLAYER) continue;
					else if (_entities[i].IS_ENEMY == false) continue;
					
					dist = AI.findPixelDistanceToPlayer(_entities[i], DistanceAlgorithmType.EUCLIDIAN_NON_ROOT);
					//trace("Checking: " + dist);
					if (dist <= MapManager.TILE_SIZE * MapManager.TILE_SIZE * 0.5)
					{
						PlayerManager.playerHitBy(_entities[i]);
						return;
					}
				}
			}
			else
			{
				if (AI.findPixelDistanceToPlayer(entity, DistanceAlgorithmType.EUCLIDIAN_NON_ROOT) <= MapManager.TILE_SIZE * MapManager.TILE_SIZE * 0.5)
				{
					PlayerManager.playerHitBy(entity);
					return;
				}
			}
		}
		
		/**
		 * Given a visibility statement, determines if the conditions evaluate to be *all* true. If they are, returns true. If not, returns false.
		 * @param	visibility A string containing semi-colon delimited conditional statements.
		 * @return True if all statements are true. False if any are false.
		 */
		public static function evaluateVisibility(visibility:String):Boolean
		{
			var statements:Array = visibility.split(";");
			for (var i:int = 0; i < statements.length; i++)
			{
				var statement:Array = String(statements[i]).split("::");
				var key:String = statement[0];
				var stateName:String = statement[1];
				var value:String = statement[2];
				var realValue:String = CommandManager.getStateValue(stateName);
				if (key == "if")
				{
					if (value != realValue) return false;
				} else
				if (key == "ifnot")
				{
					if (value == realValue) return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Called when the given entity has finished moving into its next time. Handles the transition to standing animations, fixing layering, coin collision checking, etc.
		 * @param	entity The entity that has just finished moving.
		 */
		private static function finishMovingEntity(entity:Entity):void
		{
			entity.setMoving(false);
			
			// Finish the entity's walk animation
			entity.prepareToStopWalking();
			
			// If the entity is executing a command, that probably means they're being forced to move.
			if (entity.EXECUTING_COMMAND || entity.COMMANDS.length > 0) 
			{
				CommandManager.nextCommand(entity);
				if (entity.IS_PLAYER) PlayerManager.checkForCoins();
				return;
			}
			
			MapManager.checkForObjects(entity);
			
			// Check to see if this entity is the player. If it is and the desired direction is specified, more that way.
			// If the entity is not a player, attempt to run its AI.
			if (entity.IS_PLAYER && OptionsManager.CONTROLS)
			{
				PlayerManager.checkForCoins();
				
				if (PlayerManager.PLAYER_DIRECTION != "")
				{
					// If EASY_INPUT is on and the algorithm calls a failure, return - that is, don't move the player!
					if (OptionsManager.EASY_INPUT && !PlayerManager.determineEasyInputDirection()) return;
					
					moveEntity(entity, PlayerManager.PLAYER_DIRECTION);
				}
			}
			else if (!entity.IS_PLAYER) entity.runAI();
		}
		
		/**
		 * Constructs an entity of the given type and places it on the map at the specified x- and y-coordinates.
		 * @param	entityType	The type of entity to be created.
		 * @param	xTile	The x-coordinate (in tiles) the entity is to be placed at.
		 * @param	yTile	The y-coordinate (in tiles) the entity is to be placed at.
		 * @param	direction (Optional) If set, turns the created entity in that direction.
		 * @return	The entity that was created.
		 */
		public static function createEntity(entityType:String, xTile:int, yTile:int, direction:String = Direction.DOWN, fromRegion:String = ""):Entity
		{
			if (!_entities) _entities = new Vector.<Entity>();
			if (!_coins) _coins = new Vector.<Entity>();
			
			var cl:Class = getDefinitionByName("com.ryanwirth.pelletquest.world.entity." + entityType) as Class;
			var entity:Entity = new cl(xTile, yTile) as Entity;
			
			// Update the entity's source region
			entity.setFromRegion(fromRegion);
			
			// Position the entity within the map.
			entity.x = xTile * MapManager.TILE_SIZE;
			entity.y = yTile * MapManager.TILE_SIZE;
			
			// In order to resolve layering issues, moving coins downward will cause them to show up on top of all other entities on the same row.
			if (entityType == EntityType.COIN)
			{
				entity.y++;
				
				// Keep track of coins in their own vector.
				_coins.push(entity);
			}
			else _entities.push(entity);
			
			// Update the entity's direction
			entity.animate(entity.ANIMATION_TYPE, direction);
			
			// Check for the activation flag - but not for coins!
			if (_activateEntities && entityType != EntityType.COIN && entity.IS_ENEMY) entity.activate();
			
			// Call the finishMoving() function in order to start its AI, if it has one.
			entity.runAI(true);
			
			// Add the entity to the map.
			GameManager.RENDERER.addChildTo(entity, TileType.ENTITIES);
			
			return entity;
		}
		
		/**
		 * Destroys any entities at the provided x- and y-coordinates.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @param	entityType If given, will only destroy entities matching the entityType.
		 */
		public static function destroyEntityAt(xTile:int, yTile:int, entityType:String = ""):void
		{
			var i:int;
			
			if (entityType == EntityType.COIN)
			{
				// Search the _coins vector.
				for (i = 0; i < _coins.length; i++)
				{
					if (_coins[i].X_TILE == xTile && _coins[i].Y_TILE == yTile)
					{
						destroyEntity(_coins[i]);
						_coins[i] = null;
						_coins.splice(i, 1);
						return; // We'll only ever destroy one coin at a time. Therefore, stop iterating through the vector when the coin is found.
					}
				}
			}
			else
			{
				// Search the regular _entities vector.
				for (i = 0; i < _entities.length; i++)
				{
					if (entityType != "" && _entities[i].ENTITY_TYPE != entityType) continue;
					
					if (_entities[i].X_TILE == xTile && _entities[i].Y_TILE == yTile)
					{
						destroyEntity(_entities[i]);
						_entities[i] = null;
						_entities.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		/**
		 * Finds and returns the entity at the provided x- and y-coordinates with a matching entityType, if given. If no entity exists, returns null.
		 * @param	xTile The x-coordinate to search.
		 * @param	yTile The y-coordiante to search.
		 * @param	entityType (Optional) The entity type to look for.
		 * @return If found, the entity at the provided coordinates. If not found, null.
		 */
		public static function getEntityAt(xTile:int, yTile:int, entityType:String = ""):Entity
		{
			var i:int;
			var l:int;
			
			if (entityType == EntityType.COIN)
			{
				// Search the _coins vector.
				for (i = 0, l = _coins.length; i < l; i++)
				{
					if (_coins[i].X_TILE == xTile && _coins[i].Y_TILE == yTile) return _coins[i];
				}
			}
			else
			{
				// Search the regular _entities vector.
				for (i = 0, l = _entities.length; i < l; i++)
				{
					if (entityType != "" && _entities[i].ENTITY_TYPE != entityType) continue;
					else return _entities[i];
				}
			}
			
			return null;
		}
		
		/**
		 * Activates all of the entities currently on-screen.
		 */
		public static function activateEntities():void
		{
			if (_activateEntities) return;
			_activateEntities = true;
			
			for (var i:int = 0, l:int = _entities.length; i < l; i++)
				if (_entities[i].IS_ENEMY) _entities[i].activate();
		}
		
		/**
		 * Turns off the activateEntities flag and deactivates all already created entities.
		 */
		public static function deactivateEntities():void
		{
			if (!_activateEntities) return;
			_activateEntities = false;
			
			for (var i:int = 0, l:int = _entities.length; i < l; i++) _entities[i].deactivate();
		}
		
		/**
		 * Removes the entity from the map and destroys it.
		 * @param	entity The entity to be destroyed.
		 */
		public static function destroyEntity(entity:Entity, removeFromVector:Boolean = false):void
		{
			if (!entity) return;
			
			TweenMax.killTweensOf(entity);
			
			GameManager.RENDERER.removeChildFrom(entity, TileType.ENTITIES);
			
			entity.destroy();
			
			if (entity.FROM_REGION != "") MapManager.changeRegionSpawnCount(entity.FROM_REGION, -1);
			
			if (removeFromVector)
			{
				// Iterate through the vector, looking for the entity we just destroyed.
				for (var i:int = 0, l:int = _entities.length; i < l; i++)
				{
					if (_entities[i] == entity)
					{
						// We've found the entity!
						_entities.splice(i, 1);
						return;
					}
				}
			}
		}
		
		/**
		 * Cleans up all entities and coins tracked by the EntityManager.
		 */
		public static function destroy():void
		{
			var i:int;
			
			if (_entities)
			{
				for (i = 0; i < _entities.length; i++)
				{
					destroyEntity(_entities[i]);
					_entities[i] = null;
				}
				
				_entities = null;
			}
			
			if (_coins)
			{
				for (i = 0; i < _coins.length; i++)
				{
					destroyEntity(_coins[i]);
					_coins[i] = null;
				}
				
				_coins = null;
			}
			
			_activateEntities = false;
		}
		
		/**
		 * Checks for an entity at the given x- and y-coordinates. Does not include ECoin entities or the player.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @return True if there is an entity at the provided coordinates, false if not.
		 */
		public static function isEntityAt(xTile:int, yTile:int, entityType:String = "", onlyNonEnemies:Boolean = false):Boolean
		{
			if (!_entities) _entities = new Vector.<Entity>();
			if (!_coins) _coins = new Vector.<Entity>();
			
			var i:int;
			var l:int;
			
			if (entityType == EntityType.COIN)
			{
				for (i = 0, l = _coins.length; i < l; i++)
					if (_coins[i].X_TILE == xTile && _coins[i].Y_TILE == yTile) return true;
			}
			else
			{
				for (i = 0, l = _entities.length; i < l; i++)
				{
					if (entityType != "" && _entities[i].ENTITY_TYPE != entityType) continue;
					
					if (_entities[i].IS_PLAYER == false && _entities[i].X_TILE == xTile && _entities[i].Y_TILE == yTile && _entities[i].EXPLODED == false)
					{
						if (onlyNonEnemies && _entities[i].IS_ENEMY) continue;
						
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Provides the current number of entities within the EntityManager.
		 */
		public static function get NUMBER_OF_ENTITIES():int
		{
			return _entities != null ? _entities.length : 0;
		}
		
		/**
		 * Serializes/encodes all of the currently created entities into an object vector for saving in the current save file.
		 * @return The encoded entities as an object vector.
		 */
		public static function ENCODE_ENTITIES():Vector.<Object>
		{
			var vec:Vector.<Object> = new Vector.<Object>();
			if (!_entities) return vec;
			
			for (var i:int = 0; i < _entities.length; i++)
			{
				// Don't save the player!
				if (_entities[i].IS_PLAYER || _entities[i].SAVE == false) continue;
				
				var obj:Object = new Object();
				obj.type = _entities[i].ENTITY_TYPE;
				obj.x = _entities[i].X_TILE;
				obj.y = _entities[i].Y_TILE;
				obj.dir = _entities[i].DIRECTION;
				obj.region = _entities[i].FROM_REGION;
				vec.push(obj);
			}
			
			return vec;
		}
		
		/**
		 * De-serializes/decodes the entity data stored as an object vector, creating each entity as specified.
		 * @param	vec The entity object vector containing the type, coordinates, and direction of each entity.
		 */
		public static function DECODE_ENTITIES(vec:Vector.<Object>):void
		{
			for (var i:int = 0; i < vec.length; i++)
			{
				if (isEntityAt(vec[i].x, vec[i].y)) continue;
				
				var entity:Entity = createEntity(vec[i].type, vec[i].x, vec[i].y, vec[i].dir, vec[i].region);
				if (vec[i].region != "") MapManager.changeRegionSpawnCount(vec[i].region, 1);
			}
		}
		
		/**
		 * Finds and returns an entity whose name property matches the given name.
		 * @param	name The name of the entity to find.
		 * @return An entity with a matching name property.
		 */
		public static function getEntityByName(name:String):Entity
		{
			if (!_entities) _entities = new Vector.<Entity>();
			
			for (var i:int = 0; i < _entities.length; i++) if (_entities[i].NAME == name) return _entities[i];
			return null;
		}
	
	}

}