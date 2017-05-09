package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import flash.text.TextFormat;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIScrollPopup extends Sprite implements UIElement
	{
		[Embed(source = "assets/UIScrollPopup.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/UIScrollPopup.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		private var _tiles:Vector.<Image>;
		private var _width:int;
		private var _height:int;
		private var _title:String;
		private var _titleColor:uint;
		private var _titleText:TextField;
		private var _bottomTitle:String;
		private var _bottomText:TextField;
		private var _content:String;
		private var _contentText:TextField;
		private var _tapCallback:Function;
		
		/**
		 * Constructs a scroll window with the given height and width (in tiles).
		 * @param	widthInTiles The width of the window in tiles (32px each).
		 * @param	heightInTiles The height of the window in tiles (32px each).
		 */
		public function UIScrollPopup(widthInTiles:int, heightInTiles:int, title:String = "New Window", bottomTitle:String = "Tap to Continue", content:String = "", tapCallback:Function = null, titleColor:uint = 0xFF8800)
		{
			_width = widthInTiles;
			_height = heightInTiles;
			_title = title;
			_titleColor = titleColor;
			_bottomTitle = bottomTitle;
			_content = content;
			_tapCallback = tapCallback;
			if (_width < 3 || _height < 3) trace("UIScrollPopup: Cannot create a window less than 3x3!");
			
			construct();
		}
		
		public function get TILE_WIDTH():int
		{
			return _width;
		}
		
		public function get TILE_HEIGHT():int
		{
			return _height;
		}
		
		public function updateTitle(title:String):void
		{
			if (title == null) title = _title;
			
			_title = title;
			
			if (_title == "")
			{
				if (_titleText) this.removeChild(_titleText, true);
				_titleText = null;
				flatten();
				return;
			}
			
			if (!_titleText)
			{
				_titleText = new TextField(_width * MapManager.TILE_SIZE, 12, LocalizationManager.parseLabel(_title), LocalizationManager.getFontName(), 12 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
				_titleText.hAlign = HAlign.LEFT;
				_titleText.color = _titleColor;
				_titleText.x = 6;
				_titleText.y = 8;
				this.addChild(_titleText);
			}
			else _titleText.text = LocalizationManager.parseLabel(_title);
			
			flatten();
		}
		
		public function updateBottomTitle(title:String):void
		{
			if (title == null) title = _bottomTitle;
			
			_bottomTitle = title;
			
			if (_bottomTitle == "")
			{
				if (_bottomText) this.removeChild(_bottomText, true);
				_bottomText = null;
				flatten();
				return;
			}
			
			if (!_bottomText)
			{
				_bottomText = new TextField(_width * MapManager.TILE_SIZE - 11, 8, LocalizationManager.parseLabel(_bottomTitle), LocalizationManager.getFontName(), 8 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
				_bottomText.color = 0xEEEEEE;
				_bottomText.hAlign = HAlign.CENTER;
				_bottomText.x = 4;
				_bottomText.y = Math.round(TILE_HEIGHT * MapManager.TILE_SIZE - MapManager.TILE_SIZE / 2 - _bottomText.height / 2 + 3);
				this.addChild(_bottomText);
			}
			else _bottomText.text = LocalizationManager.parseLabel(_bottomTitle);
			
			flatten();
		}
		
		public function updateContent(content:String):void
		{
			if (content == null) content = _content;
			
			_content = content;
			
			if (_content == "")
			{
				if (_contentText) this.removeChild(_contentText, true);
				_contentText = null;
				flatten();
				return;
			}
			
			if (!_contentText)
			{
				_contentText = new TextField(_width * MapManager.TILE_SIZE - 12, _height * MapManager.TILE_SIZE - 8, LocalizationManager.parseLabel(_content), LocalizationManager.getFontName(), 10 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
				_contentText.hAlign = HAlign.LEFT;
				_contentText.vAlign = VAlign.TOP;
				_contentText.y = MapManager.TILE_SIZE - 11;
				_contentText.x = 6;
				this.addChild(_contentText);
			}
			else _contentText.text = LocalizationManager.parseLabel(_content);
			
			flatten();
		}
		
		public function construct():void
		{
			_tiles = new Vector.<Image>();
			
			drawTexture("top_left", 0, 0);
			drawTexture("top_right", _width - 1, 0);
			
			for (var i:int = 0; i < _width; i++)
			{
				for (var j:int = 0; j < _height; j++)
				{
					if ((i == 0 || i == _width - 1) && (j == 0 || j == _height - 1)) continue;
					var textureName:String = "center";
					if (i == 0) textureName = "left";
					else if (i == _width - 1) textureName = "right";
					else if (j == 0) textureName = "top_center";
					else if (j == _height - 1) textureName = "bottom_center";
					else textureName = "center";
					
					drawTexture(textureName, i, j);
				}
			}
			
			drawTexture("bottom_left", 0, _height - 1);
			drawTexture("bottom_right", _width - 1, _height - 1);
			
			updateTitle(_title);
			updateBottomTitle(_bottomTitle);
			updateContent(_content);
			
			if (_tapCallback != null) this.addEventListener(TouchEvent.TOUCH, tap);
			
			this.flatten();
		}
		
		private function tap(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			if (!touch) return;
			
			if (_tapCallback != null) _tapCallback();
		}
		
		private function drawTexture(textureName:String, xLoc:int, yLoc:int):void
		{
			var image:Image = new Image(atlas.getTexture(textureName));
			image.smoothing = TextureSmoothing.NONE;
			image.x = xLoc * MapManager.TILE_SIZE;
			image.y = yLoc * MapManager.TILE_SIZE;
			this.addChild(image);
			_tiles.push(image);
		}
		
		public function destroy():void
		{
			this.unflatten();
			
			if (_bottomText) this.removeChild(_bottomText, true);
			if (_titleText) this.removeChild(_titleText, true);
			if (_contentText) this.removeChild(_contentText, true);
			
			_bottomText = _titleText = _contentText = null;
			
			_tapCallback = null;
			
			for (var i:int = 0; i < _tiles.length; i++) this.removeChild(_tiles[i], true);
			_tiles = null;
		}
	}

}