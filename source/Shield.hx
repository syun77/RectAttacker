package ;

import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * シールド
 **/
class Shield extends FlxSprite {
    public function new() {
        super(-100, -100);
        makeGraphic(10, 4, FlxColor.GOLDEN);

        // 消しておく
        kill();
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        // 反動を減衰
        velocity.x *= 0.9;
        velocity.y *= 0.9;
    }
}
