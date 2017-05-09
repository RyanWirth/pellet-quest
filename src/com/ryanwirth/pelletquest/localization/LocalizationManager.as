package com.ryanwirth.pelletquest.localization
{
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class LocalizationManager
	{
		public static const KINGDOM_NAME:String = "Rockbourne";
		public static const NPC_INNKEEPER:String = "Wilgrim";
		public static const NPC_INNKEEPER_COLOR:String = "0xdb5f2f";
		
		public static var languageCode:String;
		public static var languageCountry:String;
		public static var language:Language;
		
		public function LocalizationManager()
		{
		
		}
		
		/**
		 * Loads the user's local language into memory.
		 */
		public static function initializeLocalization(localeType:String = null):void
		{
			if (localeType != null)
			{
				languageCode = localeType;
			}
			else
			{
				//var languageData:Array = String(Capabilities.languages[0]).split("-");
				//languageCode = languageData[0];
				//languageCountry = languageData[1];
				
			}
			//languageCode = "es";
			
			trace("LocalizationManager: Using locale " + languageCode + "," + languageCountry);
			
			loadLocaleType(languageCode);
		}
		
		/**
		 * Given a LocaleType, loads the indicated Language into memory. If a language is already loaded, disposes of it.
		 * @param	localeType
		 */
		public static function loadLocaleType(localeType:String):void
		{
			if (language) language.destroy();
			language = null;
			
			languageCode = localeType;
			
			OptionsManager.setCurrentLocale(localeType);
			
			switch (localeType)
			{
			case LocaleType.SPANISH: 
				language = new LSpanishES();
				break;
			case LocaleType.FRENCH: 
				language = new LFrenchFR();
				break;
			case LocaleType.ENGLISH: 
			default: 
				language = new LEnglishUS();
				OptionsManager.setCurrentLocale(LocaleType.ENGLISH);
				break;
			}
		}
		
		/**
		 * Parses the given label string by replacing phrases and other things.
		 * @param	label The starting label string.
		 * @return The localized label.
		 */
		public static function parseLabel(label:String, _autoDismissal:int = 0):String
		{
			for (var i:int = 0, l:int = Language.PHRASES.length; i < l; i++)
			{
				label = label.replace(Language.PHRASES[i], getPhrase(String(Language.PHRASES[i])));
			}
			
			label = label.replace("{{t}}", _autoDismissal.toString());
			label = label.replace("{{name}}", SaveManager.SAVE.SAVE_NAME);
			label = label.replace("{{kingdom}}", KINGDOM_NAME.toUpperCase());
			label = label.replace("{{NPC_INNKEEPER}}", NPC_INNKEEPER.toUpperCase());
			label = label.replace("{{NPC_INNKEEPER_COLOR}}", NPC_INNKEEPER_COLOR);
			label = label.replace("{{n}}", "\n");
			
			return label;
		}
		
		/**
		 * Formats a number by adding commas every third number (XXX,XXX,XXX)
		 * @param	number The number to format.
		 * @return The formatted number.
		 */
		public static function formatNumber(number:Number):String
		{
			var nString:String = String(number)
			var rst:String = '';
			var separator:String = language.numberSeparator;
			while (nString.length > 3)
			{
				var pcs:String = nString.substr(-3)
				nString = nString.substr(0, nString.length - 3)
				rst = separator + pcs + rst
			}
			return (nString.length) ? rst = nString + rst : rst
		}
		
		/**
		 * Returns the proper, localized version of the specified phrase. If one cannot be found, returns an ENGLISH_US localized version.
		 * @param	phraseType The type of phrase to find.
		 * @return The localized phrase.
		 */
		public static function getPhrase(phraseType:String):String
		{
			return language.getPhrase(phraseType);
		}
		
		/**
		 * Returns the type of font to use for the current Language. If GoodNeighbors does not have all the characters used in the current Language, uses the system font.
		 * @return The name of the font to use in the TextField.
		 */
		public static function getFontName():String
		{
			return "GoodNeighbors";
		}
		
		/**
		 * Some languages have significantly longer phrases. As such, this returns a Number to multiply with the default fontSize.
		 * @return A Number to multiply with the fontSize.
		 */
		public static function getFontSizeMultiplier():Number
		{
			return 1;
		}
		
		/**
		 * Finds a string between a start and end string in a given fullString.
		 * @param	start The starting string to look for.
		 * @param	end The encapsulating (end) string.
		 * @param	fullString The string to look in.
		 * @return The string between the start and end strings.
		 */
		public static function getSubString(start:String, end:String, fullString:String):String
		{
			var startIndex:Number = fullString.indexOf(start) + start.length;
			var endIndex:Number = fullString.indexOf(end, startIndex) - 1;// You can change this to 
			// lastIndexOf in order to
			// get the string between the 
			//first instance of start and
			// the last index of end
			return fullString.substring(startIndex, endIndex);
		}
	
	}

}