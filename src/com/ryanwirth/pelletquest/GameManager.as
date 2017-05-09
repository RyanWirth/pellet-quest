package com.ryanwirth.pelletquest
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.stat.StatManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.WorldManager;
	import com.ryanwirth.pelletquest.world.WorldRenderer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class GameManager
	{
		private static var _stage:Stage;
		private static var _starling:Starling;
		private static var _fpsCounter:FPSCounter;
		private static var _paused:Boolean = false;
		private static var _gameJuggler:Juggler;
		
		public static var MAXIMUM_SPAWN_DISTANCE:Number = 15;
		
		public function GameManager()
		{
			throw(new Error("GameManager: Do not instantiate."));
		}
		
		/**
		 * Begins the game by initializing Starling. The reference to the stage must be set prior to calling startGame().
		 */
		public static function startGame():void
		{
			if (!stage) throw(new Error("Stage reference not set."));
			
			_starling = new Starling(WorldRenderer, stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), null, "auto", "auto");
			
			updateScale(calculateScaleFactor());
			_starling.addEventListener(Event.CONTEXT3D_CREATE, starlingContext3D);
			_starling.addEventListener(Event.ROOT_CREATED, starlingRootCreated);
			_starling.start();
		}
		
		/**
		 * Updates the display scaling and ripples the change down to the WorldManager.
		 * @param	scale The new scale factor.
		 */
		public static function updateScale(scale:Number):void
		{
			_starling.stage.stageWidth = stageFullWidth / scale;
			_starling.stage.stageHeight = stageFullHeight / scale;
			
			WorldManager.updateScale(scale);
		}
		
		/**
		 * Automatically determines the best scale factor for the current device.
		 * @return The scale factor as a Number.
		 */
		private static function calculateScaleFactor():Number
		{
			if (stageFullHeight <= 240 || stageFullWidth <= 240) return 1;
			else if (stageFullHeight <= 320 || stageFullWidth <= 320) return 2;
			else if (stageFullHeight <= 1024 || stageFullWidth <= 1024) return 3;
			else return 4;
		}
		
		/**
		 * Called when Starling has created the Context3D instance. Can be used to update a loading screen or similar.
		 * @param	e
		 */
		private static function starlingContext3D(e:Event):void
		{
			_starling.removeEventListener(Event.CONTEXT3D_CREATE, starlingContext3D);
			
			trace("GameManager: Starling Context3D created.");
		}
		
		/**
		 * Called when Starling is ready to proceed and the world can be created.
		 * @param	e
		 */
		private static function starlingRootCreated(e:Event):void
		{
			_starling.removeEventListener(Event.ROOT_CREATED, starlingRootCreated);
			
			createGameJuggler();
			
			// Load the save!
			SaveManager.loadSave("Ryan");
			
			// Initialize localization!
			LocalizationManager.initializeLocalization(SaveManager.SAVE.LOCALE_TYPE);
			
			// Set up the OptionsManager
			OptionsManager.setFPS(SaveManager.SAVE.FPS);
			OptionsManager.setScale(SaveManager.SAVE.SCALE != 0 ? SaveManager.SAVE.SCALE : calculateScaleFactor());
			OptionsManager.setEasyInput(SaveManager.SAVE.EASY_INPUT);
			OptionsManager.setMusic(SaveManager.SAVE.MUSIC);
			OptionsManager.setSoundEffects(SaveManager.SAVE.SOUND_EFFECTS);
			
			// Update the CommandManager states object
			CommandManager.loadStatesObject(SaveManager.SAVE.STATES);
			
			// Begin the game.
			WorldManager.startGame();
			
			// Make sure the font is loaded and ready.
			UIManager.prepareFont();
			
			// Create the HUD
			UIManager.createGameUI();
			
			// Make sure stat changes are loaded.
			StatManager.DECODE_STAT_CHANGES(SaveManager.SAVE.STAT_CHANGES);
			
			// Display the FPS counter in the top-left corner.
			createFPSCounter();
		}
		
		/**
		 * Pauses the game by pausing all tweens and updating the pause flag.
		 */
		public static function pauseGame():void
		{
			if (_paused) return;
			_paused = true;
			
			// Pause all tweens!
			TweenMax.pauseAll();
		}
		
		/**
		 * Resumes the game by resuming all tweens and updating the pause flag.
		 */
		public static function resumeGame():void
		{
			if (!_paused) return;
			_paused = false;
			
			// Resume all tweens!
			TweenMax.resumeAll();
		}
		
		/**
		 * Creates the FPSCounter and places it on the screen.
		 */
		static private function createFPSCounter():void
		{
			_fpsCounter = new FPSCounter(0, stageFullHeight - 15, 0xFFFFFF, true, 0x000000);
			stage.addChild(_fpsCounter);
		}
		
		/**
		 * Sets the reference to the stage in order to be used in Starling's initialization.
		 */
		public static function set stage(stageObject:Stage):void
		{
			_stage = stageObject;
		}
		
		/**
		 * Provides a reference to the stage of the application. Typically, RENDERER is used to add elements to application's screen instead.
		 */
		public static function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * Returns either the stage's width or the device's width, depending on the type of build.
		 */
		public static function get stageFullWidth():int
		{
			return stage.fullScreenWidth > stage.fullScreenHeight ? stage.fullScreenWidth : stage.fullScreenHeight;
		}
		
		/**
		 * Returns either the stage's height or the device's height, depending on the type of build.
		 */
		public static function get stageFullHeight():int
		{
			return stage.fullScreenHeight < stage.fullScreenWidth ? stage.fullScreenHeight : stage.fullScreenWidth;
		}
		
		/**
		 * Returns the horizontal size of Starling's stage - that is, the scaled down copy.
		 */
		public static function get stageWidth():int
		{
			return _starling.stage.stageWidth > _starling.stage.stageHeight ? _starling.stage.stageWidth : _starling.stage.stageHeight;
		}
		
		/**
		 * Returns the vertical size of Starling's stage - that is, the scaled down copy.
		 */
		public static function get stageHeight():int
		{
			return _starling.stage.stageHeight < _starling.stage.stageWidth ? _starling.stage.stageHeight : _starling.stage.stageWidth;
		}
		
		/**
		 * Provides a reference to the root WorldRenderer class usually in order to add Sprites or MovieClips to the Starling DisplayList.
		 */
		public static function get RENDERER():WorldRenderer
		{
			return _starling.root as WorldRenderer;
		}
		
		/**
		 * Provides access to Starling's animation juggler.
		 */
		public static function get GAME_JUGGLER():Juggler
		{
			return _gameJuggler;
		}
		
		public static function get JUGGLER():Juggler
		{
			return _starling.juggler;
		}
		
		/**
		 * Provides the paused state of the GameManager.
		 */
		public static function get PAUSED():Boolean
		{
			return _paused;
		}
		
		/**
		 * Provides direct access to the Starling instance.
		 */
		public static function get STARLING():Starling
		{
			return _starling;
		}
		
		public static function createGameJuggler():void
		{
			_gameJuggler = new Juggler();
			RENDERER.addEventListener(EnterFrameEvent.ENTER_FRAME, updateGameJuggler);
		}
		
		private static function updateGameJuggler(e:EnterFrameEvent):void
		{
			if (_paused) return;
			
			_gameJuggler.advanceTime(e.passedTime);
		}
	
	}

}