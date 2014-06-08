package ;
import flixel.util.FlxRandom;
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

    private var _id:Int = 0;
    private var _timer:Int = 0;
    private var _hpmax:Int = 0;
    private var _hp:Int = 0;

    public function new() {
        super(-100, -100);
        makeGraphic(8, 8, FlxColor.GREEN);
        immovable = true; // 反動で動かないようにする

        // 非表示にする
        kill();
    }

    /**
     * 初期化
     * @param id 敵ID
     **/
    public function init(id:Int):Void {
        _id = id;
        _hp = 30;
        _hpmax = _hp;
        /*
        var size = FlxRandom.intRanged(8, 32);
        makeGraphic(size, size, FlxColor.GREEN);
        // 出現位置調整
        x -= size/2;
        y -= size/2;
        */
        _timer = 0;
    }

    /**
     * ダメージ処理
     **/
    public function damage(val:Int):Void {
        _hp -= val;
        if(_hp <= 0) {
            _hp = 0;
            kill();
        }
    }

    /**
     * 更新
     **/
    override function update():Void {
        super.update();

        velocity.x *= 0.95;
        velocity.y *= 0.95;
        if(isOnScreen()==false) {
            // 画面外で消える
            kill();
        }

        _timer++;
        /*
        if(_timer%6 == 0) {
            bullet(_timer*2, 100);
        }
        */
        if(_timer%120 == 0) {
            bulletAim(0, 100);
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
        var b:Bullet = s_bullets.getFirstDead();
        if(b != null) {
            b.revive();
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
