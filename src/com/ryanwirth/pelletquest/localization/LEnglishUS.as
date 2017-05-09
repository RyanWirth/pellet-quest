package com.ryanwirth.pelletquest.localization 
{
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class LEnglishUS extends Language
	{
		public static const LANGUAGE:Object = { LANGUAGE_NAME: "English",
		
												MENU_PAUSED: "Paused",
												MENU_CONTINUE: "Continue",
												MENU_OPTIONS: "Options",
												MENU_SAVE: "Save",
												MENU_SAVING: "Saving...",
												MENU_QUIT: "Quit",
												MENU_TAP_TO_CONTINUE:"Tap to continue",
												MENU_TAP_TO_CLOSE:"Tap to close",
												MENU_GAMEPLAY_OPTIONS:"Gameplay Options",
												MENU_SOUND_OPTIONS:"Sound Options",
												MENU_BACK:"Back",
												MENU_FPS:"FPS",
												MENU_SCALE:"Scale",
												MENU_SIMPLE_INPUT:"Simple Input",
												MENU_MUSIC:"Music",
												MENU_SOUND_EFFECTS:"Sound Effects",
												
												HUD_POWER_UP: "Power-Up!",
												
												STAT_INVINCIBILITY:"Invincibility",
												STAT_SPEED:"Speed",
												
												TIP_PREFIX:"Tip",
												TIP_CONTROLS_TITLE:"Controls",
												TIP_CONTROLS_DESCRIPTION:"Tap on the screen in the direction you want to go.",
												TIP_CONTROLS_STOP_DESCRIPTION:"Tap on the center of the screen to stop moving.",
												TIP_NIGHT_TITLE:"Night",
												TIP_NIGHT_DESCRIPTION:"Night is approaching! DARK CREATURES are coming!",
												
												NUMBER_SEPARATOR: ",",
												SECONDS_LETTER: "s"
												};
		
		public function LEnglishUS() 
		{
			super(LocaleType.ENGLISH, LANGUAGE);
		}
		
	}

}