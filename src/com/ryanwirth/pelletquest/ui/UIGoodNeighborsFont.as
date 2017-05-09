package com.ryanwirth.pelletquest.ui
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIGoodNeighborsFont
	{
		[Embed(source = "assets/UIGoodNeighborsFont.xml", mimeType = "application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "assets/UIGoodNeighborsFont.png")]
		public static const FontTexture:Class;
		
		public static var texture:Texture = Texture.fromEmbeddedAsset(FontTexture);
		public static var xml:XML = XML(new FontXml());
		
		public function UIGoodNeighborsFont()
		{
			var font:BitmapFont = new BitmapFont(texture, xml);
			font.smoothing = TextureSmoothing.NONE;
			
			TextField.registerBitmapFont(font);
		}
	
	}

}