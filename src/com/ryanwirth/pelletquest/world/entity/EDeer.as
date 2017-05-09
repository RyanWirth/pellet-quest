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
	public class EDeer extends Entity
	{
		[Embed(source = "assets/EDeer.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EDeer.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EDeer(xTile:int, yTile:int)
		{
			super(atlas, EntityType.DEER, xTile, yTile, Direction.DOWN, AnimationType.STATIC, 8, WalkSpeed.ZERO, 6, AIType.NONE, null, 0, false, false);
			
			ANIMATION.y = 0;
			
			resetFrameDurations(null);
			ANIMATION.addEventListener(Event.COMPLETE, resetFrameDurations);
		}
		
		private function resetFrameDurations(e:Event):void
		{
			ANIMATION.setFrameDuration(0, Math.random() * 10);
			ANIMATION.setFrameDuration(2, Math.random() * 10);
			ANIMATION.currentFrame = 0;
			ANIMATION.play();
		}
	
	}

}