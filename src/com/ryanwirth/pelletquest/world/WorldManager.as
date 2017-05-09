package com.ryanwirth.pelletquest.world
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.entity.EntityType;
	import com.ryanwirth.pelletquest.world.entity.SpawnManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.map.MapType;
	import com.ryanwirth.pelletquest.ui.UIManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class WorldManager
	{
		private static var _gameStarted:Boolean = false;
		
		public function WorldManager()
		{
		
		}
		
		/**
		 * Upon creation/initialization of Starling, startGame() is called where the map is created, the player placed, etc.
		 * @param	mapType If given, the MapType to load the player onto.
		 */
		public static function startGame(mapType:String = ""):void
		{
			if (GAME_STARTED) return;
			_gameStarted = true;
			
			// Draw the map and prepare for the game.
			MapManager.createMap(mapType == "" ? SaveManager.SAVE.MAP : mapType, SaveManager.SAVE.X_TILE, SaveManager.SAVE.Y_TILE);
			PlayerManager.prepareForGame();
			
			// Create and initialize the player.
			PlayerManager.setEntityAsPlayer(EntityManager.createEntity(EntityType.CLOTH_ARMOR_MALE, SaveManager.SAVE.X_TILE, SaveManager.SAVE.Y_TILE));
			
			// Decrypt any saved entity data.
			EntityManager.DECODE_ENTITIES(SaveManager.SAVE.ENTITY_DATA);
			
			// Start the SpawnManager
			SpawnManager.startTimer();
			
			// Fix entity layering
			GameManager.RENDERER.fixEntitiesLayering();
			
			// Update the Day/Night cycle state.
			UIManager.updateDayNightCycleState();
		}
		
		/**
		 * Switches the current map by updating the MapType, the player's x- and y-coordinates, and their starting direction.
		 * @param	mapType The new MapType.
		 * @param	xTile The starting x-coordinate.
		 * @param	yTile The starting y-coordinate.
		 * @param	direction The direction to face the player upon loading.
		 * @param	moveOnCreation If true, the Player will move in the given direction upon map creation. If false, the Player will simply stand still.
		 */
		public static function reloadMap(mapType:String, xTile:int, yTile:int, direction:String, moveOnCreation:Boolean):void
		{
			trace("MapManager: Reloading map", mapType, xTile, yTile, direction);
			
			// Destroy all the currently created entities in order to prevent them from being included in the save file.
			EntityManager.destroy();
			
			// Save the new direction and coordinates in the Player's current save file.
			SaveManager.SAVE.updateDirection(direction);
			SaveManager.SAVE.updateLocation(xTile, yTile);
			SaveManager.save();
			
			// Cleanup all of the component managers.
			endGame();
			
			// Begin the game with the new MapType.
			startGame(mapType);
			
			// If moveOnCreation is true, move the Player in the specified direction.
			if (moveOnCreation) EntityManager.moveEntity(PlayerManager.PLAYER, direction);
		}
		
		/**
		 * Cleans up all World assets including the map and entities.
		 */
		public static function endGame():void
		{
			if (!GAME_STARTED) return;
			_gameStarted = false;
			
			MapManager.destroy();
			PlayerManager.destroy();
			SpawnManager.stopTimer();
		}
		
		/**
		 * Updates the Map's display scaling by redrawing/removing excess tiles.
		 * @param	scale The new scale factor.
		 */
		public static function updateScale(scale:Number):void
		{
			if (!GAME_STARTED) return;
			
			MapManager.forceMapRedraw();
		}
		
		/**
		 * Returns true if the game is currently started and running, false if not.
		 */
		public static function get GAME_STARTED():Boolean
		{
			return _gameStarted;
		}
	
	}

}