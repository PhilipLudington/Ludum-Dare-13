Type TMapLoadScreen Extends TScreen 

	Method Load()
		SetImageFont(MyGame.MainFont)
		ImageLoad("mapload.png")
		MidHandleImage(Image)
		HeaderLoad("logosmall",210,35)
		
		Menu = TMenu.Create("ButtonMO", "ButtonClick",0,0,10)
		Menu.SoundMouseOver.volume = 0.4;
		
		'Add Buttons
		Menu.AddNew("back","backMO")
		Menu.AddNew("playgame","playgameMO").OKButton = 1
		
		'Position menu right hand corner
		Menu.Centre() 'Center the Menu
		Menu.SetY(Menu.Y+200)
		Menu.SetX(Menu.X+250)
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
			Game.DestinationTScreen = MyGame.GameScreen
		EndIf
		
		'If the about button is clicked, fade to the about screen
		If Menu.FindButton("back").Clicked Then
			Game.GameFade.Init(FADE_SPEED,1,Game.MusicChannel, True)
			Game.DestinationTScreen = MyGame.TitleScreen
		EndIf
		
	End Method
	
	Method Draw()
		SetBlend SOLIDBLEND
		'Image is a field of the base type TScreen
		DrawImage(Image,screenwidth/2,screenheight/2)
		SetBlend ALPHABLEND
		Header.Draw() 'Draw the logo that we loaded earlier
		Menu.Draw() 'Draw the Menu
	End Method
	
	Method SetEscDestination() 'over ride base type method
		'if esc is pressed, go to the TitleScreen
		Game.DestinationTScreen = MyGame.TitleScreen
	End Method
EndType
