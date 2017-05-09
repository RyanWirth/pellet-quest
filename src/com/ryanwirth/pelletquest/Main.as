package com.ryanwirth.pelletquest
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.WorldManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.ui.MenuType;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(Event.ADDED, startGame);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// Keep the application from dimming.
			//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function startGame(e:Event):void
		{
			stage.removeEventListener(Event.ADDED, startGame);
			
			// Entry point
			GameManager.stage = stage;
			GameManager.startGame();
		}
		
		private function deactivate(e:Event):void 
		{
			SaveManager.save();
			
			// Attempt to pause the game.
			if (WorldManager.GAME_STARTED && GameManager.PAUSED == false) UIManager.createMenu(MenuType.PAUSE);
			
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}