package ;

import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * シールド
 **/
class Shield extends FlxSprite {

    private static inline var _DECAY_VOLOCITY = 0.9;

    public function new() {
        super(-100, -100);
        makeGraphic(10*3, 4, FlxColor.GOLDEN);

        // 消しておく
        kill();
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();
    }

    /**
     * 反動を減衰する
     **/
    public function decayVelocity():Void {
        velocity.x *= _DECAY_VOLOCITY;
        velocity.y *= _DECAY_VOLOCITY;
    }
}
