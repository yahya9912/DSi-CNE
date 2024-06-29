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
var portVer:Int = 0.1;

var menuNames = ["settings", "cart" "camera", "sound", "shop"];

DiscordUtil.changePresence("In the DSi Home Menu", null);
window.title = "Nintendo DSi";
FlxG.mouse.visible = true;

function create(){
	window.fullscreen = false;	
    FlxG.width = 256;
    FlxG.height = 386;
    FlxG.initialWidth = 256;
    FlxG.initialHeight = 386;
    FlxG.resizeGame(256 , 386 );
    window.resize(FlxG.width, FlxG.height);
	FlxG.sound.playMusic(Paths.music("bios"));

	bg = new FlxSprite().loadGraphic(Paths.image('bg'));
	add(bg);

	settings = new FlxSprite(103, 283).loadGraphic(Paths.image('icons/settings'));
	add(settings);
	
	playbutt = new FlxSprite(0, 275).loadGraphic(Paths.image('buttonplay'));
	playbutt.screenCenter(FlxAxes.X);
	add(playbutt);


	vol = new FlxSprite(7,4).loadGraphic(Paths.image('volume'));
	add(vol);

	notif = new FlxSprite(3, 197).loadGraphic(Paths.image("bubble"));
	notif.alpha = 0;
	add(notif);

	new FlxTimer().start(.8, function(){ //you gotta wait so you can select stuffies :3
		canSelect = true;
		FlxTween.tween(notif, {alpha: 1}, .1);
	});
	
	arrL = new FlxSprite(0, 365).loadGraphic(Paths.image("arrowleft"));
    add(arrL);

	arrR = new FlxSprite(365, 237).loadGraphic(Paths.image("arrowright"));
    add(arrR);

	fard = new CustomShader("fart");
    //FlxG.camera.addShader(fard);

	battery = new FlxSprite(235, 7).loadGraphic(Paths.image('battery'));
    add(battery);

	versionShit = new FunkinText(4, FlxG.height, 0, 'WORK IN PROGRESS | Nintendo DSi');
	versionShit.y -= versionShit.height + 22;
	add(versionShit);

	usertext = new FunkinText(28, FlxG.height, 0, 'Yahya :3');
	usertext.y -= usertext.height + 365;
	add(usertext);
}

function update(elapsed:Float) {

	if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new ModState("DSi/camera")); 
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("DSi/shop"));
	//if (FlxG.keys.justPressed.SIX) FlxG.switchState(new Freeplay());

	if (controls.LEFT_P)  changeItem(-1);
	if (controls.RIGHT_P) changeItem(1);
	
	if (controls.BACK){
		FlxG.switchState(new MainMenuState());
		FlxG.resizeGame(1280, 720);
		FlxG.resizeWindow(1280, 720);
		FlxG.width = 1280;
		FlxG.height = 720;
		FlxG.initialWidth = 1280;
		FlxG.initialHeight = 720;	
	}

	// make it customisable
	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new EditorPicker());
	}
	
	if (controls.SWITCHMOD) {
		persistentUpdate = false;
		openSubState(new ModSwitchMenu());
	}

	if (controls.ACCEPT) selectItem();

}

function selectItem() {
	selectedSomethin = true;
	confirm.play();

		var daChoice:String = menuNames[curSelected];

		var event = event("onSelectItem", EventManager.get(NameEvent).recycle(daChoice));
		if (event.cancelled) return;
		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Mode Selected");

			case 'camera':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");

			case 'trophies':
				FlxG.switchState(new Trophies());
				trace("Credits Menu Selected");

			case 'settings':
				FlxG.switchState(new Settings());
				trace("Welcome to the LiveArea!");
				FlxG.sound.play(Paths.sound('LiveArea/enter'), 1);
		};
}
