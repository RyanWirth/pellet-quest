package com.ryanwirth.pelletquest.world
{
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.stat.StatChangeType;
	import com.ryanwirth.pelletquest.stat.StatManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.ai.AI;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.entity.EntityType;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.particle.ParticleManager;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class PlayerManager
	{
		private static var _player:Entity;
		private static var _cantMoveDirection:String = "";
		private static var _playerDirection:String = "";
		private static var _touchedScreen:Boolean = false;
		
		public function PlayerManager()
		{
			throw(new Error("PlayerManager: Do not instantiate."));
		}
		
		/**
		 * Changes the reference to the player.
		 * @param	entity The new player reference.
		 */
		public static function setEntityAsPlayer(entity:Entity):void
		{
			if (_player) _player.setPlayer(false);
			_playerDirection = "";
			_cantMoveDirection = "";
			
			_player = entity;
			_player.animate(_player.ANIMATION_TYPE, SaveManager.SAVE.DIRECTION);
			_player.setPlayer(true);
			
			checkForCoins();
			
			MapManager.checkForObjects(entity);
		}
		
		/**
		 * Prepares for the Player by adding event listeners.
		 */
		public static function prepareForGame():void
		{
			GameManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			GameManager.RENDERER.addEventListener(TouchEvent.TOUCH, checkTouch);
		}
		
		/**
		 * Updates the player's desired move direction. This will take effect immediately if the player isn't moving, or when the player
		 * finishes moving into his next tile.
		 * @param	directionType The desired direction of movement.
		 */
		public static function setPlayerMoveDirection(directionType:String):void
		{
			// Don't accept updates to the player move direction while the game is paused!
			if (GameManager.PAUSED || !OptionsManager.CONTROLS) return;
			
			_touchedScreen = true;
			
			if (directionType == "")
			{
				_playerDirection = "";
				return;
			}
			
			if (OptionsManager.EASY_INPUT)
			{
				// Determine if we can walk this way.
				var ai:AI = new AI(PLAYER, -1, -1, false);
				if (ai.CAN_MOVE(directionType) && (PLAYER.DIRECTION != directionType || !PLAYER.IS_MOVING))
				{
					_playerDirection = directionType;
					_cantMoveDirection = "";
				}
				else _cantMoveDirection = directionType;
			}
			else
				_playerDirection = directionType;
			
			if (!PLAYER.IS_MOVING && PLAYER_DIRECTION != "")
				EntityManager.moveEntity(PLAYER, PLAYER_DIRECTION);
			else if (PLAYER.IS_MOVING && PLAYER.DIRECTION == Direction.reverse(PLAYER_DIRECTION)) 
			{
				var eX:int = PLAYER.x;
				var eY:int = PLAYER.y;
				
				EntityManager.interruptMoveEntity(PLAYER);
				EntityManager.moveEntity(PLAYER, PLAYER_DIRECTION);
				
				PLAYER.x = eX;
				PLAYER.y = eY;
			}
		}
		
		/**
		 * Used to indicate when the player sets a move direction that cannot be walked.
		 * @param	cantMove
		 */
		public static function setPlayerCantMoveDirection(cantMoveDirection:String):void
		{
			_cantMoveDirection = cantMoveDirection;
		}
		
		public static function get PLAYER_DIRECTION_CANT_MOVE():String
		{
			return _cantMoveDirection;
		}
		
		/**
		 * Checks the provided TouchEvent to determine if it is a tap on screen by the player.
		 * If it is, determine which segment of the screen the tap is within (four trapezoids
		 * extending to the centered tile) and moves in the corresponding direction.
		 * @param	e
		 */
		private static function checkTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(GameManager.RENDERER, TouchPhase.BEGAN);
			if (!touch) return;
			
			var point:Point = touch.getLocation(GameManager.RENDERER);
			var boundsWidth:Number = GameManager.stageWidth * 0.5 - MapManager.TILE_SIZE;
			var boundsHeight:Number = GameManager.stageHeight * 0.5 - MapManager.TILE_SIZE;
			
			if (point.x <= boundsWidth && (point.y <= boundsHeight ? point.x < point.y : true) && (point.y >= GameManager.stageHeight - boundsHeight ? point.x < GameManager.stageHeight - point.y : true)) setPlayerMoveDirection(Direction.LEFT);
			else if (point.x >= GameManager.stageWidth - boundsWidth && (point.y <= boundsHeight ? GameManager.stageWidth - point.x < point.y : true) && (point.y >= GameManager.stageHeight - boundsHeight ? GameManager.stageWidth - point.x < GameManager.stageHeight - point.y : true)) setPlayerMoveDirection(Direction.RIGHT);
			else if (point.y <= boundsHeight) setPlayerMoveDirection(Direction.UP);
			else if (point.y >= GameManager.stageHeight - boundsHeight) setPlayerMoveDirection(Direction.DOWN);
			else setPlayerMoveDirection("");
		}
		
		/**
		 * Checks keyboard presses and looks for the arrow keys being pressed.
		 * If an arrow key is pressed, moves the player in the corresponding direction.
		 * @param	e
		 */
		private static function checkKey(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				setPlayerMoveDirection(Direction.LEFT);
				break;
			case 38: 
				setPlayerMoveDirection(Direction.UP);
				break;
			case 39: 
				setPlayerMoveDirection(Direction.RIGHT);
				break;
			case 40: 
				setPlayerMoveDirection(Direction.DOWN);
				break;
			case 13: 
				if (GameManager.PAUSED) GameManager.resumeGame();
				else GameManager.pauseGame();
				break;
			case 16: 
				PLAYER.explode();
				break;
			case 17: 
				trace("PlayerManager: Saving!");
				SaveManager.save();
				break;
			}
		}
		
		/**
		 * Called when the Player has been hit by the given entity.
		 * @param	entity The attacking entity.
		 */
		public static function playerHitBy(entity:Entity):void
		{
			if (GameManager.PAUSED) return;
			
			if (StatManager.isStatChangeActive(StatChangeType.POWER_UP))
			{
				// The Power-Up! is active, destroy the offending entity and give the player points.
				ParticleManager.createPopupText(GameManager.stageWidth / 2, GameManager.stageHeight / 2, "+" + LocalizationManager.formatNumber(entity.POINT_VALUE), (entity.POINT_VALUE / 5) * 3);
				SaveManager.SAVE.givePoints(entity.POINT_VALUE);
				UIManager.HUD.updateCoinCount();
				entity.explode();
				return;
			}
			
			// The player does not have the Power-Up! active. Flashes the screen red and starts flashing the last heart on the HUD 
			UIManager.playerHit();
			UIManager.HUD.flashLastHeart();
			
			// Pause the game for a moment
			GameManager.pauseGame();
			
			// After two seconds (2000 ms), resumes the game and allows the player to continue.
			setTimeout(continueHit, 2000, entity);
		}
		
		private static function continueHit(entity:Entity):void
		{
			GameManager.resumeGame();
			
			SaveManager.SAVE.takeLife();
			UIManager.HUD.drawHearts(SaveManager.SAVE.LIVES);
			
			entity.explode();
		}
		
		/**
		 * Determines if the tile the player is currently on has a coin on it.
		 * If the player is on a coin, destroys it and adds it to the consumed list.
		 */
		public static function checkForCoins():void
		{
			if (!SaveManager.SAVE.isCoinConsumed(PLAYER.X_TILE, PLAYER.Y_TILE) && EntityManager.isEntityAt(PLAYER.X_TILE, PLAYER.Y_TILE, EntityType.COIN))
			{
				SaveManager.SAVE.consumeCoin(PLAYER.X_TILE, PLAYER.Y_TILE);
				
				var coin:Entity = EntityManager.getEntityAt(PLAYER.X_TILE, PLAYER.Y_TILE, EntityType.COIN);
				if (coin && coin.IS_COIN_POWERUP) StatManager.activateStatChange(StatChangeType.POWER_UP, 10);
				
				EntityManager.destroyEntityAt(PLAYER.X_TILE, PLAYER.Y_TILE, EntityType.COIN);
				
				if (UIManager.HUD) UIManager.HUD.updateCoinCount();
			}
		}
		
		/**
		 * Calculates a direction based on the EASY_INPUT algorithm.
		 * @return True if the player should continue to move, false if not.
		 */
		public static function determineEasyInputDirection():Boolean
		{
			if (!OptionsManager.EASY_INPUT) return false;
			
			var ai:AI = new AI(PLAYER, -1, -1, false);
			if (PLAYER_DIRECTION_CANT_MOVE != "" && ai.CAN_MOVE(PLAYER_DIRECTION_CANT_MOVE))
			{
				if (PLAYER_DIRECTION != PLAYER_DIRECTION_CANT_MOVE) setPlayerMoveDirection(PLAYER_DIRECTION_CANT_MOVE);
				else if (ai.NUMBER_OF_POSSIBLE_PATHS >= 3) setPlayerCantMoveDirection("");
			}
			else
			{
				if (!ai.CAN_MOVE(PLAYER_DIRECTION) && ai.NUMBER_OF_POSSIBLE_PATHS < 3)
				{
					// We can't move the direction we want to!
					if (ai.NUMBER_OF_POSSIBLE_PATHS == 1) return false; // We don't want to automatically turn around at a dead end.
					else PlayerManager.setPlayerMoveDirection(ai.RANDOM_PATH_EXCEPT(Direction.reverse(PLAYER.DIRECTION)));
				}
				else if (!OptionsManager.EASY_INPUT_WAIT && !ai.CAN_MOVE(PLAYER_DIRECTION)) return false;
				else if (OptionsManager.EASY_INPUT_WAIT && PLAYER.DIRECTION == PLAYER_DIRECTION && ai.NUMBER_OF_POSSIBLE_PATHS >= 3) return false;
			}
			
			return true;
		}
		
		/**
		 * Removes references and event listeners.
		 */
		public static function destroy():void
		{
			_player = null;
			_cantMoveDirection = "";
			_playerDirection = "";
			
			GameManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			GameManager.RENDERER.removeEventListener(TouchEvent.TOUCH, checkTouch);
		}
		
		/**
		 * Provides direct access to the _player Entity.
		 */
		public static function get PLAYER():Entity
		{
			return _player;
		}
		
		/**
		 * Provides access to the current "requested" direction of movement for the player.
		 * Warning: does not correspond to the player's current direction - may be a direction
		 * that waiting to take effect when the player finishes moving.
		 */
		public static function get PLAYER_DIRECTION():String
		{
			return _playerDirection;
		}
		
		/**
		 * Returns true if the player has tapped the screen (updated their movement direction) at least once. False if not.
		 */
		public static function get TOUCHED_SCREEN():Boolean
		{
			return _touchedScreen;
		}
	}

}