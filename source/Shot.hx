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

        // 初期状態は無効
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
