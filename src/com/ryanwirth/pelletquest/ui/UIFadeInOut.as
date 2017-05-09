package com.ryanwirth.pelletquest.ui
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import starling.display.Image;
	import starling.textures.Texture;
	import com.greensock.easing.Linear;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIFadeInOut extends Image
	{
		private var _halfwayCallback:Function;
		private var _halfDuration:Number;
		
		public function UIFadeInOut(color:uint = 0x000000, halfDuration:Number = 0.5, halfwayCallback:Function = null)
		{
			super(Texture.fromColor(GameManager.stageWidth, GameManager.stageHeight, 0xFFFFFFFF));
			this.color = color;
			this.alpha = 0;
			
			_halfwayCallback = halfwayCallback;
			_halfDuration = halfDuration;
			
			this.touchable = false;
			
			fadeIn();
		}
		
		public function fadeIn():void
		{
			TweenMax.to(this, _halfDuration, { alpha:1, onComplete:midway, ease:Linear.easeNone } );
		}
		
		public function midway():void
		{
			if (_halfwayCallback != null) _halfwayCallback();
			_halfwayCallback = null;
			
			fadeOut();
		}
		
		public function fadeOut():void
		{
			TweenMax.to(this, _halfDuration, {alpha: 0, onComplete: this.removeFromParent, onCompleteParams: [true]});
		}
	
	}

}