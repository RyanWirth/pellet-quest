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
	public class SetCommand extends Command
	{
		private var _propertyName:String;
		private var _propertyValue:String;
		
		public function SetCommand(propertyName:String, propertyValue:String) 
		{
			_propertyName = propertyName;
			_propertyValue = propertyValue
			
			super(CommandType.SET);
		}
		
		override public function execute(entity:Entity):void
		{
			CommandManager.setStateValue(_propertyName, _propertyValue);
			CommandManager.nextCommand(entity);
		}
		
	}

}