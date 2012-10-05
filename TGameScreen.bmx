Type TGameScreen Extends TScreen
	Field CityPoint:TGameImage
	Field CityPointMO:TGameImage
	Field cityButtons:TList = New TList
	Field clickedCity:TCityButton
	Field trackButtons:TList = New TList
	Field cash:Int = 7250000
	Field hours:Float = 0.0
	Field month:Int = 6
	Field day:Int = 15
	Field year:Int = 1890
	Field trackCost:TList
	Field connected:TList
	Field noTracks:Int = 1

	Method Load()
		SetImageFont(MyGame.MainFont)
		ImageLoad("bg1.jpg")		
		HeaderLoad("logosmall",210,35)
		CityPoint = TGameImage.CreateAuto(Game.ImagePath+"citypoint.png" )
		CityPointMO = TGameImage.CreateAuto(Game.ImagePath+"citypointMO.png" )
		
		TCity.Create( 433, 343, "Chicago", "CHI" )
		TCity.Create( 594, 334, "New York", "NYC" )
		TCity.Create( 526, 351, "Pittsburgh", "PIT" )
		TCity.Create( 586, 349, "Philadelphia", "PHI" )
		TCity.Create( 567, 371, "Washington", "WDC" )
		TCity.Create( 559, 576, "Miami", "MIA" )
		TCity.Create( 533, 510, "Jacksonville", "JAC" )
		TCity.Create( 530, 545, "Tampa", "TAM" )
		TCity.Create( 540, 536, "Orlando", "ORL" )
		TCity.Create( 412, 394, "St. Louis", "STL" )
		TCity.Create( 619, 303, "Boston", "BOS" )
		TCity.Create( 565, 361, "Baltimore", "BAL" )
		TCity.Create( 587, 275, "Burlington", "BUR" )
		TCity.Create( 631, 249, "Bangor", "BAN" )
		TCity.Create( 505, 339, "Cleveland", "CLE" )
		TCity.Create( 480, 341, "Toledo", "TOL" )
		
		TCity.CreateFreight("CHI", "NYC", 500000 )
		TCity.CreateFreight("CHI", "PIT", 50000 )
		TCity.CreateFreight("NYC", "PIT", 150000 )
		TCity.CreateFreight("PIT", "WDC", 40000 )
		TCity.CreateFreight("WDC", "PIT", 10000 )
		TCity.CreateFreight("WDC", "JAC", 300000 )
		
		TCity.CreateTrack("NYC", "PIT", 373, 10000 + 373 * 22, 373 * 14653 )
		TCity.CreateTrack("NYC", "WDC", 228, 10000 + 228 * 12, 228 * 8053)
		TCity.CreateTrack("PIT", "WDC", 245, 10000 + 245 * 19, 245 * 15653)
		TCity.CreateTrack("PIT", "JAC", 1174, 10000 + 1174 * 35, 1174 * 9653)
		TCity.CreateTrack("CHI", "PIT", 463, 10000 + 463 * 29, 463 * 11653)
		TCity.CreateTrack("MIA", "JAC", 344, 18000 + 344 * 29, 344 * 5653)
		TCity.CreateTrack("MIA", "ORL", 236, 18000 + 236 * 29, 236 * 5653)
		TCity.CreateTrack("TAM", "JAC", 197, 18000 + 197 * 29, 197 * 5653)
		TCity.CreateTrack("TAM", "MIA", 286, 18000 + 286* 29, 286 * 5653)
		TCity.CreateTrack("TAM", "ORL", 84, 18000 + 84 * 29, 84 * 5653)
		TCity.CreateTrack("JAC", "ORL", 140, 18000 + 140 * 29, 140 * 5653)
		
		Local city:TCity
		Local cityButton:TCityButton
		For city = EachIn TCity.InnerList
			cityButton = TCityButton.CreateSpecial2( city, "citypoint", "citypointMO" )
			cityButton.LoadMouseClick( "citypointClicked", -1 )
			cityButton.MouseClickDuration = -1 'keep it down
			cityButton.LoadMouseOverAndClicked( "citypointMOClicked" )
			cityButton.x = city.x
			cityButton.y = city.y
			cityButtons.AddLast( cityButton  )
		Next

	End Method

	Method Start()
		Super.Start()
		Game.GameFade.Init(FADE_SPEED,0) 'initiate fading
		Game.Mouse.On()
		Game.FixedRateLogic.Init()
	End Method

	Method Logic()
		Super.Logic() 'handles menu core logic
		
		'Move time
		hours = hours + (Delta * 1.2)
		If hours > 23
			hours = 0
			day = day + 1
			'Bills due
			Local track:TTrack
			Local trackButton:TTrackButton
			For track = EachIn TCity.trackList
				If track.building And track.buildingPause = 0
					track.milesDone = track.milesDone + 1
					cash = cash - track.buildCost / track.miles
					If track.milesDone > track.miles
						track.building = 0
						track.buildDone = 1
						BuildTrackButtons()
						'Update What Cities are Connected to the Network
						connected = New TList
						Local city:TCity
						For city= EachIn TCity.InnerList
							Local track:TTrack
							For track = EachIn TCity.GetTracks( city.shortName )
								If track.buildDone
									Local shortName:String
									Local found:Int = 0
									For shortName= EachIn connected
										If shortName = track.toCity.shortname Or shortName = track.fromCity.shortname
											found = 1
											Exit
										EndIf
									Next
									If found <> 1									
										connected.AddLast(shortName)
									EndIf
								EndIf
							Next
						Next
						'Figure Revenue for each city's freight connected
						For city= EachIn TCity.InnerList
							Local freight:TFreight
							For freight= EachIn city.freightList
								Local shortName:String
								Local found:Int = 0
								For shortName= EachIn connected
									If shortName = freight.toCity.shortname 
										Local shortName2:String
										Local found2:Int = 0
										For shortName2= EachIn connected
											If shortName2 = freight.fromCity.shortname
												cash = cash + Ceil(freight.revenue / 30)
												Exit
											EndIf
										Next
									EndIf
								Next
							Next
						Next
					EndIf					
				EndIf		
			Next
		End If
		If day > 30
			day = 1
			month = month + 1
		EndIf
		If month > 12
			month = 1
			year = year + 1
		EndIf
		
		Local cityButton:TCityButton
		For cityButton = EachIn cityButtons
			cityButton.Logic()
			
			If cityButton.Clicked And clickedCity <> cityButton
				If clickedCity <> Null
					clickedCity.ClearClick()
					trackButtons.Clear()
				End If
				clickedCity = cityButton
				BuildTrackButtons()
			EndIf
		Next
		
		Local trackButton:TTrackButton
		For trackButton= EachIn trackButtons
			trackButton.Manage()
			
			If trackButton.Clicked
				If trackButton.track.surveyDone = 0
					trackButton.track.surveyDone = 1
					cash = cash - trackButton.track.surveyCost
					BuildTrackButtons()
				Else
					If trackButton.track.buildDone = 0
						If trackButton.track.building 
							If trackButton.track.buildingPause
								trackButton.track.buildingPause = 0
							Else
								trackButton.track.buildingPause = 1
							EndIf
							BuildTrackButtons()
						Else
							trackButton.track.building = 1
							trackButton.track.buildingPause = 0
							noTracks = 0
						End If
					End If
				EndIf
			EndIf
		Next

	End Method
	
	Method BuildTrackButtons()
		'Clear old buttons
		trackButtons.Clear()
		'Add track buttons
		Local track:TTrack
		Local trackButton:TTrackButton
		For track = EachIn TCity.trackList
			If track.ToCity = clickedCity.city Or track.FromCity = clickedCity.city
				If track.surveyDone
					If Not track.buildDone
						If track.building 
							If  track.buildingPause
								trackButton = TTrackButton.CreateSpecial2( track, "restart", "restartMO" )
								trackButtons.AddLast( trackButton )
							Else
								trackButton = TTrackButton.CreateSpecial2( track, "pause", "pauseMO" )
								trackButtons.AddLast( trackButton )
							EndIf
						Else
							If noTracks = 1
								trackButton = TTrackButton.CreateSpecial2( track, "build", "buildMO" )
								trackButtons.AddLast( trackButton )
							Else
								trackButton = TTrackButton.CreateSpecial2( track, "build", "buildMO" )
								trackButton.LoadDisabled("buildDisabled")
								trackButton.ClickDisabled = 0
								trackButtons.AddLast( trackButton )
								Local found:Int = 0
								Local track2 :TTrack
								For track2 = EachIn TCity.GetTracks( clickedCity.city.shortName )
									 If track2.buildDone	
										found = 1
										Exit
									EndIf
								Next
								If found = 0
									trackButton.Disabled = 1
								EndIf							
							EndIf
						EndIf
					EndIf
				Else
					trackButton = TTrackButton.CreateSpecial2( track, "survey", "surveyMO" )
					trackButtons.AddLast( trackButton )
				End If
			End If			
		Next
	EndMethod

	Method Draw()
		Cls
		SetBlend ALPHABLEND
		DrawImage(image,0,0)
		Header.Draw() 'Draw the header
						
		'Draw Date
		SetColor 141,69,29
		SetImageFont(MyGame.MainFont)
		ccDrawText( month +"/" + day + "/" + year, 635, 5 )
		
		'Draw Cash
		SetColor 141,69,29
		SetImageFont(MyGame.MainFont)
		ccDrawText( "$" + cash, 635, 40 )	
		
		'Draw track
		Local track:TTrack
		For track = EachIn TCity.trackList
			SetColor 141,69,29
			'Draw tracks
			If track.surveyDone = 1 
				If track.buildDone = 1
					DrawLine(track.fromCity.x + 4,track.fromCity.y + 4,track.toCity.x + 4,track.toCity.y + 4 )
				EndIf
			EndIf
		Next
		
		'Draw Clicked City Header
		If clickedCity <> Null And trackButtons.Count() > 0
			SetColor 141,69,29
			SetImageFont(MyGame.MainFont)
			ccDrawText( clickedCity.city.name, 635, 310 )	
		EndIf
		
		'Draw track realted controls
		Local trackButton:TTrackButton
		Local counter:Int = 0
		For trackButton = EachIn trackButtons
			track = trackButton.track
				
			'Draw button info and track connections
			If trackButton.track.surveyDone = 0
				SetColor 141,69,29
				SetImageFont(MyGame.MainFontMedium)
				DottedLine(track.fromCity.x + 4,track.fromCity.y + 4,track.toCity.x + 4,track.toCity.y + 4)			
				ccDrawText( "to " + track.ToShortName( clickedCity.city.shortName ) + " " + track.Miles + "m. $" + track.surveyCost, 660, 350 + (25*counter) )
			Else 'trackButton.track.surveyDone = 1
				If trackButton.track.buildDone = 0
					If trackButton.track.building
						SetColor 141,69,29
						SetImageFont(MyGame.MainFontMedium)
						DottedLine(track.fromCity.x + 4,track.fromCity.y + 4,track.toCity.x + 4,track.toCity.y + 4, 8)
						Local milesLeft:Int = track.Miles - track.milesDone
						Local costLeft:Int = (milesLeft * track.buildCost / track.miles )
						ccDrawText( "to " + track.ToShortName( clickedCity.city.shortName ) + " " + milesLeft + "m. $" + costLeft, 645, 350 + (25*counter) )
					Else
						SetColor 141,69,29
						SetImageFont(MyGame.MainFontMedium)
						DottedLine(track.fromCity.x + 4,track.fromCity.y + 4,track.toCity.x + 4,track.toCity.y + 4, 1)			
						ccDrawText( "to " + track.ToShortName( clickedCity.city.shortName ) + " " + track.Miles + "m. $" + track.buildCost, 645, 350 + (25*counter) )
					EndIf
				EndIf					
			EndIf
			
			'Draw buttons
			SetColor 255,255,255
			trackButton.x = 610
			trackButton.y = 350 + (25*counter)
			trackButton.Draw()
			
			counter = counter + 1
		Next
				
		'Draw cities
		Local cityButton:TCityButton
		For cityButton= EachIn cityButtons
			cityButton.Draw()
			
			If cityButton.MouseOver
				'Draw data about hovered over city
				SetColor 141,69,29
				SetImageFont(MyGame.MainFont)
				ccDrawText( cityButton.city.name, 600, 450 )					
				SetImageFont(MyGame.MainFontSmall)
				ccDrawText( cityButton.city.shortName, cityButton.city.x - 3, cityButton.city.y + 6 )
				'Draw freight data
				Local freight:TFreight = New TFreight
				Local counter:Int = 0
				For freight = EachIn cityButton.city.freightList
					ccDrawText( freight.toCity.shortName, 600, 490 + (10*counter))
					ccDrawText( freight.revenue, 630, 490 + (10*counter))
					ccDrawText( freight.toCity.shortName, freight.toCity.x - 3, freight.toCity.y + 6 )
					counter = counter + 1
				Next
			EndIf
		Next
		
		'Draw instructional text
		SetColor 255,255,255
		SetImageFont(MyGame.MainFontSmall)
		ccDrawTextCentre("Press <esc> to Exit",560,1)
	End Method

	Method SetEscDestination() 'over ride base type method
		'if esc is pressed, go to the TitleScreen
		?Debug
			Game.DestinationTScreen = Game.ExitScreen
		?Not Debug
			Game.DestinationTScreen = MyGame.TitleScreen
		?
	End Method
	
	Function CreateNodeCostMatrix:TList()
		Local cityX:TCity
		Local cityY:TCity
		Local rows:TList = New TList
		For cityX = EachIn TCity.InnerList
			Local column:TValueList = New TValueList
			rows.AddLast( column )
			For cityY = EachIn TCity.InnerList
				Local track:TTrack = TCity.GetTrack( cityX.shortName, cityY.shortName )
				Local value:TValue
				If track <> Null And track.buildDone = 1
					value = TValue.Create( "", track.miles )
				Else
					value = TValue.Create( "", -1 )
				EndIf
				column.AddLast( value )
			Next		
		Next
		
		Return rows
	End Function
	
End Type
