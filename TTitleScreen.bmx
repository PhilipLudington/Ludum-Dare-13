Type TTitleScreen Extends TScreen
	Field x#,y#

	Method Load()
		'this is a TScreen method
		ImageLoad("title.jpg",FILTEREDIMAGE)
		MidHandleImage(Image)
		
		'this gets midhandled automatically
		HeaderLoad("logolarge",screenwidth/2,100)
		Menu = TMenu.Create("ButtonMO", "ButtonClick",0,0,10)
		Menu.SoundMouseOver.volume = 0.4;
		
		'Add a new Button
		'Allow Space and Enter to trigger it
		Menu.AddNew("playgame", "playgameMO").OKButton = 1
		Menu.AddNew("about","aboutMO")
		Menu.AddNew("exitgame","exitgameMO")
		
		Menu.Centre() 'Center the Menu
		'Move the Y position of the menu
		Menu.SetY(Menu.Y+50)
	End Method

	Method Start()
		Super.Start() 'Call Start method of base type TScreen
		Game.GameFade.Init(FADE_SPEED,0) 'fade in
		Game.Mouse.On()
		Game.FixedRateLogic.Init()
	End Method
	
	Method Logic()
		'Call the logic method of the base type
		Super.Logic()
		
		'If the start button is clicked, fade to the next screen
		'and set that next screen to the GameScreen
		If Menu.FindButton("playgame").Clicked Then
			Game.GameFade.Init(FADE_SPEED,1,Game.MusicChannel, True)
			Game.DestinationTScreen = MyGame.MapLoadScreen
		EndIf
		
		'If the about button is clicked, fade to the about screen
		If Menu.FindButton("about").Clicked Then
			Game.GameFade.Init(FADE_SPEED,1,Game.MusicChannel, True)
			Game.DestinationTScreen = MyGame.AboutScreen
		EndIf
		
		'If the exit button is clicked, fade the screen and exit
		If Menu.FindButton("exitgame").Clicked Then
			Game.GameFade.Init(FADE_SPEED,1,Game.MusicChannel, True)
			Game.DestinationTScreen = Game.ExitScreen
		EndIf
	End Method

	Method Draw()
		SetBlend SOLIDBLEND
		'Image is a field of the base type TScreen
		DrawImage(Image,screenwidth/2+x,screenheight/2+y)
		SetBlend ALPHABLEND
		Header.Draw() 'Draw the logo that we loaded earlier
		Menu.Draw() 'Draw the Menu
	End Method
End Type
