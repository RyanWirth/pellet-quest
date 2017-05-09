package com.ryanwirth.pelletquest.world.entity
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class PBlondHair extends EntityPart
	{
		[Embed(source = "assets/EMale.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/PBlondHair.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function PBlondHair(initialAnimationType:String, initialDirection:String, frameRate:Number)
		{
			super(atlas, initialAnimationType, initialDirection, frameRate);
		}
	
	}

}