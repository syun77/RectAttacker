package ;

import flixel.util.FlxAngle;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 敵弾クラス
 **/
class Bullet extends FlxSprite {
    public function new() {
        super();
        loadGraphic("assets/images/bullet.png", true);
        FlxG.debugger.drawDebug = true;
        width /= 2;
        height /= 2;
        centerOffsets();

        // 消しておく
        kill();
    }

    /**
     * 更新
     **/
    override function update():Void {
        super.update();

        var dir = Math.atan2(-velocity.y, velocity.x) * FlxAngle.TO_DEG;
        var d = 22.5;
        var start = -180.0 - d/2;
        var i = 0;
        while(start < 180+d) {
            var next = start + d;
            if(start <= dir && dir < next) {
                animation.frameIndex = i;
            }
            start = next;
            i++;
            i = i%8;
        }


        if(isOnScreen()==false) {
            // 画面外で消える
            kill();
        }
    }
}
