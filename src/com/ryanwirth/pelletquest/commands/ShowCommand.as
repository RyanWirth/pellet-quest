package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class ShowCommand extends Command
	{
		private var _object:String;
		
		public function ShowCommand(object:String) 
		{
			_object = object;
			
			super(CommandType.SHOW);
		}
		
		override public function execute(entity:Entity):void
		{
			switch(_object)
			{
				case "hud":
					if (UIManager.HUD) UIManager.HUD.show();
					break;
				case "hearts":
					if (UIManager.HUD) UIManager.HUD.show("hearts");
					break;
				case "coins":
					if (UIManager.HUD) UIManager.HUD.show("coins");
					break;
			}
			
			CommandManager.nextCommand(entity);
		}
		
	}

}