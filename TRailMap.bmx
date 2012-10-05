Type TRailMap
	Field cityList:TList = CreateList()
	
	Function CreateTRailMap:TRailMap() 
		
		Local railMap:TRailMap = New TRailMap
		
		' TODO: Load from file

		
		Return railMap
	End Function
	
	Method Load() 
	End Method
	
EndType
