package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.ui.UIManager;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIButtonPause extends UIButton implements UIElement
	{
		[Embed(source = "assets/UIButtonPause.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/UIButtonPause.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		public function UIButtonPause(flattenCallback:Function = null)
		{
			super(atlas, UIManager.createMenu, [MenuType.PAUSE], flattenCallback);
		}
	}

}