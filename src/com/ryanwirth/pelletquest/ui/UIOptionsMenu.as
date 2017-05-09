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
	public class UIOptionsMenu extends UIMenu
	{	
		public function UIOptionsMenu(destroyCallback:Function, destroyCallbackParams:Array = null)
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
			
			menuOptions();
		}
		
		private function menuOptions():void
		{
			destroyElements();
			
			_window.updateTitle(Language.MENU_OPTIONS);
			
			createButton(switchLanguage, Language.LANGUAGE_NAME);
			createButton(enterGame, Language.MENU_GAMEPLAY_OPTIONS);
			createButton(enterSound, Language.MENU_SOUND_OPTIONS);
			createButton(pressBack, Language.MENU_BACK);
			
			alignElements();
		}
		
		private function pressBack():void
		{
			TweenNano.to(this, 0.25, { x:GameManager.stageWidth, onComplete:destroy } );
			
			var menu:UIMenu = UIManager.createMenu(DESTROY_CALLBACK_PARAMS ? DESTROY_CALLBACK_PARAMS[0] : MenuType.PAUSE);
			menu.x = -GameManager.stageWidth;
			
			TweenNano.to(menu, 0.25, { x:0 } );
			
			NULL_CALLBACK();
		}
		
		private function switchLanguage():void
		{
			var nextLocaleType:String = LocaleType.getNextLocaleType(OptionsManager.CURRENT_LOCALE_TYPE);
			LocalizationManager.loadLocaleType(nextLocaleType);
			
			if(UIManager.HUD) UIManager.HUD.updatePowerUpText();
			
			_window.updateTitle(Language.MENU_OPTIONS);
			
			destroyElements();
			menuOptions();
		}
		
		private function enterGame():void
		{
			NULL_CALLBACK();
			
			TweenNano.to(this, 0.25, { x: -GameManager.stageWidth, onComplete:destroy } );
			
			var menu:UIMenu = UIManager.createMenu(MenuType.OPTIONS_GAMEPLAY);
			menu.x = GameManager.stageWidth;
			
			TweenNano.to(menu, 0.25, { x:0 } );
		}
		
		private function enterSound():void 
		{
			NULL_CALLBACK();
			
			TweenNano.to(this, 0.25, { x: -GameManager.stageWidth, onComplete:destroy } );
			
			var menu:UIMenu = UIManager.createMenu(MenuType.OPTIONS_SOUND);
			menu.x = GameManager.stageWidth;
			
			TweenNano.to(menu, 0.25, { x:0 } );
		}
	
	}

}