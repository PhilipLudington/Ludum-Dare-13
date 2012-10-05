Type TIronRoadsGame Extends TDreamBlitzGame
	Field MainFont:TImageFont
	Field MainFontMedium:TImageFont
	Field MainFontSmall:TImageFont
	Field TitleScreen:TTitleScreen
	Field GameScreen:TGameScreen
	Field AboutScreen:TAboutScreen
	
	Method InitTIronRoadsGame()
	
		Super.InitTDreamBlitzGame()
	
		TitleScreen = New TTitleScreen
		TitleScreen.InitTTitleScreen( Self )
		
		GameScreen = New TGameScreen
		GameScreen.InitTGameScreen( Self )
		
		AboutScreen = New TAboutScreen
		AboutScreen.InitTAboutScreen( Self )
		
		MainFont = LoadImageFont("Data/fonts/radius__.ttf", 40,SMOOTHFONT)
		MainFontMedium = LoadImageFont("Data/fonts/radius__.ttf", 18,SMOOTHFONT)
		MainFontSmall = LoadImageFont("Data/fonts/radius__.ttf", 12,SMOOTHFONT)
		
	End Method
EndType
