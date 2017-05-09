package com.ryanwirth.pelletquest.world.entity
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.ai.AI;
	import com.ryanwirth.pelletquest.world.ai.DistanceAlgorithmType;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import io.arkeus.tiled.TiledObject;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class SpawnManager
	{
		
		public function SpawnManager()
		{
		
		}
		
		/**
		 * Begins the timer (5 second intervals) to check for region spawns and creates the initial amount of entities in the player's current region.
		 */
		public static function startTimer():void
		{
			checkTimer();
			
			// Start the process by spawning the current region's initial amount
			var region:TiledObject = MapManager.getCurrentRegion();
			if (region && SaveManager.SAVE.NEW_SAVE)
			{
				var spawnInitial:int = int(region.properties.properties.spawnInitial);
				for (var i:int = 0; i < spawnInitial; i++) spawnEntityInRegion(region, true);
			}
		}
		
		private static function checkTimer():void
		{
			MapManager.updateRegions(5);
			
			TweenMax.delayedCall(5, checkTimer);
		}
		
		public static function stopTimer():void
		{
			TweenMax.killDelayedCallsTo(checkTimer);
		}
		
		public static function spawnEntityInRegion(region:TiledObject, canBeOnScreen:Boolean = false):void
		{
			if (region == null || region.type != "region") throw(new Error("SpawnManager: Attempted spawn on non-region " + region + "."));
			
			var hour:int = UIManager.DAY_NIGHT_CYCLE ? UIManager.DAY_NIGHT_CYCLE.HOUR : 8;
			var maxSpawns:int = (hour >= 20 || hour < 7) ? int(region.properties.properties.spawnMaxNight) : int(region.properties.properties.spawnMaxDay);
			var curSpawns:int = int(region.properties.properties.spawnCur);
			
			// There are already enough entities within the region.
			if (curSpawns >= maxSpawns) return;
			
			// Choose an entity type.
			var possibleEntityTypes:Array = String(region.properties.properties.spawn).split(",");
			var entityType:String = possibleEntityTypes[Math.floor(Math.random() * possibleEntityTypes.length)];
			
			// Choose a location to spawn.
			var xTile:int = 0;
			var yTile:int = 0;
			var attempts:int = 0;
			var distance:Number = 0;
			do
			{
				// If we try to place the entity more than 10 times and fail, just stop.
				if (attempts >= 10) return;
				attempts++;
				
				xTile = Math.floor(Math.random() * region.width) + region.x;
				yTile = Math.floor(Math.random() * region.height) + region.y;
				
				distance = AI.findDistanceToPlayer(null, DistanceAlgorithmType.EUCLIDIAN, xTile, yTile);
				
			} while (!MapManager.isTileWalkable(xTile, yTile, true) || (!canBeOnScreen ? MapManager.doesTileExist(xTile, yTile) : false) || distance >= GameManager.MAXIMUM_SPAWN_DISTANCE || (canBeOnScreen ? distance < 5 : false));
			
			trace("SpawnManager: Spawned " + entityType + " in " + region.name + " at " + xTile + "x" + yTile + ".");
			
			var entity:Entity = EntityManager.createEntity(entityType, xTile, yTile);
			entity.setFromRegion(region.name);
			
			// Increment the current spawn count.
			MapManager.changeRegionSpawnCount(region.name, 1);
		}
	
	}

}