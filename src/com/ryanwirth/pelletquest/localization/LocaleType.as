package com.ryanwirth.pelletquest.localization
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class LocaleType
	{
		public static const ENGLISH:String = "en";
		
		public static const FRENCH:String = "fr";
		
		public static const SPANISH:String = "es";
		
		public static const GERMAN:String = "de";
		
		public static const ITALIAN:String = "it";
		
		public static const PORTUGUESE_BR:String = "ptBR";
		
		public static const PORTUGUESE_PT:String = "ptPT";
		
		public static const RUSSIAN:String = "ru";
		
		public static const TURKISH:String = "tr";
		
		public static const DANISH:String = "da";
		
		public static const NORWEGIAN:String = "no";
		
		public static const SWEDISH:String = "sv";
		
		public static const BULGARIAN:String = "bg";
		
		public function LocaleType()
		{
		
		}
		
		/**
		 * Given a LocaleType, returns the next LocaleType in the list of supported languages. Loops around from the bottom to the top (English).
		 * @param	localeType The current LocaleType.
		 * @return The next LocaleType.
		 */
		public static function getNextLocaleType(localeType:String):String
		{
			switch(localeType)
			{
				case ENGLISH:
					return FRENCH;
					break;
				case FRENCH:
					return SPANISH;
					break;
				case SPANISH:
					return ENGLISH;
					break;
			}
			
			return ENGLISH;
		}
	
	}

}