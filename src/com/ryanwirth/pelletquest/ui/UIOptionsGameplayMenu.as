package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.localization.LocaleType;
	import com.greensock.TweenNano;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIOptionsGameplayMenu extends UIMenu
	{	
		public function UIOptionsGameplayMenu(destroyCallback:Function, destroyCallbackParams:Array = null)
		{
			super(destroyCallback, destroyCallbackParams);
			
			construct();
		}
		
		override public function construct():void
		{
			if (UIManager.HUD) UIManager.HUD.visible = false;
			GameManager.pauseGame();
			
			_window = new UIScrollSmall(MapManager.CHUNK_WIDTH < 8 ? MapManager.CHUNK_WIDTH <= 5 ? 5 : MapManager.CHUNK_WIDTH - 1 : 8, MapManager.CHUNK_HEIGHT < 6 ? MapManager.CHUNK_HEIGHT <= 4 ? 4 : MapManager.CHUNK_HEIGHT - 1 : 6, Language.MENU_OPTIONS);
			_window.x = Math.round(GameManager.stageWidth / 2 - (_window.width - 17) / 2 - 4);
			_window.y = GameManager.stageHeight / 2 - _window.height / 2;
			this.addChild(_window);
			
			_windowCenterXAxis = Math.round(_window.x + (_window.width - 17) / 2 + 4);
			
			enterGame();
		}
		
		private function pressBack():void
		{
			TweenNano.to(this, 0.25, { x:GameManager.stageWidth, onComplete:destroy } );
			
			var menu:UIMenu = UIManager.createMenu(MenuType.OPTIONS);
			menu.x = -GameManager.stageWidth;
			
			TweenNano.to(menu, 0.25, { x:0 } );
			
			NULL_CALLBACK();
		}
		
		private function enterGame():void
		{
			destroyElements();
			
			_window.updateTitle(Language.MENU_GAMEPLAY_OPTIONS);
			
			createButton(switchFPS, Language.MENU_FPS + ": " + OptionsManager.FPS);
			createButton(switchScale, Language.MENU_SCALE + ": " + OptionsManager.SCALE + "x");
			createCheckBox(toggleEasyInput, Language.MENU_SIMPLE_INPUT, OptionsManager.EASY_INPUT);
			createButton(pressBack, Language.MENU_BACK);
			
			alignElements();
		}
		
		private function switchScale():void
		{
			var newScale:Number = OptionsManager.SCALE;
			if (newScale == 1) newScale = 2;
			else if (newScale == 2) newScale = 3;
			else if (newScale == 3) newScale = 4;
			else if (newScale == 4) newScale = 1;
			
			OptionsManager.setScale(newScale);
			
			if(UIManager.HUD) UIManager.HUD.resizeHUD();
			UIIconManager.resizeHUD();
			
			destroyElements();
			this.removeChild(_window);
			_window.destroy();
			_window = null;
			
			construct();
			
			enterGame();
		}
		
		private function switchFPS():void 
		{
			var newFPS:int = OptionsManager.FPS;
			if (newFPS == 24) newFPS = 30;
			else if (newFPS == 30) newFPS = 60;
			else if (newFPS == 60) newFPS = 24;
			
			OptionsManager.setFPS(newFPS);
			
			(_elements[0] as UIButton).updateLabel(Language.MENU_FPS + ": " + newFPS);
		}
		
		private function toggleEasyInput(state:Boolean):void
		{
			OptionsManager.setEasyInput(state);
		}
	
	}

}