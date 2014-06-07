package ;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
/**
 * プレイヤークラス
 **/
class Player extends FlxSprite {

    // 移動速度
    static inline private var SPEED = 150;
    // ショットの速度
    static inline private var SPEED_SHOT = 500;

    public var shots:FlxTypedGroup<Shot>;

    /**
     * コンストラクタ
     **/
    public function new() {
        super(FlxG.width/2, FlxG.height - 64);
        makeGraphic(8, 8, FlxColor.AQUAMARINE);
        offset.set(4, 4);
        immovable = true;
    }

    public function setShots(shots:FlxTypedGroup<Shot>) {
        this.shots = shots;
    }

    /**
     * 更新
     **/
    override public function update():Void {

        velocity.set(0, 0);
        var p:FlxPoint = FlxPoint.get(0, 0);
        if(FlxG.keys.pressed.LEFT) {
            p.x = -1;
        }
        if(FlxG.keys.pressed.UP) {
            p.y = -1;
        }
        if(FlxG.keys.pressed.RIGHT) {
            p.x = 1;
        }
        if(FlxG.keys.pressed.DOWN) {
            p.y = 1;
        }

        if(p.x != 0 || p.y != 0) {
            var rad:Float = Math.atan2(p.y, p.x);
            var speed:Float = SPEED;
            velocity.x = speed * Math.cos(rad);
            velocity.y = speed * Math.sin(rad);
        }

        if(FlxG.keys.pressed.SPACE) {
            //var shot: Shot = shots.recycle();
            var shot: Shot = shots.getFirstDead();
            if(shot != null) {
                shot.revive();
                shot.x = x;
                shot.y = y;
                shot.velocity.y = -SPEED_SHOT;
            }
        }

        super.update();
    }

}
