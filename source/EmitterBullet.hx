package ;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
/**
 * 敵弾破壊エフェクト
 **/
class EmitterBullet extends FlxEmitter {
    private static inline var SPEED:Int = 200;
    private static inline var SIZE:Int = 128;

    public function new() {
        super(0, 0, SIZE);
        setXSpeed(-SPEED, SPEED);
        setYSpeed(-SPEED, SPEED);
        gravity = 50;

        // パーティクル生成
        for(i in 0...SIZE) {
            add(new ParticleBullet());
        }
    }

    public function explode(px:Float, py:Float):Void {
        x = px;
        y = py;
        start(true, 1, 0, 4, 1);
    }
}

class ParticleBullet extends FlxParticle {
    private var _timer:Int = 0;
    public function new() {
        super();
        makeGraphic(2, 2, FlxColor.SALMON);
    }
    override public function update():Void {
        _timer++;
        visible = if(_timer%4 < 2) true else false;
        velocity.x *= 0.97;
        velocity.y *= 0.97;
        super.update();
    }
}
