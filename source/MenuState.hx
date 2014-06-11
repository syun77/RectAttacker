package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    private var _textTitle:FlxText;
    private var _textCopyright:FlxText;
    private var _textPressKey:FlxText;
    private var _timer:Int = 0;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        _textTitle = new FlxText(0, FlxG.height/2-32, FlxG.width);
        _textTitle.text = "RECT ATTACKER";
        _textTitle.alignment = "center";
        _textTitle.size = 16;
        add(_textTitle);

        _textCopyright = new FlxText(0, FlxG.height-16, FlxG.width);
        _textCopyright.text = "(C)2014 2dgames.jp";
        _textCopyright.alignment = "center";
        add(_textCopyright);

        _textPressKey = new FlxText(0, FlxG.height/2+32, FlxG.width);
        _textPressKey.text = "Press z or space key";
        _textPressKey.alignment = "center";
        add(_textPressKey);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
        _timer++;
        _textPressKey.visible = (_timer%48 < 32);

        if(FlxG.keys.anyJustPressed(["Z", "SPACE"])) {
            FlxG.switchState(new PlayState());
        }
	}
}