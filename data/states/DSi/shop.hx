import funkin.backend.utils.DiscordUtil;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import lime.app.Application;

DiscordUtil.changePresence("In the DSi Shop", null);
window.title = "Nintendo DSi | DSi Shop";
FlxG.mouse.visible = true;

function create(){
	FlxG.sound.playMusic(Paths.music("shop"));

	bg = new FlxSprite().loadGraphic(Paths.image('shop/bg'));
	add(bg);

	text = new FlxSprite(0, 191).loadGraphic(Paths.image('shop/warningText'));
	add(text);

	exit = new FlxSprite(0, 345).loadGraphic(Paths.image('shop/exit'));
	exit.screenCenter(FlxAxes.X);
	add(exit);
	
	exit1 = new FlxSprite(0, 343).loadGraphic(Paths.image('shop/exitS'));
	exit1.alpha = 0;
	exit1.screenCenter(FlxAxes.X);
	add(exit1);
	
	troph = new FlxSprite(235, 7).loadGraphic(Paths.image('battery'));
    add(troph);


}

function update(elapsed:Float){ 	
		if (FlxG.mouse.overlaps(exit))	{	
			exit1.alpha = 1;
			if (FlxG.mouse.justPressed) {
			FlxG.switchState(new ModState("DSi/home")); 
			FlxG.sound.play(Paths.sound('menu/confirm'));			
		}
	}
	else exit1.alpha = 0;	
}