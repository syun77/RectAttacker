package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
/**
 * ボスクラス
 */
class Boss extends FlxSprite {
    static public var s_enemys:FlxTypedGroup<Enemy>;

    private var _hpmax:Int = 0;
    private var _hp:Int = 0;
    private var _timer:Int = 0;
    private var _id:Int = 0;

    public function new() {
        super(-100, -100);
        makeGraphic(8, 8, FlxColor.GREEN);
        immovable = true; // 反動で動かないようにする

        // 非表示にする
        kill();
    }

    /**
     * 初期化
     * @param id 敵ID
     **/
    public function init(id:Int):Void {
        _id = id;
        _hp = 30;
        _hpmax = _hp;
        var size = FlxRandom.intRanged(8, 32);
        makeGraphic(size, size, FlxColor.GREEN);
        // 出現位置調整
        x -= size/2;
        y -= size/2;
    }

    /**
     * ダメージ処理
     **/
    public function damage(val:Int):Void {
        _hp -= val;
        if(_hp <= 0) {
            _hp = 0;
            kill();
        }
    }

    /**
     * 敵の生成
     **/
    public function addEnemy(dir:Float, speed:Float):Void {
        var e:Enemy = s_enemys.recycle();
        e.x = FlxG.width/2;
        e.y = 64;
        var rad = dir*FlxAngle.TO_RAD;
        e.velocity.x = speed * Math.cos(rad);
        e.velocity.y = speed * Math.sin(rad);
        e.init(1);
    }

    override public function update():Void {
        super.update();

        _timer++;
        if(_timer%120 == 0) {
            addEnemy(FlxRandom.floatRanged(270-45, 270+45), 100);
        }
    }
}
