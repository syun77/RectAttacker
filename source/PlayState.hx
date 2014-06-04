package;

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

    /**
     * 生成
     **/
    override public function create():Void {
        super.create();

        _player = new Player();
        add(_player);
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
        super.update();
    }
}