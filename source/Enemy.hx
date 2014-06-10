package ;
import Reflect;
import flixel.util.FlxAngle;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

private enum State {
    Init;
    Appear;
    Main;
}

/**
 * 敵クラス
 **/
class Enemy extends FlxSprite {
    static public var target:Player;
    static public var s_bullets:FlxTypedGroup<Bullet>;
    static public var csv:CsvLoader;

    private var _id:Int = 0;
    private var _state:State;
    private var _timer:Int = 0;
    private var _tDestroy:Int = 0;
    private var _hpmax:Int = 0;
    private var _hp:Int = 0;

    private function _update001():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                }
            case State.Main:
                _timer++;
                if(_timer%240 == 0) {
                    bulletNWay(getAim(), 5, 60, 100);
                }
                if(_timer%240 == 120) {
                    bulletNWay(getAim(), 6, 60, 100);
                }
        }
    }

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
        _hp = csv.getInt(id, "hp");
        _hpmax = _hp;
        var size = csv.getInt(id, "size");
        makeGraphic(size, size, FlxColor.GREEN);
        // 出現位置調整
        x -= size/2;
        y -= size/2;
        _tDestroy = csv.getInt(id, "destroy");
        _timer = 0;
        _state = State.Init;
    }

    private function _decay(d:Float):Void {
        velocity.x *= d;
        velocity.y *= d;
    }

    /**
     * ダメージ処理
     **/
    public function damage(val:Int):Void {
        _hp -= val;
        if(_hp <= 0) {
            _hp = 0;
            vanish();
        }
    }

    /**
     * 消滅する
     **/
    private function vanish(bAttack:Bool=true):Void {
        kill();
    }

    /**
     * 更新
     **/
    override function update():Void {
        super.update();

        switch(_id) {
        case 1: _update001();
        }

        if(isOnScreen()==false) {
            // 画面外で消える
            kill();
        }

        _tDestroy -= 1;
        /*
        if(_tDestroy < 1) {
            vanish(false);
        }
        */
    }

    /**
     * 弾を撃つ
     * @param dir 方向
     * @param speed 速さ
     **/
    public function bullet(dir:Float, speed:Float):Void {
        var rad:Float = FlxAngle.TO_RAD * dir;
        var dx:Float = speed * Math.cos(rad);
        var dy:Float = speed * -Math.sin(rad);
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
    public function bulletAim(ofs:Float, speed:Float):Void {
        var aim = getAim();
        bullet(aim+ofs, speed);
    }

    /**
     * NWay弾を撃つ
     * @param dir 中心の角度
     * @param num 弾の数
     * @parma duration 弾の全体の広さ（角度）
     * @parma speed 弾のスピード
     **/
    public function bulletNWay(dir:Float, num:Int, duration:Float, speed:Float):Void {
        if(num == 1) {
            bullet(dir, speed);
            return;
        }

        if(num%2 == 0) {
            // 偶数弾
            var d = duration / (num - 1);
            var rot = dir - (d/2) - (d*(num/2-1));
            for(i in 0...num) {
                bullet(rot, speed);
                rot += d;
            }

        }
        else {
            // 奇数弾
            var d = duration / (num - 1);
            var rot = dir - (d*((num-1)/2));
            for(i in 0...num) {
                bullet(rot, speed);
                rot += d;
            }
        }
    }

    /**
     * 狙い撃ち角度を取得する
     * @return 狙い撃ち角度
     **/
    public function getAim():Float {
        var aim = FlxAngle.angleBetween(this, target, true);
        // FlxMath.angleBetween()が左回転で実装しているので
        // 回転方向を右回りに変換する
        var ret = if(aim > 0) 360 - aim else aim * -1;

        return ret;
    }
}
