package com.ryanwirth.pelletquest.world
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.tile.TileType;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class WorldRenderer extends Sprite
	{
		private var _top:Sprite;
		private var _entities:Sprite;
		private var _bottom:Sprite;
		private var _hud:Sprite;
		
		private var _panning:Boolean = false;
		
		private var _blurFilter:BlurFilter;
		
		/**
		 * Simply a sprite container that holds all the different layers of the map.
		 * All creation logic is done in WorldManager.
		 */
		public function WorldRenderer()
		{
			_top = new Sprite();
			_entities = new Sprite();
			_bottom = new Sprite();
			_hud = new Sprite();
			
			_top.touchable = _entities.touchable = false;
			
			addChild(_bottom);
			addChild(_entities);
			addChild(_top);
			addChild(_hud);
		}
		
		public function get BOTTOM():Sprite
		{
			return _bottom;
		}
		
		public function destroy():void
		{
			removeChild(_bottom, true);
			removeChild(_top, true);
			removeChild(_entities, true);
			removeChild(_hud, true);
			
			_bottom = _top = _entities = _hud = null;
		}
		
		/**
		 * Centers the three sprites (_top, _entities, and _bottom) around specified tile coordinates.
		 * @param	xTile The center tile's x-coordinate.
		 * @param	yTile The center tile's y-coordinate.
		 */
		public function centerMap(xTile:int, yTile:int):void
		{
			if (!_top || !_entities || !_bottom) return;
			
			_top.x = _entities.x = _bottom.x = getMapXCoordinate(xTile);
			_top.y = _entities.y = _bottom.y = getMapYCoordinate(yTile);
		
		}
		
		/**
		 * Simple depth sorting of all the children within the _entities Sprite.
		 */
		public function fixEntitiesLayering():void
		{
			_entities.sortChildren(depthSort);
		}
		
		/**
		 * Adds the given DisplayObject to the indicated ChunkType, specifying the desired layer to have the DisplayObject added to.
		 * @param	displayObject The DisplayObject to add to the specified layer.
		 * @param	chunkType The ChunkType indicating which layer to add displayObject to.
		 */
		public function addChildTo(displayObject:DisplayObject, tileType:String):void
		{
			switch (tileType)
			{
			case TileType.TOP: 
				_top.addChild(displayObject);
				break;
			case TileType.BOTTOM: 
				_bottom.addChild(displayObject);
				break;
			case TileType.ENTITIES: 
				_entities.addChild(displayObject);
				break;
			case TileType.HUD: 
				_hud.addChild(displayObject);
				break;
			default: 
				throw(new Error("Unknown ChunkType '" + tileType + "'."));
				break;
			}
		}
		
		/**
		 * Removes the given DisplayObject from the specified ChunkType (layer).
		 * @param	displayObject The DisplayObject to be removed.
		 * @param	chunkType The ChunkType of the layer to remove displayObject from.
		 */
		public function removeChildFrom(displayObject:DisplayObject, tileType:String):void
		{
			switch (tileType)
			{
			case TileType.BOTTOM: 
				_bottom.removeChild(displayObject);
				break;
			case TileType.TOP: 
				_top.removeChild(displayObject);
				break;
			case TileType.ENTITIES: 
				_entities.removeChild(displayObject);
				break;
			case TileType.HUD: 
				_hud.removeChild(displayObject);
				break;
			default: 
				throw(new Error("Unknown ChunkType '" + tileType + "'."));
				break;
			}
		}
		
		/**
		 * Pans the map in the specified direction (by one tile.)
		 * @param	directionType
		 */
		public function pan(directionType:String, distanceMultplier:Number = 1):void
		{
			if (_panning) return;
			_panning = true;
			
			var newCenteredXTile:int = MapManager.CENTERED_X_TILE;
			var newCenteredYTile:int = MapManager.CENTERED_Y_TILE;
			
			switch (directionType)
			{
			case Direction.DOWN: 
				newCenteredYTile++;
				break;
			case Direction.LEFT: 
				newCenteredXTile--;
				break;
			case Direction.RIGHT: 
				newCenteredXTile++;
				break;
			case Direction.UP: 
				newCenteredYTile--;
				break;
			}
			
			var xCoordinate:int = getMapXCoordinate(newCenteredXTile);
			var yCoordinate:int = getMapYCoordinate(newCenteredYTile);
			
			MapManager.updateCenteredTileCoordinates(newCenteredXTile, newCenteredYTile);
			
			TweenMax.to(_top, 1 / PlayerManager.PLAYER.WALK_SPEED * distanceMultplier, {x: xCoordinate, y: yCoordinate, ease: Linear.easeNone, onUpdate: updatePan, onComplete: finishPan});
		}
		
		public function interruptPan():void
		{
			_panning = false;
			
			TweenMax.killTweensOf(_top);
		}
		
		/**
		 * Called when the WorldRenderer is panning the map. Used to eliminate seams appearing from non-rounded x- and y-coordinates.
		 */
		private function updatePan():void
		{
			_top.x = _entities.x = _bottom.x = _top.x;
			_top.y = _entities.y = _bottom.y = _top.y;
		}
		
		/**
		 * Called when the WorldRenderer has finished panning the map.
		 */
		private function finishPan():void
		{
			_panning = false;
			
			MapManager.checkForTileUpdates();
		}
		
		/**
		 * Returns the x-coordinate of the map sprites (_top, _entities, _bottom) if they exist.
		 */
		public function get MAP_X_COORDINATE():int
		{
			return _top.x;
		}
		
		/**
		 * Returns the y-coordinate of the map sprites (_top, _entities, _bottom) if they exist.
		 */
		public function get MAP_Y_COORDINATE():int
		{
			return _top.y;
		}
		
		/**
		 * Calculates the x-coordinate (in pixels) of the map given by an x-coordinate (in tiles) to be centered.
		 * @param	xTile The x-coordinate of the tile to be centered.
		 * @return The x-coordinate in pixels of the centered map.
		 */
		public function getMapXCoordinate(xTile:int):int
		{
			return (xTile) * -1 * MapManager.TILE_SIZE + GameManager.stageWidth * 0.5 - MapManager.TILE_SIZE * 0.5;
		}
		
		/**
		 * Calculates the y-coordinate (in pixels) of the map given a y-coordinate (in tiles) to be centered.
		 * @param	yTile The y-coordinate of the tile to be centered.
		 * @return The y-coordinate in pixels of the centered map.
		 */
		public function getMapYCoordinate(yTile:int):int
		{
			return (yTile) * -1 * MapManager.TILE_SIZE + GameManager.stageHeight * 0.5 - MapManager.TILE_SIZE * 0.5;
		}
		
		/**
		 * Flattens both the _top and _bottom sprites, but not the _entities sprite due to the fact that all moving entities must be seen immediately.
		 * Flattened sprites do not display changes within themselves until they are reflattened/unflattened.
		 */
		public function flattenSprites():void
		{
			_top.flatten(true);
			_bottom.flatten(true);
		}
		
		private function depthSort(do1:DisplayObject, do2:DisplayObject):int
		{
			if (do1.y < do2.y) return -1;
			else if (do1.y > do2.y) return 1;
			else return 0;
		}
	
	}

}