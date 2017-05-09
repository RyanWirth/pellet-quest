package com.ryanwirth.pelletquest.world.entity
{
	import com.ryanwirth.pelletquest.GameManager;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class EntityPart extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var _frameRate:Number;
		private var _animationType:String;
		private var _direction:String;
		
		private var _animation:MovieClip;
		
		public function EntityPart(atlas:TextureAtlas, initialAnimationType:String, initialDirection:String, frameRate:Number)
		{
			_atlas = atlas;
			_frameRate = frameRate;
			
			updateAnimation(initialAnimationType, initialDirection);
		}
		
		public function setFrameRate(frameRate:Number):void
		{
			_frameRate = frameRate;
			
			if (_animation) _animation.fps = _frameRate;
		}
		
		public function pause():void
		{
			if (_animation) _animation.pause();
		}
		
		public function get texture():Texture
		{
			if (!_animation) return null;
			
			return _animation.getFrameTexture(_animation.currentFrame);
		}
		
		public function updateAnimation(animationType:String, direction:String):void
		{
			if (_animationType == animationType && _direction == direction) return;
			destroyAnimation();
			
			_animationType = animationType;
			_direction = direction;
			
			_animation = new MovieClip(_atlas.getTextures(animationType + "_" + direction), _frameRate);
			_animation.smoothing = TextureSmoothing.NONE;
			this.addChild(_animation);
			GameManager.GAME_JUGGLER.add(_animation);
		}
		
		private function destroyAnimation():void
		{
			if (_animation)
			{
				this.removeChild(_animation);
				GameManager.GAME_JUGGLER.remove(_animation);
				_animation.dispose();
				_animation = null;
			}
		}
		
		public function destroy():void
		{
			destroyAnimation();
			
			_atlas = null;
			dispose();
		}
	
	}

}