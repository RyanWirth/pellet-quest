package com.ryanwirth.pelletquest.options
{
	import com.ryanwirth.pelletquest.localization.LocaleType;
	import com.ryanwirth.pelletquest.GameManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class OptionsManager
	{
		private static var _easyInput:Boolean = true;
		private static var _easyInputWait:Boolean = false;
		private static var _fps:int = 30;
		private static var _scale:Number = 0;
		private static var _controls:Boolean = true;
		private static var _music:Boolean = true;
		private static var _soundEffects:Boolean = true;
		
		private static var _currentLocale:String = LocaleType.ENGLISH;
		
		private static var _twentyFourHourTime:Boolean = false;
		
		public function OptionsManager()
		{
		
		}
		
		/**
		 * Changes whether the 24-hour clock is on or off.
		 * @param	twentyFourHourTime The new state of the 24-hour clock option (true is on, false is off).
		 */
		public static function setTwentyFourHourTime(twentyFourHourTime:Boolean):void
		{
			_twentyFourHourTime = twentyFourHourTime;
		}
		
		/**
		 * Changes whether the Easy Input option is on or off. Easy Input allows the player to move along a single path without having to input a direction at corners where there are only two possible paths.
		 * @param	easyInput The new state of the Easy Input option.
		 */
		public static function setEasyInput(easyInput:Boolean):void
		{
			_easyInput = easyInput;
			
			if (!EASY_INPUT) setEasyInputWait(false);
		}
		
		public static function setEasyInputWait(easyInputWait:Boolean):void
		{
			_easyInputWait = easyInputWait;
			
			if (EASY_INPUT_WAIT) setEasyInput(true);
		}
		
		public static function setScale(scale:Number):void
		{
			_scale = scale;
			
			GameManager.updateScale(SCALE);
		}
		
		public static function setMusic(music:Boolean):void
		{
			_music = music;
		}
		
		public static function setSoundEffects(soundEffects:Boolean):void
		{
			_soundEffects = soundEffects;
		}
		
		public static function get CURRENT_LOCALE_TYPE():String
		{
			return _currentLocale;
		}
		
		public static function setCurrentLocale(localeType:String):void
		{
			_currentLocale = localeType;
		}
		
		public static function setFPS(fps:int):void
		{
			_fps = fps;
			GameManager.stage.frameRate = FPS;
		}
		
		/**
		 * Updates the state of the controls. If on is true, the player will be able to input directions through tapping. If on is false, the player will not have control.
		 * @param	on
		 */
		public static function setControls(on:Boolean):void
		{
			_controls = on;
		}
		
		/**
		 * "Easy input" will make the player follow the path if there is only one route to follow. In addition, if the player sets a move direction
		 * that cannot be immediately followed, it will be set as "pending" and will take effect when that direction is walkable.
		 */
		public static function get EASY_INPUT():Boolean
		{
			return _easyInput;
		}
		
		/**
		 * "Easy input wait" must be on with "Easy input," whereby the player will wait when there are three possible paths for the player to select a direction.
		 */
		public static function get EASY_INPUT_WAIT():Boolean
		{
			return _easyInputWait;
		}
		
		/**
		 * Returns the current FPS setting.
		 */
		public static function get FPS():int
		{
			return _fps;
		}
		
		/**
		 * Returns the current map scale value.
		 */
		public static function get SCALE():Number
		{
			return _scale;
		}
		
		/**
		 * If the twenty-four hour time mode is enabled, return true. If not, return false.
		 */
		public static function get TWENTY_FOUR_HOUR_TIME():Boolean
		{
			return _twentyFourHourTime;
		}
		
		/**
		 * If the player still has control of the player, returns true. If not, false.
		 */
		public static function get CONTROLS():Boolean
		{
			return _controls;
		}
		
		/**
		 * Returns the state of the Music option.
		 */
		public static function get MUSIC():Boolean
		{
			return _music;
		}
		
		/**
		 * Returns the state of the Sound Effects option.
		 */
		public static function get SOUND_EFFECTS():Boolean
		{
			return _soundEffects;
		}
	
	}

}