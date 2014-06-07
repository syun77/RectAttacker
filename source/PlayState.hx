package;

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
    // 大人カベ
    private var _walls:FlxGroup;

    private var _timer:Int;

    private var _nShot:Int = 0;
    private var _nEnemy:Int = 0;
    private var _nBullet:Int = 0;
    private var _dbgButton:FlxSystemButton;


    /**
     * 生成
     **/
    override public function create():Void {
        super.create();

        // プレイヤー生成
        _player = new Player();
        add(_player);

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

        // 大人カベグループ
        _walls = new FlxGroup();
        var w4 = FlxG.width/4;
        var s = 4;
        var xList = [-s+w4, -s+w4, FlxG.width-w4, w4];
        var yList = [-s, -s, 0, FlxG.height];
        var wList = [s, FlxG.width+s, s, FlxG.width];
        var hList = [FlxG.height+s, s, FlxG.height, s];
        for(i in 0...4) {
            var w:FlxSprite = new FlxSprite(xList[i], yList[i]);
            w.makeGraphic(wList[i], hList[i], FlxColor.GRAY);
            w.alpha = 0.5;
            w.immovable = true;
            _walls.add(w);
        }
        add(_walls);

        // 各種変数初期化
        _timer = 0;

        // デバッグ機能
        FlxG.debugger.toggleKeys = ["ALT"];
        FlxG.watch.add(this, "_nShot");
        FlxG.watch.add(this, "_nEnemy");
        FlxG.watch.add(this, "_nBullet");
        FlxG.watch.add(_player, "x");
        FlxG.watch.add(_player, "y");
        _dbgButton = FlxG.debugger.addButton(ButtonAlignment.MIDDLE, _player.getFlxFrameBitmapData(), FlxG.resetState);
    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();
        FlxG.debugger.removeButton(_dbgButton);
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
            e.init(1);
        }

        _nShot = _shots.countLiving();
        _nEnemy = _enemys.countLiving();
        _nBullet = _bullets.countLiving();
        super.update();

        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }

        // 当たり判定
        FlxG.collide(_player, _bullets, _vsPlayerBullet);
        FlxG.collide(_shots, _enemys, _vsShotEnemy);
        FlxG.collide(_player, _walls);
    }

    private function _vsPlayerBullet(player:Player, bullet:Bullet):Void {
        bullet.kill();
    }

    private function _vsShotEnemy(shot:Shot, enemy:Enemy):Void {
        enemy.damage(1);
        shot.kill();
    }
}