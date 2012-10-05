SuperStrict

?Win32
Import "../include/fullaccess.cpp"
Import "-ladvapi32"
?

'Import various Mac OS API calls made in C.

?MacOS
Import "../include/GAGMacLib.m"
?

Import "../DreamBlitz/DreamBlitz.bmx"

Include "TIronRoadsTGame.bmx"
Include "TCity.bmx"
Include "TFreight.bmx"
Include "TTrack.bmx"
Include "TCityButton.bmx"
Include "TTrackButton.bmx"
Include "TAboutScreen.bmx"
Include "TTitleScreen.bmx"
Include "TGameScreen.bmx"
Include "TMapLoadScreen.bmx"

?Not Debug
Try
?
	ccCreateMutex("Iron Roads")
	
	AppTitle = "Iron Roads"
	
	ScreenWidth = 800
	ScreenHeight = 600
	
	dlog "Starting up"
	MyGame = New TMyGame
	Game = MyGame
	MyGame.SetSubPathWrapper("Mr. Phil Games/Iron Roads")
	MyGame.Init()
	MyGame.DebugDisplayX = 5
	MyGame.DebugDisplayY = 95
	MyGame.SetEscapeSound("ButtonClick")
	
	Global images:TImageBank = MyGame.images
	images.SetPath(Game.ImagePath)
	Global sounds:TSoundBank = MyGame.sounds
	sounds.SetPath(Game.SoundPath)
	
	Global MainFont:TImageFont = MyGame.MainFont
	Global MainFontMedium:TImageFont = MyGame.MainFontMedium
	Global MainFontSmall:TImageFont = MyGame.MainFontSmall
	
	'Instance both types that we created
	Global GameScreen:TGameScreen = MyGame.GameScreen
	Global AboutScreen:TAboutScreen = MyGame.AboutScreen
	Global TitleScreen:TTitleScreen = MyGame.TitleScreen
	
	Game.GraphicsCreate() 'Create a graphics context
	HideMouse 'hide the mouse
	MyGame.LoadData() 'load data using a function we will define
	ccFlushAll() 'flush keys and mouse
	
	Local LoopExit:Int = 0 'boolean for exiting the main loop
	Game.FixedRateLogic.Init()
	Game.NoTimingTicks = 3 'only applied if Game.NoTiming=1
	
	Repeat
		'do the logic separately from the drawing
		If Game.MainLogicLoop() = -1 Then MyGame.ShutDown()
		'draw the screen and flip it to show it
		Game.ScreenDraw()
	Until LoopExit = 1
	
	MyGame.ShutDown()
?Not Debug
Catch ex:Object
	Try
		HandleGeneralError(ex)
	Catch ex:Object
		Print "Unhandled exception:"		
		Print ex.ToString()	
	End Try	
End Try
?