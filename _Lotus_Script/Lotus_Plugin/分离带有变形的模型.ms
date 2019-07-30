
	fn Lotus_morpherPickUpForDetachMorpherElement =
	(
		if $ != undefined then
		(
			pickUpOBJArr = #()
			join pickUpOBJArr $
			skinBaseOBJ = pickUpOBJArr[1]

			if pickUpOBJArr.count >= 2 then
			(	
				if skinBaseOBJ.modifiers[#Morpher] == undefined then
				(
					addmodifier skinBaseOBJ (Morpher ())
					skinBaseOBJ.modifiers[#Morpher].Autoload_of_targets = 1
				)

				for i = 1 to pickUpOBJArr.count - 1 do 
				(
					WM3_MC_BuildFromNode skinBaseOBJ.morpher i pickUpOBJArr[1+i]	
				)
			)	
		)
	)
	
	fn Lotus_BatchExportMorpher2 =
	(
		selectObj = selection[1]
		theDistance = (selectObj.max.x - selectObj.min.x) * 1.3
		newObj = copy selectObj
		
		max modify mode
		try( deleteModifier newObj newObj.modifiers[#Skin] )catch()
		modPanel.setCurrentObject newObj.modifiers[#Morpher]
		
		for i = 1 to (WM3_NumberOfChannels $.modifiers[#Morpher]) do 
		(
			try
			(
				if newObj.modifiers[#Morpher][i] as string != "SubAnim:__empty" then
				(
					newObj.pos.x += theDistance
					WM3_SetChannelPos newObj.modifiers[#Morpher] i
					findCTS = windows.getchildhwnd #max "Extract" 
					uiaccessor.pressbutton findCTS[1]
				)
			)catch()
		)		
		delete newObj
	)

	fn Lotus_SkinReplace2 = 
	(
		temp = $		
		if temp != undefined then
		(
			tempArr = #()
			join tempArr $
			
			if tempArr.count == 2 then
			(
				local skinReOBJ = tempArr[1]
				local baseOBJ = tempArr[2]
				
				skinReOBJ.pos.X = baseOBJ.pos.X
				
				addmodifier skinReOBJ (Skin_Wrap ())
				skinReOBJ.modifiers[#Skin_Wrap].falloff = 8
				skinReOBJ.modifiers[#Skin_Wrap].distance = 0.06
				skinReOBJ.modifiers[#Skin_Wrap].faceLimit = 20
				skinReOBJ.modifiers[#Skin_Wrap].weightAllVerts = on
				skinReOBJ.modifiers[#Skin_Wrap].meshList = #(baseOBJ)
				skinReOBJ.modifiers[#Skin_Wrap].Blend = on
				skinReOBJ.modifiers[#Skin_Wrap].blendDistance = 5.5
				select skinReOBJ
				max modify mode
				findCTS = windows.getchildhwnd #max "Convert To Skin" 
				uiaccessor.pressbutton findCTS[1]
				deleteModifier skinReOBJ skinReOBJ.modifiers[#Skin_Wrap]
				skinReOBJ.modifiers[#Skin].filter_vertices = on
				skinReOBJ.modifiers[#Skin].bone_Limit = 4
				skinReOBJ.modifiers[#Skin].clearZeroLimit = 0.02	

				skinReOBJ.name = baseOBJ.name
				delete baseOBJ
				clearSelection()
			)
		)
	)
	
	baseOBJ = (selection as array)[1]
	max modify mode
	baseOBJ.modifiers[#Morpher].Spinner_Minimum = -100
	maxOps.cloneNodes baseOBJ cloneType:#copy newNodes:&copyOBJ
	copyOBJ = copyOBJ[1]
	deleteModifier copyOBJ copyOBJ.modifiers[#Skin]
	copyOBJ.pos.z += 150
	modPanel.setCurrentObject copyOBJ.modifiers[#Morpher]
	select copyOBJ
	actionMan.executeAction 0 "197" 
	Lotus_BatchExportMorpher2()
	hide copyOBJ
	max select all
	morpherArray = (selection as array)
	max unhide all
	select copyOBJ
	modPanel.setCurrentObject copyOBJ.modifiers[#Edit_Poly]
	subobjectLevel = 4
	deleteFaceArray = copyOBJ.modifiers[#Edit_Poly].getSelection #Face
	for i = 1 to morpherArray.count do
	(
		addModifier morpherArray[i] (Edit_Poly ())
		select morpherArray[i]
		modPanel.setCurrentObject morpherArray[i].modifiers[#Edit_Poly]
		subobjectLevel = 4
		morpherArray[i].modifiers[#Edit_Poly].SetSelection #Face #{}
		morpherArray[i].modifiers[#Edit_Poly].Select #Face deleteFaceArray
	)
	select copyOBJ
	modPanel.setCurrentObject copyOBJ.modifiers[#Edit_Poly]
	subobjectLevel = 4
	copyOBJ.modifiers[#Edit_Poly].ButtonOp #DeleteFace
	for i = 1 to morpherArray.count do
	(
		select morpherArray[i]
		modPanel.setCurrentObject morpherArray[i].modifiers[#Edit_Poly]
		subobjectLevel = 4
		morpherArray[i].modifiers[#Edit_Poly].ButtonOp #DeleteFace
	)
	convertTo copyOBJ Editable_Poly
	select copyOBJ
	selectMore morpherArray
	Lotus_morpherPickUpForDetachMorpherElement()
	select copyOBJ
	modPanel.setCurrentObject copyOBJ.modifiers[#Morpher]
	findCTS = windows.getchildhwnd #max "Zero Active Channel Values" 
	uiaccessor.pressbutton findCTS[1]
	copyOBJ.transform = baseOBJ.transform
	maxOps.cloneNodes baseOBJ cloneType:#copy newNodes:&copyOBJtoKill
	select copyOBJ
	selectmore copyOBJtoKill
	Lotus_SkinReplace2()
	delete morpherArray
	delete baseOBJ
