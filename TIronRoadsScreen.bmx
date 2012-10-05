Type TIronRoadsScreen Extends TDreamBlitzScreen
	Field Game:TIronRoadsGame
	
	Method InitTIronRoadsScreen( GameContext:TIronRoadsGame )
	
		InitTDreamBlitzScreen( GameContext )
		Game = GameContext
		
	End Method
	
End Type
