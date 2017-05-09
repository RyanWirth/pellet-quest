package com.ryanwirth.pelletquest.ui
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.tile.TileType;
	import flash.utils.getDefinitionByName;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIManager
	{
		public static const REFERENCES:Array = [UIPauseMenu, UIOptionsMenu, UIOptionsGameplayMenu, UIOptionsSoundMenu];
		
		private static var _uiGoodNeighborsFont:UIGoodNeighborsFont;
		private static var _uiGameHUD:UIGameHUD;
		private static var _uiDayNightCycle:UIDayNightCycle;

		private static var _dialogueBoxesOpen:int = 0;
		
		public function UIManager()
		{
		
		}
		
		/**
		 * Creates the GoodNeighbors font for use in the UI.
		 */
		public static function prepareFont():void
		{
			_uiGoodNeighborsFont = new UIGoodNeighborsFont();
		}
		
		/**
		 * Draws the game's HUD and Day/Night cycle. If the GoodNeighbors font has not yet been prepared, prepares it.
		 */
		public static function createGameUI():void
		{
			if (!_uiGoodNeighborsFont) prepareFont();
			
			_uiDayNightCycle = new UIDayNightCycle(SaveManager.SAVE.TIME_HOUR, SaveManager.SAVE.TIME_MINUTE);
			GameManager.RENDERER.addChildTo(_uiDayNightCycle, TileType.HUD);
			
			_uiGameHUD = new UIGameHUD();
			GameManager.RENDERER.addChildTo(_uiGameHUD, TileType.HUD);
			
			// Restore all of the saved icon holders.
			UIIconManager.DECODE_ICON_HOLDERS(SaveManager.SAVE.ICON_HOLDERS);
			
			updateDayNightCycleState();
		}
		
		/**
		 * Depending on the Day/Night cycle state of the map, will update the visible property of the Day/Night cycle to match.
		 */
		public static function updateDayNightCycleState():void
		{
			if (!_uiDayNightCycle) return;
			
			if (!MapManager.DAY_NIGHT) _uiDayNightCycle.visible = false;
			else _uiDayNightCycle.visible = true;
		}
		
		/**
		 * Creates the specified menu and adds it to the HUD layer.
		 * @param	menuType The type of menu to create.
		 * @return A reference to the menu that was just created.
		 */
		public static function createMenu(menuType:String, destroyCallback:Function = null, destroyCallbackParams:Array = null):UIMenu
		{
			var cl:Class = getDefinitionByName("com.ryanwirth.pelletquest.ui." + menuType) as Class;
			var menu:UIMenu = new cl(destroyCallback, destroyCallbackParams) as UIMenu;
			
			GameManager.RENDERER.addChildTo(menu, TileType.HUD);
			
			return menu;
		}
		
		public static function createDialogueBox(dialogueName:String, dialogueNameColor:uint, callback:Function, messages:Array, pauseGame:Boolean = true, isTip:Boolean = false):void
		{
			var messageVector:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < messages.length; i++) messageVector.push(String(messages[i]));
			
			if (pauseGame) 
			{
				GameManager.pauseGame();
				UIIconManager.hide();
			}
			
			var dialogueBox:UIDialogueBox = new UIDialogueBox(dialogueName, dialogueNameColor, messageVector, finishDialogue, callback, isTip ? 2 : 3);
			dialogueBox.x = UIGameHUD.PADDING;
			if (!isTip) dialogueBox.y = GameManager.stageHeight - dialogueBox.height - UIGameHUD.PADDING;
			else dialogueBox.y = UIGameHUD.PADDING + MapManager.TILE_SIZE;
			HUD.addChild(dialogueBox);
			
			_dialogueBoxesOpen++;
		}
		
		private static function finishDialogue(callback:Function):void
		{
			_dialogueBoxesOpen--;
			
			if (_dialogueBoxesOpen == 0) 
			{
				GameManager.resumeGame();
				UIIconManager.show();
			}
			
			if (callback != null) callback();
		}
		
		public static function createQuestionBox(dialogueName:String, dialogueNameColor:uint, question:String, answers:Array, callback:Function):void
		{
			GameManager.pauseGame();
			UIIconManager.hide();
			
			var questionBox:UIQuestionBox = new UIQuestionBox(dialogueName, dialogueNameColor, question, answers, finishQuestion, callback, 3);
			questionBox.x = UIGameHUD.PADDING;
			questionBox.y = GameManager.stageHeight - questionBox.height - UIGameHUD.PADDING;
			HUD.addChild(questionBox);
			
			_dialogueBoxesOpen++;
		}
		
		/**
		 * Called when a UIQuestionBox returns an answer.
		 * @param	callback The callback to the question caller.
		 * @param	answer The answer given by the Player.
		 */
		private static function finishQuestion(callback:Function, answer:String):void
		{
			_dialogueBoxesOpen--;
			
			if (_dialogueBoxesOpen == 0)
			{
				GameManager.resumeGame();
				UIIconManager.show();
			}
			
			if (callback != null) callback(answer);
		}
		
		/**
		 * Flashes the screen with the provided colour.
		 * @param	color The color to flash the screen.
		 */
		public static function playerHit(color:uint = 0xFF0000):void
		{
			var _uiPlayerHit:UIPlayerHit = new UIPlayerHit(color);
			GameManager.RENDERER.addChildTo(_uiPlayerHit, TileType.HUD);
		}
		
		public static function fadeInOut(callback:Function):void
		{
			var _uiFadeInOut:UIFadeInOut = new UIFadeInOut(0x000000, 0.5, callback);
			GameManager.RENDERER.addChildTo(_uiFadeInOut, TileType.HUD);
		}
		
		/**
		 * Provides direct access to the game's HUD.
		 */
		public static function get HUD():UIGameHUD
		{
			return _uiGameHUD;
		}
		
		/**
		 * Provides direct access to the game's Day/Night cycle.
		 */
		public static function get DAY_NIGHT_CYCLE():UIDayNightCycle
		{
			return _uiDayNightCycle;
		}
		
		/**
		 * Returns the number of dialogue boxes currently open.
		 */
		public static function get DIALOGUE_BOXES_OPEN():int
		{
			return _dialogueBoxesOpen;
		}
	
	}

}