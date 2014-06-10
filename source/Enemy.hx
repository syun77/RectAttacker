package ;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

private enum State {
    Init;
    Appear;
    Main;
    Main2;
    Main3;
}

/**
 * 敵クラス
 **/
class Enemy extends FlxSprite {
    static public var target:Player;
    static public var s_bullets:FlxTypedGroup<Bullet>;
    static public var csv:CsvLoader;
    static public var level:Int = 0;

    private var _id:Int = 0;
    private var _state:State;
    private var _timer:Int = 0;
    private var _tDestroy:Int = 0;
    private var _hpmax:Int = 0;
    private var _hp:Int = 0;
    private var _val:Float = 0;

    // zaco
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
                    _timer = 100;
                }
            case State.Main:
                _timer++;
                if(_timer%120== 0) {
                    var n = 3 + Math.floor(level/3);
                    var speed = 50 + level*10;
                    bulletNWay(getAim(), 3, 5, 50);

                }
            default:
                trace("Warning: not expect.");
        }
    }

    // aim
    private function _update002():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                    _val = getAim();
                }
            case State.Main:
                _timer++;
                if(_timer%5== 0) {
                    var speed = 150 + level*20;
                    bullet(_val, speed);
                }
                if(_timer > 20+level*3) {
                    _timer = 0;
                    _state = State.Main2;
                }
            case State.Main2:
                _timer++;
                if(_timer > 80) {
                    _timer = 0;
                    _state = State.Appear;
                }

            default:
                trace("Warning: not expect.");
        }
    }

    // side
    private function _update003():Void {
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _decay(0.97);
                _timer--;
                if(_timer < 1) {
                    _state = State.Main;
                    velocity.x = 0;
                    velocity.y = 50;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                var interval:Int = 50 - level;
                interval = if(interval < 20) 20 else interval;
                if(_timer%interval == 0) {
                    var speed = 80 + level*10;
                    var dir = if(x > FlxG.width/2) 180 else 0;
                    bullet(dir, speed);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // aim2
    private function _update004():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 100;
                }
            case State.Main:
                _timer++;
                if(_timer%120== 0) {
                    var speed = 100 + 10 * level;
                    bulletAim(0, speed);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // winder
    private function _update005():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                if(_timer%4 == 0) {
                    var rad = _timer * FlxAngle.TO_RAD * 2;
                    var speed = 120 + level * 15;
                    var range = 10 + level * 1;
                    if(range > 40) { range = 40; }
                    bullet(270+Math.cos(rad)*10, speed);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // whip
    private function _update006():Void {
        switch(_state) {
            case State.Init:
                _timer = 30;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                _decay(0.93);
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 50;
                }
            case State.Main:
                _timer++;
                var speed = 50 + level * 5;
                var v = _timer%120;
                switch(v) {
                case 59: _val = getAim();
                case 60, 65, 70, 75, 80:
                    speed += v%60*3;
                    bullet(_val, speed+10);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // invader
    private function _update007():Void {
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _decay(0.95);
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 80;
                    velocity.set(100, 0);
                }
            case State.Main:
                if(x <= 80) {
                    x = 80;
                    velocity.x *= -1;
                }
                if(x >= 240) {
                    x = 240;
                    velocity.x *= -1;
                }
                _timer++;
                if(_timer%110== 0) {
                    var speed = 100 + 10 * level;
                    for(i in 0...3) {
                        bulletOffset(0, -8*i, 270, speed);
                    }
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // rotate
    private function _update008():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                if(_timer%4 == 0) {
                    var rad = _timer * FlxAngle.TO_RAD * 4;
                    var dir = _timer * 4;
                    var speed = 120 + level * 15;
                    for(i in 0...3) {
                        var ofsX = 8 * i * Math.cos(rad);
                        var ofsY = 8 * i * -Math.sin(rad);
                        bulletOffset(ofsX, ofsY, dir, speed);
                    }
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // none
    private function _update009():Void {
        switch(_state) {
            case State.Init:
                _timer = 30;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
            default:
                trace("Warning: not expect.");
        }
    }

    // 5way
    private function _update010():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                var speed = 100 + level * 15;
                var duration = 80 - level * 1;
                duration = if(duration < 45) 45 else duration;
                switch(_timer%90) {
                    case 1:
                        _val = getAim();
                    case 2,6,10:
                        bulletNWay(_val, 5, duration, speed);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // 4way
    private function _update011():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                var speed = 100 + level * 15;
                var duration = 80 - level * 1;
                duration = if(duration < 45) 45 else duration;
                switch(_timer%90) {
                case 1:
                    _val = getAim();
                case 2,6,10:
                    bulletNWay(_val, 4, duration, speed);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    // gravity
    private function _update012():Void {
        _decay(0.95);
        switch(_state) {
            case State.Init:
                _timer = 60;
                _state = State.Appear;
            case State.Appear:
                _timer--;
                if(_timer < 1 ) {
                    _state = State.Main;
                    _timer = 0;
                }
            case State.Main:
                _timer++;
                switch(_timer%90) {
                    case 1:
                        _val = FlxRandom.floatRanged(45, 135);
                    case 2,6,10:
                        var gravity = 100 + 10 * level;
                        bulletOffset(0, 0, _val, 100, 0, gravity);
                }
            default:
                trace("Warning: not expect.");
        }
    }

    /**
     * コンストラクタ
     **/
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
        revive();
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
            case 2: _update002();
            case 3: _update003();
            case 4: _update004();
            case 5: _update005();
            case 6: _update006();
            case 7: _update007();
            case 8: _update008();
            case 9: _update009();
            case 10: _update010();
            case 11: _update011();
            case 12: _update012();
        }

        if(isOnScreen()==false) {
            // 画面外で消える
            kill();
        }

        _tDestroy -= 1;
        if(_tDestroy < 1) {
            vanish(false);
        }
    }

    public function bulletOffset(ofsX:Float, ofsY:Float, dir:Float, speed:Float, ax:Float=0, ay:Float=0) {
        var rad:Float = FlxAngle.TO_RAD * dir;
        var dx:Float = speed * Math.cos(rad);
        var dy:Float = speed * -Math.sin(rad);
        var b:Bullet = s_bullets.getFirstDead();
        if(b != null) {
            b.revive();
            b.x = ofsX + x + width/2 - b.width/2;
            b.y = ofsY + y + width/2 - b.width/2;
            b.velocity.set(dx, dy);
            b.acceleration.set(ax, ay);
        }
    }
    
    /**
     * 弾を撃つ
     * @param dir 方向
     * @param speed 速さ
     **/
    public function bullet(dir:Float, speed:Float):Void {
        bulletOffset(0, 0, dir, speed);
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
