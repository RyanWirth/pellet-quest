package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIGameHUD extends Sprite implements UIElement
	{
		[Embed(source = "assets/UIGameHUD.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/UIGameHUD.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public static var PADDING:int = 2;
		
		private var _hearts:Vector.<Image>;
		private var _coin:Image;
		private var _coinsText:TextField;
		private var _pauseButton:UIButtonPause;
		private var _powerUpText:TextField;
		
		private var _flashTimeoutUID:int = -1;
		
		public function UIGameHUD()
		{
			construct();
		}
		
		public function construct():void
		{
			_pauseButton = new UIButtonPause();
			_pauseButton.x = GameManager.stageWidth - _pauseButton.width - PADDING;
			_pauseButton.y = PADDING;
			this.addChild(_pauseButton);
			
			drawCoin();
			
			drawHearts(SaveManager.SAVE.LIVES);
		}
		
		public function hide():void
		{
			_pauseButton.visible = false;
			
			_coin.visible = false;
			
			if (_powerUpText) _powerUpText.visible = false;
			
			_coinsText.visible = false;
			
			for (var i:int = 0; i < _hearts.length; i++) _hearts[i].visible = false;
		}
		
		public function show(type:String = "all"):void
		{
			if (type == "hearts" || type == "all")
			{
				for (var i:int = 0; i < _hearts.length; i++)
				{
					_hearts[i].visible = true;
				}
			}
			
			if (type == "coins" || type == "all")
			{
				_coinsText.visible = true;
				_coin.visible = true;
			} 
			
			if (type == "pausebutton" || type == "all")
			{
				_pauseButton.visible = true;
			}
			
			if (type == "poweruptext" || type == "all")
			{
				if (_powerUpText) _powerUpText.visible = true;
			}
		}
		
		/**
		 * Called when the game's scale has been changed. Recenters the Power-Up! text, aligns the coin and heart readouts, and aligns the pause button to the right side.
		 */
		public function resizeHUD():void
		{
			_pauseButton.x = GameManager.stageWidth - _pauseButton.width - PADDING;
			
			drawCoin();
			drawHearts(SaveManager.SAVE.LIVES);
			
			updatePowerUpText();
		}
		
		/**
		 * If the power up is currently on, returns true. If not, returns false.
		 */
		public function get POWER_UP_ON():Boolean
		{
			return _powerUpText != null ? _powerUpText.visible : false;
		}
		
		/**
		 * Displays the POWER UP! text.
		 */
		public function powerUpOn():void
		{
			if (_powerUpText) return;
			
			_powerUpText = new TextField(GameManager.stageWidth, 24 * LocalizationManager.getFontSizeMultiplier(), LocalizationManager.parseLabel(Language.HUD_POWER_UP).toUpperCase(), LocalizationManager.getFontName(), 24 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
			_powerUpText.autoSize = TextFieldAutoSize.HORIZONTAL;
			_powerUpText.x = Math.round(GameManager.stageWidth / 2 - _powerUpText.width / 2);
			_powerUpText.y = Math.round(PADDING * 2 + _coinsText.height);
			
			this.addChild(_powerUpText);
		
		}
		
		/**
		 * Reparses the Power-Up! text due to a language change and recenters it on the HUD.
		 */
		public function updatePowerUpText():void
		{
			if (_powerUpText) 
			{
				_powerUpText.text = LocalizationManager.parseLabel(Language.HUD_POWER_UP).toUpperCase();
				_powerUpText.x = Math.round(GameManager.stageWidth / 2 - _powerUpText.width / 2);
			}
		}
		
		/**
		 * Alternates the visible property of the _powerupText between true and false.
		 */
		public function flashPowerUpText():void
		{
			if (!_powerUpText) 
			{
				powerUpOn();
				return;
			}
			
			_powerUpText.visible = !_powerUpText.visible;
		
		}
		
		/**
		 * Removes the POWER UP! text.
		 */
		public function powerUpOff():void
		{
			if (!_powerUpText) return;
			
			this.removeChild(_powerUpText, true);
			_powerUpText = null;
		
		}
		
		/**
		 * Redraws the coin counter.
		 */
		public function updateCoinCount():void
		{
			drawCoin();
		}
		
		/**
		 * Destroys the coin counter.
		 */
		private function destroyCoin():void
		{
			if (_coin)
			{
				this.removeChild(_coin, true);
				_coin = null;
			}
			
			if (_coinsText)
			{
				this.removeChild(_coinsText, true);
				_coinsText = null;
			}
		
		}
		
		/**
		 * If the coin counter has not yet been created, creates it. Otherwise, simply updates the counter text and location on the screen.
		 */
		private function drawCoin():void
		{
			if (!_coin)
			{
				_coin = new Image(atlas.getTexture("coin"));
				_coin.smoothing = TextureSmoothing.NONE;
				this.addChild(_coin);
			}
			
			if (!_coinsText)
			{
				_coinsText = new TextField(GameManager.stageWidth, 16, LocalizationManager.formatNumber(SaveManager.SAVE.NUMBER_OF_POINTS), "GoodNeighbors", 16, 0xFFFFFF, true);
				_coinsText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				this.addChild(_coinsText);
			}
			else _coinsText.text = LocalizationManager.formatNumber(SaveManager.SAVE.NUMBER_OF_POINTS);
			
			_coinsText.y = PADDING - 1;
			_coinsText.x = Math.round(GameManager.stageWidth / 2 - (_coinsText.width + _coin.width) / 2) + _coin.width;
			_coinsText.touchable = false;
			
			_coin.x = _coinsText.x - _coin.width - PADDING;
			_coin.y = PADDING;
		}
		
		/**
		 * Draws the given number of hearts on the HUD.
		 * @param	heartNumber The number of hearts to draw.
		 */
		public function drawHearts(heartNumber:int = 3):void
		{
			destroyHearts();
			
			_hearts = new Vector.<Image>();
			
			for (var i:int = 0; i < heartNumber; i++)
			{
				var heart:Image = new Image(atlas.getTexture("heart"));
				
				heart.smoothing = TextureSmoothing.NONE;
				heart.y = PADDING;
				heart.x = PADDING + (heart.width + PADDING) * i;
				this.addChild(heart);
				
				_hearts.push(heart);
			}
		
		}
		
		/**
		 * Destroys all hearts on the HUD.
		 */
		private function destroyHearts():void
		{
			if (!_hearts) return;
			
			stopFlashingLastHeart();
			
			for (var i:int = 0; i < _hearts.length; i++)
			{
				this.removeChild(_hearts[i], true);
				_hearts[i] = null;
			}
			
			_hearts = null;
		
		}
		
		/**
		 * Destroys the in-game HUD.
		 */
		public function destroy():void
		{
			destroyHearts();
			destroyCoin();
			
			if (_pauseButton)
			{
				this.removeChild(_pauseButton, true);
				_pauseButton = null;
			}
		}
		
		/**
		 * Begins flashing the furthest right heart of the player.
		 */
		
		public function flashLastHeart():void
		{
			if (!_hearts) return;
			
			_flashTimeoutUID = setTimeout(toggleLastHeartVisibility, 250);
		}
		
		/**
		 * Stops the furthest right heart from flashing.
		 */
		public function stopFlashingLastHeart():void
		{
			if (_flashTimeoutUID == -1) return;
			
			clearTimeout(_flashTimeoutUID);
			_flashTimeoutUID = -1;
		}
		
		/**
		 * Alternates visible property of the furthest right heart on the HUD between true and false.
		 */
		private function toggleLastHeartVisibility():void
		{
			if (_hearts.length == 0) return;
			
			_hearts[_hearts.length - 1].visible = _hearts[_hearts.length - 1].visible ? false : true;
			
			_flashTimeoutUID = setTimeout(toggleLastHeartVisibility, 250);
		}
	}

}