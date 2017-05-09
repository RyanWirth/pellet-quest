package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.AnimationType;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class TurnCommand extends Command
	{
		private var _direction:String;
		
		public function TurnCommand(direction:String) 
		{
			_direction = direction;
			
			super(CommandType.TURN);
		}
		
		override public function execute(entity:Entity):void
		{
			entity.animate(AnimationType.STAND, _direction);
			
			CommandManager.nextCommand(entity);
		}
		
	}

}