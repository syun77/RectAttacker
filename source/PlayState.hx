package;

import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.ui.FlxSystemButton;
import flixel.util.FlxColor;
import flixel.system.debug.FlxDebugger;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * 状態
 **/
private enum State {
    Init; // 初期化
    Main; // メイン
    Damage; // 被弾
    GameoverInt; // ゲームオーバー・初期化
    GameoverMain; // ゲームオーバー・メイン
}

/**
 * メインゲームState
 **/
class PlayState extends FlxState {

    // ■定数
    // 最初の残基数
    private static inline var LIVES_START = 3;
    // ダメージタイマー
    private static inline var TIMER_DAMAGE = 30;
    private static inline var TIMER_GAMEOVER_INIT = 30;
    private static var s_sndHorming:FlxSound = null;

    // ■ゲームオブジェクト
    // プレイヤー
    private var _player:Player;
    // ショットグループ
    private var _shots:FlxTypedGroup<Shot>;
    // ホーミング弾
    private var _hormings:FlxTypedGroup<Horming>;
    // 敵グループ
    private var _enemys:FlxTypedGroup<Enemy>;
    // ボス
    private var _boss:Boss;
    // 敵弾グループ
    private var _bullets:FlxTypedGroup<Bullet>;
    // 大人カベ
    private var _walls:FlxGroup;

    // CSV
    private var _csvEnemy:CsvLoader;
    private var _csvBoss1:CsvLoader;
    private var _csvBoss2:CsvLoader;
    private var _csvBoss3:CsvLoader;

    // テキスト
    private var _textShot:FlxText;
    private var _textShield:FlxText;
    private var _textLevel:FlxText;
    private var _textLife:FlxText;
    private var _textMessage:FlxText;
    private var _textPressKey:FlxText;

    // エミッタ
    private var _emitterEnemy:EmitterEnemy;
    private var _emitterBoss:EmitterBoss;
    private var _emitterBullet:EmitterBullet;
    private var _emitterPlayer:EmitterPlayer;

    // デバッグ用
    private var _nShot:Int = 0;
    private var _nEnemy:Int = 0;
    private var _nBullet:Int = 0;

    // ■ゲーム変数
    private var _timer:Int; // 汎用タイマー
    private var _lives:Int = 2; // 残機
    private var _level:Int = 0; // 現在のレベル
    private var _score:Int = 0; // スコア
    private var _state:State = State.Main; // 状態


    /**
     * 生成
     **/
    override public function create():Void {
        super.create();

        // プレイヤー生成
        _player = new Player();
        add(_player);
        _player.init();
        // シールドを登録
        add(_player.getShield());

        // ショット生成
        _shots = new FlxTypedGroup<Shot>(64);
        for(i in 0..._shots.maxSize) {
            _shots.add(new Shot());
        }
        add(_shots);
        _player.setShots(_shots);

        // 敵の生成
        _enemys = new FlxTypedGroup<Enemy>(32);
        for(i in 0..._enemys.maxSize) {
            _enemys.add(new Enemy());
        }
        add(_enemys);
        Enemy.target = _player;

        // ボスの生成
        _boss = new Boss();
        Boss.s_enemys = _enemys;
        add(_boss);
        add(_boss.getText());

        // ホーミンググループ
        _hormings = new FlxTypedGroup<Horming>(128);
        for(i in 0..._hormings.maxSize) {
            _hormings.add(new Horming());
        }
        add(_hormings);
        Horming.s_enemys = _enemys;
        Horming.s_boss = _boss;

        // 敵弾グループ
        _bullets = new FlxTypedGroup<Bullet>(256);
        for(i in 0..._bullets.maxSize) {
            _bullets.add(new Bullet());
        }
        add(_bullets);
        Enemy.s_bullets = _bullets;

        // 大人カベグループ
        _walls = new FlxGroup();
        var w4 = FlxG.width/4;
        var s = 4;
        var xList = [-s+w4, -s+w4, FlxG.width-w4, w4];
        var yList = [-s, -s, 0, FlxG.height-24];
        var wList = [s, FlxG.width+s, s, FlxG.width-w4*2];
        var hList = [FlxG.height+s, s, FlxG.height, 24];
        for(i in 0...4) {
            var w:FlxSprite = new FlxSprite(xList[i], yList[i]);
            w.makeGraphic(Math.floor(wList[i]), hList[i], FlxColor.GRAY);
            w.alpha = 0.5;
            w.immovable = true;
            _walls.add(w);
        }
        add(_walls);

        // CSV読み込み
        _csvEnemy = new CsvLoader();
        _csvEnemy.load("assets/data/enemy.csv");
        Enemy.csv = _csvEnemy;
        _csvBoss1 = new CsvLoader();
        _csvBoss1.load("assets/data/boss1.csv");
        _csvBoss2 = new CsvLoader();
        _csvBoss2.load("assets/data/boss2.csv");
        _csvBoss3 = new CsvLoader();
        _csvBoss3.load("assets/data/boss3.csv");

        // テキスト生成
        add(_player.getPowerText());
        _textShot = new FlxText(96, FlxG.height-12, 64);
        _textShield = new FlxText(160, FlxG.height-12, 64);
        _textLevel = new FlxText(4, 4, 64);
        _textLife = new FlxText(4, 4+12, 64);
        _textMessage = new FlxText(0, FlxG.height/2-32, FlxG.width, 8*2);
        _textMessage.alignment = "center";
        _textMessage.visible = false;
        _textPressKey = new FlxText(0, FlxG.height/2 + 16, FlxG.width);
        _textPressKey.alignment = "center";
        _textPressKey.text = "press z or space key.";
        _textPressKey.visible = false;
        add(_textShot);
        add(_textShield);
        add(_textLevel);
        add(_textLife);
        add(_textMessage);
        add(_textPressKey);

        // エミッタ
        _emitterEnemy = new EmitterEnemy();
        _emitterBoss = new EmitterBoss();
        _emitterBullet = new EmitterBullet();
        _emitterPlayer = new EmitterPlayer();
        add(_emitterEnemy);
        add(_emitterBoss);
        add(_emitterBullet);
        add(_emitterPlayer);
        Enemy.s_emitter = _emitterEnemy;
        Boss.s_emitter = _emitterBoss;
        Bullet.s_emitter = _emitterBullet;

        // 各種変数初期化
        _timer = 0;

        // レベル開始
        _nextLevel();

        FlxG.sound.volume = 1.0;
        FlxG.sound.playMusic("001");

        // デバッグ機能
        FlxG.debugger.toggleKeys = ["ALT"];
        FlxG.watch.add(this, "_state");
        FlxG.watch.add(this, "_timer");
        FlxG.watch.add(this, "_nShot");
        FlxG.watch.add(this, "_nEnemy");
        FlxG.watch.add(this, "_nBullet");
        FlxG.watch.add(_player, "x");
        FlxG.watch.add(_player, "y");
        FlxG.watch.add(_boss, "exists");
//        FlxG.watch.add(_player.getShield(), "exists");
//        FlxG.watch.add(_player.getShield(), "x");
//        FlxG.watch.add(_player.getShield(), "y");
    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();

    }

    private function _getWaitTime():Float {
        var tWait:Float = 1 - _level * 0.05;
        if(tWait < 0.1) {
            return 0.1;
        }
        return tWait;
    }

    private function _nextLevel():Void {
        _state = State.Init;

        _level++;
        Enemy.level = _level;
        _textMessage.visible = true;
        _textMessage.x = -200;
        _textMessage.text = "LEVEL: " + _level;
        FlxTween.tween(_textMessage, {x:0}, _getWaitTime(), {ease:FlxEase.expoOut, complete:_hideMessage});

        // ボス出現
        _boss.revive();
        _boss.x = FlxG.width/2 - _boss.width/2;
        _boss.y = 32;
        switch((_level-1)%3) {
            case 0: _boss.init(_level, _csvBoss1);
            case 1: _boss.init(_level, _csvBoss2);
            case 2: _boss.init(_level, _csvBoss3);
            default: throw "Error: Invalid level = " + _level;
        }
        _boss.visible = false;

        // 敵とボスの更新を止める
        _boss.active = false;
        _enemys.active = false;
        _player.stopRecover(true);
        _bullets.active = false;
        _shots.active = false;
        _hormings.active = false;
    }
    private function _hideMessage(tween:FlxTween):Void {
        _state = State.Main;
        FlxTween.tween(_textMessage, { x: FlxG.width }, _getWaitTime(), { ease: FlxEase.expoIn, complete:_hideMessageEnd });
    }
    private function _hideMessageEnd(tween:FlxTween):Void {
        _textMessage.visible = false;
        // 敵とボス動き出す
        _boss.active = true;
        _enemys.active = true;
        _bullets.active = true;
        _shots.active = true;
        _hormings.active = true;
        _player.stopRecover(false);
        _boss.visible = true;
        // BGM再生開始
//        switch((_level-1)%3) {
//            case 0: FlxG.sound.playMusic("001");
//            case 1: FlxG.sound.playMusic("002");
//            case 2: FlxG.sound.playMusic("003");
//        }
    }

    private function _setTextColor(text:FlxText, val:Int):Void {
        switch(val) {
            case a if(a <= 10):
                text.color = FlxColor.RED;
            case a if(a <= 40):
                text.color = FlxColor.YELLOW;
            default:
                text.color = FlxColor.WHITE;
        }
    }
    /**
     * テキスト更新
     **/
    private function _updateText():Void {
        _textShot.text = "Shot: "+_player.getPowerShotRatio() + "%";
        _setTextColor(_textShot, _player.getPowerShotRatio());
        _textShield.text = "Shield: "+_player.getPowerShieldRatio() + "%";
        _setTextColor(_textShield, _player.getPowerShieldRatio());
        _textLevel.text = "Level: " + _level;
        _textLife.text = "Lives: " + _lives;
        if(_lives == 0) {
            _textLife.color = FlxColor.RED;
        }
    }

    private function _updatePre():Void {
        // テキスト更新
        _updateText();

        _nShot = _shots.countLiving();
        _nEnemy = _enemys.countLiving();
        _nBullet = _bullets.countLiving();
        super.update();

#if !FLX_NO_DEBUG
        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }
#end

    }

    /**
     * 更新有効フラグを設定する
     **/
    private function _setActiveAll(b:Bool):Void {
        _player.active = b;
        _shots.active = b;
        _hormings.active = b;
        _enemys.active = b;
        _boss.active = b;
        _bullets.active = b;
    }

    /**
     * 更新
     **/
    override public function update():Void {

        _updatePre();

        switch(_state) {
        case State.Init:

        case State.Main:
            _updateMain();
        case State.Damage:
            _updateDamage();
        case State.GameoverInt:
            _timer--;
            if(_timer < 1) {
                _state = State.GameoverMain;
            }
        case State.GameoverMain:
            if(FlxG.keys.anyJustPressed(["SPACE", "Z"])) {
                FlxG.resetState();
            }
            FlxG.collide(_hormings, _enemys, _vsHormingEnemy);
            FlxG.collide(_shots, _boss, _vsShotBoss);
            FlxG.collide(_hormings, _boss, _vsHormingBoss);
        }
        FlxG.collide(_player, _walls);
    }


    private function _updateMain():Void {

        _timer++;

        if(_boss.exists == false) {
            // ボスが死んだので次のレベルに進む
            _nextLevel();
            var name = "00" + (((_level-1)%6)+1);
            FlxG.sound.playMusic(name);
            FlxG.sound.play("levelup");
            return;
        }

        // 当たり判定
        FlxG.collide(_player, _bullets, _vsPlayerBullet);
        FlxG.collide(_shots, _enemys, _vsShotEnemy);
        FlxG.collide(_hormings, _enemys, _vsHormingEnemy);
        FlxG.collide(_shots, _boss, _vsShotBoss);
        FlxG.collide(_hormings, _boss, _vsHormingBoss);
        FlxG.overlap(_player.getShield(), _bullets, _vsShieldBullet);
//        FlxG.collide(_player.getShield(), _bullets, _vsShieldBullet);
    }
    private function _updateDamage():Void {
        _timer--;
        if(_timer < 1) {
            _state = State.Main;
            _setActiveAll(true);
        }
    }

    private function _vsPlayerBullet(player:Player, bullet:Bullet):Void {
        bullet.vanish();
        if(_player.isInvisibled() == false) {

            // 死亡処理
            // 破壊エフェクト再生
            _emitterPlayer.explode(_player.x+_player.width/2, _player.y+_player.height/2);
            FlxG.sound.play("damage");

            _lives--;
            if(_lives < 0) {
                // ゲームオーバーへ
                _player.vanish();
                _lives = 0;
                _state = State.GameoverInt;
                _timer = TIMER_GAMEOVER_INIT;
                _textMessage.x = 0;
                _textMessage.text = "GameOver";
                _textMessage.visible = true;
                _textPressKey.visible = true;
            }
            else {
                // 復活
                _player.init();

                // ダメージ状態へ
                _state = State.Damage;
                _timer = TIMER_DAMAGE;
                _setActiveAll(false); // すべてのオブジェクトの動きを止める

                // 敵弾を全消す
                _bullets.forEachAlive(
                function(b:Bullet) {
                    b.vanish(); // すべて消す
                });
            }

            // ダメージ演出
            FlxG.camera.flash(0xffFFFFFF, 0.3);
            FlxG.camera.shake(0.02, 0.35);
        }
    }

    private static inline var POWER_SHOT = 1; // 通常ショットの威力
    private static inline var POWER_HORMING = 10; // ホーミング弾の威力
    private function _vsShotEnemy(shot:Shot, enemy:Enemy):Void {
        enemy.damage(POWER_SHOT);
        shot.kill();
    }

    private function _vsHormingEnemy(horming:Horming, enemy:Enemy):Void {
        enemy.damage(POWER_HORMING);
        horming.vanish();
    }

    private function _vsShotBoss(shot:Shot, boss:Boss):Void {
        boss.damage(POWER_SHOT);
        shot.kill();
    }

    private function _vsHormingBoss(horming:Horming, boss:Boss):Void {
        boss.damage(POWER_HORMING);
        horming.vanish();
    }
    private function _vsShieldBullet(shield:Shield, bullet:Bullet):Void {
        shield.velocity.set(bullet.velocity.x, bullet.velocity.y);
        bullet.vanish();
        var h:Horming = _hormings.getFirstDead();
        if(h != null) {
            h.init(bullet.x, bullet.y, bullet.velocity);
            h.revive();
            if(s_sndHorming != null) {
                s_sndHorming.stop();
            }
            s_sndHorming = FlxG.sound.play("horming");
        }
    }
}