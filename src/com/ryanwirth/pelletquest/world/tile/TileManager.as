package com.ryanwirth.pelletquest.world.tile
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class TileManager
	{
		[Embed(source = "assets/tileset.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/tileset.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false, 1);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function TileManager()
		{
			throw(new Error("TileManager: Do not instantiate."));
		}
		
		/**
		 * Provides access to the TileManager's TextureAtlas.
		 */
		public static function get ATLAS():TextureAtlas
		{
			return atlas;
		}
	
	}

}