package com.ryanwirth.pelletquest.ui
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIPlayerHit extends Image
	{
		
		public function UIPlayerHit(color:uint = 0xFF0000)
		{
			super(Texture.fromColor(GameManager.stageWidth, GameManager.stageHeight, 0xFFFFFFFF));
			this.color = color;
			this.alpha = 0.25;
			
			fadeOut();
		}
		
		public function fadeOut():void
		{
			TweenMax.to(this, 0.5, {alpha: 0, onComplete: this.removeFromParent, onCompleteParams: [true]});
		}
	
	}

}