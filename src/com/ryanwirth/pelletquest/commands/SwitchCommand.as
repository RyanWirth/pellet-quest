package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.AnimationType;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class SwitchCommand extends Command
	{
		private var _propertyName:String;
		private var _valueCommandPairs:Array;
		
		public function SwitchCommand(propertyName:String, valueCommandPairs:Array) 
		{
			_propertyName = propertyName;
			_valueCommandPairs = valueCommandPairs;
			
			super(CommandType.SWITCH);
		}
		
		override public function execute(entity:Entity):void
		{
			var propertyValue:String = CommandManager.getStateValue(_propertyName);
			trace("SWITCH:", _propertyName, propertyValue);
			var valueCommandPair:Array;
			var runCommand:String = "null";
			var onEntityObjectName:String = "";
			for (var i:int = 0; i < _valueCommandPairs.length; i++)
			{
				valueCommandPair = String(_valueCommandPairs[i]).split("-");
				
				if ((propertyValue == null && valueCommandPair[0] == "null") || (propertyValue != null && valueCommandPair[0] == propertyValue))
				{
					runCommand = valueCommandPair[1];
					onEntityObjectName = valueCommandPair[2];
				}
			}
			
			if (runCommand != "null")
			{
				CommandManager.decodeCommandString(entity, MapManager.getObjectProperty(runCommand, onEntityObjectName));
			}
			
			CommandManager.nextCommand(entity);
		}
		
	}

}