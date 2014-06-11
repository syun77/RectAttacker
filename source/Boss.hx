package ;

import flixel.text.FlxText;
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
    static public var s_emitter:EmitterBoss;

    private var _hpmax:Int = 0;
    private var _hp:Int = 0;
    private var _timer:Int = 0;
    private var _id:Int = 0;

    private var _text:FlxText;
    private var _csv:CsvLoader;

    public function new() {
        super(-100, -100);
        makeGraphic(24, 24, FlxColor.FOREST_GREEN);
        immovable = true; // 反動で動かないようにする

        _text = new FlxText(-100, -100, 64);
        _text.setFormat(null, 8, FlxColor.WHITE, "center");
        _text.kill();

        // 非表示にする
        kill();

        FlxG.watch.add(this, "_timer");
    }

    public function getText():FlxText {
        return _text;
    }

    /**
     * 初期化
     * @param id 敵ID
     **/
    public function init(id:Int, csv:CsvLoader):Void {
        _id = id;
        _hp = 45 + id * 5;
        _hpmax = _hp;
        _text.revive();
        _text.x = x + width/2 - _text.width/2;
//        _text.y = y + height/2 - _text.height/2;
        _text.y = y - 16;
        _text.text = "" + _hp;

        _csv = csv;

        _timer = 0;
    }

    /**
     * 消滅する
     **/
    public function vanish():Void {
        kill();
        _text.kill();
        s_emitter.explode(x+width/2, y+height/2);
    }

    /**
     * ダメージ処理
     **/
    public function damage(val:Int):Void {
        _hp -= val;
        if(_hp <= 0) {
            _hp = 0;
            vanish(); // 消滅する
        }

        // テキスト更新
        _text.text = "" + _hp;
    }

    /**
     * 敵の生成
     **/
    public function addEnemy(eid:Int, dir:Float, speed:Float):Void {
        var e:Enemy = s_enemys.getFirstDead();
        if(e != null) {
//            trace("eid="+eid+" dir="+dir+" speed="+speed);
            e.x = x + width/2;
            e.y = y + height/2;
            var rad = dir*FlxAngle.TO_RAD;
            e.velocity.x = speed * Math.cos(rad);
            e.velocity.y = speed * -Math.sin(rad);
            e.init(eid);

        }
    }

    override public function update():Void {
        super.update();

        _timer++;
        var i = _timer;
        if(_csv.hasId(i)) {
            var cmd = _csv.getString(i, "cmd");
            switch(cmd) {
            case "e":
                var eid = _csv.getInt(i, "eid");
                var dir = _csv.getInt(i, "dir");
                var speed = _csv.getInt(i, "speed");
                var rnd = _csv.getInt(i, "rnd");
                addEnemy(eid, dir+FlxRandom.floatRanged(0, rnd), speed);
            case "time":
                var val = _csv.getInt(i, "val");
                _timer = val;
            }
        }
    }
}
