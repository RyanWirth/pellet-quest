package com.ryanwirth.pelletquest.commands 
{
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.entity.AnimationType;
	import com.ryanwirth.pelletquest.ui.UIIconManager;
	import com.ryanwirth.pelletquest.ui.IconType;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.greensock.TweenNano;
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class TipCommand extends Command
	{
		private var _tipType:String;
		private var _tipDelay:int;
		private var _tipDuration:int;
		
		public function TipCommand(tipType:String, tipDelay:int, tipDuration:int) 
		{
			_tipType = tipType;
			_tipDelay = tipDelay;
			_tipDuration = tipDuration;
			
			super(CommandType.TIP);
		}
		
		override public function execute(entity:Entity):void
		{
			TweenNano.delayedCall(_tipDelay, showTip, [_tipType, _tipDuration]);
			
			CommandManager.nextCommand(entity);
		}
		
		public static function showTip(tipType:String, tipDuration:Number):void
		{
			UIIconManager.addIconHolder(IconType.ICON_BLUE_FEATHER, Language.TIP_PREFIX + ": " + TipType.getTipTitle(tipType) + " ({{t}})", TipType.getTipDescription(tipType), true, 0xFFFFFF, 0xFFFFFF, tipDuration);
		}
		
	}

}