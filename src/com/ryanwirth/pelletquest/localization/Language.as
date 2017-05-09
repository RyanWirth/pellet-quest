package com.ryanwirth.pelletquest.localization
{
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Language
	{
		public static const LANGUAGE_NAME:String = "LANGUAGE_NAME";
		
		public static const MENU_PAUSED:String = "MENU_PAUSED";
		public static const MENU_CONTINUE:String = "MENU_CONTINUE";
		public static const MENU_SAVE:String = "MENU_SAVE";
		public static const MENU_SAVING:String = "MENU_SAVING";
		public static const MENU_OPTIONS:String = "MENU_OPTIONS";
		public static const MENU_QUIT:String = "MENU_QUIT";
		public static const MENU_TAP_TO_CONTINUE:String = "MENU_TAP_TO_CONTINUE";
		public static const MENU_TAP_TO_CLOSE:String = "MENU_TAP_TO_CLOSE";
		public static const MENU_GAMEPLAY_OPTIONS:String = "MENU_GAMEPLAY_OPTIONS";
		public static const MENU_SOUND_OPTIONS:String = "MENU_SOUND_OPTIONS";
		public static const MENU_BACK:String = "MENU_BACK";
		public static const MENU_FPS:String = "MENU_FPS";
		public static const MENU_SCALE:String = "MENU_SCALE";
		public static const MENU_SIMPLE_INPUT:String = "MENU_SIMPLE_INPUT";
		public static const MENU_MUSIC:String = "MENU_MUSIC";
		public static const MENU_SOUND_EFFECTS:String = "MENU_SOUND_EFFECTS";
		
		public static const HUD_POWER_UP:String = "HUD_POWER_UP";
		
		public static const STAT_INVINCIBILITY:String = "STAT_INVINCIBILITY";
		public static const STAT_SPEED:String = "STAT_SPEED";
		
		public static const TIP_PREFIX:String = "TIP_PREFIX";
		public static const TIP_CONTROLS_TITLE:String = "TIP_CONTROLS_TITLE";
		public static const TIP_CONTROLS_DESCRIPTION:String = "TIP_CONTROLS_DESCRIPTION";
		public static const TIP_CONTROLS_STOP_DESCRIPTION:String = "TIP_CONTROLS_STOP_DESCRIPTION";
		public static const TIP_NIGHT_TITLE:String = "TIP_NIGHT_TITLE";
		public static const TIP_NIGHT_DESCRIPTION:String = "TIP_NIGHT_DESCRIPTION";
		
		public static const NUMBER_SEPARATOR:String = "NUMBER_SEPARATOR";
		public static const SECONDS_LETTER:String = "SECONDS_LETTER";
		
		// Private data store for the language and its type.
		private var _langCode:String;
		private var _langObj:Object;
		
		public static const PHRASES:Array = [TIP_PREFIX, TIP_CONTROLS_DESCRIPTION, TIP_CONTROLS_STOP_DESCRIPTION, TIP_NIGHT_DESCRIPTION, TIP_NIGHT_TITLE, TIP_CONTROLS_TITLE, MENU_SOUND_EFFECTS, MENU_MUSIC, MENU_SAVING, MENU_FPS, MENU_SCALE, MENU_SIMPLE_INPUT, LANGUAGE_NAME, MENU_PAUSED, MENU_CONTINUE, MENU_SAVE, MENU_OPTIONS, MENU_QUIT, MENU_TAP_TO_CLOSE, MENU_TAP_TO_CONTINUE, MENU_GAMEPLAY_OPTIONS, MENU_SOUND_OPTIONS, MENU_BACK, HUD_POWER_UP, STAT_INVINCIBILITY, STAT_SPEED, NUMBER_SEPARATOR, SECONDS_LETTER];
		
		public function Language(langCode:String, langObj:Object)
		{
			_langCode = langCode;
			_langObj = langObj;
		}
		
		/**
		 * Retrieves the supplied phrase from this Language. If this Language does not have the specified phrase, uses the LEnglishUS Language as a backup.
		 * @param	phraseType The phrase type to retrieve.
		 * @return The localized phrase.
		 */
		public function getPhrase(phraseType:String):String
		{
			if (_langObj.hasOwnProperty(phraseType)) return _langObj[phraseType];
			else
			{
				// Try and get an English version of this phrase.
				var enLang:Language = new LEnglishUS();
				if (enLang._langObj.hasOwnProperty(phraseType))
				{
					trace("Language: WARNING!", phraseType, "does not have a localized string for", LANG_CODE, "!");
					return enLang.LANG_OBJ[phraseType];
				}
				else throw(new Error("Language: Unknown Phrase '" + phraseType + "'!"));
			}
		}
		
		/**
		 * A fast method for retrieving the localized number separator (thousands places)
		 */
		public function get numberSeparator():String  { return LocalizationManager.parseLabel(NUMBER_SEPARATOR); }
		
		/**
		 * Provides direct access to the current Language object.
		 */
		public function get LANG_OBJ():Object  { return _langObj; }
		
		/**
		 * Provides direct access to the two letter language code of this Language.
		 */
		public function get LANG_CODE():String  { return _langCode; }
		
		/**
		 * Disposes of the language object.
		 */
		public function destroy():void
		{
			_langObj = null;
		}
	
	}

}