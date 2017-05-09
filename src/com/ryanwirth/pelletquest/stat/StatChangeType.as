package com.ryanwirth.pelletquest.stat 
{
	import com.ryanwirth.pelletquest.ui.IconType;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.localization.Language;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class StatChangeType 
	{
		public static const POWER_UP:String = "PowerUpStatChange";
		
		public function StatChangeType() 
		{
			
		}
		
		/**
		 * Gets the icon of the given statChangeType to be shown in the UIIconHolder.
		 * @param	statChangeType The statChangeType to lookup.
		 * @return The IconType to be shown in the UIIconHolder.
		 */
		public static function getIconType(statChangeType:String):String
		{
			switch(statChangeType)
			{
				case POWER_UP:
					return IconType.ICON_BLUE_FIRE_BALL;
					break;
				default:
					throw(new Error("StatChangeType: Unknown type '" + statChangeType + "'."));
					break;
			}
			
			return null;
		}
		
		/**
		 * Gets the name of the given statChangeType as a localized string. This name is shown on the top line of the UIIconHolder.
		 * @param	statChangeType The statChangeType to lookup.
		 * @return The localized name string.
		 */
		public static function getName(statChangeType:String):String
		{
			switch(statChangeType)
			{
				case POWER_UP:
					return Language.HUD_POWER_UP;
					break;
				default:
					throw(new Error("StatChangeType: Unknown type '" + statChangeType + "'."));
					break;
			}
			
			return null;
		}
		
		/**
		 * Gets the color of the label text to be shown on the UIIconHolder.
		 * @param	statChangeType The statChangeType to lookup.
		 * @return The color expressed as an unsigned integer (0xFFFFFF is the default, if not otherwise specified).
		 */
		public static function getNameColor(statChangeType:String):uint
		{
			switch(statChangeType)
			{
				case POWER_UP:
					return 0x00e0ff;
					break;
			}
			
			return 0xFFFFFF;
		}
		
		/**
		 * Gets the description of the given statChangeType as a localized string. This description is shown on the bottom line of the UIIconHolder.
		 * @param	statChangeType The statChangeType to lookup.
		 * @return The localized description string.
		 */
		public static function getDescription(statChangeType:String):String
		{
			switch(statChangeType)
			{
				case POWER_UP:
					return Language.STAT_INVINCIBILITY + " + " + Language.STAT_SPEED;
					break;
				default:
					throw(new Error("StatChangeType: Unknown type '" + statChangeType + "'."));
					break;
			}
			
			return null;
		}
		
	}

}