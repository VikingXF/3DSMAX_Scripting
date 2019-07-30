
	theMYPCPath = "D:\\Lotus_\\Lotus_PoseTool_\\"   	--"D:\\Lotus_\\Lotus_PoseTool_"
	try ( HiddenDOSCommand ( "md " + theMYPCPath + "0" ) )catch()
	global poseTool_FilePathTo = "D:\\Lotus_\\Lotus_PoseTool_\\0"
	global tempFileName
--设置通用路径

	fn Lotus_SavePoseToolFileGetFN  =
	(
		global allJsPosePathArray = getDirectories "D:\\Lotus_\\Lotus_PoseTool_\\*"
		global allJsPoseNameArray = #()
		for i = 1 to allJsPosePathArray.count do 
		(
			a = filenameFromPath allJsPosePathArray[i]
			a = (filterString a "\\")[1]
			append allJsPoseNameArray a
		)
	)
	Lotus_SavePoseToolFileGetFN()
	
	fn Lotus_PoseToolToSave =
	(
		tempD_Temporarydocuments_tran = poseTool_FilePathTo + tempFileName + "_Transform.txt"
		tempD_Temporarydocuments_pos = poseTool_FilePathTo + tempFileName + "_Pos.txt"
		deletefile tempD_Temporarydocuments_tran
		deletefile tempD_Temporarydocuments_pos
		theSelect = selection as array
		tempArray = #()
		global toSaveString = ""
		
		for i = 1 to theSelect.count do
		(
			try
			(
				toSaveString += (theSelect[i].name) + "&&&" + (theSelect[i].transform as string) + "\n" 
			)catch()
		)
		lotus_saveTXT tempD_Temporarydocuments_tran toSaveString
		toSaveString = ""
		
		for i = 1 to theSelect.count do
		(
			try
			(
				toSaveString += (theSelect[i].name) + "&&&" + (theSelect[i].pos.controller.value as string) + "&&&" + (theSelect[i].rotation.controller.value as string) + "&&&" + (theSelect[i].scale.controller.value as string) + "\n" 
			)catch()
		)
		lotus_saveTXT tempD_Temporarydocuments_pos toSaveString
	)
	
	fn Lotus_PoseToolToLoad =
	(
		theSelect = selection as array
		tempD_Temporarydocuments_tran = poseTool_FilePathTo + tempFileName + "_Transform.txt"
		tempD_Temporarydocuments_pos = poseTool_FilePathTo + tempFileName + "_Pos.txt"
		manyPointArray1 = lotus_loadTXT tempD_Temporarydocuments_tran
		manyPointArray2 = lotus_loadTXT tempD_Temporarydocuments_pos
		
		for i = 1 to manyPointArray1.count do
		(
			manyPointArray1[i] = filterString manyPointArray1[i] "&&&"
			manyPointArray1[i][2] = Lotus_StringConvertToMatrix3 manyPointArray1[i][2]
		)
		
		for i = 1 to manyPointArray2.count do
		(
			manyPointArray2[i] = filterString manyPointArray2[i] "&&&"
			manyPointArray2[i][2] = Lotus_StringConvertToPoint3 manyPointArray2[i][2]
			manyPointArray2[i][3] = Lotus_StringConvertToQuat manyPointArray2[i][3]
			manyPointArray2[i][4] = Lotus_StringConvertToPoint3 manyPointArray2[i][4]
		)
		
		for i = 1 to 3 do
		(
			for i = 1 to theSelect.count do 
			(
				for o = 1 to manyPointArray1.count do 
				(
					if (theSelect[i].name == manyPointArray1[o][1]) then
					(
						theSelect[i].transform = manyPointArray1[o][2]
					)
					break
				)
			)
			
			for i = 1 to theSelect.count do 
			(
				for o = 1 to manyPointArray2.count do 
				(
					if (theSelect[i].name == manyPointArray2[o][1]) then
					(
						theSelect[i].pos.controller.value = manyPointArray2[o][2]
						theSelect[i].rotation.controller.value = manyPointArray2[o][3]
						theSelect[i].scale.controller.value = manyPointArray2[o][4]
					)
					break
				)
			)
		)
	)
--函数
	
	try( destroydialog pose_saveRollout )catch()
	rollout pose_saveRollout "poseSave v1.1" width:650 height:845
	(
		edittext txt "添加命名:" pos:[10,10]  fieldWidth:200 labelOnTop:true bold: true
		dropdownlist downlist "选择角色" pos:[240,7] items:allJsPoseNameArray width:100 height:1000
		subrollout 'sub1' "" pos:[10,60] width:635 height:780 align:#left
		button bt1 "路径" width:40 height:20  pos:[345 ,26] 
		
		on txt entered txt do ( try ( HiddenDOSCommand ( "md " + "D:\\Lotus_\\Lotus_PoseTool_\\" + txt ) ;pose_saveRollout.txt.text = "" ;Lotus_SavePoseToolFileGetFN() ;pose_saveRollout.downlist.items = allJsPoseNameArray )catch() )
		on bt1 pressed do ( try( shellLaunch "explorer.exe" poseTool_FilePathTo )catch() )
		on downlist selected num do 
		( 
			global poseTool_FilePathTo = "D:\\Lotus_\\Lotus_PoseTool_\\" + pose_saveRollout.downlist.items[num] 
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp011.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp011.bitmap = openBitMap ( poseTool_FilePathTo + "\\a1.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp012.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp012.bitmap = openBitMap ( poseTool_FilePathTo + "\\a2.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp013.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp013.bitmap = openBitMap ( poseTool_FilePathTo + "\\a3.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp014.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp014.bitmap = openBitMap ( poseTool_FilePathTo + "\\a4.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp015.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp015.bitmap = openBitMap ( poseTool_FilePathTo + "\\a5.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp016.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp016.bitmap = openBitMap ( poseTool_FilePathTo + "\\a6.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp017.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp017.bitmap = openBitMap ( poseTool_FilePathTo + "\\a7.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp018.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp018.bitmap = openBitMap ( poseTool_FilePathTo + "\\a8.jpg" )  )catch()
			try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp019.bitmap )catch()
			try( pose_saveRollout.sub1.cldRollout.bmp019.bitmap = openBitMap ( poseTool_FilePathTo + "\\a9.jpg" )  )catch()
		)
	)
	createdialog pose_saveRollout pos:[1100,80]
	
--主Rollout
		rollout cldRollout "" width:610 height:850 --子集Rol
		(
			imgtag bmp011 width:190 height:200 pos:[10,10] --bitmap:(openBitMap @"C:\\Users\\Administrator\\Desktop\\xx\\1.jpg")
				groupBox grp011 "NO_1" width:190 height:200 pos:[cldRollout.bmp011.pos.x + 0   ,cldRollout.bmp011.pos.y + 0] 
				button bmp011_s "Save" width:60 height:30  pos:[cldRollout.bmp011.pos.x + 0   ,cldRollout.bmp011.pos.y + 205] 
				button bmp011_l "Load" width:60 height:30  pos:[cldRollout.bmp011.pos.x + 65  ,cldRollout.bmp011.pos.y + 205]
				button bmp011_d "Del"  width:30  height:30 pos:[cldRollout.bmp011.pos.x + 160 ,cldRollout.bmp011.pos.y + 205]
					on bmp011 mousedown do ( if cldRollout.bmp011.bitmap != undefined then( tempFileName = "\\a1" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp011_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a1" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp011.bitmap )catch()
						try( cldRollout.bmp011.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp011_l pressed do with undo on ( tempFileName = "\\a1" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp011_d pressed do with undo on 
					( 
						tempFileName = "\\a1" 
						try( forceReloadBitmapFile cldRollout.bmp011.bitmap ;cldRollout.bmp011.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
				
			imgtag bmp012 width:190 height:200 pos:[210,10]
				groupBox grp012 "NO_2" width:190 height:200 pos:[cldRollout.bmp012.pos.x + 0   ,cldRollout.bmp012.pos.y + 0]
				button bmp012_s "Save" width:60 height:30  pos:[cldRollout.bmp012.pos.x + 0   ,cldRollout.bmp012.pos.y + 205]
				button bmp012_l "Load" width:60 height:30  pos:[cldRollout.bmp012.pos.x + 65  ,cldRollout.bmp012.pos.y + 205]
				button bmp012_d "Del"  width:30  height:30 pos:[cldRollout.bmp012.pos.x + 160 ,cldRollout.bmp012.pos.y + 205]
					on bmp012 mousedown do ( if cldRollout.bmp012.bitmap != undefined then( tempFileName = "\\a2" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp012_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a2" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp012.bitmap )catch()
						try( cldRollout.bmp012.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp012_l pressed do with undo on ( tempFileName = "\\a2" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp012_d pressed do with undo on 
					( 
						tempFileName = "\\a2" 
						try( forceReloadBitmapFile cldRollout.bmp012.bitmap ;cldRollout.bmp012.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
					
			imgtag bmp013 width:190 height:200 pos:[410,10]
				groupBox grp013 "NO_3" width:190 height:200 pos:[cldRollout.bmp013.pos.x + 0   ,cldRollout.bmp013.pos.y + 0]
				button bmp013_s "Save" width:60 height:30  pos:[cldRollout.bmp013.pos.x + 0   ,cldRollout.bmp013.pos.y + 205]
				button bmp013_l "Load" width:60 height:30  pos:[cldRollout.bmp013.pos.x + 65  ,cldRollout.bmp013.pos.y + 205]
				button bmp013_d "Del"  width:30  height:30 pos:[cldRollout.bmp013.pos.x + 160 ,cldRollout.bmp013.pos.y + 205]
					on bmp013 mousedown do ( if cldRollout.bmp013.bitmap != undefined then( tempFileName = "\\a3" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp013_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a3" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp013.bitmap )catch()
						try( cldRollout.bmp013.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp013_l pressed do with undo on ( tempFileName = "\\a3" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp013_d pressed do with undo on 
					( 
						tempFileName = "\\a3" 
						try( forceReloadBitmapFile cldRollout.bmp013.bitmap ;cldRollout.bmp013.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
			
			imgtag bmp014 width:190 height:200 pos:[10,260]
				groupBox grp014 "NO_4" width:190 height:200 pos:[cldRollout.bmp014.pos.x + 0   ,cldRollout.bmp014.pos.y + 0]
				button bmp014_s "Save" width:60 height:30  pos:[cldRollout.bmp014.pos.x + 0   ,cldRollout.bmp014.pos.y + 205]
				button bmp014_l "Load" width:60 height:30  pos:[cldRollout.bmp014.pos.x + 65  ,cldRollout.bmp014.pos.y + 205]
				button bmp014_d "Del"  width:30  height:30 pos:[cldRollout.bmp014.pos.x + 160 ,cldRollout.bmp014.pos.y + 205]
					on bmp014 mousedown do ( if cldRollout.bmp014.bitmap != undefined then( tempFileName = "\\a4" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp014_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a4" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp014.bitmap )catch()
						try( cldRollout.bmp014.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp014_l pressed do with undo on ( tempFileName = "\\a4" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp014_d pressed do with undo on 
					( 
						tempFileName = "\\a4" 
						try( forceReloadBitmapFile cldRollout.bmp014.bitmap ;cldRollout.bmp014.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
			
			imgtag bmp015 width:190 height:200 pos:[210,260]
				groupBox grp015 "NO_5" width:190 height:200 pos:[cldRollout.bmp015.pos.x + 0   ,cldRollout.bmp015.pos.y + 0]
				button bmp015_s "Save" width:60 height:30  pos:[cldRollout.bmp015.pos.x + 0   ,cldRollout.bmp015.pos.y + 205]
				button bmp015_l "Load" width:60 height:30  pos:[cldRollout.bmp015.pos.x + 65  ,cldRollout.bmp015.pos.y + 205]
				button bmp015_d "Del"  width:30  height:30 pos:[cldRollout.bmp015.pos.x + 160 ,cldRollout.bmp015.pos.y + 205]
					on bmp015 mousedown do ( if cldRollout.bmp015.bitmap != undefined then( tempFileName = "\\a5" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp015_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a5" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp015.bitmap )catch()
						try( cldRollout.bmp015.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp015_l pressed do with undo on ( tempFileName = "\\a5" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp015_d pressed do with undo on 
					( 
						tempFileName = "\\a5" 
						try( forceReloadBitmapFile cldRollout.bmp015.bitmap ;cldRollout.bmp015.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
				
			imgtag bmp016 width:190 height:200 pos:[410,260]
				groupBox grp016 "NO_6" width:190 height:200 pos:[cldRollout.bmp016.pos.x + 0   ,cldRollout.bmp016.pos.y + 0]
				button bmp016_s "Save" width:60 height:30  pos:[cldRollout.bmp016.pos.x + 0   ,cldRollout.bmp016.pos.y + 205]
				button bmp016_l "Load" width:60 height:30  pos:[cldRollout.bmp016.pos.x + 65  ,cldRollout.bmp016.pos.y + 205]
				button bmp016_d "Del"  width:30  height:30 pos:[cldRollout.bmp016.pos.x + 160 ,cldRollout.bmp016.pos.y + 205]
					on bmp016 mousedown do ( if cldRollout.bmp016.bitmap != undefined then( tempFileName = "\\a6" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp016_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a6" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp016.bitmap )catch()
						try( cldRollout.bmp016.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp016_l pressed do with undo on ( tempFileName = "\\a6" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp016_d pressed do with undo on 
					( 
						tempFileName = "\\a6" 
						try( forceReloadBitmapFile cldRollout.bmp016.bitmap ;cldRollout.bmp016.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
			
			imgtag bmp017 width:190 height:200 pos:[10,510]
				groupBox grp017 "NO_7" width:190 height:200 pos:[cldRollout.bmp017.pos.x + 0   ,cldRollout.bmp017.pos.y + 0]
				button bmp017_s "Save" width:60 height:30  pos:[cldRollout.bmp017.pos.x + 0   ,cldRollout.bmp017.pos.y + 205]
				button bmp017_l "Load" width:60 height:30  pos:[cldRollout.bmp017.pos.x + 65  ,cldRollout.bmp017.pos.y + 205]
				button bmp017_d "Del"  width:30  height:30 pos:[cldRollout.bmp017.pos.x + 160 ,cldRollout.bmp017.pos.y + 205]
					on bmp017 mousedown do ( if cldRollout.bmp017.bitmap != undefined then( tempFileName = "\\a7" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp017_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a7" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp017.bitmap )catch()
						try( cldRollout.bmp017.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp017_l pressed do with undo on ( tempFileName = "\\a7" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp017_d pressed do with undo on 
					( 
						tempFileName = "\\a7" 
						try( forceReloadBitmapFile cldRollout.bmp017.bitmap ;cldRollout.bmp017.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
				
			imgtag bmp018 width:190 height:200 pos:[210,510]
				groupBox grp018 "NO_8" width:190 height:200 pos:[cldRollout.bmp018.pos.x + 0   ,cldRollout.bmp018.pos.y + 0]
				button bmp018_s "Save" width:60 height:30  pos:[cldRollout.bmp018.pos.x + 0   ,cldRollout.bmp018.pos.y + 205]
				button bmp018_l "Load" width:60 height:30  pos:[cldRollout.bmp018.pos.x + 65  ,cldRollout.bmp018.pos.y + 205]
				button bmp018_d "Del"  width:30  height:30 pos:[cldRollout.bmp018.pos.x + 160 ,cldRollout.bmp018.pos.y + 205]
					on bmp018 mousedown do ( if cldRollout.bmp018.bitmap != undefined then( tempFileName = "\\a8" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp018_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a8" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp018.bitmap )catch()
						try( cldRollout.bmp018.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp018_l pressed do with undo on ( tempFileName = "\\a8" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp018_d pressed do with undo on 
					( 
						tempFileName = "\\a8" 
						try( forceReloadBitmapFile cldRollout.bmp018.bitmap ;cldRollout.bmp018.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
				
			imgtag bmp019 width:190 height:200 pos:[410,510]
				groupBox grp019 "NO_9" width:190 height:200 pos:[cldRollout.bmp019.pos.x + 0   ,cldRollout.bmp019.pos.y + 0]
				button bmp019_s "Save" width:60 height:30  pos:[cldRollout.bmp019.pos.x + 0   ,cldRollout.bmp019.pos.y + 205]
				button bmp019_l "Load" width:60 height:30  pos:[cldRollout.bmp019.pos.x + 65  ,cldRollout.bmp019.pos.y + 205]
				button bmp019_d "Del"  width:30  height:30 pos:[cldRollout.bmp019.pos.x + 160 ,cldRollout.bmp019.pos.y + 205]
					on bmp019 mousedown do ( if cldRollout.bmp019.bitmap != undefined then( tempFileName = "\\a9" ;try( shellLaunch "explorer.exe" ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch() ) )
					on bmp019_s pressed do with undo on 
					( 
						try( renderers.production = default_scanline_renderer())catch()
						tempFileName = "\\a9" ;try( Lotus_PoseToolToSave() )catch()
						tempSelection = selection as array ;hideByCategory.bones = true 
						try( render outputSize: [800,842] vfb:off outputFile:( poseTool_FilePathTo + tempFileName + ".jpg" ) gamma:2.2 )catch()
						try( forceReloadBitmapFile cldRollout.bmp019.bitmap )catch()
						try( cldRollout.bmp019.bitmap = openBitMap ( poseTool_FilePathTo + tempFileName +".jpg" )  )catch()
						hideByCategory.bones = false ;select tempSelection
					)
					on bmp019_l pressed do with undo on ( tempFileName = "\\a9" ;try( Lotus_PoseToolToLoad())catch() )
					on bmp019_d pressed do with undo on 
					( 
						tempFileName = "\\a9" 
						try( forceReloadBitmapFile cldRollout.bmp019.bitmap ;cldRollout.bmp019.bitmap = undefined )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + ".jpg" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Transform.txt" ) )catch()
						try( deletefile ( poseTool_FilePathTo + tempFileName + "_Pos.txt" ) )catch()
					)
		)
			
	AddSubRollout pose_saveRollout.sub1 cldRollout
		
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp011.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp011.bitmap = openBitMap ( poseTool_FilePathTo + "\\a1.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp012.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp012.bitmap = openBitMap ( poseTool_FilePathTo + "\\a2.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp013.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp013.bitmap = openBitMap ( poseTool_FilePathTo + "\\a3.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp014.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp014.bitmap = openBitMap ( poseTool_FilePathTo + "\\a4.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp015.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp015.bitmap = openBitMap ( poseTool_FilePathTo + "\\a5.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp016.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp016.bitmap = openBitMap ( poseTool_FilePathTo + "\\a6.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp017.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp017.bitmap = openBitMap ( poseTool_FilePathTo + "\\a7.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp018.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp018.bitmap = openBitMap ( poseTool_FilePathTo + "\\a8.jpg" )  )catch()
		try( forceReloadBitmapFile pose_saveRollout.sub1.cldRollout.bmp019.bitmap )catch()
		try( pose_saveRollout.sub1.cldRollout.bmp019.bitmap = openBitMap ( poseTool_FilePathTo + "\\a9.jpg" )  )catch()