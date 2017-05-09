package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class HideCommand extends Command
	{
		private var _object:String;
		
		public function HideCommand(object:String) 
		{
			_object = object;
			
			super(CommandType.HIDE);
		}
		
		override public function execute(entity:Entity):void
		{
			switch(_object)
			{
				case "hud":
					if (UIManager.HUD) UIManager.HUD.hide();
					break;
			}
			
			CommandManager.nextCommand(entity);
		}
		
	}

}