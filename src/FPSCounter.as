package{
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.entity.EntityManager;
	import com.ryanwirth.pelletquest.GameManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.ryanwirth.pelletquest.ui.UIManager;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

    public class FPSCounter extends Sprite{
        private var last:uint = getTimer();
        private var ticks:uint = 0;
        private var tf:TextField;

        public function FPSCounter(xPos:int=0, yPos:int=0, color:uint=0xffffff, fillBackground:Boolean=false, backgroundColor:uint=0x000000) {
            x = xPos;
            y = yPos;
            tf = new TextField();
            tf.textColor = color;
            tf.text = "----- fps - 0 tiles - 0 pooled - 0 entities";
            tf.selectable = false;
            tf.background = fillBackground;
            tf.backgroundColor = backgroundColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
            addChild(tf);
            width = tf.textWidth;
            height = tf.textHeight;
            addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
        }

        public function tick(evt:Event):void {
            ticks++;
            var now:uint = getTimer();
            var delta:uint = now - last;
            if (delta >= 1000) {
                //trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
                var fps:Number = ticks / delta * 1000;
                tf.text = fps.toFixed(1) + " - " + MapManager.NUMBER_OF_TILES + " tiles - " + MapManager.NUMBER_OF_POOLED_TILES + " pooled - " + EntityManager.NUMBER_OF_ENTITIES + " entities" + (GameManager.PAUSED ? " - PAUSED" : "") + (UIManager.DAY_NIGHT_CYCLE ? " " + UIManager.DAY_NIGHT_CYCLE.TIME : "");
                ticks = 0;
                last = now;
            }
        }
    }
}