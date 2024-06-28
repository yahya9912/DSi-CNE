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

var fard:CustomShader;
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var curSelected:Int = 0;
var portVer:Int = 0.1;

var menuNames = ["settings", "cart" "camera", "sound", "sudoku"];

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

	settings = new FlxSprite().loadGraphic(Paths.image('icons/settings'));
	add(settings);
	settings.x = 103;
	settings.y = 283;
	
	playbutt = new FlxSprite().loadGraphic(Paths.image('buttonplay'));
	playbutt.screenCenter(FlxAxes.X);
	add(playbutt);
	playbutt.y = 275;


	vol = new FlxSprite().loadGraphic(Paths.image('volume'));
	vol.y = 7; 
	vol.x = 4;
	add(vol);

	notif = new FlxSprite().loadGraphic(Paths.image("bubble"));
	notif.x = 3;
	notif.y = 197;
	add(notif);
	//notif.y = 183 = 678;
	
	arrL = new FlxSprite().loadGraphic(Paths.image("arrowleft"));
    //bg.colorTransform.color = 0xFFFFFFFF;
    arrL.scale.set(1, 1);
    add(arrL);
	arrL.y = 365;

	arrR = new FlxSprite().loadGraphic(Paths.image("arrowright"));
    //bg.colorTransform.color = 0xFFFFFFFF;
    arrR.scale.set(1, 1);
    add(arrR);
	arrR.y = 365;
	arrR.x = 237;

	fard = new CustomShader("fart");
    //FlxG.camera.addShader(fard);

	troph = new FlxSprite().loadGraphic(Paths.image('battery'));
    //troph.scale.set(1, 1);
    troph.x = 235;
	troph.y = 7;
    add(troph);

	versionShit = new FunkinText(4, FlxG.height, 0, 'WORK IN PROGRESS | Nintendo DSi');
	versionShit.y -= versionShit.height + 22;
	add(versionShit);

	usertext = new FunkinText(4, FlxG.height, 0, 'Yahya :3');
	usertext.y -= usertext.height + 365;
	usertext.x = 28;
	add(usertext);
}

function update(elapsed:Float) {

	if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new ModState("DSi/camera")); 
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("DSi/shop"));
	//if (FlxG.keys.justPressed.SIX) FlxG.switchState(new Freeplay());

	if (controls.LEFT_P)
		changeItem(-1);
	
	if (controls.RIGHT_P)
		changeItem(1);
	
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

	if (controls.ACCEPT)
	{
		selectItem();
	}

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
