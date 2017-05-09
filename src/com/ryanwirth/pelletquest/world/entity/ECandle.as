package com.ryanwirth.pelletquest.world.entity
{
	import com.ryanwirth.pelletquest.world.ai.AIType;
	import com.ryanwirth.pelletquest.world.Direction;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ECandle extends Entity
	{
		[Embed(source = "assets/ECandle.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/ECandle.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function ECandle(xTile:int, yTile:int)
		{
			super(atlas, EntityType.CANDLE, xTile, yTile, Direction.DOWN, AnimationType.STATIC, 8, WalkSpeed.ZERO, 6, AIType.NONE, null, 0, false, true);
		}
	
	}

}