package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.AnimationType;
	import com.ryanwirth.pelletquest.ui.UIIconManager;
	import com.ryanwirth.pelletquest.ui.IconType;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class CloseTipsCommand extends Command
	{
		public function CloseTipsCommand() 
		{
			super(CommandType.CLOSE_TIPS);
		}
		
		override public function execute(entity:Entity):void
		{
			UIIconManager.removeIconHolder(null, IconType.ICON_BLUE_FEATHER);
			
			CommandManager.nextCommand(entity);
		}
		
	}

}