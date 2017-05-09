package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIScrollSmall extends Sprite implements UIElement
	{
		[Embed(source = "assets/UIScrollSmall.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/UIScrollSmall.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		private var _tiles:Vector.<Image>;
		private var _width:int;
		private var _height:int;
		private var _title:String;
		private var _titleText:TextField;
		
		/**
		 * Constructs a scroll window with the given height and width (in tiles).
		 * @param	widthInTiles The width of the window in tiles (32px each).
		 * @param	heightInTiles The height of the window in tiles (32px each).
		 */
		public function UIScrollSmall(widthInTiles:int, heightInTiles:int, title:String = "New Window")
		{
			_width = widthInTiles;
			_height = heightInTiles;
			_title = title;
			if (_width < 3 || _height < 3) trace("UIScrollSmall: Cannot create a window less than 3x3!");
			
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
			
			if (!_titleText)
			{
				_titleText = new TextField(_width * MapManager.TILE_SIZE - 17, 20, LocalizationManager.parseLabel(_title), LocalizationManager.getFontName(), 20 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
				_titleText.x = 4;
				_titleText.hAlign = HAlign.CENTER;
				//_titleText.x = MapManager.TILE_SIZE;
				_titleText.y = MapManager.TILE_SIZE / 2 - _titleText.height / 2 - 7;
				this.addChild(_titleText);
			}
			else _titleText.text = LocalizationManager.parseLabel(_title);
			
			this.flatten();
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
			
			this.flatten();
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
			
			if (_titleText) this.removeChild(_titleText, true);
			_titleText = null;
			
			for (var i:int = 0; i < _tiles.length; i++) this.removeChild(_tiles[i], true);
			_tiles = null;
		}
	}

}