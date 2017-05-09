package com.ryanwirth.pelletquest.world.entity
{
	import com.ryanwirth.pelletquest.world.ai.AIType;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class EDoor1 extends Entity
	{
		[Embed(source = "assets/EDoor1.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/EDoor1.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function EDoor1(xTile:int, yTile:int)
		{
			super(atlas, EntityType.DOOR1, xTile, yTile, Direction.DOWN, AnimationType.STATIC, 16, WalkSpeed.ZERO, 6, AIType.NONE, null, 0, false, false);
			
			fixAnimation();
			ANIMATION.stop();
		}
		
		override protected function fixAnimation():void
		{
			ANIMATION.y = -MapManager.TILE_SIZE;
			ANIMATION.loop = false;
			ANIMATION.setFrameDuration(3, 1);
			ANIMATION.addEventListener(Event.COMPLETE, finishPlaying);
		}
		
		override public function play():void
		{
			if (ANIMATION.currentFrame == 5) ANIMATION.currentFrame = 1;
			else if (ANIMATION.currentFrame == 4) ANIMATION.currentFrame = 2;
			else if (ANIMATION.currentFrame == 3) ANIMATION.currentFrame = 3;
			
			ANIMATION.play();
		}
		
		private function finishPlaying(e:Event):void
		{
			ANIMATION.stop();
		}
	
	}

}