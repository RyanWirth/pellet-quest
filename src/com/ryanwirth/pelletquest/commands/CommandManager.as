package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class CommandManager 
	{
		private static var _states:Object;
		
		public function CommandManager() 
		{
			
		}
		
		/**
		 * Adds the given vector of Command objects to the entity's command vector. If the entity is not currently executing any command, starts the execution process.
		 * @param	entity The entity to assign the commands to.
		 * @param	commands The vector of Command objects.
		 */
		public static function assignCommands(entity:Entity, commands:Vector.<Command>):void
		{
			// If the entity has been destroyed, its commands vector will be null.
			if (!entity.COMMANDS) return;
			
			for (var i:int = 0, l:int = commands.length; i < l; i++) entity.COMMANDS.push(commands[i]);
			
			if (!entity.EXECUTING_COMMAND)
			{
				entity.setExecutingCommand(true);
				nextCommand(entity);
			}
		}
		
		/**
		 * Executes the next available Command the entity has. If no such Command exists, stops executing.
		 * @param	entity The entity to execute the command on.
		 */
		public static function nextCommand(entity:Entity):void
		{
			if (entity.COMMANDS == null) return;
			else if (entity.COMMANDS.length == 0)
			{
				entity.setExecutingCommand(false);
				return;
			}
			
			var command:Command = entity.COMMANDS[0];
			if (command.TYPE == CommandType.MOVE && entity.IS_MOVING) return;
			
			entity.COMMANDS.shift();
			command.execute(entity);
		}
		
		/**
		 * Decodes a string in the format of [CommandType][(::)(data)(::)(data)...];[CommandType][(::)(data)(::)(data)...];...
		 * @param	entity The entity to add the commands to.
		 * @param	commands The string of encoded commands.
		 */
		public static function decodeCommandString(entity:Entity, commandsString:String):void
		{
			var commands:Vector.<Command> = new Vector.<Command>();
			var commandsData:Array = commandsString.split(";");
			for (var i:int = 0, l:int = commandsData.length; i < l; i++)
			{
				var commandData:Array = LocalizationManager.parseLabel(String(commandsData[i])).split("::");
				var commandType:String = commandData[0];
				var command:Command;
				
				var messages:Array;
				var k:int;
				switch(commandType)
				{
					case CommandType.MOVE:
						command = new MoveCommand(commandData[1]);
						break;
					case CommandType.CONTROLS:
						command = new ControlsCommand(commandData[1] == "on" ? true : false);
						break;
					case CommandType.HIDE:
						command = new HideCommand(commandData[1]);
						break;
					case CommandType.SHOW:
						command = new ShowCommand(commandData[1]);
						break;
					case CommandType.WAIT:
						command = new WaitCommand(Number(commandData[1]));
						break;
					case CommandType.DIALOGUE:
						messages = [];
						for (k = 3; k < commandData.length; k++) messages.push(commandData[k]);
						command = new DialogueCommand(commandData[1], uint(commandData[2]), messages);
						break;
					case CommandType.TURN:
						command = new TurnCommand(commandData[1]);
						break;
					case CommandType.COMMAND:
						command = new CommandCommand(commandData[1], commandData[2], (commandData.length > 3 ? commandData[3] : ""));
						break;
					case CommandType.TIP:
						command = new TipCommand(commandData[1], int(commandData[2]), int(commandData[3]));
						break;
					case CommandType.CLOSE_TIPS:
						command = new CloseTipsCommand();
						break;
					case CommandType.CREATE:
						command = new CreateCommand(commandData[1]);
						break;
					case CommandType.CALL:
						command = new CallCommand(commandData[1], commandData[2]);
						break;
					case CommandType.SET:
						command = new SetCommand(commandData[1], commandData[2]);
						break;
					case CommandType.SWITCH:
						messages = [];
						for (k = 2; k < commandData.length; k++) messages.push(commandData[k]);
						command = new SwitchCommand(commandData[1], messages);
						break;
					case CommandType.PLAY:
						command = new PlayCommand(commandData[1]);
						break;
					case CommandType.DESTROY:
						command = new DestroyCommand(commandData[1]);
						break;
					case CommandType.ANIMATE:
						command = new AnimateCommand(commandData[1], commandData[2], commandData[3], (commandData[4] == "true" ? true : false));
						break;
					case CommandType.MAP:
						command = new MapCommand(commandData[1], int(commandData[2]), int(commandData[3]), commandData[4], commandData.length > 5  && commandData[5] == "true" ? true : false);
						break;
					case CommandType.QUESTION:
						messages = [];
						for (k = 4; k < commandData.length; k++) messages.push(commandData[k]);
						command = new QuestionCommand(commandData[1], uint(commandData[2]), commandData[3], messages);
						break;
					case "":
						continue;
						break;
				}
				
				commands.push(command);
			}
			
			assignCommands(entity, commands);
		}
		
		/**
		 * Returns the given propertyName's value from the states object.
		 * @param	propertyName The name of the property to get the value of.
		 * @return The property's value.
		 */
		public static function getStateValue(propertyName:String):String
		{
			if (propertyName == "previousY") return MapManager.PREVIOUS_Y_TILE.toString();
			else if (propertyName == "previousX") return MapManager.PREVIOUS_X_TILE.toString();
			
			return _states[propertyName];
		}
		
		/**
		 * Sets the given propertyName on the states object to the given value.
		 * @param	propertyName The name of the property to change.
		 * @param	value The property's new value.
		 */
		public static function setStateValue(propertyName:String, value:String):void
		{
			_states[propertyName] = value;
		}
		
		/**
		 * Changes the states object.
		 * @param	states The new states object.
		 */
		public static function loadStatesObject(states:Object):void
		{
			_states = states;
		}
		
		/**
		 * Provides the entire _states object for saving.
		 * @return The current _states object.
		 */
		public static function saveStatesObject():Object
		{
			return _states;
		}
		
	}

}