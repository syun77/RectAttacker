package ;

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

    public function new() {
        super(-100, -100);
        makeGraphic(4, 4, FlxColor.CYAN);

        // 初期状態は無効
        kill();
    }

    /**
     * 更新
     **/
    private var _targetX:Float = 0;
    private var _targetY:Float = 0;
    private var _distance:Float = 0;
    private var _angle:Float = 0;
    override public function update():Void {

        super.update();

        _distance = 999999999;
        if(s_boss.exists) {
            _distance = FlxMath.distanceBetween(this, s_boss);
            _targetX = s_boss.x;
            _targetY = s_boss.y;
            _angle = FlxAngle.angleBetween(this, s_boss);
        }

        s_enemys.forEachAlive(_checkDistance);

        velocity.x = Math.cos(_angle) * 100;
        velocity.y = Math.sin(_angle) * 100;
    }

    private function _checkDistance(e:Enemy):Void {
        var dist:Float = FlxMath.distanceBetween(this, e);
        if(dist < _distance) {
            _distance = dist;
            _targetX = e.x;
            _targetY = e.y;
            _angle = FlxAngle.angleBetween(this, e);
        }
    }
}
