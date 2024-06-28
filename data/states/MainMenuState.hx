import funkin.backend.utils.DiscordUtil;
import flixel.FlxState;

DiscordUtil.changePresence("About to boot their console.", null);

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.I) FlxG.switchState(new ModState("DSi/home")); 
	//if (FlxG.keys.justPressed.SIX) FlxG.switchState(new Freeplay());
}