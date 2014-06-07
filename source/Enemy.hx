package ;
import flixel.util.FlxAngle;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 敵クラス
 **/
class Enemy extends FlxSprite {
    static public var target:Player;
    static public var s_bullets:FlxTypedGroup<Bullet>;

    private var _timer:Int = 0;

    public function new() {
        super(-100, -100);
        makeGraphic(8, 8, FlxColor.GREEN);
        immovable = true; // 反動で動かないようにする

        // 非表示にする
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

        _timer++;
        if(_timer%6 == 0) {
            bullet(_timer*2, 100);
        }
    }

    /**
     * 弾を撃つ
     * @param dir 方向
     * @param speed 速さ
     **/
    public function bullet(dir:Float, speed:Float):Void {
        var rad:Float = FlxAngle.TO_RAD * dir;
        var dx:Float = speed * Math.cos(rad);
        var dy:Float = speed * Math.sin(rad);
        var b:Bullet = s_bullets.recycle();
        if(b != null) {
            b.x = x + width/2 - b.width/2;
            b.y = y + width/2 - b.width/2;
            b.velocity.set(dx, dy);
        }
    }

    /**
     * 狙い撃ち弾を撃つ
     * @param ofs   狙い撃ち角度からずらす角度
     * @param speed 速さ
     **/
    public function bulletAim(ofs:Float, speed:Float) {
        var aim = FlxAngle.angleBetween(this, target, true);
        bullet(aim+ofs, speed);
    }
}
