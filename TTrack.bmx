Type TTrack
	Field fromCity:TCity
	Field toCity:TCity
	Field miles:Int
	Field surveyCost:Int
	Field surveyDone:Int = 0
	Field buildDone:Int = 0
	Field buildCost:Int
	Field building:Int = 0
	Field buildingPause:Int = 0
	Field milesDone:Int = 0
	
	Method ToShortName:String( fromShortName:String )
		If fromShortName = fromCity.shortName
			Return toCity.shortName
		Else
			Return fromCity.shortName
		EndIf
	End Method
EndType
