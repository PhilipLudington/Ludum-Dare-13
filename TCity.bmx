Type TCity
	Field x:Int
	Field y:Int
	Field name:String
	Field shortName:String
	Field freightList:TList = New TList
	Global trackList:TList = New TList
	Global InnerList:TList = New TList
	
	Function Create:TCity( x:Int, y:Int, name:String, shortName:String)
		Local newCity:TCity= New TCity
		newCity.x = x
		newCity.y = y
		newCity.name = name
		newCity.shortName = shortName
		
		InnerList.AddLast(newCity)
		Return newCity
	End Function
	
	Function CreateFreight( fromShortName:String, toShortName:String, revenue:Int )
		Local city:TCity
		Local fromCity:TCity
		Local toCity:TCity
		For city = EachIn InnerList
			If fromShortName = city.shortName
				fromCity = city 
			EndIf
			If toShortName= city.shortName
				toCity= city 
			EndIf
		Next
		

		Assert(fromCity <> Null)
		Assert(toCity <> Null)

		
		If fromCity <> Null And toCity <> Null
			Local freight:TFreight = New TFreight
			freight.fromCity = fromCity
			freight.toCity = toCity 
			freight.revenue = revenue
			fromCity.freightList.AddLast( freight )
		EndIf
	End Function
	
	Function CreateTrack( fromShortName:String, toShortName:String, miles:Int, surveyCost:Int, buildCost:Int )
		Local city:TCity
		Local fromCity:TCity
		Local toCity:TCity
		For city = EachIn InnerList
			If fromShortName = city.shortName
				fromCity = city 
			EndIf
			If toShortName= city.shortName
				toCity= city 
			EndIf
		Next		

		Assert(fromCity <> Null)
		Assert(toCity <> Null)
		
		If fromCity <> Null And toCity <> Null
			Local track:TTrack = New TTrack 
			track.fromCity = fromCity
			track.toCity = toCity 
			track.miles = miles
			track.surveyCost = surveyCost
			track.buildCost= buildCost
			trackList.AddLast( track )
		EndIf
	End Function
	
	Function GetTracks:TList( cityShortName:String )
		Local list:TList = New TList
		Local track:TTrack = New TTrack
		
		For track = EachIn trackList
			If track.fromCity.shortName = cityShortName Or track.toCity.shortName = cityShortName
				list.AddLast( track )
			EndIf
		Next
		
		Return list		
	End Function
	
	Function GetTrack:TTrack( city1ShortName:String, city2ShortName:String )
		Local track:TTrack
		For track = EachIn GetTracks(city1ShortName)
			If track.fromCity.shortName = city2ShortName Or track.toCity.shortName = city2ShortName
				Return track
			EndIf
		Next
		
		Return Null
	End Function
	
End Type
