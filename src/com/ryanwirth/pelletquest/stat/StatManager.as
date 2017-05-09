package com.ryanwirth.pelletquest.stat
{
	import adobe.utils.CustomActions;
	import flash.utils.getDefinitionByName;
	import com.ryanwirth.pelletquest.ui.UIIconManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class StatManager
	{
		// Keep all of the stat changes in the SWF.
		private static const REFERENCES:Array = [PowerUpStatChange];
		
		// The active list of stat changes.
		private static var _activeStatChanges:Vector.<StatChange>;
		
		public function StatManager()
		{
		
		}
		
		/**
		 * Encodes all active stat changes into an object vector for saving.
		 * @return The encoded object vector.
		 */
		public static function ENCODE_STAT_CHANGES():Vector.<Object>
		{
			var vec:Vector.<Object> = new Vector.<Object>();
				
			if (!_activeStatChanges) return vec;
			
			for (var i:int = 0, l:int = _activeStatChanges.length; i < l; i++)
			{
				var obj:Object = new Object();
				obj.type = _activeStatChanges[i].TYPE;
				obj.duration = _activeStatChanges[i].DURATION;
				vec.push(obj);
			}
			
			return vec;
		}
		
		/**
		 * Decodes all of the saved stat changes and adds them to the StatManager.
		 * @param	vec The saved object vector of stat changes.
		 */
		public static function DECODE_STAT_CHANGES(vec:Vector.<Object>):void
		{
			for (var i:int = 0, l:int = vec.length; i < l; i++)
			{
				activateStatChange(vec[i].type, vec[i].duration);
			}
		}
		
		/**
		 * Activates the specified statChangeType. Should the given statChangeType already be activated, adds the given duration to the stat change or, if the duration given is zero, fails silently.
		 * @param	statChangeType The type of stat change to activate.
		 * @param	duration The length of time to have the stat change active for.
		 */
		public static function activateStatChange(statChangeType:String, duration:Number = 0):void
		{
			if (!_activeStatChanges) _activeStatChanges = new Vector.<StatChange>();
			
			if (isStatChangeActive(statChangeType))
			{
				// The stat change is already active. If the duration is greater than zero, add the duration to the stat change. If not, do nothing.
				if (duration > 0)
				{
					getStatChange(statChangeType).addToDuration(duration);
				}
				getStatChange(statChangeType).activate();
				return;
			}
			
			// Find the definition and create an instance of the specified stat change.
			var cl:Class = getDefinitionByName("com.ryanwirth.pelletquest.stat." + statChangeType) as Class;
			var statChange:StatChange = new cl(duration) as StatChange;
			
			// Get all the data to be used in the UIIconHolder.
			var iconType:String = StatChangeType.getIconType(statChangeType);
			var labelText:String = StatChangeType.getName(statChangeType) + (duration > 0 ? " (" + Math.floor(duration) + ")" : "");
			var descriptionText:String = StatChangeType.getDescription(statChangeType);
			var labelColor:uint = StatChangeType.getNameColor(statChangeType);
			
			// Add the icon holder to the HUD!
			UIIconManager.addIconHolder(iconType, labelText, descriptionText, false, labelColor, 0xFFFFFF, 0, false);
			
			_activeStatChanges.push(statChange);
		}
		
		/**
		 * Looks through all active stat changes to check for type matches with the given type.
		 * @param	statChangeType The type of stat change to look for.
		 * @return True if the given stat change type is currently activated, false if not.
		 */
		public static function isStatChangeActive(statChangeType:String):Boolean
		{
			if (!_activeStatChanges) return false;
			
			for (var i:int = 0, l:int = _activeStatChanges.length; i < l; i++)
				if (_activeStatChanges[i].TYPE == statChangeType) return true;
			return false;
		}
		
		/**
		 * Retrieves the stat change matching the given type.
		 * @param	statChangeType The type of stat change to get.
		 * @return A StatChange object with a matching TYPE property. If one was not found, returns null.
		 */
		public static function getStatChange(statChangeType:String):StatChange
		{
			if (!_activeStatChanges) _activeStatChanges = new Vector.<StatChange>();
			
			for (var i:int = 0, l:int = _activeStatChanges.length; i < l; i++) if (_activeStatChanges[i].TYPE == statChangeType) return _activeStatChanges[i];
			
			return null;
		}
		
		/**
		 * Removes the supplied StatChange from the active list.
		 * @param	statChange The StatChange to deactivate.
		 */
		public static function deactivateStatChange(statChange:StatChange):void
		{
			if (!_activeStatChanges) _activeStatChanges = new Vector.<StatChange>();
			
			for (var i:int = 0; i < _activeStatChanges.length; i++)
			{
				if (_activeStatChanges[i] == statChange)
				{
					UIIconManager.removeIconHolder(UIIconManager.getIconHolderWithType(StatChangeType.getIconType(statChange.TYPE)));
					_activeStatChanges.splice(i, 1);
				}
			}
		}
	
	}

}