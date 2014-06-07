package;

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
 * メインゲームState
 **/
class PlayState extends FlxState {

    // プレイヤー
    private var _player:Player;
    // ショットグループ
    private var _shots:FlxTypedGroup<Shot>;
    // 敵グループ
    private var _enemys:FlxTypedGroup<Enemy>;
    // 敵弾グループ
    private var _bullets:FlxTypedGroup<Bullet>;
    // テキスト
    private var _text:FlxText;
    // テキスト
    private var _text2:FlxText;
    // テキスト
    private var _text3:FlxText;

    private var _timer:Int;

    /**
     * 生成
     **/
    override public function create():Void {
        super.create();

        // プレイヤー生成
        _player = new Player();
        add(_player);

        // メッセージテキスト生成
        _text = new FlxText(0, 0);
        add(_text);
        _text2 = new FlxText(0, 16);
        add(_text2);
        _text3 = new FlxText(0, 32);
        add(_text3);

        // ショット生成
        _shots = new FlxTypedGroup<Shot>(8);
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

        // 敵弾グループ
        _bullets = new FlxTypedGroup<Bullet>(256);
        for(i in 0..._bullets.maxSize) {
            _bullets.add(new Bullet());
        }
        add(_bullets);
        Enemy.s_bullets = _bullets;

        // 各種変数初期化
        _timer = 0;

    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * 更新
     **/
    override public function update():Void {

        _timer++;
        if(_timer%60 == 0 && _enemys.countLiving() == 0) {
            var e:Enemy = _enemys.recycle();
            e.x = FlxG.width/2;
            e.y = 64;
        }

        _text.text = "shot:" + _shots.countLiving();
        _text2.text = "enemy:" + _enemys.countLiving();
        _text3.text = "bullet:" + _bullets.countLiving();
        super.update();

        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }

        // 当たり判定
        FlxG.collide(_player, _bullets, _vsPlayerBullet);
        FlxG.collide(_shots, _enemys, _vsShotEnemy);
    }

    private function _vsPlayerBullet(player:Player, bullet:Bullet):Void {
        bullet.kill();
    }

    private function _vsShotEnemy(shot:Shot, enemy:Enemy):Void {
        shot.kill();
    }
}