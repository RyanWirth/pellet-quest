package com.ryanwirth.pelletquest.world.map
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class MapOVERWORLD extends Map
	{
		[Embed(source = "assets/OVERWORLD.tmx", mimeType = "application/octet-stream")]
		private static const WORLD:Class;
		
		public function MapOVERWORLD()
		{
			super(WORLD);
		}
	
	}

}