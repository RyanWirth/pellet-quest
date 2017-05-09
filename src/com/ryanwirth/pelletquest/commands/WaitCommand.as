package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.greensock.TweenNano;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class WaitCommand extends Command
	{
		private var _duration:Number;
		
		public function WaitCommand(duration:Number) 
		{
			_duration = duration;
			
			super(CommandType.WAIT);
		}
		
		override public function execute(entity:Entity):void
		{
			TweenNano.delayedCall(_duration, CommandManager.nextCommand, [entity]);
		}
		
	}

}