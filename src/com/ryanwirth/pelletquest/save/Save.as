package com.ryanwirth.pelletquest.save
{
	import com.ryanwirth.pelletquest.commands.CommandManager;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import com.ryanwirth.pelletquest.options.OptionsManager;
	import com.ryanwirth.pelletquest.stat.StatManager;
	import com.ryanwirth.pelletquest.ui.UIIconManager;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.map.MapType;
	import flash.geom.Point;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Save
	{
		private var so:SharedObject;
		
		// Data
		private var _saveName:String;
		private var _coins:Vector.<Point>;
		private var _xTile:int;
		private var _yTile:int;
		private var _direction:String;
		private var _lives:int = 0;
		private var _points:int = 0;
		private var _time_hour:int = 0;
		private var _time_minute:int = 0;
		private var _statchanges:Vector.<Object>;
		private var _iconholders:Vector.<Object>;
		private var _localetype:String;
		private var _fps:int;
		private var _scale:Number = 3;
		private var _easyInput:Boolean = true;
		private var _music:Boolean = true;
		private var _nightTip:Boolean = false;
		private var _soundEffects:Boolean = true;
		private var _states:Object;
		private var _map:String;
		
		private var _newSave:Boolean = false;
		
		public function Save(saveName:String)
		{
			so = SharedObject.getLocal(saveName);
			
			_coins = new Vector.<Point>();
			
			_saveName = saveName;
			
			if (so.data.coins != null)
			{
				var coins:Vector.<Object> = so.data.coins;
				for (var i:int = 0, l:int = coins.length; i < l; i++) _coins.push(new Point(coins[i].x, coins[i].y));
			}
			else _newSave = true;
			
			if (so.data.xTile != null) _xTile = int(so.data.xTile);
			else _xTile = -1;
			
			if (so.data.yTile != null) _yTile = int(so.data.yTile);
			else _yTile = -1;
			
			if (so.data.direction != null) _direction = String(so.data.direction);
			else _direction = Direction.DOWN;
			
			if (so.data.lives != null) _lives = int(so.data.lives);
			else _lives = 3;
			
			if (so.data.points != null) _points = int(so.data.points);
			else _points = 0;
			
			if (so.data.time_hour != null) _time_hour = int(so.data.time_hour);
			else _time_hour = 8;
			
			if (so.data.time_minute != null) _time_minute = int(so.data.time_minute);
			else _time_minute = 0;
			
			if (so.data.statchanges != null) _statchanges = so.data.statchanges;
			else _statchanges = new Vector.<Object>();
			
			if (so.data.iconholders != null) _iconholders = so.data.iconholders;
			else _iconholders = new Vector.<Object>();
			
			if (so.data.localetype != null) _localetype = so.data.localetype;
			else _localetype = null;
			
			if (so.data.fps != null) _fps = so.data.fps;
			else _fps = 30;
			
			if (so.data.scale != null) _scale = so.data.scale;
			else _scale = 0;
			
			if (so.data.easyInput != null) _easyInput = so.data.easyInput;
			else _easyInput = true;
			
			if (so.data.nightTip != null) _nightTip = so.data.nightTip;
			else _nightTip = false;
			
			if (so.data.music != null) _music = so.data.music;
			else _music = true;
			
			if (so.data.soundEffects != null) _soundEffects = so.data.soundEffects;
			else _soundEffects = true;
			
			if (so.data.states != null) _states = so.data.states;
			else _states = new Object();
			
			if (so.data.map != null) _map = so.data.map;
			else _map = MapType.OVERWORLD;
		}
		
		/**
		 * Returns the name of this save file.
		 */
		public function get SAVE_NAME():String
		{
			return _saveName;
		}
		
		/**
		 * Flushes the loaded SharedObject.
		 */
		public function save():void
		{
			so.data.coins = _coins;
			so.data.xTile = _xTile;
			so.data.yTile = _yTile;
			so.data.direction = _direction;
			so.data.entities = EntityManager.ENCODE_ENTITIES();
			so.data.lives = _lives;
			so.data.points = _points;
			so.data.time_hour = UIManager.DAY_NIGHT_CYCLE ? UIManager.DAY_NIGHT_CYCLE.HOUR : 8;
			so.data.time_minute = UIManager.DAY_NIGHT_CYCLE ? UIManager.DAY_NIGHT_CYCLE.MINUTE : 0;
			so.data.statchanges = StatManager.ENCODE_STAT_CHANGES();
			so.data.iconholders = UIIconManager.ENCODE_ICON_HOLDERS();
			so.data.localetype = LocalizationManager.language.LANG_CODE;
			so.data.fps = OptionsManager.FPS;
			so.data.scale = OptionsManager.SCALE;
			so.data.easyInput = OptionsManager.EASY_INPUT;
			so.data.music = OptionsManager.MUSIC;
			so.data.soundEffects = OptionsManager.SOUND_EFFECTS;
			so.data.states = CommandManager.saveStatesObject();
			so.data.map = MapManager.MAP_TYPE;
			so.data.nightTip = _nightTip;
			so.flush();
		}
		
		/**
		 * Checks if the coin at the provided x- and y-coordinates has been consumed.
		 * @param	xTile The x-coordinate of the tile to check.
		 * @param	yTile The y-coordinate of the tile to check.
		 * @return True if the coin has been consumed, false if not.
		 */
		public function isCoinConsumed(xTile:int, yTile:int):Boolean
		{
			for (var i:int = 0, l:int = _coins.length; i < l; i++)
				if (_coins[i].x == xTile && _coins[i].y == yTile) return true;
			return false;
		}
		
		/**
		 * Adds a point with the x- and y-coordinates provided to the _coins vector, indicating that the coin at that location has been consumed/taken.
		 * @param	xTile
		 * @param	yTile
		 */
		public function consumeCoin(xTile:int, yTile:int):void
		{
			_coins.push(new Point(xTile, yTile));
		}
		
		/**
		 * Updates the save file's player coordinates.
		 * @param	xTile The player's new x-coordinate.
		 * @param	yTile The player's new y-coordinate.
		 */
		public function updateLocation(xTile:int, yTile:int):void
		{
			_xTile = xTile;
			_yTile = yTile;
		}
		
		/**
		 * Updates the save file's player direction.
		 * @param	direction The player's new direction.
		 */
		public function updateDirection(direction:String):void
		{
			_direction = direction;
		}
		
		/**
		 * Saves the object and then disposes of the SharedObject and other resources.
		 */
		public function destroy():void
		{
			save();
			
			so = null;
			_coins = null;
			_statchanges = null;
			_iconholders = null;
		}
		
		/**
		 * Adds the given number of points to the player's point sum.
		 * @param	points The points to add (or, if negative, to take away.)
		 */
		public function givePoints(points:int):void
		{
			_points += points;
		}
		
		/**
		 * Provides access to the saved entity data.
		 */
		public function get ENTITY_DATA():Vector.<Object>
		{
			if (so.data.entities != null) return so.data.entities;
			else return new Vector.<Object>();
		}
		
		/**
		 * Provides access to the player's x-coordinate.
		 */
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		/**
		 * Provides access to the player's y-coordinate.
		 */
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		/**
		 * Provides access to the player's current direction.
		 */
		public function get DIRECTION():String
		{
			return _direction;
		}
		
		/**
		 * Returns the sum of both the coins and points the player has.
		 */
		public function get NUMBER_OF_POINTS():int
		{
			return _coins.length + _points;
		}
		
		/**
		 * Returns the number of lives the player has.
		 */
		public function get LIVES():int
		{
			return _lives;
		}
		
		/**
		 * Decrements the lives variable by one.
		 */
		public function takeLife():void
		{
			_lives--;
		}
		
		/**
		 * Returns the last saved hour of the game.
		 */
		public function get TIME_HOUR():int
		{
			return _time_hour;
		}
		
		/**
		 * Returns the last saved minute of the game.
		 */
		public function get TIME_MINUTE():int
		{
			return _time_minute;
		}
		
		/**
		 * Returns the saved list of UIIconHolders.
		 */
		public function get ICON_HOLDERS():Vector.<Object>
		{
			return _iconholders;
		}
		
		/**
		 * Returns the saved list of StatChanges.
		 */
		public function get STAT_CHANGES():Vector.<Object>
		{
			return _statchanges;
		}
		
		/**
		 * If this save hasn't yet been saved (it was just created), returns true. If not, returns false.
		 */
		public function get NEW_SAVE():Boolean
		{
			return _newSave;
		}
		
		/**
		 * Returns the last saved LocaleType.
		 */
		public function get LOCALE_TYPE():String
		{
			return _localetype;
		}
		
		/**
		 * Returns the saved FPS setting.
		 */
		public function get FPS():int
		{
			return _fps;
		}
		
		/**
		 * Returns the map scaling value.
		 */
		public function get SCALE():Number
		{
			return _scale;
		}
		
		/**
		 * Returns the saved states object.
		 */
		public function get STATES():Object
		{
			return _states;
		}
		
		/**
		 * Returns the saved MapType.
		 */
		public function get MAP():String
		{
			return _map;
		}
		
		/**
		 * Returns the state of the Easy Input option.
		 */
		public function get EASY_INPUT():Boolean
		{
			return _easyInput;
		}
		
		/**
		 * Returns the state of the Music option.
		 */
		public function get MUSIC():Boolean
		{
			return _music;
		}
		
		/**
		 * Returns the state of the Sound Effects option.
		 */
		public function get SOUND_EFFECTS():Boolean
		{
			return _soundEffects;
		}
		
		/**
		 * If the Night Tip has been seen, returns true. Otherwise, returns false.
		 */
		public function get NIGHT_TIP():Boolean
		{
			return _nightTip;
		}
		
		/**
		 * Switches the state of whether or not the Night Tip has been seen yet.
		 * @param	nightTip
		 */
		public function setNightTip(nightTip:Boolean):void
		{
			_nightTip = nightTip;
		}
	}

}