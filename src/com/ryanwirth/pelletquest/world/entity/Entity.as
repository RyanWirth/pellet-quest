package com.ryanwirth.pelletquest.world.entity
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.commands.Command;
	import com.ryanwirth.pelletquest.GameManager;
	import com.ryanwirth.pelletquest.save.SaveManager;
	import com.ryanwirth.pelletquest.world.ai.AIManager;
	import com.ryanwirth.pelletquest.world.ai.AIType;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.particle.ParticleManager;
	import flash.utils.getDefinitionByName;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Entity extends Sprite
	{
		private var _type:String;
		private var _xTile:int;
		private var _yTile:int;
		private var _animationType:String = "";
		private var _direction:String = "";
		private var _atlas:TextureAtlas;
		private var _defaultFrameRate:Number = 8;
		private var _currentFrameRate:Number = 8;
		private var _defaultWalkSpeed:Number = 4;
		private var _walkSpeed:Number = 4;
		private var _yOffset:int = 0;
		private var _isMoving:Boolean = false;
		private var _isPlayer:Boolean = false;
		private var _entityType:String;
		private var _aiType:String;
		private var _exploding:Boolean = false;
		private var _fromRegion:String = "";
		private var _pointValue:int = 100;
		private var _isEnemy:Boolean = true;
		private var _save:Boolean = true;
		
		// Special variables for tinting colors, powerup flags, etc.
		private var _coinPowerup:Boolean = false;
		private var _activated:Boolean = false;
		private var _initialColor:uint;
		private var _activatedColor:uint = 0x00e0ff;
		private var _commands:Vector.<Command>;
		private var _executingCommand:Boolean = false;
		private var _name:String = "";
		
		private var _animation:MovieClip;
		private var _parts:Vector.<EntityPart>;
		
		public function Entity(atlas:TextureAtlas, entityType:String, xTile:int, yTile:int, direction:String, initialAnimationType:String = AnimationType.WALK, defaultFrameRate:int = 8, walkSpeed:Number = 4, yOffset:int = 0, aiType:String = AIType.NONE, entityParts:Array = null, pointValue:int = 5, isEnemy:Boolean = true, playOnCreation:Boolean = true)
		{
			_atlas = atlas;
			_defaultFrameRate = defaultFrameRate;
			_currentFrameRate = _defaultFrameRate;
			_yOffset = yOffset;
			_defaultWalkSpeed = walkSpeed;
			_walkSpeed = walkSpeed;
			_entityType = entityType;
			_aiType = aiType;
			_pointValue = pointValue;
			_isEnemy = isEnemy;
			_parts = new Vector.<EntityPart>();
			_commands = new Vector.<Command>();
			
			touchable = false;
			
			updateLocation(xTile, yTile);
			
			createParts(entityParts, initialAnimationType, direction);
			
			animate(initialAnimationType, direction, playOnCreation);
		}
		
		/**
		 * Explodes this entity into its pixels, then destroys it.
		 */
		public function explode():void
		{
			if (!_animation || _exploding) return;
			_exploding = true;
			
			ParticleManager.createEntityExplosion(this, _yOffset);
			
			EntityManager.destroyEntity(this, true);
		}
		
		/**
		 * Plays the requested animationType and direction. If both the animationType and direction are already being played, fails silently.
		 * @param	animationType The new AnimationType to play.
		 * @param	direction The new direction the entity is facing.
		 * @param	play True if the animation should play automatically, false if not.
		 */
		public function animate(animationType:String, direction:String, play:Boolean = true):void
		{
			// If the entity is being exploded, don't allow the animation to be updated!
			if (_exploding || !_atlas) return;
			
			// Make sure all pending "stopWalking" calls are killed - we're (most likely) going to move right now!
			TweenMax.killDelayedCallsTo(stopWalking);
			
			// If the animation requested is the same one we're already playing, return.
			if (_animationType == animationType && _direction == direction) return;
			
			// Update both the animationType and the direction of this entity.
			_animationType = animationType;
			_direction = direction;
			
			// If this is the player, make sure this direction is updated in the save file.
			if (IS_PLAYER) SaveManager.SAVE.updateDirection(DIRECTION);
			
			// Clean up the old animation.
			destroyAnimation();
			
			// Create the new animation MovieClip!
			_animation = new MovieClip(_atlas.getTextures(_animationType + "_" + _direction), _currentFrameRate);
			
			// Tinting and color restoration.
			_initialColor = _animation.color;
			if (_activated) _animation.color = _activatedColor;
			
			// Add the animation to the stage.
			_animation.smoothing = TextureSmoothing.NONE;
			_animation.y = MapManager.TILE_SIZE - _animation.height + _yOffset;
			this.addChild(_animation);
			
			if (!play) _animation.stop();
			
			// Make sure all child parts are updated, too.
			updatePartsAnimation();
			
			// Add the animation to the JUGGLER to ensure its frames are updated.
			GameManager.GAME_JUGGLER.add(_animation);
			
			fixAnimation();
		}
		
		/**
		 * Designed to be overridden. Called when the Entity's animation is updated.
		 */
		protected function fixAnimation():void
		{
			
		}
		
		/**
		 * Changes the entity's walking speed. If walkSpeed is set to -1, resets the walkSpeed to its default.
		 * @param	walkSpeed The new walk speed (in tiles per second).
		 */
		public function setWalkSpeed(walkSpeed:Number):void
		{
			if (walkSpeed == -1) _walkSpeed = _defaultWalkSpeed;
			else _walkSpeed = walkSpeed;
		}
		
		/**
		 * Changes the entity's animation framerate. If the frameRate is set to -1, resets the framerate to its default.
		 * @param	frameRate The new framerate.
		 */
		public function setFrameRate(frameRate:Number):void
		{
			// If the frameRate given is -1, reset it to the default framerate.
			if (frameRate == -1) frameRate = _defaultFrameRate;
			
			// Change the FPS of this animation!
			_currentFrameRate = frameRate;
			if (_animation) _animation.fps = _currentFrameRate;
			
			// Propagate changes to the entity's parts.
			for (var i:int = 0, l:int = _parts.length; i < l; i++) _parts[i].setFrameRate(_currentFrameRate);
		}
		
		/**
		 * Marks the entity as a coin powerup.
		 */
		public function setCoinPowerup():void
		{
			_coinPowerup = true;
			
			animate(AnimationType.WALK, Direction.DOWN, true);
		}
		
		/**
		 * Returns true if the coin is a tinted powerup, false if not.
		 */
		public function get IS_COIN_POWERUP():Boolean
		{
			return _coinPowerup;
		}
		
		/**
		 * Tints the entity to the _activatedColor.
		 */
		public function activate():void
		{
			_activated = true;
			
			if (_animation) _animation.color = _activatedColor;
		}
		
		/**
		 * Turns tinting off.
		 */
		public function deactivate():void
		{
			_activated = false;
			
			if (_animation) _animation.color = _initialColor;
		}
		
		/**
		 * Returns true if the entity is tinted, false if not.
		 */
		public function get ACTIVATED():Boolean
		{
			return _activated;
		}
		
		/**
		 * Pauses the current animation.
		 */
		public function pause():void
		{
			if (_animation) _animation.pause();
		}
		
		/**
		 * Resumes the current animation.
		 */
		public function play():void
		{
			if (_animation) _animation.play();
		}
		
		/**
		 * Sets a "timer" that will allow the Entity to begin walking again without stopping the animation.
		 * If animate() is not called within the pause duration (0.25 seconds), the walking animation is stopped.
		 */
		public function prepareToStopWalking():void
		{
			TweenMax.delayedCall(0.05, stopWalking);
		}
		
		/**
		 * Switches the walking animation of the entity into a standing one that matches the entity's current direction.
		 */
		private function stopWalking():void
		{
			if (!IS_PLAYER) return;
			
			animate(AnimationType.STAND, DIRECTION);
		}
		
		/**
		 * Removes and disposes of the current animation.
		 */
		private function destroyAnimation():void
		{
			if (!_animation) return;
			
			_animation.removeEventListeners();
			GameManager.GAME_JUGGLER.remove(_animation);
			this.removeChild(_animation, true);
			_animation = null;
		}
		
		/**
		 * Cycles through all the parts this entity has and updates their animation and moves it to the top of the display list.
		 */
		private function updatePartsAnimation():void
		{
			if (!_parts) return;
			
			for (var i:int = 0; i < _parts.length; i++)
			{
				_parts[i].updateAnimation(_animationType, _direction);
				_parts[i].y = MapManager.TILE_SIZE - _animation.height + _yOffset;
				this.setChildIndex(_parts[i], this.numChildren - 1);
			}
		}
		
		/**
		 * Constructs all of the parts that make up this entity and adds them to the display list.
		 * @param	parts The array of EntityPartTypes to create.
		 * @param	initialAnimationType The animation to play upon construction.
		 * @param	initialDirection The direction of the animation to play upon construction.
		 */
		public function createParts(parts:Array, initialAnimationType:String, initialDirection:String):void
		{
			if (!parts) return;
			
			for (var i:int = 0; i < parts.length; i++)
			{
				var cl:Class = getDefinitionByName("com.ryanwirth.pelletquest.world.entity." + parts[i]) as Class;
				var part:EntityPart = new cl(initialAnimationType, initialDirection, _defaultFrameRate) as EntityPart;
				this.addChild(part);
				_parts.push(part);
			}
			parts = null;
		}
		
		/**
		 * Cleans up and destroys all the parts this entity has.
		 */
		private function destroyParts():void
		{
			if (!_parts) return;
			
			for (var i:int = 0; i < _parts.length; i++)
			{
				this.removeChild(_parts[i]);
				_parts[i].destroy();
				_parts[i] = null;
			}
			_parts = null;
		}
		
		/**
		 * Cleans up the entity by destroying the current animation, any optional entity parts, and removing the reference to the TextureAtlas.
		 */
		public function destroy():void
		{
			destroyAnimation();
			destroyParts();
			_atlas = null;
			_commands = null;
		}
		
		/**
		 * Provides direct access to the animation MovieClip object.
		 */
		public function get ANIMATION():MovieClip
		{
			return _animation;
		}
		
		/**
		 * Provides access to the entity's current x-coordinate.
		 */
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		/**
		 * Provides access to the entity's current y-coordinate;
		 */
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		/**
		 * Returns true if the entity is currently being tweened from one position to another.
		 */
		public function get IS_MOVING():Boolean
		{
			return _isMoving;
		}
		
		/**
		 * Changes the _isMoving state of the entity.
		 * @param	moving True if the entity is now moving, false if not.
		 */
		public function setMoving(moving:Boolean):void
		{
			_isMoving = moving;
		}
		
		/**
		 * Returns true if this entity is currently set as the Player entity within PlayerManager.
		 */
		public function get IS_PLAYER():Boolean
		{
			return _isPlayer;
		}
		
		/**
		 * Sets whether or not this entity is currently the Player within PlayerManager.
		 * @param	isPlayer
		 */
		public function setPlayer(isPlayer:Boolean):void
		{
			_isPlayer = isPlayer;
			
			if (IS_PLAYER) _aiType = ""; // The player does not need AI.
		}
		
		/**
		 * Ensures the entity is at its current position, then changes the entity's current x- and y-coordinates.
		 * @param	xTile The new x-coordinate.
		 * @param	yTile The new y-coordinate.
		 */
		public function updateLocation(xTile:int, yTile:int):void
		{
			this.x = _xTile * MapManager.TILE_SIZE;
			this.y = _yTile * MapManager.TILE_SIZE;
			
			_xTile = xTile;
			_yTile = yTile;
			
			if (IS_PLAYER) SaveManager.SAVE.updateLocation(xTile, yTile);
		}
		
		/**
		 * Provides the direction the entity is currently facing.
		 */
		public function get DIRECTION():String
		{
			return _direction;
		}
		
		/**
		 * Provides the AnimationType the entity is currently playing.
		 */
		public function get ANIMATION_TYPE():String
		{
			return _animationType;
		}
		
		/**
		 * Provides the entity's default walking speed (measured in tiles per second.)
		 */
		public function get WALK_SPEED():Number
		{
			return _walkSpeed;
		}
		
		/**
		 * Provides the type of this entity.
		 */
		public function get ENTITY_TYPE():String
		{
			return _entityType;
		}
		
		/**
		 * A function designed to be overridden with some form of AI. Called every time the entity finishes moving into a tile.
		 */
		public function runAI(getInitialDirection:Boolean = false):void
		{
			if (_aiType != AIType.NONE)
				AIManager.findPath(_aiType, this, getInitialDirection);
		}
		
		/**
		 * Sets a timer whereby the entity will wait to run its AI again.
		 */
		public function prepareForRunningAI():void
		{
			TweenMax.delayedCall(1 / _walkSpeed, runAI);
		}
		
		/**
		 * Changes the AI type of the entity. Takes effect on the next AI run.
		 * @param	aiType The new AI type.
		 */
		public function setAIType(aiType:String):void
		{
			_aiType = aiType;
		}
		
		/**
		 * Returns the "exploding" state of the Entity. True means that the entity has been broken down into its pixels and is currently being animated.
		 */
		public function get EXPLODED():Boolean
		{
			return _exploding;
		}
		
		/**
		 * Changes the name of the region that the entity is from. Used in reducing spawn counts of the region when this entity dies.
		 * @param	regionName The name of the region the entity is from.
		 */
		public function setFromRegion(regionName:String):void
		{
			_fromRegion = regionName;
		}
		
		/**
		 * Returns the name of the region from where this entity originated.
		 */
		public function get FROM_REGION():String
		{
			return _fromRegion;
		}
		
		/**
		 * Returns the point value of this entity.
		 */
		public function get POINT_VALUE():int
		{
			return _pointValue;
		}
		
		public function get IS_ENEMY():Boolean
		{
			return _isEnemy;
		}
		
		/**
		 * If true, the save file will include this entity in its data. If false, the entity will be omitted.
		 */
		public function get SAVE():Boolean
		{
			return _save;
		}
		
		/**
		 * Forces the save file to not include this entity in its save data.
		 */
		public function disableSaving():void
		{
			_save = false;
		}
		
		/**
		 * Returns the command vector.
		 */
		public function get COMMANDS():Vector.<Command>
		{
			return _commands;
		}
		
		/**
		 * If the entity is currently executing a command, returns true. If not, returns false.
		 */
		public function get EXECUTING_COMMAND():Boolean
		{
			return _executingCommand;
		}
		
		/**
		 * Updates the EXECUTING_COMMAND flag.
		 * @param	executingCommand If the entity has begun to execute a command, true. If the entity has just finished, false.
		 */
		public function setExecutingCommand(executingCommand:Boolean):void
		{
			_executingCommand = executingCommand;
		}
		
		/**
		 * Updates the entity's name.
		 * @param	name The new entity name.
		 */
		public function setName(name:String):void
		{
			_name = name;
		}
		
		/**
		 * Returns the entity's name if has been set. If it hasn't been set, returns an empty string.
		 */
		public function get NAME():String
		{
			return _name;
		}
	}

}