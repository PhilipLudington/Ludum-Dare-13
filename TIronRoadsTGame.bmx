
Global MyGame:TMyGame

Type TMyGame Extends TGame
	Field GameScreen:TGameScreen = New TGameScreen
	Field TitleScreen:TTitleScreen = New TTitleScreen
	Field AboutScreen:TAboutScreen = New TAboutScreen
	Field MapLoadScreen:TMapLoadScreen = New TMapLoadScreen
	
	Field MainFont:TImageFont = LoadImageFont("Data/fonts/radius__.ttf", 40,SMOOTHFONT)
	Field MainFontMedium:TImageFont = LoadImageFont("Data/fonts/radius__.ttf", 18,SMOOTHFONT)
	Field MainFontSmall:TImageFont = LoadImageFont("Data/fonts/radius__.ttf", 12,SMOOTHFONT)
	Field images:TImageBank = New TImageBank
	Field sounds:TSoundBank = New TSoundBank

	Method New()
		
	End Method
	Method Shutdown()
		Tgame.MakeGoodExit()
		ShowMouse() 'just in case it was hidden.
		'Exit the program
		End
	End Method
	
	'Instance both types that we created
	
	Method LoadData()
		AutoMidHandle True
		ccClsVSync()'Ensure clear screen when loading
	
		LoadSounds()
		LoadImages()
	
		
		'Go directly to game screen? (Used to speed up debugging)
		'The screen you want to jump to
		Local JumpScreen:TScreen
		?Debug			
			JumpScreen = MapLoadScreen
		?Not Debug
			JumpScreen = MapLoadScreen
		?
			
		JumpScreen.Load() 'Call load method of JumpScreen 
		JumpScreen.Start() 'Call start method of JumpScreen 
		
		'Now loading is complete, let the main loop handle the drawing
		Game.DestinationTScreen = JumpScreen		
	
		?Win32 'Has the app been suspended while loading? If so, deal with it.
		If GetForegroundWindow()<>Game.WindowHandle
			Game.SuspendedEvent = 1
		EndIf
		?
	End Method 
	
	Method LoadSounds()
		sounds.Load("ButtonClick") 'load the sound "buttonclick"
	End Method 
	
	Method LoadImages()
		Game.mouse.Load("pointer") 'load mouse pointer image
		images.Load("Paused") 'Load "paused" graphic
		'Create Paused sprite
		Game.SpritePausedCreate(Images.Find("Paused"))
	End Method 

End Type

Function DottedLine(stx#,sty#,enx#,eny#,dotlength:Int=5)

	Local mvx:Float=Stx-enx
	Local mvy:Float=sty-eny
	If mvx<0 mvx=-mvx
	If mvy<0 mvy=-mvy
	
	Local mv:Float=mvx
	If mvy>mvx mv=mvy
	
	Local stpx:Float=(mvx/mv)
	If Stx>enx stpx=-stpx
	
	Local stpy:Float=(mvy/mv)
	If Sty>eny stpy=-stpy

	Local nc:Int
	For nc=0 To Floor(mv)
		If stx>0 And stx<ScreenWidth -1
			If sty>0 And sty<ScreenHeight-1
				If (Int(nc/dotlength) Mod 2) = 0
					Plot stx,sty
				End If
			End If
		End If
			
		stx=stx+stpx
		sty=sty+stpy
	Next

End Function