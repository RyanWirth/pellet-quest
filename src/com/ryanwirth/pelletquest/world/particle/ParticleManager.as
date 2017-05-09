package com.ryanwirth.pelletquest.world.particle
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.tile.TileType;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ParticleManager
	{
		
		public function ParticleManager()
		{
		
		}
		
		public static function createPopupText(x:int, y:int, text:String = "+100", duration:Number = 3):void
		{
			var tf:TextField = new TextField(GameManager.stageWidth, 16, text, "GoodNeighbors", 16, 0xFFFFFF);
			tf.autoSize = TextFieldAutoSize.HORIZONTAL;
			tf.x = x + (Math.random() * 64 - 32);
			tf.y = y + (Math.random() * 64 - 32);
			
			GameManager.RENDERER.addChildTo(tf, TileType.HUD);
			
			TweenMax.to(tf, duration, {alpha: 0, ease: Linear.easeIn, y: tf.y - tf.height * 2, onComplete: tf.removeFromParent, onCompleteParams: [true]});
		}
		
		/**
		 * Takes the provided entity and renders it into pixels, then animates the pixels outwards in an explosion-type effect.
		 * @param	entity The entity to explode.
		 * @param	yOffset The yOffset property of the entity for vertical alignment.
		 */
		public static function createEntityExplosion(entity:Entity, yOffset:int = 0):void
		{
			var prevX:int = entity.x;
			var prevY:int = entity.y;
			var startY:int = entity.y + (MapManager.TILE_SIZE - entity.height) + yOffset;
			
			var renderTexture:RenderTexture = new RenderTexture(entity.width, entity.height, false);
			entity.x = 0;
			entity.y = 64 - MapManager.TILE_SIZE - yOffset;
			renderTexture.draw(entity);
			
			entity.x = prevX;
			entity.y = prevY;
			
			var region:Rectangle = new Rectangle(0, 0, 2, 2);
			var newY:int;
			var newX:int;
			
			for (var i:int = 0 + 8; i < 32 - 8; i += 4)
			{
				for (var j:int = 0 + 16; j < 64 - 16; j += 4)
				{
					region.x = i;
					region.y = j;
					
					var particle:Image = new Image(Texture.fromTexture(renderTexture, region));
					particle.smoothing = TextureSmoothing.NONE;
					particle.x = i + prevX;
					particle.y = j + startY;
					
					newX = (i - 16) * (Math.random() * 4 + 1) + particle.x;
					newY = (j - 32) * (Math.random() * 4 + 1) + particle.y;
					
					TweenMax.to(particle, Math.random() * 1, {x: newX, y: newY, onComplete: TweenMax.to, onCompleteParams: [particle, (Math.random() * 2) + 1, {alpha: 0, onComplete: particle.removeFromParent, onCompleteParams: [true]}]});
					
					GameManager.RENDERER.addChildTo(particle, TileType.ENTITIES);
				}
			}
		}
	
	}

}