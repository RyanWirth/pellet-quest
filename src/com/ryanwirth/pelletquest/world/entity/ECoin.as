package com.ryanwirth.pelletquest.world.entity
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ECoin extends Entity
	{
		[Embed(source = "assets/ECoin.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/ECoin.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 32 / MapManager.TILE_SIZE);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function ECoin(xTile:int, yTile:int)
		{
			super(atlas, EntityType.COIN, xTile, yTile, Direction.DOWN, AnimationType.STATIC, 10);
			
			ANIMATION.advanceTime(Math.random() * 10);
		}
	
	}

}