Type TTrackButton Extends TButton
	Field track:TTrack
		
	Function CreateSpecial2:TTrackButton( track:TTrack, ImageMainFile$, ImageMouseOverFile$="", SoundMouseOverFile$="", SoundClickFile$="")
		Local b:TTrackButton = New TTrackButton 
		b.Load(ImageMainFile, ImageMouseOverFile, SoundMouseOverFile, SoundClickFile)
		b.track = track
		Return b		
	EndFunction
End Type
