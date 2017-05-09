package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;

	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AnimateCommand extends Command
	{
		private var _entityName:String;
		private var _animationType:String;
		private var _direction:String;
		private var _play:Boolean;
		
		public function AnimateCommand(entityName:String, animationType:String, direction:String, play:Boolean) 
		{
			_entityName = entityName;
			_animationType = animationType;
			_direction = direction;
			_play = play;
			
			super(CommandType.ANIMATE);
		}
		
		override public function execute(entity:Entity):void
		{
			var _entity:Entity = EntityManager.getEntityByName(_entityName);
			if (_entity)
			{
				if (_entity.ANIMATION_TYPE == _animationType && _entity.DIRECTION == _direction && _play) _entity.play();
				else _entity.animate(_animationType, _direction, _play);
			}
			CommandManager.nextCommand(entity);
		}
		
	}

}