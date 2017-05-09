package com.ryanwirth.pelletquest.localization 
{
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class LSpanishES extends Language
	{
		public static const LANGUAGE:Object = { LANGUAGE_NAME: "Español",
		
												MENU_PAUSED: "Pausado",
												MENU_CONTINUE: "Continuar",
												MENU_OPTIONS: "Opciones",
												MENU_SAVE: "Guardar", 
												MENU_SAVING: "Guardando...",
												MENU_QUIT: "Cerrar",
												MENU_TAP_TO_CONTINUE:"Toque para continuar",
												MENU_TAP_TO_CLOSE:"Toque para cerrar",
												MENU_GAMEPLAY_OPTIONS:"Opciones de Juego",
												MENU_SOUND_OPTIONS:"Opciones de Sonido",
												MENU_BACK:"Volver",
												MENU_FPS:"IPS",
												MENU_SCALE:"Escala",
												MENU_SIMPLE_INPUT:"Entrada Simple",
												MENU_MUSIC:"Música",
												MENU_SOUND_EFFECTS:"Efectos de Sonido",
												
												HUD_POWER_UP: "Potenciador!",
												
												STAT_INVINCIBILITY:"Invencibilidad",
												STAT_SPEED:"Velocidad",
												
												TIP_PREFIX:"Consejo",
												TIP_CONTROLS_TITLE:"Controles",
												TIP_CONTROLS_DESCRIPTION:"Toque en la pantalla en la dirección que desea ir.",
												
												NUMBER_SEPARATOR: " ",
												SECONDS_LETTER: "s"
												};
		
		public function LSpanishES() 
		{
			super(LocaleType.SPANISH, LANGUAGE);
		}
		
	}

}