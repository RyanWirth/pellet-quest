package com.ryanwirth.pelletquest.world.map
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.SpawnManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import com.ryanwirth.pelletquest.world.tile.TileLayer;
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledReader;
	import io.arkeus.tiled.TiledTileLayer;
	import io.arkeus.tiled.TiledTileset;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Map
	{
		private var _map:TiledMap;
		
		private var _tileset:TiledTileset;
		
		// Layers that contain the map data.
		private var _objectsLayer:TiledObjectLayer;
		private var _regionsLayer:TiledObjectLayer;
		private var _topLayer:TiledTileLayer;
		private var _top2Layer:TiledTileLayer;
		private var _coinsLayer:TiledTileLayer;
		private var _mid2Layer:TiledTileLayer;
		private var _midLayer:TiledTileLayer;
		private var _botLayer:TiledTileLayer;
		private var _firstGID:int = 0;
		private var _paddingTile:int = -1;
		
		private var _tilesetTiles:Object;
		private var _regionsLayerObjects:Vector.<TiledObject>;
		private var _topLayerData:Vector.<Vector.<uint>>;
		private var _top2LayerData:Vector.<Vector.<uint>>;
		private var _coinsLayerData:Vector.<Vector.<uint>>;
		private var _botLayerData:Vector.<Vector.<uint>>;
		private var _mid2LayerData:Vector.<Vector.<uint>>;
		private var _midLayerData:Vector.<Vector.<uint>>;
		private var _objectsLayerObjects:Vector.<TiledObject>;
		
		private var _dayNight:Boolean = true;
		
		/**
		 * The base class of maps which provides access to their embedded TMX file class.
		 * @param	world The reference to the embedded asset of the extending map.
		 */
		public function Map(world:Class)
		{
			_map = TiledReader.loadFromEmbedded(world);
			
			_dayNight = _map.properties.properties.hasOwnProperty("dayNight") ? (_map.properties.properties.dayNight == "false" ? false : true) : true;
			
			_tileset = _map.tilesets.getTilesetByName("tileset");
			_tilesetTiles = _tileset.tiles;
			_firstGID = _tileset.firstGid;
			_paddingTile = _map.properties.properties.hasOwnProperty("paddingTile") ? _map.properties.properties.paddingTile : -1;
			
			// Sort the layers within the map.
			var _layers:Vector.<TiledLayer> = _map.layers.getAllLayers();
			var i:int;
			var l:int;
			for (i = 0; i < _layers.length; i++)
			{
				switch (_layers[i].name)
				{
				case "top": 
					_topLayer = _layers[i] as TiledTileLayer;
					_topLayerData = _topLayer.data;
					break;
				case "top2": 
					_top2Layer = _layers[i] as TiledTileLayer;
					_top2LayerData = _top2Layer.data;
					break;
				case "coins": 
					_coinsLayer = _layers[i] as TiledTileLayer;
					_coinsLayerData = _coinsLayer.data;
					break;
				case "mid2": 
					_mid2Layer = _layers[i] as TiledTileLayer;
					_mid2LayerData = _mid2Layer.data;
					break;
				case "mid": 
					_midLayer = _layers[i] as TiledTileLayer;
					_midLayerData = _midLayer.data;
					break;
				case "map": 
					_botLayer = _layers[i] as TiledTileLayer;
					_botLayerData = _botLayer.data;
					break;
				case "regions": 
					_regionsLayer = _layers[i] as TiledObjectLayer;
					_regionsLayerObjects = _regionsLayer.objects;
					break;
				case "objects": 
					_objectsLayer = _layers[i] as TiledObjectLayer;
					_objectsLayerObjects = _objectsLayer.objects;
					break;
				}
			}
			
			if (_regionsLayer)
			{
				// Initialize all of the regions in the map by resizing them and setting up spawn properties.
				var region:TiledObject;
				for (i = 0, l = _regionsLayerObjects.length; i < l; i++)
				{
					// Turn the region pixel coordinates into tile coordinates
					region = _regionsLayerObjects[i];
					region.x /= 32;
					region.y /= 32;
					region.width /= 32;
					region.height /= 32;
					region.properties.properties.spawnCur = 0;
					region.properties.properties.spawnCurTime = int(region.properties.properties.spawnTime);
				}
			}
			
			if (_objectsLayer)
			{
				// Initialize all of the entities of the map.
				var object:TiledObject;
				for (i = 0, l = _objectsLayerObjects.length; i < l; i++)
				{
					// Turn the entity's pixel coordinates into tile coordinates
					object = _objectsLayerObjects[i];
					object.x /= 32;
					object.y /= 32;
				}
			}
		}
		
		/**
		 * Checks to see if the given entity is on an object.
		 * @param	entity The entity to check.
		 * @return True if the entity is on something, false if not.
		 */
		public function checkForObjects(entity:Entity):Boolean
		{
			var object:TiledObject;
			for (var i:int = 0, l:int = _objectsLayerObjects.length; i < l; i++)
			{
				object = _objectsLayerObjects[i];
				if (object.type == "script" && object.x == entity.X_TILE && object.y == entity.Y_TILE)
				{
					CommandManager.decodeCommandString(entity, object.properties.properties.onWalk);
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Finds and returns the object with a matching name property.
		 * @param	name The name of the TiledObject to find.
		 * @return The matching TiledObject.
		 */
		public function getObjectWithName(name:String):TiledObject
		{
			for (var i:int = 0, l:int = _objectsLayerObjects.length; i < l; i++)
			{
				if (_objectsLayerObjects[i].name == name) return _objectsLayerObjects[i];
			}
			
			return null;
		}
		
		/**
		 * Gets the specified property from an object whose name matches the given objectName.
		 * @param	propertyName The name of the property to get.
		 * @param	objectName The name of the object to get.
		 * @return The value of the property.
		 */
		public function getObjectProperty(propertyName:String, objectName:String):String
		{
			var object:TiledObject;
			for (var i:int = 0, l:int = _objectsLayerObjects.length; i < l; i++)
			{
				object = _objectsLayerObjects[i];
				if (object.name == objectName) return object.properties.properties[propertyName];
			}
			
			return "";
		}
		
		/**
		 * Iterates through all of the regions in the map and ticks them down by the timeDelta. If their spawnTime is up, reset it and spawn a new entity within the region.
		 * @param	timeDelta The time elapsed since the last update.
		 */
		public function updateRegions(timeDelta:int = 5):void
		{
			var region:TiledObject;
			for (var i:int = 0, l:int = _regionsLayerObjects.length; i < l; i++)
			{
				region = _regionsLayerObjects[i];
				
				region.properties.properties.spawnCurTime -= timeDelta;
				
				if (region.properties.properties.spawnCurTime <= 0)
				{
					SpawnManager.spawnEntityInRegion(region);
					region.properties.properties.spawnCurTime = int(region.properties.properties.spawnTime);
				}
			}
		}
		
		/**
		 * Reduces the spawnCur property (that is, how many entities are currently from the region) of the region with the given regionName.
		 * @param	regionName The region's name to reduce the spawn count.
		 * @param	change The amount to change the spawn count by.
		 */
		public function changeRegionSpawnCount(regionName:String, change:int):void
		{
			var region:TiledObject = getRegionFromName(regionName);
			region.properties.properties.spawnCur = int(region.properties.properties.spawnCur) + change;
		}
		
		/**
		 * Finds a region with a name matching the one provided.
		 * @param	regionName The name of the region to find.
		 * @return	The found region.
		 */
		public function getRegionFromName(regionName:String):TiledObject
		{
			for (var i:int = 0, l:int = _regionsLayerObjects.length; i < l; i++)
			{
				if (_regionsLayerObjects[i].name == regionName) return _regionsLayerObjects[i];
			}
			
			return null;
		}
		
		/**
		 * Retrieves the tile index of the corresponding x- and y-tile coordinates on the specified TileLayer.
		 * @param	xTile The x-coordinate of the tile.
		 * @param	yTile The y-coordinate of the tile.
		 * @param	tileLayer The layer to retrieve the index from.
		 * @return The tile index pointing to a particular tile in the tileset.
		 */
		public function getTileIndex(xTile:int, yTile:int, tileLayer:String):int
		{
			if (yTile < 0 || xTile < 0 || yTile >= _map.height || xTile >= _map.width) return -1;
			
			switch (tileLayer)
			{
			case TileLayer.BOT: 
				return _botLayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			case TileLayer.MID: 
				return _midLayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			case TileLayer.MID2: 
				return _mid2LayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			case TileLayer.COINS: 
				return _coinsLayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			case TileLayer.TOP: 
				return _topLayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			case TileLayer.TOP2: 
				return _top2LayerData[int(yTile)][int(xTile)] - _firstGID;
				break;
			default: 
				throw(new Error("Map: Unknown TileLayer '" + tileLayer + "'."));
				break;
			}
			
			return -1;
		}
		
		/**
		 * Changes the tile index at the given x- and y-coordinates on the specified layer.
		 * @param	xTile The x-coordinate of the tile to change.
		 * @param	yTile The y-coordinate of the tile to change.
		 * @param	tileLayer The layer upon which to change the tile value.
		 * @param	value The new tile index.
		 */
		public function setTileIndex(xTile:int, yTile:int, tileLayer:String, value:int):void
		{
			if (yTile < 0 || xTile < 0 || yTile >= _map.height || xTile >= _map.width) return;
			
			switch (tileLayer)
			{
			case TileLayer.BOT: 
				_botLayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			case TileLayer.MID: 
				_midLayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			case TileLayer.MID2: 
				_mid2LayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			case TileLayer.COINS: 
				_coinsLayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			case TileLayer.TOP: 
				_topLayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			case TileLayer.TOP2: 
				_top2LayerData[int(yTile)][int(xTile)] = value + _firstGID;
				break;
			default: 
				throw(new Error("Map: Unknown TileLayer '" + tileLayer + "'."));
				break;
			}
		}
		
		/**
		 * Finds the object that exists at the given x- and y-coordinates.
		 * @param	xTile The x-coordinate to look at.
		 * @param	yTile The y-coordinate to look at.
		 * @return The object at the provided coordinates. If no such object exists, returns null.
		 */
		public function getObjectAt(xTile:int, yTile:int):TiledObject
		{
			var object:TiledObject;
			for (var i:int = 0, l:int = _objectsLayerObjects.length; i < l; i++)
			{
				object = _objectsLayerObjects[i];
				if (object.x == xTile && object.y == yTile) return object;
			}
			
			return null;
		}
		
		/**
		 * Looks up the value of the given propertyName of the tile at the provided coordinates and tile layer.
		 * @param	xTile The x-coordinate of the tile.
		 * @param	yTile The y-coordinate of the tile.
		 * @param	tileLayer The layer to look up the tile.
		 * @param	propertyName The name of the property to look for.
		 * @return The value of propertyName within the tile's properties.
		 */
		public function getTileProperty(xTile:int, yTile:int, tileLayer:String, propertyName:String):String
		{
			var tileindex:int = getTileIndex(xTile, yTile, tileLayer);
			if (tileindex > 0 && _tilesetTiles[int(tileindex)] && _tilesetTiles[int(tileindex)].properties.properties.hasOwnProperty(propertyName)) return _tilesetTiles[int(tileindex)].properties.properties[propertyName];
			else return "";
		}
		
		/**
		 * Finds the region the player is currently in.
		 * @return
		 */
		public function getCurrentRegion():TiledObject
		{
			return getRegionAt(PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
		}
		
		/**
		 * Finds the region that bounds the given x- and y-coordinates.
		 * @param	xTile The x-coordinate within a region.
		 * @param	yTile The y-coordinate within a region.
		 * @return The region the coordinates reside within.
		 */
		public function getRegionAt(xTile:int, yTile:int):TiledObject
		{
			var object:TiledObject;
			for (var i:int = 0, l:int = _regionsLayerObjects.length; i < l; i++)
			{
				object = _regionsLayerObjects[i];
				if (xTile >= object.x && xTile <= object.x + object.width && yTile >= object.y && yTile <= object.y + object.height) return object;
			}
			
			return null;
		}
		
		/**
		 * Fully disposes of the Map instance by cleaning up the TiledMap, disposing of TiledLayers, and nulling their references.
		 */
		public function destroy():void
		{
			_map.destroy();
			_map = null;
			
			_tilesetTiles = null;
			_regionsLayerObjects = null;
			_botLayerData = null;
			_midLayerData = null;
			_mid2LayerData = null;
			_topLayerData = null;
			_top2LayerData = null;
			_coinsLayerData = null;
			_objectsLayerObjects = null;
			
			_top2Layer.destroy();
			_botLayer.destroy();
			_mid2Layer.destroy();
			_midLayer.destroy();
			_coinsLayer.destroy();
			_topLayer.destroy();
			_regionsLayer.destroy();
			_objectsLayer.destroy();
			
			_regionsLayer = _objectsLayer = null;
			_botLayer = _mid2Layer = _top2Layer = _midLayer = _coinsLayer = _topLayer = null;
		}
		
		/**
		 * Provides access to the TiledMap instance.
		 */
		public function get MAP():TiledMap
		{
			return _map;
		}
		
		/**
		 * Returns the tile that should be used when draw calls are outside of the map's bounds.
		 */
		public function get PADDING_TILE():int
		{
			return _paddingTile;
		}
		
		/**
		 * Returns the Day/Night overlay state for this Map. If true, the Day/Night overlay will be visible. If false, it wil be hidden.
		 */
		public function get DAY_NIGHT():Boolean
		{
			return _dayNight;
		}
	
	}

}