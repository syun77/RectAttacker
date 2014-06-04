package ;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import flixel.FlxSprite;
/**
 * ショット
 **/
class Shot extends FlxSprite {

    /**
     * コンストラクタ
     **/
    public function new() {
        super(-100, -100);
        makeGraphic(4, 4, FlxColor.CYAN);
        offset.set(2, 2);

        // 初期状態は無効
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
