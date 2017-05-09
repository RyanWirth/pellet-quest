package com.ryanwirth.pelletquest.save
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class SaveManager
	{
		private static var _save:Save;
		
		public function SaveManager()
		{
			throw(new Error("SaveManager: Do not instantiate."));
		}
		
		/**
		 * Loads the save file with the given saveName into memory.
		 * @param	saveName The name of the file to load.
		 */
		public static function loadSave(saveName:String):void
		{
			if (_save) closeSave();
			
			deleteSave(saveName);
			
			trace("SaveManager: Loading save '" + saveName + "'...");
			_save = new Save(saveName);
		}
		
		/**
		 * Saves the current file.
		 */
		public static function save():void
		{
			if (!_save) return;
			
			trace("SaveManager: Saving data...");
			_save.save();
		}
		
		/**
		 * Saves the current file and then disposes of its resources.
		 */
		public static function closeSave():void
		{
			if (!_save) return;
			
			save();
			
			_save.destroy();
			_save = null;
		}
		
		public static function deleteSave(saveName:String = ""):void
		{
			if (saveName != "")
			{
				trace("SaveManager: Deleting save '" + saveName + "'...");
				SharedObject.getLocal(saveName).clear();
			}
		}
		
		/**
		 * Provides direct access to the loaded save.
		 */
		public static function get SAVE():Save
		{
			if (!_save) throw(new Error("SaveManager: Save file not yet loaded."));
			else return _save;
		}
	}

}