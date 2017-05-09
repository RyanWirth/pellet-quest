package com.ryanwirth.pelletquest.stat 
{
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	import com.ryanwirth.pelletquest.world.entity.WalkSpeed;
	import com.ryanwirth.pelletquest.world.entity.EntityManager
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class PowerUpStatChange extends StatChange
	{
		
		public function PowerUpStatChange(duration:Number) 
		{
			super(StatChangeType.POWER_UP, duration);
		}
		
		override public function activate():void
		{
			UIManager.playerHit(0x00DDFF);
			
			UIManager.HUD.powerUpOn();
			
			PlayerManager.PLAYER.setWalkSpeed(WalkSpeed.FAST);
			PlayerManager.PLAYER.setFrameRate(20);
			
			EntityManager.activateEntities();
		}
		
		override public function tick():void
		{
			if (DURATION <= 3)
			{
				if (DURATION != 3) UIManager.HUD.flashPowerUpText();
				
				if (PlayerManager.PLAYER.ACTIVATED) PlayerManager.PLAYER.deactivate();
				else PlayerManager.PLAYER.activate();
			} else
			{
				if (PlayerManager.PLAYER.ACTIVATED == false) PlayerManager.PLAYER.activate();
				if (UIManager.HUD.POWER_UP_ON == false) UIManager.HUD.powerUpOff();
			}
		}
		
		override public function deactivate():void
		{
			UIManager.HUD.powerUpOff();
			
			PlayerManager.PLAYER.setWalkSpeed(-1);
			PlayerManager.PLAYER.setFrameRate( -1);
			
			EntityManager.deactivateEntities();
		}
		
	}

}