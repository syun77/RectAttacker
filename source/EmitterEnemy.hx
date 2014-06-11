package ;

import flixel.util.FlxColor;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
/**
 * 敵破壊エフェクト
 **/
class EmitterEnemy extends FlxEmitter {
    private static inline var SPEED:Int = 100;
    private static inline var SIZE:Int = 10;

    public function new() {
        super(0, 0, SIZE);
        setXSpeed(-SPEED, SPEED);
        setYSpeed(-SPEED, SPEED);

        // パーティクル生成
        for(i in 0...SIZE) {
            var p:FlxParticle = new FlxParticle();
            p.makeGraphic(2, 2, FlxColor.GREEN);
            add(p);
        }
    }

    public function explode(px:Float, py:Float):Void {
        x = px;
        y = py;
        start(true, 1, 0, SIZE, 1);
    }
}
