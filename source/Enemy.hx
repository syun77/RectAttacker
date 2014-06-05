package ;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 敵クラス
 **/
class Enemy extends FlxSprite {
    static public var target:Player;

    public function new() {
        super(-100, -100);
        makeGraphic(8, 8, FlxColor.GREEN);
        offset.set(4, 4);

        // 非表示にする
        kill();
    }
}
