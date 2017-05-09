package com.ryanwirth.pelletquest.ui
{
	import com.greensock.TweenMax;
	import com.ryanwirth.pelletquest.localization.LocalizationManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.events.TouchPhase;
	import com.ryanwirth.pelletquest.GameManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class UIIconHolder extends Sprite implements UIElement
	{
		[Embed(source = "assets/UIIconHolder.xml", mimeType = "application/octet-stream")]
		private static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source = "assets/UIIconHolder.png")]
		private static const AtlasTexture:Class;
		
		private static const texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture, false, false);
		private static const xml:XML = XML(new AtlasXml());
		private static const atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		private var _iconType:String;
		private var _icon:UIIcon;
		private var _background:Image;
		private var _label:String;
		private var _labelText:TextField;
		private var _subLabel:String;
		private var _subLabelText:TextField;
		private var _hideLabels:Boolean;
		private var _labelColor:uint;
		private var _subLabelColor:uint;
		private var _autoDismissal:int;
		private var _allowSaving:Boolean;
		
		private var _labelsVisible:Boolean = true;
		
		public function UIIconHolder(iconType:String, label:String = "", subLabel:String = "", hideLabels:Boolean = false, labelColor:uint = 0xFFFFFF, subLabelColor:uint = 0xFFFFFF, autoDismissal:int = 0, allowSaving:Boolean = true)
		{
			_iconType = iconType;
			_label = label;
			_subLabel = subLabel;
			_hideLabels = hideLabels;
			_labelColor = labelColor;
			_subLabelColor = subLabelColor;
			_autoDismissal = autoDismissal;
			_allowSaving = allowSaving;
			
			construct();
		}
		
		public function get AUTO_DISMISSAL():int
		{
			return _autoDismissal;
		}
		
		public function get ALLOW_SAVING():Boolean
		{
			return _allowSaving;
		}
		
		public function get LABEL_COLOR():uint
		{
			return _labelColor;
		}
		
		public function get SUBLABEL_COLOR():uint
		{
			return _subLabelColor;
		}
		
		public function updateLabelVisibility(visible:Boolean):void
		{
			_labelsVisible = visible;
			
			if (_subLabelText) _subLabelText.visible = _labelsVisible;
			if (_labelText) _labelText.visible = _labelsVisible;
		}
		
		public function get LABELS_VISIBLE():Boolean
		{
			return _labelsVisible;
		}
		
		/**
		 * Returns whether or not the labels can be hidden (tapped to show/hide their labels) or not.
		 */
		public function get HIDE_LABELS():Boolean
		{
			return _hideLabels;
		}
		
		/**
		 * Returns the current label text.
		 */
		public function get LABEL():String
		{
			return _label;
		}
		
		/**
		 * Returns the current sub-label text.
		 */
		public function get SUBLABEL():String
		{
			return _subLabel;
		}
		
		/**
		 * Fades both labels to an alpha of zero within the specified duration.
		 * @param	duration The amount of time to fade the labels out.
		 */
		public function fadeOutLabel(duration:Number):void
		{
			if (_labelText)
			{
				TweenMax.to(_labelText, duration, {alpha: 0});
			}
			
			if (_subLabelText)
			{
				TweenMax.to(_subLabelText, duration, {alpha: 0});
			}
		}
		
		/**
		 * Fades both labels from an alpha of 0 to 1 within the specified duration.
		 * @param	duration The amount of time to fade the labels in.
		 */
		public function fadeInLabel(duration:Number):void
		{
			if (_labelText)
			{
				_labelText.alpha = 0;
				TweenMax.to(_labelText, duration, { alpha:1 } );
			}
			
			if (_subLabelText)
			{
				_subLabelText.alpha = 0;
				TweenMax.to(_subLabelText, duration, { alpha:1 } );
			}
		}
		
		public function construct():void
		{
			_background = new Image(atlas.getTexture("icon_holder"));
			_background.smoothing = TextureSmoothing.NONE;
			this.addChild(_background);
			
			_icon = new UIIcon(_iconType);
			_icon.x = _background.width / 2 - _icon.width / 2;
			_icon.y = _background.height / 2 - _icon.height / 2;
			_icon.touchable = false;
			this.addChild(_icon);
			
			updateLabelText(_label);
			updateSubLabelText(_subLabel);
			
			if (_hideLabels)
			{
				this.addEventListener(TouchEvent.TOUCH, tapBackground);
			}
			
			if (_autoDismissal > 0)
			{
				startCountdown();
			}
		}
		
		private function startCountdown():void
		{
			_autoDismissal++;
			decreaseDismissal();
		}
		
		private function decreaseDismissal():void
		{
			if (!_background) return;
			
			if(!GameManager.PAUSED) _autoDismissal--;
			
			updateLabelText(_label);
			updateSubLabelText(_subLabel);
			
			if (_autoDismissal <= 0)
			{
				UIIconManager.removeIconHolder(this);
				return;
			}
			
			TweenMax.delayedCall(1, decreaseDismissal);
		}
		
		private function tapBackground(e:TouchEvent):void
		{
			if (e.getTouch(this, TouchPhase.BEGAN)) e.stopImmediatePropagation();
			
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			if (!touch) return;
			
			updateLabelVisibility(!_labelsVisible);
			
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		/**
		 * If the label does not yet exist, creates it. Otherwise, simply updates the text of the label. If the new label text is an empty string (""), removes the label and resets the position of the sub-label, if it exists.
		 * @param	label The new label text.
		 */
		public function updateLabelText(label:String):void
		{
			_label = label;
			
			if (_label == "")
			{
				if (_labelText)
				{
					this.removeChild(_labelText, true);
					
					if (_subLabelText) _subLabelText.y -= 5;
				}
				_labelText = null;
			}
			else
			{
				if (!_labelText)
				{
					_labelText = new TextField(200, 12 * LocalizationManager.getFontSizeMultiplier(), LocalizationManager.parseLabel(_label, _autoDismissal), LocalizationManager.getFontName(), 12 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
					_labelText.hAlign = HAlign.RIGHT;
					_labelText.x = -_labelText.width - 2;
					_labelText.y = _background.height / 2 - _labelText.height / 2 - 2;
					_labelText.touchable = false;
					_labelText.color = _labelColor;
					this.addChild(_labelText);
					
					if (_subLabelText)
					{
						_labelText.y -= 5;
						_subLabelText.y += 5;
					}
				}
				else _labelText.text = LocalizationManager.parseLabel(_label, _autoDismissal);
				
				_labelText.visible = _labelsVisible;
			}
		}
		
		/**
		 * If the sub-label does not exist, creates it. Otherwise, simply updates the text of the sub-label. If the new label is an empty string (""), removes the sub-label and resets the position of the label, if it exists.
		 * @param	label The new sub-label text.
		 */
		public function updateSubLabelText(label:String):void
		{
			_subLabel = label;
			
			if (_subLabel == "")
			{
				if (_subLabelText)
				{
					this.removeChild(_subLabelText, true);
					
					if (_labelText) _labelText.y += 5;
				}
				_subLabelText = null;
			}
			else
			{
				if (!_subLabelText)
				{
					_subLabelText = new TextField(200, 8 * LocalizationManager.getFontSizeMultiplier(), LocalizationManager.parseLabel(_subLabel, _autoDismissal), LocalizationManager.getFontName(), 8 * LocalizationManager.getFontSizeMultiplier(), 0xFFFFFF);
					_subLabelText.hAlign = HAlign.RIGHT;
					_subLabelText.x = -_subLabelText.width - 2;
					_subLabelText.y = _background.height / 2 - _subLabelText.height / 2 - 2;
					_subLabelText.touchable = false;
					_subLabelText.color = _subLabelColor;
					this.addChild(_subLabelText);
					
					if (_labelText)
					{
						_labelText.y -= 5;
						_subLabelText.y += 5;
					}
					
				}
				else _subLabelText.text = LocalizationManager.parseLabel(_subLabel, _autoDismissal);
				
				_subLabelText.visible = _labelsVisible;
			}
		}
		
		/**
		 * Destroys the background, icon, and both label TextFields.
		 */
		public function destroy():void
		{
			this.removeEventListener(TouchEvent.TOUCH, tapBackground);
			this.removeChild(_background, true);
			this.removeChild(_icon, true);
			
			if (_labelText) this.removeChild(_labelText, true);
			_labelText = null;
			
			if (_subLabelText) this.removeChild(_subLabelText, true);
			_subLabelText = null;
			
			_background = null;
			_icon = null;
			
			this.removeFromParent(true);
		}
		
		/**
		 * Provides the type of the icon held by the IconHolder.
		 */
		public function get ICON_TYPE():String
		{
			return _iconType;
		}
		
		/**
		 * Provides the true width of the IconHolder (that is, excluding both labels).
		 */
		public function get ICON_WIDTH():int
		{
			return _background.width;
		}
	
	}

}