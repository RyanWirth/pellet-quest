package com.ryanwirth.pelletquest.world.map
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.entity.EntityType;
	import com.ryanwirth.pelletquest.world.map.Map;
	import com.ryanwirth.pelletquest.world.tile.Tile;
	import com.ryanwirth.pelletquest.world.tile.TileLayer;
	import com.ryanwirth.pelletquest.world.tile.TileType;
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class MapManager
	{
		// The size of a tile's height and width measured in pixels. Divided by the native tile size of 32, a value of 64 means a scaling factor of two.
		public static var TILE_SIZE:int = 32;
		
		public static var CHUNK_WIDTH:int = 1;
		public static var CHUNK_HEIGHT:int = 1;
		
		// A vector that holds all currently created tiles, in order to check which 
		private static var _tiles:Vector.<Tile>;
		private static var _tilesPool:Vector.<Tile>;
		
		// The instance of the map currently loaded and its respective name.
		private static var _map:Map;
		private static var _mapType:String;
		
		// The coordinates of the currently centered tile.
		private static var _centeredXTile:int = -1;
		private static var _centeredYTile:int = -1;
		
		private static var _previousCenteredXTile:int = -1;
		private static var _previousCenteredYTile:int = -1;
		
		public function MapManager()
		{
			throw(new Error("MapManager: Do not instantiate."));
		}
		
		/**
		 * Begins the game by creating the map through drawing the "chunks" around the initial x- and y-coordinates provided.
		 * @param	mapType The type of the map to be created. Must be a valid type found in MapType.
		 * @param	initialXTile The x-coordinate of the tile to create the map around.
		 * @param	initialYTile The y-coordinate of the tile to create the map around.
		 */
		public static function createMap(mapType:String, initialXTile:int, initialYTile:int):void
		{
			_tiles = new Vector.<Tile>();
			_tilesPool = new Vector.<Tile>();
			_mapType = mapType;
			_centeredXTile = initialXTile;
			_centeredYTile = initialYTile;
			
			// Calculate a chunk's height and width
			CHUNK_WIDTH = Math.ceil(GameManager.stageWidth / TILE_SIZE * 1);
			CHUNK_HEIGHT = Math.ceil(GameManager.stageHeight / TILE_SIZE * 1);
			
			GameManager.MAXIMUM_SPAWN_DISTANCE = CHUNK_HEIGHT + CHUNK_WIDTH;
			
			trace("MapManager: Chunk dimensions: " + CHUNK_WIDTH + "x" + CHUNK_HEIGHT + ", maximum spawn distance: " + GameManager.MAXIMUM_SPAWN_DISTANCE);
			
			// Create the instance of the map to be created.
			getMapReference();
			
			// Check for unset initialXTiles and initialYTiles
			if (_centeredXTile == -1 || _centeredYTile == -1)
			{
				_centeredXTile = _map.MAP.properties.properties.spawnXT;
				_centeredYTile = _map.MAP.properties.properties.spawnYT;
				
				SaveManager.SAVE.updateLocation(_centeredXTile, _centeredYTile);
				SaveManager.SAVE.updateDirection(_map.MAP.properties.properties.spawnDirection);
			}
			
			// Move the WorldRenderer sprites to their starting position.
			GameManager.RENDERER.centerMap(_centeredXTile, _centeredYTile);
			
			// Start creating tiles.
			checkForTileUpdates();
		}
		
		/**
		 * Recalculates CHUNK_WIDTH and CHUNK_HEIGHT and redraws the map.
		 */
		public static function forceMapRedraw():void
		{
			CHUNK_WIDTH = Math.ceil(GameManager.stageWidth / TILE_SIZE * 1);
			CHUNK_HEIGHT = Math.ceil(GameManager.stageHeight / TILE_SIZE * 1);
			
			GameManager.MAXIMUM_SPAWN_DISTANCE = CHUNK_HEIGHT + CHUNK_WIDTH;
			
			GameManager.RENDERER.centerMap(_centeredXTile, _centeredYTile);
			
			_previousCenteredXTile = _previousCenteredYTile = -1;
			checkForTileUpdates();
		}
		
		/**
		 * Checks to see if the given entity is on a script or similar.
		 * @param	entity The entity to check.
		 * @return True if the entity is on something, false if not.
		 */
		public static function checkForObjects(entity:Entity):Boolean
		{
			return _map.checkForObjects(entity);
		}
		
		/**
		 * Gets the specified property from an object whose name matches the given objectName.
		 * @param	propertyName The name of the property to get.
		 * @param	objectName The name of the object to get.
		 * @return The value of the property.
		 */
		public static function getObjectProperty(propertyName:String, objectName:String):String
		{
			return _map.getObjectProperty(propertyName, objectName);
		}
		
		/**
		 * Searches for tiles that are out of bounds and, if one or more are found, destroys it.
		 * If any tiles within the visible screen area have not been created yet, creates them.
		 */
		public static function checkForTileUpdates():void
		{
			var startXTile:int = _centeredXTile - Math.floor(CHUNK_WIDTH / 2 + 1);
			var startYTile:int = _centeredYTile - Math.floor(CHUNK_HEIGHT / 2 + 1);
			var endXTile:int = _centeredXTile + Math.floor(CHUNK_WIDTH / 2 + 1);
			var endYTile:int = _centeredYTile + Math.floor(CHUNK_HEIGHT / 2 + 1);
			
			var i:int;
			var l:int;
			var xTile:int = 0;
			var yTile:int = 0;
			var mapChanged:Boolean = false;
			for (i = 0, l = _tiles.length; i < l; i++)
			{
				xTile = _tiles[i].X_TILE;
				yTile = _tiles[i].Y_TILE;
				if (xTile < startXTile || xTile > endXTile || yTile < startYTile || yTile > endYTile)
				{
					mapChanged = true;
					GameManager.RENDERER.removeChildFrom(_tiles[i], _tiles[i].TILE_TYPE);
					EntityManager.destroyEntityAt(xTile, yTile, EntityType.COIN);
					_tilesPool.push(_tiles[i]);
					_tiles.splice(i, 1);
					i--;
					l--;
				}
			}
			
			// ********** only check moved regions
			if (_previousCenteredXTile == -1 && _previousCenteredYTile == -1)
			{
				// This is the first call, draw every tile!
				for (i = startXTile; i <= endXTile; i++)
				{
					for (var j:int = startYTile; j <= endYTile; j++)
					{
						if (!doesTileExist(i, j)) drawTile(i, j);
					}
				}
				
				mapChanged = true;
			}
			else
			{
				mapChanged = true;
				
				var dX:int = _previousCenteredXTile - _centeredXTile;
				var dY:int = _previousCenteredYTile - _centeredYTile;
				if (dX < 0)
				{
					// Moved to the right
					for (i = startYTile; i <= endYTile; i++) drawTile(endXTile, i);
				}
				else if (dX > 0)
				{
					// Moved to the left
					for (i = startYTile; i <= endYTile; i++) drawTile(startXTile, i);
				}
				else if (dY < 0)
				{
					// Moved down
					for (i = startXTile; i <= endXTile; i++) drawTile(i, endYTile);
				}
				else if (dY > 0)
				{
					// Moved up
					for (i = startXTile; i <= endXTile; i++) drawTile(i, startYTile);
				}
				else mapChanged = false;
			}
			
			if (mapChanged)
			{
				GameManager.RENDERER.flattenSprites();
			}
		}
		
		/**
		 * Checks if the specified tile coordinates could be seen on screen.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @return True if the tile can be seen, false if not.
		 */
		public static function couldTileBeVisible(xTile:int, yTile:int):Boolean
		{
			var mapX:int = _centeredXTile * TILE_SIZE - TILE_SIZE;
			var mapY:int = _centeredYTile * TILE_SIZE - TILE_SIZE;
			var mapWidth:int = (CHUNK_WIDTH + 2) * TILE_SIZE;
			var mapHeight:int = (CHUNK_HEIGHT + 2) * TILE_SIZE;
			var tileX:int = xTile * TILE_SIZE;
			var tileY:int = yTile * TILE_SIZE;
			
			return !(mapX > tileX + (TILE_SIZE - 1) || mapX + (mapWidth - 1) < tileX || mapY > tileY + (TILE_SIZE - 1) || mapY + (mapHeight - 1) < tileY);
		}
		
		/**
		 * Determines if the specified tile has already been drawn.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @return True if the tile exists, false if not.
		 */
		public static function doesTileExist(xTile:int, yTile:int):Boolean
		{
			for (var i:int = 0; i < _tiles.length; i++)
				if (_tiles[i].X_TILE == xTile && _tiles[i].Y_TILE == yTile) return true;
			return false;
		}
		
		/**
		 * Determines if an entity can move into the provided tile coordinates based on the lower level tile properties at that point.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @return True if an entity may walk into this tile, false if not.
		 */
		public static function isTileWalkable(xTile:int, yTile:int, checkForEntities:Boolean = false):Boolean
		{
			if (_map.getTileProperty(xTile, yTile, TileLayer.BOT, "isWalkable") == "false") return false;
			else if (_map.getTileProperty(xTile, yTile, TileLayer.MID, "isWalkable") == "false") return false;
			else if (_map.getTileProperty(xTile, yTile, TileLayer.MID2, "isWalkable") == "false") return false;
			else if (checkForEntities && EntityManager.isEntityAt(xTile, yTile, "", true)) return false;
			else return true;
		}
		
		/**
		 * Draws the two layers (top and bottom) of the specified tile, adds them to the _tiles array and to the WorldRenderer.
		 * If a coin exists at these coordinates, places an ECoin on the map.
		 * @param	xTile The x-coordinate of the tile to draw.
		 * @param	yTile The y-coordinate of the tile to draw.
		 */
		public static function drawTile(xTile:int, yTile:int):void
		{
			var tileTop:Tile = getTileFromPool();
			var tileBot:Tile = getTileFromPool();
			
			// Get any entity objects at this location, make sure to check for drawcalls
			var entityObj:TiledObject = _map.getObjectAt(xTile, yTile);
			if (entityObj != null && entityObj.type == "entity" && EntityManager.getEntityByName(entityObj.name) == null && (entityObj.properties.properties.hasOwnProperty("visibility") ? EntityManager.evaluateVisibility(entityObj.properties.properties.visibility) : true))
			{
				var region:TiledObject = _map.getRegionAt(xTile, yTile);
				var entity:Entity = EntityManager.createEntity(entityObj.properties.properties.type, xTile, yTile, Direction.DOWN, region != null ? region.name : "");
				if (entityObj.properties.properties.save == "false") entity.disableSaving();
				if (entityObj.properties.properties.hasOwnProperty("direction")) entity.animate(entity.ANIMATION_TYPE, entityObj.properties.properties.direction);
				entity.setName(entityObj.name);
			} else
			if (entityObj != null && entityObj.type == "drawcall")
			{
				trace("Interpreting drawcall");
				interpretDrawCall(entityObj, xTile, yTile);
			}
			
			if (!tileTop.drawTile(xTile, yTile, TileType.TOP)) tileTop.visible = false;
			else tileTop.visible = true;
			
			tileBot.drawTile(xTile, yTile, TileType.BOTTOM);
			tileTop.x = tileBot.x = xTile * TILE_SIZE;
			tileTop.y = tileBot.y = yTile * TILE_SIZE;
			
			_tiles.push(tileTop, tileBot);
			
			var coinIndex:int = getTileIndex(xTile, yTile, TileLayer.COINS);
			if (coinIndex == 0 && !SaveManager.SAVE.isCoinConsumed(xTile, yTile) && !EntityManager.isEntityAt(xTile, yTile, EntityType.COIN)) EntityManager.createEntity(EntityType.COIN, xTile, yTile);
			else if (coinIndex == 1 && !SaveManager.SAVE.isCoinConsumed(xTile, yTile) && !EntityManager.isEntityAt(xTile, yTile, EntityType.COIN)) EntityManager.createEntity(EntityType.COIN, xTile, yTile).setCoinPowerup();
			
			
			GameManager.RENDERER.addChildTo(tileTop, TileType.TOP);
			GameManager.RENDERER.addChildTo(tileBot, TileType.BOTTOM);
		}
		
		/**
		 * Retrieves an object from the objects layer at the given x- and y-coordinates, if one exists.
		 * @param	xTile The x-coordinate to check.
		 * @param	yTile The y-coordinate to check.
		 * @return The TiledObject at the given coordinates, if it exists. If not, null.
		 */
		public static function getObjectAt(xTile:int, yTile:int):TiledObject
		{
			return _map.getObjectAt(xTile, yTile);
		}
		
		/**
		 * Interprets "drawcall" type objects at draw-time. Performs special operations such as changing tile indexes and other tasks.
		 * @param	drawCall The drawcall TiledObject.
		 * @param	xTile The x-coordinate of this TiledObject.
		 * @param	yTile The y-coordinate of this TiledObject.
		 */
		private static function interpretDrawCall(drawCall:TiledObject, xTile:int, yTile:int):void
		{
			var beforeDraw:String = drawCall.properties.properties.hasOwnProperty("beforeDraw") ? drawCall.properties.properties.beforeDraw : "";
			trace(beforeDraw);
			var data:Array = beforeDraw.split("::");
			var key:String = data[0];
			var variable:String = data[1];
			var variableValue:String = CommandManager.getStateValue(variable);
			variableValue = variableValue == null ? "null" : variableValue;
			trace(key, variable, variableValue);
			for (var i:int = 2; i < data.length; i++)
			{
				var stateData:Array = String(data[i]).split("-");
				var testValue:String = stateData[0];
				var command:String = stateData[1];
				var commandValue:String = stateData[2];
				trace("Checking", variableValue, testValue, command, commandValue);
				if (variableValue == testValue)
				{
					trace("Equality");
					switch(command)
					{
						case "setmid":
							trace('setmid', commandValue, xTile, yTile);
							_map.setTileIndex(xTile, yTile, TileLayer.MID, int(commandValue));
							break;
					}
				}
			}
		}
		
		/**
		 * Forcibly creates the entity with the given name.
		 * @param	entityName The name of the entity object to find and create.
		 */
		public static function createEntity(entityName:String):void
		{
			var entityObj:TiledObject = _map.getObjectWithName(entityName);
			
			if (entityObj != null && entityObj.type == "entity" && EntityManager.isEntityAt(entityObj.x, entityObj.y) == false)
			{
				var region:TiledObject = _map.getRegionAt(entityObj.x, entityObj.y);
				var entity:Entity = EntityManager.createEntity(entityObj.properties.properties.type, entityObj.x, entityObj.y, Direction.DOWN, region != null ? region.name : "");
				if (entityObj.properties.properties.save == "false") entity.disableSaving();
				entity.setName(entityObj.name);
			}
		}
		
		/**
		 * Returns a spare tile from the _tilesPool vector if one exists. If not, creates a tile.
		 * @return
		 */
		private static function getTileFromPool():Tile
		{
			var tile:Tile;
			if (_tilesPool.length > 0)
			{
				tile = _tilesPool[0];
				_tilesPool.splice(0, 1);
			}
			else tile = new Tile();
			
			return tile;
		}
		
		/**
		 * Destroy all tiles including those in the tile pool, then dispose of the map and null all references.
		 */
		public static function destroy():void
		{
			var i:int;
			for (i = 0; i < _tiles.length; i++)
			{
				GameManager.RENDERER.removeChildFrom(_tiles[i], _tiles[i].TILE_TYPE);
				_tiles[i].destroy();
				_tiles[i] = null;
			}
			_tiles = null;
			for (i = 0; i < _tilesPool.length; i++)
			{
				_tilesPool[i].destroy();
				_tilesPool[i] = null;
			}
			_tilesPool = null;
			
			_map.destroy();
			_map = null;
			
			_previousCenteredXTile = _previousCenteredYTile = _centeredXTile = _centeredYTile = -1;
			_mapType = null;
		}
		
		/**
		 * Creates a copy of the MapType being created by the MapManager.
		 */
		private static function getMapReference():void
		{
			switch (_mapType)
			{
			case MapType.OVERWORLD: 
				_map = new MapOVERWORLD();
				break;
			case MapType.INN:
				_map = new MapINN();
				break;
			default: 
				throw(new Error("Unknown MapType '" + _mapType + "'."));
				break;
			}
		}
		
		/**
		 * Retrieves the tile index of the corresponding x- and y-tile coordinates on the specified TileLayer.
		 * @param	xTile The x-coordinate of the tile.
		 * @param	yTile The y-coordinate of the tile.
		 * @param	tileLayer The layer to retrieve the index from.
		 * @return The tile index pointing to a particular tile in the tileset.
		 */
		public static function getTileIndex(xTile:int, yTile:int, tileLayer:String):int
		{
			return _map.getTileIndex(xTile, yTile, tileLayer);
		}
		
		/**
		 * Updates the centered x- and y-coordinates of the map.
		 * @param	xTile The new x-coordinate (in tiles.)
		 * @param	yTile The new y-coordinate (in tiles.)
		 */
		public static function updateCenteredTileCoordinates(xTile:int, yTile:int):void
		{
			_previousCenteredXTile = _centeredXTile;
			_previousCenteredYTile = _centeredYTile;
			
			_centeredXTile = xTile;
			_centeredYTile = yTile;
		}
		
		/**
		 * Reduces the current spawn count of the region with the given name.
		 * @param	regionName The region to reduce the spawn count of.
		 * @param	change The amount to change the spawn count by.
		 */
		public static function changeRegionSpawnCount(regionName:String, change:int):void
		{
			if (!_map) return;
			
			_map.changeRegionSpawnCount(regionName, change);
		}
		
		/**
		 * Updates all the regions, checking for new spawns.
		 * @param	timeDelta The time elapsed since the last update call.
		 * @param	spawnInitial True if the initial amount of entities should be spawned, false if not.
		 */
		public static function updateRegions(timeDelta:int = 5):void
		{
			if (!_map) return;
			
			_map.updateRegions(timeDelta);
		}
		
		/**
		 * Finds the region the player is currently in.
		 * @return The current region object.
		 */
		public static function getCurrentRegion():TiledObject
		{
			if (!_map) return null;
			else return _map.getCurrentRegion();
		}
		
		/**
		 * Retrieves the region with the given name.
		 * @param	regionName The name of the region to find.
		 * @return A region with a matching name or, if one was not found, null.
		 */
		public static function getRegionFromName(regionName:String):TiledObject
		{
			if (!_map) return null;
			else return _map.getRegionFromName(regionName);
		}
		
		/**
		 * Provides the currently centered x-coordinate of the centered tile.
		 */
		public static function get CENTERED_X_TILE():int
		{
			return _centeredXTile;
		}
		
		/**
		 * Provides the currently centered y-coordinate of the centered tile.
		 */
		public static function get CENTERED_Y_TILE():int
		{
			return _centeredYTile;
		}
		
		/**
		 * Provides the currently loaded TiledMap instance.
		 */
		public static function get MAP():TiledMap
		{
			if (!_map) return null;
			else return _map.MAP;
		}
		
		/**
		 * Provides the current number of tiles on screen.
		 */
		public static function get NUMBER_OF_TILES():int
		{
			return _tiles != null ? _tiles.length : 0;
		}
		
		/**
		 * Provides the current number of tiles in the pool.
		 */
		public static function get NUMBER_OF_POOLED_TILES():int
		{
			return _tilesPool != null ? _tilesPool.length : 0;
		}
		
		/**
		 * Returns the last y-coordinate the player was at, before their current coordinate.
		 */
		public static function get PREVIOUS_Y_TILE():int
		{
			return _previousCenteredYTile;
		}
		
		/**
		 * Returns the last x-coordinate the player was at, before their current coordinate.
		 */
		public static function get PREVIOUS_X_TILE():int
		{
			return _previousCenteredXTile;
		}
		
		/**
		 * Returns the current MapType.
		 */
		public static function get MAP_TYPE():String
		{
			return _mapType;
		}
		
		/**
		 * Returns the tile that should be used when draw calls are outside of the map's bounds.
		 */
		public static function get PADDING_TILE():int
		{
			return _map.PADDING_TILE;
		}
		
		/**
		 * Returns the currently loaded map's Day/Night enabled state. If false, the overlay will be hidden.
		 */
		public static function get DAY_NIGHT():Boolean
		{
			return _map.DAY_NIGHT;
		}
	
	}

}