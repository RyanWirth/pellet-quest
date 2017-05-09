package com.ryanwirth.pelletquest.world.entity
{
	import com.ryanwirth.pelletquest.world.ai.AIType;
	import com.ryanwirth.pelletquest.world.Direction;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ESkeleton extends Entity
	{
		[Embed(source = "assets/ESkeleton.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/ESkeleton.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function ESkeleton(xTile:int, yTile:int)
		{
			super(atlas, EntityType.SKELETON, xTile, yTile, Direction.DOWN, AnimationType.STAND, 10, WalkSpeed.SLOW, 9, AIType.SIMPLE, null, 5, true, true);
		}
	
	}

}