package com.ryanwirth.pelletquest.localization 
{
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class LFrenchFR extends Language
	{
		public static const LANGUAGE:Object = { LANGUAGE_NAME: "Français",
		
												MENU_PAUSED: "En Pause",
												MENU_CONTINUE: "Continuer",
												MENU_OPTIONS: "Options",
												MENU_SAVE: "Sauvegarder",
												MENU_SAVING: "Sauvegarde en cours...",
												MENU_QUIT: "Quitter",
												MENU_TAP_TO_CONTINUE:"Appuyez sur pour continuer",
												MENU_TAP_TO_CLOSE:"Appuyez sur pour fermer",
												MENU_GAMEPLAY_OPTIONS:"Options de Jeu",
												MENU_SOUND_OPTIONS:"Options Sonores",
												MENU_BACK:"Retour",
												MENU_FPS:"IPS",
												MENU_SCALE:"Échelle",
												MENU_SIMPLE_INPUT:"Entrée Simple",
												MENU_MUSIC:"Musical",
												MENU_SOUND_EFFECTS:"Effets Sonores",
												
												HUD_POWER_UP: "Amélioration!",
												
												STAT_INVINCIBILITY:"Invincibilité",
												STAT_SPEED:"Vitesse",
												
												TIP_PREFIX:"Conseil",
												TIP_CONTROLS_TITLE:"Contrôles",
												TIP_CONTROLS_DESCRIPTION:"Tapez sur l'écran dans la direction où vous voulez aller.",
												
												NUMBER_SEPARATOR: " ",
												SECONDS_LETTER: "s"
												};
		
		public function LFrenchFR() 
		{
			super(LocaleType.FRENCH, LANGUAGE);
		}
		
	}

}