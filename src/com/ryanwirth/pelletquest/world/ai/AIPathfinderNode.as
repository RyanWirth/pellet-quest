package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.map.MapManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIPathfinderNode
	{
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var x:Number;
		public var y:Number;
		public var parentNode:AIPathfinderNode;
		public var traversable:Boolean = true;
		
		public function AIPathfinderNode(xTile:int, yTile:int, _parentNode:AIPathfinderNode = null)
		{
			x = xTile;
			y = yTile;
			parentNode = _parentNode;
		}
		
		public function toString():String
		{
			return "{x:" + x + ", y:" + y + "}";
		}
	
	}

}