Type TAboutScreen Extends TScreen
	Field x#,y#
	'Fast prototype buttons thanks to http://cooltext.com/ - Radius #000000 #EED8AE #FFFFF0
	Method Load()
		'this is a TScreen method
		ImageLoad("about.jpg",FILTEREDIMAGE)
		MidHandleImage(Image)
		'this gets midhandled automatically
		HeaderLoad("logolarge",screenwidth/2,100)
		Menu = TMenu.Create("ButtonMO", "ButtonClick",0,0,10)
		Menu.SoundMouseOver.volume = 0.4;
		'Add a new Button
		'Allow Space and Enter to trigger it
		Menu.AddNew("back","backMO").OKButton = 1
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

		'If the exit button is clicked, fade the screen and exit
		If Menu.FindButton("back").Clicked Then
			Game.GameFade.Init(FADE_SPEED,1,Game.MusicChannel, True)
			Game.DestinationTScreen = MyGame.TitleScreen
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
	
	Method SetEscDestination() 'over ride base type method
		'if esc is pressed, go to the TitleScreen
		Game.DestinationTScreen = MyGame.TitleScreen
	End Method
End Type
