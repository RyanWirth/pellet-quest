package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class CommandCommand extends Command
	{
		private var _commandName:String;
		private var _objectName:String;
		private var _onEntityName:String;
		
		public function CommandCommand(commandName:String, objectName:String, onEntityName:String = "") 
		{
			_commandName = commandName;
			_objectName = objectName;
			_onEntityName = onEntityName;
			
			super(CommandType.COMMAND);
		}
		
		override public function execute(entity:Entity):void
		{
			CommandManager.decodeCommandString(_onEntityName == "" ? entity : (_onEntityName == "player" ? PlayerManager.PLAYER : EntityManager.getEntityByName(_onEntityName)), MapManager.getObjectProperty(_commandName, _objectName));
			CommandManager.nextCommand(entity);
		}
		
	}

}