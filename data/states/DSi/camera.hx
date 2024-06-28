import funkin.backend.utils.DiscordUtil;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import lime.app.Application;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;

var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var curSelected:Int = 0;

var optionShit:Array<String> = ['camera', 'album', 'exit', 'calendar', 'other'];

DiscordUtil.changePresence("In the DSi Camera", null);
window.title = "Nintendo DSi | DSi Camera";

function create(){
	FlxG.sound.playMusic(Paths.music("camera"));

	bg = new FlxSprite().loadGraphic(Paths.image('bg'));
	//add(bg);
	
	arrL = new FlxSprite().loadGraphic(Paths.image("arrowleft"));
	arrL.y = 365;
    //add(arrL);

	arrR = new FlxSprite().loadGraphic(Paths.image("arrowright"));
	arrR.y = 365;
	arrR.x = 237;
    //add(arrR);

	troph = new FlxSprite().loadGraphic(Paths.image('battery'));
    //troph.scale.set(1, 1);
    troph.x = 235;
	troph.y = 7;
    add(troph);

	versionShit = new FunkinText(4, FlxG.height, 0, 'WORK IN PROGRESS');
	versionShit.y -= versionShit.height + 22;
	add(versionShit);

	text = new FunkinText(4, FlxG.height, 0, 'Nintendo DSi Camera');
	text.y  = 5;
	text.x = 28;
	add(text);

	for(i in 0...optionShit.length){
		var menuItem:FunkinSprite = new FunkinSprite(0, 0);
		if(i > 3) menuItem.frames = Paths.getSparrowAtlas('camera/big-buttons');
		else menuItem.frames = Paths.getSparrowAtlas('camera/buttons');
		menuItem.animation.addByPrefix('idle', optionShit[i], 24, true);
		menuItem.animation.addByPrefix('hover', optionShit[i] + ' Select', 24, true);
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.updateHitbox();
		menuItem.antialiasing = false;

		switch(optionShit[i]){
			case "camera": menuItem.setPosition(16, 251);
			case "album": menuItem.setPosition(116, 251);

			case "exit": menuItem.setPosition(360, 0);
			case "calendar": menuItem.setPosition(360, 80);
			case "other": menuItem.setPosition(360, 176);
		}
	}

	add(menuItems);
	
	updateItems();
}

var selectedSomethin:Bool = false;

function update(elapsed:Float) {

	if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new ModState("menus/Settings")); 
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("menus/Trophies"));
	//if (FlxG.keys.justPressed.SIX) FlxG.switchState(new Freeplay());

	if (controls.LEFT_P)
		changeItem(-1);

	if (controls.RIGHT_P)
		changeItem(1);

	if (controls.BACK)
		FlxG.switchState(new ModState("DSi/home"));

	// make it customisable
	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new EditorPicker());
	}
	
	if (controls.SWITCHMOD) {
		persistentUpdate = false;
		openSubState(new ModSwitchMenu());
	}

	if (controls.ACCEPT)
	{
		selectItem();
	}

	if (!selectedSomethin){
		for (i in menuItems.members){
			if (FlxG.mouse.overlaps(i)){
				curSelected = menuItems.members.indexOf(i);
				updateItems();

				if (FlxG.mouse.justPressed)
					selectItem();
			}else
				i.animation.play("idle", true);
		}
	}

}

function updateItems() {
	menuItems.forEach(function(spr:FunkinSprite) {
		spr.animation.play('idle');
		if (spr.ID == curSelected) spr.animation.play('hover');
	});
}

function changeItem(huh:Int = 0) {
	curSelected += huh;

	if (curSelected >= menuItems.length) curSelected = 0;
	if (curSelected < 0) curSelected = menuItems.length - 1;
}

function selectItem() {
	selectedSomethin = true;
	confirm.play();

		var daChoice:String = menuNames[curSelected];

		var event = event("onSelectItem", EventManager.get(NameEvent).recycle(daChoice));
		if (event.cancelled) return;
		switch (daChoice)
		{
			case 'exit':
				FlxG.switchState(new ModState('DSi/home'));
				trace("Exit Selected");

			case 'camera':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");

			case 'trophies':
				FlxG.switchState(new Trophies());
				trace("Credits Menu Selected");

			case 'exit':
				FlxG.switchState(new Settings());
				trace("Welcome to the LiveArea!");
				FlxG.sound.play(Paths.sound('LiveArea/enter'), 1);
		};
}