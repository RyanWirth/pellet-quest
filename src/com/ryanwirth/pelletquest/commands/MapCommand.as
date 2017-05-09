package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.WorldManager;
	import com.ryanwirth.pelletquest.ui.UIManager;

	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class MapCommand extends Command
	{
		private var _mapType:String;
		private var _xTile:int;
		private var _yTile:int;
		private var _direction:String;
		private var _moveOnCreation:Boolean;
		
		public function MapCommand(mapType:String, xTile:int, yTile:int, direction:String, moveOnCreation:Boolean) 
		{
			_mapType = mapType;
			_xTile = xTile;
			_yTile = yTile;
			_direction = direction;
			_moveOnCreation = moveOnCreation;
			
			super(CommandType.MAP);
		}
		
		override public function execute(entity:Entity):void
		{
			UIManager.fadeInOut(completeFade);
		}
		
		private function completeFade():void
		{
			WorldManager.reloadMap(_mapType, _xTile, _yTile, _direction, _moveOnCreation);
		}
		
	}

}