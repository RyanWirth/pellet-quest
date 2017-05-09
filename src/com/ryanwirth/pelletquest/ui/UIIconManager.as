package com.ryanwirth.pelletquest.ui
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.GameManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIIconManager
	{
		public static var PADDING:int = 2;
		
		private static var _iconHolders:Vector.<UIIconHolder>;
		
		public function UIIconManager()
		{
		
		}
		
		/**
		 * Encodes all of the current IconHolders into an object vector.
		 * @return The encoded object vector of IconHolders to be saved.
		 */
		public static function ENCODE_ICON_HOLDERS():Vector.<Object>
		{
			var vec:Vector.<Object> = new Vector.<Object>();
			
			if (!_iconHolders) return vec;
			
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				if (_iconHolders[i].ALLOW_SAVING == false) continue;
				var obj:Object = new Object();
				obj.type = _iconHolders[i].ICON_TYPE;
				obj.label = _iconHolders[i].LABEL;
				obj.sublabel = _iconHolders[i].SUBLABEL;
				obj.hidelabels = _iconHolders[i].HIDE_LABELS;
				obj.visible = _iconHolders[i].LABELS_VISIBLE;
				obj.labelcolor = _iconHolders[i].LABEL_COLOR;
				obj.sublabelcolor = _iconHolders[i].SUBLABEL_COLOR;
				obj.autodismissal = _iconHolders[i].AUTO_DISMISSAL;
				vec.push(obj);
			}
			
			return vec;
		}
		
		/**
		 * Decodes a saved IconHolder vector by recreating all of the stored data.
		 * @param	vec The vector of IconHolders to decode.
		 */
		public static function DECODE_ICON_HOLDERS(vec:Vector.<Object>):void
		{
			for (var i:int = 0; i < vec.length; i++)
			{
				addIconHolder(vec[i].type, vec[i].label, vec[i].sublabel, vec[i].hidelabels, vec[i].labelcolor, vec[i].sublabelcolor, vec[i].autodismissal).updateLabelVisibility(vec[i].visible);
			}
		}
		
		/**
		 * Tweens all of the current UIIconHolders into their proper position. To be used after a change in scaling.
		 */
		public static function resizeHUD():void
		{
			if (!_iconHolders) return;
			
			var iconHolder:UIIconHolder;
			for (var i:int = 0, l:int = _iconHolders.length; i < l; i++)
			{
				iconHolder = _iconHolders[i];
				
				TweenMax.killTweensOf(iconHolder);
				iconHolder.y = GameManager.stageHeight - (i + 1) * (iconHolder.height + PADDING);
				TweenMax.to(iconHolder, 0.5, {x: GameManager.stageWidth - iconHolder.ICON_WIDTH - PADDING, ease: Linear.easeInOut});
			}
		}
		
		/**
		 * Adds an icon holder with the given iconType to the HUD in the lower right corner.
		 * @param	iconType The type of icon to display.
		 * @param	labelText The label of the icon.
		 * @param	subLabelText Another row of smaller text below the label.
		 * @return The IconHolder created.
		 */
		public static function addIconHolder(iconType:String, labelText:String = "", subLabelText:String = "", hideLabels:Boolean = false, labelColor:uint = 0xFFFFFF, subLabelColor:uint = 0xFFFFFF, autoDismissal:int = 0, allowSaving:Boolean = true):UIIconHolder
		{
			if (!_iconHolders) _iconHolders = new Vector.<UIIconHolder>();
			
			var iconHolder:UIIconHolder = new UIIconHolder(iconType, labelText, subLabelText, hideLabels, labelColor, subLabelColor, autoDismissal, allowSaving);
			iconHolder.x = GameManager.stageWidth + PADDING + iconHolder.width - iconHolder.ICON_WIDTH;
			_iconHolders.push(iconHolder);
			iconHolder.y = GameManager.stageHeight - _iconHolders.length * (iconHolder.height + PADDING);
			iconHolder.fadeInLabel(0.5);
			UIManager.HUD.addChild(iconHolder);
			
			TweenMax.to(iconHolder, 0.5, {x: GameManager.stageWidth - iconHolder.ICON_WIDTH - PADDING, ease: Linear.easeInOut});
			
			return iconHolder;
		}
		
		/**
		 * Hides all the UIIconHolders.
		 */
		public static function hide():void
		{
			if (!_iconHolders) return;
			
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				_iconHolders[i].visible = false;
			}
		}
		
		/**
		 * Shows all the UIIconHolders.
		 */
		public static function show():void
		{
			if (!_iconHolders) return;
			
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				_iconHolders[i].visible = true;
			}
		}
		
		/**
		 * Updates the IconHolder with the given iconType with a new label.
		 * @param	iconType The iconType to search for.
		 * @param	newLabel The new label text.
		 * @param	newSubLabel The new sub-label text.
		 */
		public static function updateIconHolderLabel(iconType:String, newLabel:String = null, newSubLabel:String = null):void
		{
			var iconHolder:UIIconHolder = getIconHolderWithType(iconType);
			if (!iconHolder) return;
			
			if (newLabel != null) iconHolder.updateLabelText(newLabel);
			if (newSubLabel != null) iconHolder.updateSubLabelText(newSubLabel);
		}
		
		/**
		 * Finds an IconHolder on the HUD that contains the provided iconType.
		 * @param	iconType The iconType to look for.
		 * @return True if there's an IconHolder that has this type, false if not.
		 */
		public static function doesIconHolderHaveType(iconType:String):Boolean
		{
			if (getIconHolderWithType(iconType)) return true;
			else return false;
		}
		
		/**
		 * Finds and returns an IconHolder on the HUD with the given iconType.
		 * @param	iconType The iconType to look for.
		 * @return The IconHolder that holds this iconType.
		 */
		public static function getIconHolderWithType(iconType:String):UIIconHolder
		{
			if (!_iconHolders) return null;
			
			for (var i:int = 0; i < _iconHolders.length; i++)
				if (_iconHolders[i].ICON_TYPE == iconType) return _iconHolders[i];
			return null;
		}
		
		/**
		 * Removes the supplied iconHolder from the HUD and destroys it.
		 * @param	iconHolder The iconHolder to destroy.
		 * @param	iconType (Optional) If provided the iconType to remove.
		 */
		public static function removeIconHolder(iconHolder:UIIconHolder, iconType:String = ""):void
		{
			if (!_iconHolders) return;
			
			trace("UIIconManager: removeIconHolder", iconType);
			
			var removed:Boolean = false;
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				if ((iconHolder != null && _iconHolders[i] == iconHolder) || (iconType != "" && _iconHolders[i].ICON_TYPE == iconType))
				{
					removed = true;
					_iconHolders[i].fadeOutLabel(0.5);
					TweenMax.to(_iconHolders[i], 0.5, {x: GameManager.stageWidth + PADDING, ease: Linear.easeIn, onComplete: _iconHolders[i].destroy});
					_iconHolders.splice(i, 1);
					i--;
				}
			}
			
			if (removed) updateIconHolderPositions();
		}
		
		/**
		 * Tweens all of the IconHolders currently on the HUD into their proper place (usually they will slide downwards to replace an IconHolder that was just destroyed).
		 */
		public static function updateIconHolderPositions():void
		{
			var duration:Number;
			var destY:int;
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				destY = GameManager.stageHeight - (i + 1) * (_iconHolders[i].height + PADDING);
				if (_iconHolders[i].y == destY) continue;
				
				duration = Math.abs(_iconHolders[i].y - destY) / 32;
				TweenMax.killTweensOf(_iconHolders[i]);
				TweenMax.to(_iconHolders[i], duration, {y: destY});
			}
		}
		
		/**
		 * Destroys all floating icon holders.
		 */
		private function destroyIconHolders():void
		{
			if (!_iconHolders) return;
			
			for (var i:int = 0; i < _iconHolders.length; i++)
			{
				UIManager.HUD.removeChild(_iconHolders[i]);
				_iconHolders[i].destroy();
				_iconHolders[i] = null;
			}
			
			_iconHolders = null;
		}
	
	}

}