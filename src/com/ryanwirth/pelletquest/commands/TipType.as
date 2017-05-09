package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.localization.Language;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class TipType 
	{
		public static const CONTROLS:String = "controls";
		public static const CONTROLS_STOP:String = "controls_stop";
		public static const NIGHT:String = "night";
		
		public function TipType() 
		{
			
		}
		
		/**
		 * Given a tip type, returns the title label that is shown above the description. The standard format is "Tip: {{TIP_TITLE}} ({{t}})".
		 * @param	tipType The type of tip to get the title for.
		 * @return The tip's title.
		 */
		public static function getTipTitle(tipType:String):String
		{
			switch(tipType)
			{
				case CONTROLS:
					return Language.TIP_CONTROLS_TITLE;
					break;
				case CONTROLS_STOP:
					return Language.TIP_CONTROLS_TITLE;
					break;
				case NIGHT:
					return Language.TIP_NIGHT_TITLE;
					break;
				default:
					throw(new Error("TipType: Unknown type '" + tipType + "'."));
					break;
			}
			
			return "";
		}
		
		/**
		 * Given a tip type, returns the description label that is shown underneath the title.
		 * @param	tipType The type of tip to get the description for.
		 * @return The tip's description.
		 */
		public static function getTipDescription(tipType:String):String
		{
			switch(tipType)
			{
				case CONTROLS:
					return Language.TIP_CONTROLS_DESCRIPTION;
					break;
				case CONTROLS_STOP:
					return Language.TIP_CONTROLS_STOP_DESCRIPTION;
					break;
				case NIGHT:
					return Language.TIP_NIGHT_DESCRIPTION;
					break;
				default:
					throw(new Error("TipType: Unknown type '" + tipType + "'."));
					break;
			}
			
			return "";
		}
		
	}

}