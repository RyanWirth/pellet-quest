package com.ryanwirth.pelletquest.ui
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	import starling.display.Image;
	import starling.textures.Texture;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.commands.TipCommand;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIDayNightCycle extends Image
	{
		private var _hour:int;
		private var _minute:int;
		
		private var _timeSpeed:Number;
		
		public function UIDayNightCycle(hour:int, minute:int, timeSpeed:Number = 0.5)
		{
			_hour = hour;
			_minute = minute;
			_timeSpeed = timeSpeed;
			
			super(Texture.fromColor(GameManager.stageWidth, GameManager.stageHeight, 0xFFFFFFFF, false));
			
			updateOverlay();
		}
		
		public function get HOUR():int
		{
			return _hour;
		}
		
		public function get MINUTE():int
		{
			return _minute;
		}
		
		/**
		 * Advances the time and updates both the color and opacity of the overlay.
		 */
		private function updateOverlay():void
		{
			_minute++;
			
			if (_minute >= 60)
			{
				_hour++;
				_minute = 0;
			}
			if (_hour >= 24) _hour = 0;
			
			this.color = interpolateColor(getColorOverlayFromHour(_hour), getColorOverlayFromHour(_hour + 1), _minute / 60);
			
			var curAlpha:Number = getOpacityOverlayFromHour(_hour);
			var nextAlpha:Number = getOpacityOverlayFromHour(_hour + 1);
			var alphaStep:Number = (nextAlpha - curAlpha) / 60;
			
			this.alpha = curAlpha + alphaStep * _minute;
			
			TweenMax.delayedCall(_timeSpeed, updateOverlay);
			
			if (!SaveManager.SAVE.NIGHT_TIP && HOUR == 20) 
			{
				SaveManager.SAVE.setNightTip(true);
				TipCommand.showTip("night", 15);
			}
		}
		
		/**
		 * Interpolates between two colors, given a percentage (progress) between the two.
		 * @param	fromColor The starting color.
		 * @param	toColor The finishing color.
		 * @param	progress The percentage between the two colors (0 is all fromColor, 1 is all toColor.)
		 * @return The interpolated color.
		 */
		public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint
		{
			var q:Number = 1 - progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >> 8) & 0xFF;
			var fromB:uint = fromColor & 0xFF;
			
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >> 8) & 0xFF;
			var toB:uint = toColor & 0xFF;
			
			var resultA:uint = fromA * q + toA * progress;
			var resultR:uint = fromR * q + toR * progress;
			var resultG:uint = fromG * q + toG * progress;
			var resultB:uint = fromB * q + toB * progress;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;
		}
		
		/**
		 * Finds the alpha/opacity of the day/night cycle given the hour.
		 * @param	hour The hour to look up the opacity value.
		 * @return The opacity value expressed as a Number (0 being completely transparent, 1 being opaque.)
		 */
		public static function getOpacityOverlayFromHour(hour:int):Number
		{
			// Loop back around to the zeroth hour.
			if (hour > 23) hour = 0;
			
			switch (hour)
			{
			case 0: 
				return 0.8;
				break;
			case 1: 
			case 23: 
				return 0.7;
				break;
			case 2: 
			case 22: 
				return 0.6;
				break;
			case 3: 
			case 21: 
				return 0.5;
				break;
			case 4: 
			case 20: 
				return 0.4;
				break;
			case 5: 
			case 19: 
				return 0.3;
				break;
			case 6: 
			case 18: 
				return 0.2;
				break;
			case 7: 
			case 17: 
				return 0.1;
				break;
			default: 
				return 0;
				break;
			}
		}
		
		/**
		 * Looks up the color of the day/night cycle given the hour.
		 * @param	hour The hour to get the color from.
		 * @return The color as an unsigned integer.
		 */
		public static function getColorOverlayFromHour(hour:int):uint
		{
			// Loop back around to the zeroth hour.
			if (hour > 23) hour = 0;
			
			switch (hour)
			{
			case 0: 
				return 0x0f0f2d;
				break;
			case 1: 
				return 0x00103c;
				break;
			case 2: 
				return 0x000c46;
				break;
			case 3: 
				return 0x05216f;
				break;
			case 4: 
				return 0x002b8c;
				break;
			case 5: 
				return 0x005bc2;
				break;
			case 6: 
				return 0x007ad8;
				break;
			case 7: 
				return 0x00c8c6;
				break;
			case 8: 
			case 9: 
			case 10: 
			case 11: 
			case 12: 
			case 13: 
			case 14: // Transparent!
				return 0x00c8c6;
				break;
			case 15: 
			case 16: 
				return 0xd7ee7c;
				break;
			case 17: 
				return 0xb4a900;
				break;
			case 18: 
				return 0x9e5900;
				break;
			case 19: 
				return 0x701200;
				break;
			case 20: 
				return 0x580034;
				break;
			case 21: 
				return 0x3c002d;
				break;
			case 22: 
				return 0x2d004c;
				break;
			case 23: 
			default: 
				return 0x00003c;
				break;
			}
		}
		
		/**
		 * Returns a properly formatted Time string (HH:MM if 24-hour time, or HH:MM [AM|PM]).
		 */
		public function get TIME():String
		{
			if (OptionsManager.TWENTY_FOUR_HOUR_TIME)
			{
				return (HOUR < 10 ? "0" : "") + HOUR + ":" + (MINUTE < 10 ? "0" : "");
			} else
			{
				var amPm:String = "AM";
				
				var hour:int = HOUR;
				if (hour >= 12) amPm = "PM";
				if (hour > 12) hour -= 12;
				if (hour <= 0) hour = 12;
				
				return (hour < 10 ? "0" : "") + hour + ":" + (MINUTE < 10 ? "0" : "") + MINUTE + " " + amPm;
			}
		}
	}

}