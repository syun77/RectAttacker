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

        // 消しておく
        kill();
    }

    /**
     * 更新
     **/
    override function update():Void {
        super.update();

        if(isOnScreen()==false) {
            // 画面外で消える
            kill();
        }
    }
}
