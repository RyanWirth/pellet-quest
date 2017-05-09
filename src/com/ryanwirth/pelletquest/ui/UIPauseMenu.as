package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.localization.Language;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import flash.utils.setTimeout;
	import com.greensock.TweenNano;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIPauseMenu extends UIMenu
	{
		
		public function UIPauseMenu(destroyCallback:Function, destroyCallbackParams:Array)
		{
			super(destroyCallback, destroyCallbackParams);
			
			construct();
		}
		
		override public function construct():void
		{
			UIManager.HUD.visible = false;
			GameManager.pauseGame();
			
			_window = new UIScrollSmall(MapManager.CHUNK_WIDTH < 8 ? MapManager.CHUNK_WIDTH <= 5 ? 5 : MapManager.CHUNK_WIDTH - 1 : 8, MapManager.CHUNK_HEIGHT < 6 ? MapManager.CHUNK_HEIGHT <= 4 ? 4 : MapManager.CHUNK_HEIGHT - 1 : 6, Language.MENU_PAUSED);
			_window.x = Math.round(GameManager.stageWidth / 2 - (_window.width - 17) / 2 - 4);
			_window.y = GameManager.stageHeight / 2 - _window.height / 2;
			this.addChild(_window);
			
			_windowCenterXAxis = Math.round(_window.x + (_window.width - 17) / 2 + 4);
			
			createButton(closeMenu, Language.MENU_CONTINUE);
			createButton(save, Language.MENU_SAVE);
			createButton(optionsMenu, Language.MENU_OPTIONS);
			createButton(closeMenu, Language.MENU_QUIT);
			
			alignElements();
		}
		
		private function save():void
		{
			SaveManager.save();
			
			(_elements[1] as UIButton).updateLabel(Language.MENU_SAVING);
			
			setTimeout(endSave, 1000);
		}
		
		private function endSave():void
		{
			if (_elements && _elements.length > 1)
			{
				(_elements[1] as UIButton).updateLabel(Language.MENU_SAVE);
			}
		}
		
		private function optionsMenu():void
		{
			NULL_CALLBACK();
			
			TweenNano.to(this, 0.25, { x: -GameManager.stageWidth, onComplete:destroy } );
			
			var menu:UIMenu = UIManager.createMenu(MenuType.OPTIONS, UIManager.createMenu, [MenuType.PAUSE]);
			menu.x = GameManager.stageWidth;
			
			TweenNano.to(menu, 0.25, { x:0 } );
		}
	
	}

}