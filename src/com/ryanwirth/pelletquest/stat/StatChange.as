package com.ryanwirth.pelletquest.stat 
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.ui.UIIconManager;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class StatChange 
	{
		public static const TICK_TIME:Number = 0.25;
		
		private var _statChangeType:String;
		private var _duration:Number = 0;
		
		public function StatChange(statChangeType:String, duration:Number = 0) 
		{
			_statChangeType = statChangeType;
			_duration = duration;
			
			// Activate the StatChange
			activate();
			
			// Start the countdown.
			if(_duration > 0) TweenMax.delayedCall(TICK_TIME, decreaseDuration);
		}
		
		/**
		 * Returns the duration (in seconds) left for this StatChange.
		 */
		public function get DURATION():Number
		{
			return _duration;
		}
		
		/**
		 * Increases the duration of the StatChange by the given number.
		 * @param	duration The number of seconds to lengthen the duration by.
		 */
		public function addToDuration(duration:Number):void
		{
			_duration += duration;
		}
		
		/**
		 * Ticks down the duration of the StatChange by TICK_TIME seconds, updates the icon's label/description, and checks to see if the duration is up.
		 */
		private function decreaseDuration():void
		{
			_duration -= TICK_TIME;
			
			UIIconManager.updateIconHolderLabel(StatChangeType.getIconType(TYPE), StatChangeType.getName(TYPE) + " (" + Math.floor(_duration) + ")", StatChangeType.getDescription(TYPE));
			
			if (_duration > 0)
			{
				tick();
				TweenMax.delayedCall(TICK_TIME, decreaseDuration);
			} else
			{
				deactivate();
				
				StatManager.deactivateStatChange(this);
			}
			
		}
		
		public function activate():void
		{
			// To be overridden.
		}
		
		public function tick():void
		{
			// To be overridden.
		}
		
		public function deactivate():void
		{
			// To be overridden.
		}
		
		/**
		 * Returns the StatChangeType of this StatChange object.
		 */
		public function get TYPE():String { return _statChangeType }
		
	}

}