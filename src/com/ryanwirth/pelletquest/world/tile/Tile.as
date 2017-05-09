package com.ryanwirth.pelletquest.world.tile
{
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.tile.TileLayer;
	import com.ryanwirth.pelletquest.world.tile.TileManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Tile extends Sprite
	{
		private var _xTile:int;
		private var _yTile:int;
		private var _tileType:String;
		
		private var _layer1:Image;
		private var _layer2:Image;
		private var _layer3:Image;
		
		public function Tile()
		{
		
		}
		
		/**
		 * Constructs up to three layers of the tile based on the specified tileType and adds them to this Tile instance.
		 * @param	xTile The x-coordinate to get the tile index from.
		 * @param	yTile The y-coordinate to get the tile index from.
		 * @param	tileType The type of tile to construct.
		 * @return	If any layers are on the Tile's display list, returns true. If not, returns false.
		 */
		public function drawTile(xTile:int, yTile:int, tileType:String):Boolean
		{
			if (_layer1) this.removeChild(_layer1);
			if (_layer2) this.removeChild(_layer2);
			if (_layer3) this.removeChild(_layer3);
			
			_xTile = xTile;
			_yTile = yTile;
			_tileType = tileType;
			
			if (tileType == TileType.BOTTOM)
			{
				copyPixels(TileLayer.BOT, 1);
				copyPixels(TileLayer.MID, 2);
				copyPixels(TileLayer.MID2, 3);
			}
			else if (tileType == TileType.TOP)
			{
				copyPixels(TileLayer.TOP, 1);
				copyPixels(TileLayer.TOP2, 2);
			}
			
			return (this.contains(_layer1) || this.contains(_layer2) || this.contains(_layer3));
		}
		
		/**
		 * Finds the tile index of the given tileLayer at this tile's x- and y-coordinates, fetches the texture from the TileManager ATLAS and adds the layer to this Tile instance.
		 * @param	tileLayer The layer to get the tile index from.
		 * @param	layerNumber The layer order number.
		 */
		private function copyPixels(tileLayer:String, layerNumber:int):void
		{
			var tileindex:int = MapManager.getTileIndex(_xTile, _yTile, tileLayer);
			if (tileindex < 0 && tileLayer != TileLayer.BOT) return;
			else if (tileindex < 0) tileindex = MapManager.PADDING_TILE == -1 ? 1434 + Math.floor(Math.random() * 3) : MapManager.PADDING_TILE;
			else if (tileindex == 2) return; // These are the invisible boundary tiles.
			
			var textureName:String = "tile" + tileindex;
			
			if (layerNumber == 1)
			{
				if (_layer1) _layer1.texture = TileManager.ATLAS.getTexture(textureName);
				else
				{
					_layer1 = new Image(TileManager.ATLAS.getTexture(textureName));
					_layer1.smoothing = TextureSmoothing.NONE;
				}
				this.addChild(_layer1);
			}
			else if (layerNumber == 2)
			{
				if (_layer2) _layer2.texture = TileManager.ATLAS.getTexture(textureName);
				else
				{
					_layer2 = new Image(TileManager.ATLAS.getTexture(textureName));
					_layer2.smoothing = TextureSmoothing.NONE;
				}
				this.addChild(_layer2);
			}
			else if (layerNumber == 3)
			{
				if (_layer3) _layer3.texture = TileManager.ATLAS.getTexture(textureName);
				else
				{
					_layer3 = new Image(TileManager.ATLAS.getTexture(textureName));
					_layer3.smoothing = TextureSmoothing.NONE;
				}
				this.addChild(_layer3);
			}
		}
		
		/**
		 * Fully disposes of all layers. Should only be called on a forced-removal - that is, when the World must be destroyed, not simply to pool this Tile.
		 */
		public function destroy():void
		{
			if (_layer1) this.removeChild(_layer1, true);
			if (_layer2) this.removeChild(_layer2, true);
			if (_layer3) this.removeChild(_layer3, true);
			_layer1 = _layer2 = _layer3 = null;
			dispose();
		}
		
		/**
		 * Provides access to the current x-coordinate represented by this Tile.
		 */
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		/**
		 * Provides access to the current y-coordinate represented by this Tile.
		 */
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		/**
		 * Provides access to the current Tile type represented by this Tile.
		 */
		public function get TILE_TYPE():String
		{
			return _tileType;
		}
	
	}

}