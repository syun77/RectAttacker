package ;

import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
/**
 * ホーミング弾
 **/
class Horming extends FlxSprite {

    public static var s_enemys:FlxTypedGroup<Enemy>;
    public static var s_boss:Boss;

    private var _myAngle:Float;

    // 角速度
    private var _rotSpeed:Float = 0.1;
    // 移動速度
    private var _speed:Float = 300;

    // Trailエフェクト
    private var _trail:FlxTrail;

    public function new() {
        super(-100, -100);
        makeGraphic(4, 4, FlxColor.CYAN);

        // 初期状態は無効
        kill();

        // Trail生成
        _trail = new FlxTrail(this);
        FlxG.state.add(_trail);
        _trail.kill();


        /*
        FlxG.watch.add(this, "_myAngle");
        FlxG.watch.add(this, "_angle");
        FlxG.watch.add(this, "_tmpAngle");
        FlxG.watch.add(this, "x");
        FlxG.watch.add(this, "y");
        FlxG.watch.add(velocity, "x");
        FlxG.watch.add(velocity, "y");
        */
    }

    /**
     * 初期化
     **/
    public function init(px:Float, py:Float, v:FlxPoint):Void {
        x = px;
        y = py;
        velocity.set(v.x, v.y);
        _myAngle = Math.atan2(-v.y, v.x) * FlxAngle.TO_DEG;

        // Trailエフェクト表示
        _trail.revive();
    }

    /**
     * 消滅処理
     **/
    public function vanish():Void {
        // Trail非表示
        _trail.kill();
        kill();
    }

    /**
     * 更新
     **/
    private var _targetX:Float = 0;
    private var _targetY:Float = 0;
    private var _distance:Float = 0;
    private var _angle:Float = 0;
    private var _tmpAngle:Float = 0;
    override public function update():Void {

        super.update();

        _distance = 999999999;
        if(s_boss.exists) {
            _distance = FlxMath.distanceBetween(this, s_boss);
            _targetX = s_boss.x;
            _targetY = s_boss.y;
            _angle = FlxAngle.angleBetween(this, s_boss, true);
        }

        s_enemys.forEachAlive(_checkDistance);
        // FlxMath.angleBetween()が左回転で実装しているので
        // 回転方向を右回りに変換する
        _angle = if(_angle > 0) 360 - _angle else _angle * -1;

        // 回転できる角度を計算
        var dAngle = _calcAngle();
        _myAngle += dAngle;
        // 360度を超えないように調整
        _myAngle = if(_myAngle > 360) _myAngle -= 360 else _myAngle;

        velocity.x = Math.cos(_myAngle*FlxAngle.TO_RAD) * _speed;
        velocity.y = -Math.sin(_myAngle*FlxAngle.TO_RAD) * _speed;
    }

    /**
     * 回転角度を計算
     * @return 回転する角度
     **/
    private function _calcAngle():Float {
        // 0〜360度にする
        _myAngle = if(_myAngle < 0) 360 + _myAngle else _myAngle;
        _tmpAngle = if(_angle < 0) 360 + _angle else _angle;

        var sign:Float = 1;
        var d = _tmpAngle - _myAngle;
        if(Math.abs(d) > 180) {
            // 逆回しにした方が近い
            sign = -1;
        }
        return d * _rotSpeed * sign;
    }

    private function _checkDistance(e:Enemy):Void {
        var dist:Float = FlxMath.distanceBetween(this, e);
        if(dist < _distance) {
            _distance = dist;
            _targetX = e.x;
            _targetY = e.y;
            _angle = FlxAngle.angleBetween(this, e, true);
        }
    }
}
