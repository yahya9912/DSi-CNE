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

	text = new FlxSprite().loadGraphic(Paths.image('shop/warningText'));
	text.y = 191;
	add(text);

	exit = new FlxSprite().loadGraphic(Paths.image('shop/exit'));
	exit.y = 345;
	exit.screenCenter(FlxAxes.X);
	add(exit);
	
	exit1 = new FlxSprite().loadGraphic(Paths.image('shop/exitS'));
	exit1.alpha = 0;
	exit1.y = 343;
	exit1.screenCenter(FlxAxes.X);
	add(exit1);
	
	


	troph = new FlxSprite().loadGraphic(Paths.image('battery'));
    //troph.scale.set(1, 1);
    troph.x = 235;
	troph.y = 7;
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