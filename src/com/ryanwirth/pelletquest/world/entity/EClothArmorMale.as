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
	public class EClothArmorMale extends Entity
	{
		[Embed(source = "assets/EMale.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EMale.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EClothArmorMale(xTile:int, yTile:int)
		{
			super(atlas, EntityType.CLOTH_ARMOR_MALE, xTile, yTile, Direction.DOWN, AnimationType.STAND, 16, WalkSpeed.NORMAL, 9, AIType.NONE, [EntityPartType.SHOES_BROWN, EntityPartType.PANTS_GREEN, EntityPartType.ARMOR_CLOTH, EntityPartType.HAIR_BLOND]);
		}
	
	}

}