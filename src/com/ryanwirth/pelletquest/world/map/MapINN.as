package com.ryanwirth.pelletquest.world.map
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class MapINN extends Map
	{
		[Embed(source = "assets/INN.tmx", mimeType = "application/octet-stream")]
		private static const WORLD:Class;
		
		public function MapINN()
		{
			super(WORLD);
		}
	
	}

}