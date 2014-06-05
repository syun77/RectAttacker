package ;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 敵弾クラス
 **/
class Bullet extends FlxSprite {
    public function new() {
        super();
        makeGraphic(4, 4, FlxColor.RED);
        offset.set(2, 2);

        // 消しておく
        kill();
    }

    /**
     * 更新
     **/
    override function update():Void {
        super.update();

        if(x < 0 || y < 0 || x > FlxG.width || y > FlxG.height) {
            // 画面外で消える
            kill();
        }
    }
}
