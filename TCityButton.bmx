' MouseClickDuration = -1 means infinite duration - PJL 12/7/2008
Type TCityButton Extends TButton
	Field city:TCity
	Field ImageMouseOverAndClicked:TGameImage 'Optional. Shown when the mouse is over the button when clicked.
	
	Function CreateSpecial2:TCityButton( city:TCity, ImageMainFile$, ImageMouseOverFile$="", SoundMouseOverFile$="", SoundClickFile$="")
		Local b:TCityButton= New TCityButton
		b.Load(ImageMainFile, ImageMouseOverFile, SoundMouseOverFile, SoundClickFile)
		b.city = city
		Return b		
	EndFunction
	
	Method Logic()
		'Handles Mouse Over, Clicking, Animation, Glowing, Scaling etc.
				
		Local ScaleDown%=0
		
		'Only process most things if the button is active.
		'But not if the button is disabled (unless ClickDisabled is set)
		If Active And (Disabled=0 Or (Disabled=1 And ClickDisabled=1))
			'Animate?
			ManageAnim()
			'Glow?
			If GlowMode>0 Then ManageGlow()
			
			'Is the mouse over the button?
			If Game.Mouse.X >= x And Game.Mouse.X < x+w And Game.Mouse.Y >= y And Game.Mouse.Y < y+h Then
				'Should we call a special user-defined function before testing the mouse over state?
				If MouseOverUserFunction=Null Or (MouseOverUserFunction<>Null And MouseOverUserFunction()=0) Then 'MouseOverUserFunction() should return 0 if it's OK to continue.
					'Should Mouse Over be activated? If so play a sound.
					'But not if the button is down from a previous click.
					'If MouseClickCounter=0 'removed so MO happens even when Clicked - PJL 12/7/2008
						'Only play the sound the first time the mouse goes over the button (to avoid repeats).
						If MouseOver = 0 And NoSound=0 Then PlayMouseOver()
							MouseOver = 1
						'I could set MouseOver to 0 if MouseClickCounter>0 but I've chosen not too.
					'EndIf - PJL 12/7/2008
					
					'Should we activate glow fade? Must be called before Click().
					FixedGlowOnMOActivate()
					
					'Should Clicked be set? If so play a sound.
					'Use Mouse Hit not Mouse Down to avoid rapid multiple clicks of button which
					'would occur is mousedown was used.
					'OK, now the button supports MouseRepeat too!
					Local MouseRepeatClick%=(MouseRepeat<>Null And MouseRepeat.GetButton()) 'boolean evaluation
					If MouseRepeatClick Or Game.Mouse.GetMh() Then
						'Pass a UseSoundClick2 value of 1 into Click() if MouseRepeat.GetButton() returned a
						'value of 2 which means that it was NOT the first click.  This means any clicks
						'after the first click can have a different sound (if you have set up SoundClick2).
						Click(MouseRepeatClick=2) 'Uses boolean evaluation.
					Else
						'Clicked = 0 ' We don't know if it is still Clicked or not - PJL 12/7/2008
					EndIf
					
					'Should we scale it up?
					If ScaleOnMOMax>1 Then
						ScaleOnMO:+ScaleOnMOUpSpeed*Delta
						'Clamp to max limit.
						If ScaleOnMO > ScaleOnMOMax Then ScaleOnMO=ScaleOnMOMax 
					EndIf
				Else	
					'MouseOverUserFunction() Return 1 meaning do not allow Mouse Over. 
					MouseOver = 0
					'Clicked = 0 ' We don't know if it is still Clicked or not - PJL 12/7/2008									
					ScaleDown=1
				EndIf 
			Else
				'The mouse is not over the button.
				MouseOver = 0	
				'Clicked = 0 ' We don't know if it is still Clicked or not - PJL 12/7/2008
				ScaleDown=1
			EndIf
	
			'If it's an OK button, allow Space and Enter to click it (Use KeyHit not KeyDown!)
			If OKButton And (KeyHit(KEY_ENTER) Or (KeyHit(KEY_SPACE) And OKButtonUseSpace)) Then
				SimulateClick()
			EndIf
		Else
			'Safety for when it's not active or disabled.
			MouseOver = 0	
			'Clicked = 0 ' We don't know if it is still Clicked or not - PJL 12/7/2008
			ScaleDown = 1
			
			'Even if it's disabled we should make any fixed glow fade away.
			If FixedGlowOnMO=1 Then ManageGlow()
		EndIf
		
		'Scale Down? Do this even if it's disabled so it can return to normal size.
		If ScaleDown Then ManageScaleOnMO()
		
		If MouseClickDuration = -1 'infinite Click duration - PJL 12/07/2008
			If Clicked
				MouseClickCounter=1
			Else
				MouseClickCounter=0
			EndIf
		Else
			'Reduce counters. Do this even if it's disabled so it can pop back up again (return from clicked/down state).
			If MouseClickCounter > 0
				MouseClickCounter:-Delta
				If MouseClickCounter<0 Then MouseClickCounter=0 'safety
			EndIf
		EndIf
	End Method
	
	Method Draw%()
	 	'Don't draw if inactive (unless AlwaysDraw=1).		
		If Active = 0 And AlwaysDraw=0 Then Return 0
		
		'Anti-alias the button (providing button png image has alpha channel).
		SetBlend ALPHABLEND

		'Store old coords before we mess with them.
		Local oldx# = x
		Local oldy# = y
		'Apply an offset? OffX and OffY are TSprite fields.
		x:+OffX
		y:+OffY

		'Apply an Alpha? UseAlpha is a TSprite field.
		If UseAlpha Then SetAlpha Alpha
		Local OldScaleX#
		Local OldScaleY#
		If Caption<>Null Then OldRoundedCoords = Caption.RoundCoords
		
		'Scale?
		If ScaleOnMO>1 Then
			SetScale ScaleOnMO,ScaleOnMO
			x:+(ImageWidth(image.image)*(1-ScaleOnMO))/2
			y:+(ImageHeight(image.image)*(1-ScaleOnMO))/2
			'Set ScaleX and ScaleY (TSprite fields) for drawing the Shadow and Glow correctly.
			'Also store the current scale for restoring later.
			OldScaleX = ScaleX
			OldScaleY = ScaleY
			ScaleX = ScaleOnMO 
			ScaleY = ScaleOnMO 
		Else
			SetScale ScaleX, ScaleY 'These are TSprite fields.
		EndIf

		'Should we draw a Mouse Click (down) image?
		If MouseClickCounter > 0 Then
			'Which version of the Clicked image do we draw? - PJL 12/07/2008			
			If (MouseOver And ImageMouseOverAndClicked<>Null)
				DrawShadow(ImageMouseOverAndClicked) 'This is a TSprite method.
				DrawImage(ImageMouseOverAndClicked.image,x,y) 'Not animated.	
			Else
				DrawShadow(ImageMouseClick) 'This is a TSprite method.
				DrawImage(ImageMouseClick.image,x,y) 'Not animated.
			EndIf
			
			'Draw a glowing version on top?
			If GlowMode > 0 And Glow>0 Then
				DrawLight(Glow,1,1,1,ImageMouseClick) 'This is a TSprite method.			
				'Restore the Alpha because DrawLight() will have set it to 1 after it finished.
				If UseAlpha Then SetAlpha Alpha
			EndIf
			If Caption<>Null Then
				Caption.ApplyCustomColor(CaptionDownColor)
				'If we are scaling down the text or scaling up the button, switch off rounding.
				If CaptionDownScale<>1 Or ScaleOnMO>1 Then Caption.RoundCoords = 0										
				Local FinalScale# = CaptionDownScale
				If ScaleOnMO>1 Then
					SetScale ScaleOnMO,ScaleOnMO
					'No need to adjust Final scale if it's a TBitmapFont because it handles that itself when drawing.
					'But we do need to adjust it if we are drawing a TImageFont.
					If Caption.BitmapFont=Null Then FinalScale = FinalScale*ScaleOnMO						
				EndIf
				If CaptionDownScale<>1 Then Caption.ApplyScale(FinalScale)
				Caption.Draw(CaptionDownOffsetX*ScaleOnMO, CaptionDownOffsetY*ScaleOnMO, 0)
				If CaptionDownScale<>1 Or ScaleOnMO>1 Then
					Caption.RestoreScale()
					Caption.RoundCoords = OldRoundedCoords
				EndIf
				'If ScaleOnMO>1 there's no need to restore the scale as this is done further down.
			EndIf								
		Else
			'Should we draw a Mouse Over image?
			If (MouseOver And ImageMouseOver<>Null) Or (FixedGlowOnMOUseMO And GlowMode > 0 And Glow>0) Then
				DrawShadow(ImageMouseOver) 'This is a TSprite method.
				DrawImage(ImageMouseOver.image,x,y,frame)
				'Draw a glowing version on top?
				If GlowMode > 0 And Glow>0 And (FixedGlowOnMO Or AutoGlowOnMO) Then
					DrawLight(Glow,1,1,1,ImageMouseOver) 'This is a TSprite method.			
					'Restore the Alpha because DrawLight() will have set it to 1 after it finished.
					If UseAlpha Then SetAlpha Alpha
				EndIf
				If Caption<>Null Then
					'Use the inverse colour for the Mouse Over Colour.
					Caption.ApplyInverse()
					DrawCaption()
				EndIf								
			Else
				'Draw a Disabled image?
				If Disabled Then
					DrawShadow(ImageDisabled) 'This is a TSprite method.
					DrawImage(ImageDisabled.image,x,y) 'Not animated.
					If Caption<>Null Then
						Caption.ApplyCustomColor(CaptionDisabledColor)
						DrawCaption()
					EndIf								
				Else
					'Normal (no mouse over/down/disabled).
					DrawShadow(image) 'This is a TSprite method.
					DrawImage(image.image,x,y,frame)
					'Draw a glowing version on top?
					If GlowMode > 0 And Glow>0 Then
						DrawLight(Glow) 'This is a TSprite method.			
						'Restore the Alpha because DrawLight() will have set it to 1 after it finished.
						If UseAlpha Then SetAlpha Alpha
					EndIf
					If Caption<>Null Then
						'Use the inverse colour for the Mouse Over Colour.
						Caption.Apply()
						DrawCaption()
					EndIf								
				EndIf
			EndIf
		EndIf

		'Restore stuff.
		x = oldx
		y = oldy
		If UseAlpha Then SetAlpha 1 'safety
		If ScaleOnMO>1 Then
			ScaleX = OldScaleX
			ScaleY = OldScaleY
		EndIf
		SetScale 1,1 'restore
			
		Return 1 'Drawn OK.
	End Method
	
	Method LoadMouseOverAndClicked(file$)
		'Load an optional Mouse Clicked (down) button image.
		'Duration is in millisecs.
		ImageMouseOverAndClicked = New TGameImage
		ImageMouseOverAndClicked.Load(GetPath()+file+ext)
		ImageMouseOverAndClicked.MidHandle(False) 'Musn't be centered or it makes mouse over detection harder.		
	End Method
EndType
