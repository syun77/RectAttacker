package ;

import flash.display.BlendMode;
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
    static inline private var SPEED_DECAY = 0.4; // ボタンを押している時
    // ショットの速度
    static inline private var SPEED_SHOT = 500;
    // シールドのオフセット座標
    static inline private var SHIELD_OFS_Y = 16;

    // ショット
    private var _shots:FlxTypedGroup<Shot>;

    // シールド
    private var _shield:Shield;

    /**
     * コンストラクタ
     **/
    public function new() {
        super(FlxG.width/2, FlxG.height - 64);
        makeGraphic(8, 8, FlxColor.AQUAMARINE);
        //immovable = true;

        _shield = new Shield();
    }

    /**
     * ショットを設定する
     **/
    public function setShots(shots:FlxTypedGroup<Shot>) {
        this._shots = shots;
    }

    /**
     * シールドを取得する
     **/
    public function getShield():Shield {
        return _shield;
    }

    /**
     * ショットボタンを押しているかどうか
     **/
    private function _isPressdShot():Bool {
        return FlxG.keys.anyPressed(["SPACE", "Z"]);
    }

    /**
     * シールド
     **/
    private function _isPressShield():Bool {
        return FlxG.keys.anyPressed(["SHIFT", "X"]);
    }

    /**
     * 更新
     **/
    override public function update():Void {

        // 移動処理
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
            var spd:Float = SPEED;
            if(_isPressdShot() || _isPressShield()) {
                // 移動速度が落ちる
                spd *= SPEED_DECAY;
            }
            var rad:Float = Math.atan2(p.y, p.x);
            velocity.x = spd * Math.cos(rad);
            velocity.y = spd * Math.sin(rad);
        }

        // シールドの反動
        velocity.x += _shield.velocity.x;
        velocity.y += _shield.velocity.y;

        // ショット処理
        if(_isPressdShot()) {
            var shot: Shot = _shots.getFirstDead();
            if(shot != null) {
                shot.revive();
                shot.x = x + width/2 - shot.width/2;
                shot.y = y + height/2 - shot.height/2;
                shot.velocity.y = -SPEED_SHOT;
                shot.velocity.x = 0;
            }
        }
        else {
            // ショットを撃たなければシールドが使える
            if(_isPressShield()) {
                // シールド表示
                _shield.revive();
                _shield.x = x + width/2 - _shield.width/2;
                _shield.y = y - SHIELD_OFS_Y;
            }
            else {
                // シールドを消す
                _shield.kill();
            }

        }
        super.update();
    }

}
