package ;

import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
/**
 * プレイヤークラス
 **/
class Player extends FlxSprite {

    /**
     * コンストラクタ
     **/
    public function new() {
        super(FlxG.width/2, FlxG.height - 64);
        makeGraphic(8, 8, FlxColor.BLUE);
    }

    /**
     * 更新
     **/
    override public function update():Void {

        velocity.set(0, 0);
        var p:FlxPoint = FlxPoint.get(0, 0);
        if(FlxG.keys.pressed.LEFT) {
            p.x = -1;
        }
        if(FlxG.keys.pressed.UP) {
            p.y = -1;
        }
        if(FlxG.keys.pressed.RIGHT) {
            p.x = 1;
        }
        if(FlxG.keys.pressed.DOWN) {
            p.y = 1;
        }

        if(p.x != 0 || p.y != 0) {
            var rad:Float = Math.atan2(p.y, p.x);
            var speed:Float = 200;
            velocity.x = speed * Math.cos(rad);
            velocity.y = speed * Math.sin(rad);
        }

        super.update();
    }

}
