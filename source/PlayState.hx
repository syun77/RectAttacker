package;

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
    // テキスト
    private var _text:FlxText;

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

        // ショット生成
        _shots = new FlxTypedGroup<Shot>(32);
        for(i in 0...32) {
            _shots.add(new Shot());
        }
        add(_shots);
        _player.setShots(_shots);
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
        _text.text = "shot:" + _shots.countLiving();
        super.update();

        if(FlxG.keys.justPressed.ESCAPE) {
            throw "Terminate.";
        }
    }
}