import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;
import flixel.group.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.FlxState;

var optionShit:Array<String> = ['camera', 'album', 'exit', 'calendar', 'other'];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var curSelected:Int = 0;


DiscordUtil.changePresence("In the DSi Camera", null);
window.title = "Nintendo DSi | DSi Camera";

function create(){
	FlxG.sound.playMusic(Paths.music("camera"));

	grid = new FlxBackdrop(Paths.image('camera/bg'));
	grid.updateHitbox();
	grid.antialiasing = false;
	grid.velocity.x = grid.velocity.y = 10;
	add(grid);

	text = new FunkinText(28, 5, 0, 'Nintendo DSi Camera');
	add(text);

	for(i in 0...optionShit.length){
		var menuItem:FunkinSprite = new FunkinSprite(0, 130);
		if(i > 3) menuItem.frames = Paths.getSparrowAtlas('camera/big-buttons');
		else menuItem.frames = Paths.getSparrowAtlas('camera/buttons');
		menuItem.animation.addByPrefix('idle', optionShit[i], 24, true);
		menuItem.animation.addByPrefix('hover', optionShit[i] + ' Select', 24, false);
		menuItem.ID = i;
		menuItems.add(menuItem);
		//menuItem.updateHitbox();
		menuItem.antialiasing = false;

		switch(optionShit[i]){
			case "exit": menuItem.setPosition(160, 0);
			case "calendar": menuItem.setPosition(160, 80);
			case "other": menuItem.setPosition(160, 176);
			
			case "camera": menuItem.setPosition(16, 251);
			case "album": menuItem.setPosition(116, 251);
		}
	}
	add(menuItems);

	
	updateItems();
}

var selectedSomethin:Bool = false;

function update(elapsed:Float) {

	if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new ModState("menus/Settings")); 
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("menus/Trophies"));
	if (controls.LEFT_P)  changeItem(-1);
	if (controls.RIGHT_P) changeItem(1);
	if (controls.BACK)    FlxG.switchState(new ModState("DSi/home"));
	if (controls.ACCEPT)  selectItem();

	if (!selectedSomethin){
		for (i in menuItems.members){
			if (FlxG.mouse.overlaps(i)){
				curSelected = menuItems.members.indexOf(i);
				updateItems();

				if (FlxG.mouse.justPressed) selectItem();
			}
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

		var daChoice:String = optionShit[curSelected];

		var event = event("onSelectItem", EventManager.get(NameEvent).recycle(daChoice));
		if (event.cancelled) return;
		switch (daChoice)
		{
			case 'exit':   FlxG.switchState(new ModState('DSi/home'));
			case 'camera': FlxG.switchState(new FreeplayState());
			case 'calendar': FlxG.switchState(new Trophies());
		};
}