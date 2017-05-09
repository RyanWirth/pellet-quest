package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ControlsCommand extends Command
	{
		private var _on:Boolean;
		
		public function ControlsCommand(on:Boolean) 
		{
			_on = on;
			super(CommandType.CONTROLS);
		}
		
		override public function execute(entity:Entity):void
		{
			OptionsManager.setControls(_on);
			
			CommandManager.nextCommand(entity);
		}
		
	}

}