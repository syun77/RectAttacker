package ;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 敵クラス
 **/
class Enemy extends FlxSprite {
    static public var target:Player;
    static public var bullets:FlxTypedGroup<Bullet>;

    private var _timer:Int = 0;

    public function new() {
        super(-100, -100);
        makeGraphic(8, 8, FlxColor.GREEN);
        offset.set(4, 4);

        // 非表示にする
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

        _timer++;
        if(_timer%60 == 0) {
            var b:Bullet = bullets.recycle();
            b.x = x;
            b.y = y;
            b.velocity.set(0, 100);
        }
    }
}
