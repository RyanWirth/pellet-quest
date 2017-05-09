package com.ryanwirth.pelletquest.world
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Direction
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		public function Direction()
		{
		
		}
		
		/**
		 * Given a Direction, determines its cardinal opposite.
		 * @param	direction The direction in question.
		 * @return The opposite direction.
		 */
		public static function reverse(direction:String):String
		{
			if (direction == UP) return DOWN;
			else if (direction == DOWN) return UP;
			else if (direction == LEFT) return RIGHT;
			else if (direction == RIGHT) return LEFT;
			else throw(new Error("Direction: Unknown Direction '" + direction + "'."));
			
			return "";
		}
	
	}

}