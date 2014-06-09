package ;

import flixel.util.FlxRandom;
import flixel.text.FlxText;
import flash.display.BlendMode;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * 状態
 **/
enum State {
    Appear;  // 出現状態
    Standby; // 待機
}

/**
 * プレイヤークラス
 **/
class Player extends FlxSprite {

    // ■定数定義
    // 移動速度
    static inline private var SPEED = 150;
    static inline private var SPEED_DECAY = 0.4; // ボタンを押している時
    // ショットの速度
    static inline private var SPEED_SHOT = 500;
    // シールドのオフセット座標
    static inline private var SHIELD_OFS_Y = 16;
    // ショットゲージの初期値
    static inline private var POWER_SHOT_START = cast POWER_SHOT_MAX/2;
    // ショットゲージの最大値
    static inline private var POWER_SHOT_MAX = 60 * 5 * POWER_SHOT_DEC;
    // ショットゲージの1フレームあたりの減少量
    static inline private var POWER_SHOT_DEC = 4;
    // ショットゲージの1フレームあたりの回復量
    static inline private var POWER_SHOT_INC = 2;
    // シールドゲージの初期値
    static inline private var POWER_SHIELD_START = cast POWER_SHIELD_MAX/2;
    // シールドゲージの最大値
    static inline private var POWER_SHIELD_MAX = 60 * 2 * POWER_SHIELD_DEC;
    // シールドゲージの1フレームあたりの減少量
    static inline private var POWER_SHIELD_DEC = 8;
    // シールドゲージの1フレームあたりの回復量
    static inline private var POWER_SHIELD_INC = 1;
    // 無敵タイマー
    static inline private var TIMER_INVISIBLED = 120;
    // 出現演出タイマー
    static inline private var TIMER_APPEAR = 30;

    // ■ゲームオブジェクト
    // ショット
    private var _shots:FlxTypedGroup<Shot>;
    // シールド
    private var _shield:Shield;
    // ゲージテキスト
    private var _textPower:FlxText;

    // ■ゲージ
    // ショットゲージ
    private var _powerShot:Int = POWER_SHOT_START;
    // シールドゲージ
    private var _powerShield:Int = POWER_SHIELD_START;

    // ■その他
    // ショットタイマー
    private var _tShot:Int = 0;
    // 状態
    private var _state:State = State.Appear;
    // タイマー
    private var _timer:Int = 0;
    // 無敵タイマー
    private var _tInvisibled:Int = TIMER_INVISIBLED;

    /**
     * コンストラクタ
     **/
    public function new() {
        super(FlxG.width/2, FlxG.height - 64);
        makeGraphic(8, 8, FlxColor.AQUAMARINE);
        immovable = true;

        _shield = new Shield();
        _textPower = new FlxText(x, y, 64);
        _textPower.setFormat(null, 8, FlxColor.WHITE, "center");
        _textPower.text = "100%";
        _textPower.kill();

        FlxG.watch.add(this, "_state");
        FlxG.watch.add(this, "_timer");
    }

    /**
     * ゲージテキストを取得する
     **/
    public function getPowerText():FlxText {
        return _textPower;
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
     * 無敵中かどうか
     **/
    public function isInvisibled():Bool {
        return _tInvisibled > 0;
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
     * ショットゲージの割合を取得する
     * @return 0〜100
     **/
    public function getPowerShotRatio():Int {
        return Math.floor(100 * _powerShot / POWER_SHOT_MAX);
    }

    /**
     * シールドゲージの割合を取得する
     * @return 0〜100
     **/
    public function getPowerShieldRatio():Int {
        return Math.floor(100 * _powerShield / POWER_SHIELD_MAX);
    }

    /**
     * ショットゲージを増加する
     * @param val 増加する値
     **/
    public function addPowerShot(val:Int):Void {
        _powerShot += val;
        _powerShot = cast(Math.min(_powerShot, POWER_SHOT_MAX));
    }

    /**
     * シールドゲージを増加する
     * @param val 増加する値
     **/
    public function addPowerShield(val:Int):Void {
        _powerShield += val;
        _powerShield = cast(Math.min(_powerShield, POWER_SHIELD_MAX));
    }
    public function subPowerShot(val:Int):Void {
        _powerShot -= val;
        _powerShot = cast(Math.max(_powerShot, 0));
    }
    public function subPowerShield(val:Int):Void {
        _powerShield -= val;
        _powerShield = cast(Math.max(_powerShield, 0));
    }

    /**
     * ショットを撃てるかどうか
     **/
    private function _canShot():Bool {
        if(getPowerShotRatio() <= 0) {
            return false; // 撃てない
        }

        if(_tShot > 0) {
            return false; // ショットタイマーが残っているので撃てない:w
        }

        // 撃てる
        return true;
    }

    /**
     * 出現開始
     **/
    public function init():Void {

        x = FlxG.width/2;
        y = FlxG.height;
        _state = State.Appear;
        _timer = TIMER_APPEAR;
        _tInvisibled = TIMER_INVISIBLED;
        immovable = true;
    }

    /**
     * 更新・出現
     **/
    private function _updateAppear():Void {
        _timer = cast _timer * 0.9;
        y = FlxMath.lerp(FlxG.height-64, FlxG.height, _timer/TIMER_APPEAR);
        if(_timer < 1) {
            // 待機状態へ
            _state = State.Standby;
            immovable = false;
        }
    }

    /**
     * 移動する
     **/
    private function _move():Void {
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

    }

    /**
     * ショットを撃つ
     **/
    private function _doShot():Void {
        _tShot--;
        if(_canShot()) {
            // 弾が撃てる
            var shot: Shot = _shots.getFirstDead();
            if(shot != null) {
                shot.revive();
                shot.x = x + width/2 - shot.width/2;
                shot.y = y + height/2 - shot.height/2;
                shot.y += FlxRandom.floatRanged(0, 8); // 発射位置をランダムでずらす
                shot.velocity.y = -SPEED_SHOT;
                shot.velocity.x = 0;
                // スピード補正
                var func = function(v) {
                    switch(v) {
                        case a if(a < 10): return 0.2;
                        case a if(a < 40): return 0.4;
                        case a if(a < 70): return 0.6;
                        case a if(a < 90): return 0.8;
                        default: return 1;
                    }
                }
                shot.velocity.y *= func(getPowerShotRatio());
            }
            // ショットタイマーを増やす
            var func = function(v) {
                switch(v) {
                    case a if(a < 10): return 16;
                    case a if(a < 40): return 8;
                    case a if(a < 70): return 4;
                    case a if(a < 90): return 2;
                    default: return 1;
                }
            }
            _tShot = func(getPowerShotRatio());
        }
        // ショットゲージを減らす
        subPowerShot(POWER_SHOT_DEC);

        // テキスト更新
        _setText(_textPower, getPowerShotRatio());

    }

    /**
     * シールドを展開する
     **/
    private function _doShield():Void {
        // シールド表示
        _shield.revive();
        _shield.x = x + width/2 - _shield.width/2;
        _shield.y = y - SHIELD_OFS_Y;
        // シールドゲージを減らす
        subPowerShield(POWER_SHIELD_DEC);

        // テキスト更新
        _setText(_textPower, getPowerShieldRatio());
    }

    /**
     * 更新・スタンバイ状態
     **/
    private function _updateStandby():Void {

        // 移動
        _move();

        // シールドを消す
        _shield.kill();
        _shield.decayVelocity();
        // テキストを消す
        _textPower.kill();

        // ショット処理
        if(_isPressdShot()) {
            _doShot();
        }
        else {
            // ショットを撃たなければシールドが使える
            if(_isPressShield() && getPowerShieldRatio() > 0) {
                _doShield();
            }
        }

        if(_isPressdShot() == false) {
            // ショットゲージ回復
            addPowerShot(POWER_SHOT_INC);
        }
        if(_isPressShield() == false) {
            // シールドゲージ回復
            addPowerShield(POWER_SHIELD_INC);
        }

        // テキスト更新
        _textPower.x = x - _textPower.width/2 + width/2;
        _textPower.y = y+8;
    }
    /**
     * 更新
     **/
    override public function update():Void {

        if(_tInvisibled > 0) {
            _tInvisibled--;
            visible = (_tInvisibled%4 < 2);
        }

        switch(_state) {
        case State.Appear:
            _updateAppear();
        case State.Standby:
            _updateStandby();
        }

        super.update();
    }

    /**
     * テキストの設定
     **/
    private function _setText(text:FlxText, val:Int):Void {
        text.revive();
        switch(val) {
            case a if(a <= 10):
                text.color = FlxColor.RED;
            case a if(a <= 40):
                text.color = FlxColor.YELLOW;
            default:
                text.color = FlxColor.WHITE;
        }
        text.text = val + "%";
    }
}
