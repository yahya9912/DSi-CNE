import funkin.backend.utils.DiscordUtil;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.FlxObject;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;
import std.Xml;

var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var curSelected:Int = 0;
var portVer:Int = 0.1;

var camFollow:FlxObject;
var camFollowPos:FlxObject;
var camFollowXOffset:Float;

var iconYArray:Array<Float> = [];

var apps:Array<{name:String,type:String,description:String,icon:String}> = [];

var menuNames = ["settings", "cart" "camera", "sound", "shop"];

DiscordUtil.changePresence("In the DSi Home Menu", null);
window.title = "Nintendo DSi";
FlxG.mouse.visible = true;

function changeOption(change){ //called when you scroll on the menu
	FlxG.sound.play(Paths.sound('LiveArea/menuMove'));


	curSelected = FlxMath.wrap(curSelected + change, 0, apps.length-1);

	descText.text = apps.role;
	descText2.text = apps.description;

	iconGroup.members[curSelected].alpha = 1;
	camFollow.setPosition(Std.int(curSelected / 1) * 150 + 230, 0);
}

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
	bg.scrollFactor.set();
	add(bg);

	var data:Xml = Xml.parse(Assets.getText(Paths.file("data/home.xml"))).firstElement();
    for (trophy_data in data.elementsNamed("app")) {
        apps.push({
            name: trophy_data.get("name"),
            type: trophy_data.get("type"),
            creator: trophy_data.get("cred"),
            icon: trophy_data.get("icon"),
        });
    }

	camFollow = new FlxObject(640, 342, 1, 1);
	camFollowPos = new FlxObject(640, 342, 1, 1);
	add(camFollow);
	add(camFollowPos);
	iconGroup = new FlxTypedGroup();
	add(iconGroup);

	for (i in 0...apps.length)  //THESE LIL NIGGAS KEPT BREAKING MY MENUS 😭💔🙏🏾🐝💩
		{
			var icon:FlxSprite = new FlxSprite(i % 1 * 1470 + 100, Std.int(i / 1) * 120);
			icon.loadGraphic(Paths.image(('icons/') + apps[i].icon));
			icon.setGraphicSize(110);
			icon.ID = i; icon.antialiasing = false;
			icon.updateHitbox();
			iconGroup.add(icon);
			iconYArray.push(icon.y);
	
			icon.y += 283;
		}

	FlxG.camera.follow(camFollowPos, null, 2);

	descText = new FlxText(32, 10, FlxG.width, "", 19, true);
	descText.setFormat("vita/n023055ms.ttf", 30, FlxColor.WHITE, "center");
	descText.scrollFactor.set();
	add(descText);

	descTextName = new FlxText(32, 620, FlxG.width, "", 19, true);
	descTextName.setFormat("vita/n023055ms.ttf", 50, FlxColor.WHITE, "center");
	descTextName.scrollFactor.set();
	add(descTextName);

	settings = new FlxSprite(103, 283).loadGraphic(Paths.image('icons/settings'));
	add(settings);
	
	playbutt = new FlxSprite(0, 275).loadGraphic(Paths.image('buttonplay'));
	playbutt.screenCenter(FlxAxes.X);
	playbutt.scrollFactor.set();
	add(playbutt);


	vol = new FlxSprite(7,4).loadGraphic(Paths.image('volume'));
	vol.scrollFactor.set();
	add(vol);

	notif = new FlxSprite(3, 197).loadGraphic(Paths.image("bubble"));
	notif.alpha = 0;
	add(notif);

	new FlxTimer().start(.8, function(){ //you gotta wait so you can select stuffies :3
		canSelect = true;
		FlxTween.tween(notif, {alpha: 1}, .1);
	});
	
	arrL = new FlxSprite(0, 365).loadGraphic(Paths.image("arrowleft"));
	arrL.scrollFactor.set();
    add(arrL);

	arrR = new FlxSprite(365, 237).loadGraphic(Paths.image("arrowright"));
	arrR.scrollFactor.set();
    add(arrR);

	fard = new CustomShader("fart");
    FlxG.camera.addShader(fard);

	battery = new FlxSprite(235, 7).loadGraphic(Paths.image('battery'));
	battery.scrollFactor.set();
    add(battery);

	versionShit = new FunkinText(4, FlxG.height, 0, 'WORK IN PROGRESS | Nintendo DSi');
	add(versionShit);

	usertext = new FunkinText(28, FlxG.height, 0, 'Yahya :3');
	usertext.y -= usertext.height + 365;
	add(usertext);
}

function update(elapsed:Float) {

	if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new ModState("DSi/camera")); 
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("DSi/shop"));
	//if (FlxG.keys.justPressed.SIX) FlxG.switchState(new Freeplay());

	if (controls.LEFT_P)     changeOption(-1); //makes you scroll the apps
	if (controls.RIGHT_P)   changeOption(1); //same with above
	if (FlxG.mouse.wheel)  changeOption(-1); //same with above but cooler 🗣🗣
	if (-FlxG.mouse.wheel) changeOption(1); //im killing myself!
	
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

			case 'apps':
				FlxG.switchState(new Trophies());
				trace("Credits Menu Selected");

			case 'settings':
				FlxG.switchState(new Settings());
				trace("Welcome to the LiveArea!");
				FlxG.sound.play(Paths.sound('LiveArea/enter'), 1);
		};
}
