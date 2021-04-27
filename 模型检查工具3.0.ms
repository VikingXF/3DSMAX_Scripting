
----------------------------------------rolloutfloater
if MR != undefined do closerolloutfloater MR
MR = newrolloutfloater "模型检查工具3.0" 290 800 30 100
rollout ReleaseNotes "版本信息"
(
	groupbox gb1 "版本说明:" width:250 height:55
	label lab0 "版本: 3.0" pos:[95,23]
	label 'lbl1' "模型制作流程工具，有问题跟需求联系XF" pos:[19,40] width:230 height:20 align:#left	
	---hyperlink mylink "版本更新" address:"http://" pos:[93,115] color:blue
)

rollout InformationTools "信息反馈" width:541 height:250
(
	groupBox 'grp12' "信息反馈" pos:[6,4] width:266 height:120 align:#left		
	button 'ClearInformation' "清除信息" pos:[166,18] width:96 height:24 toolTip:"" align:#left	
	listBox 'Information' "单击选择模型" pos:[19,30] width:244 height:5 selection:1 align:#left
	
	-----------------------清除信息--------------------------------------------------------		
	on ClearInformation pressed  do
		InformationTools.Information.items = #("")
)




rollout ModelTools "★---------- 模型检查工具 ----------★" 
(
	checkbutton 'ModelCheckB' "模型检查" pos:[4,4] width:85 height:22 align:#left
		checkbutton 'ModelToDealB' "模型处理" pos:[94,4] width:85 height:22 align:#left	
			checkbutton 'RenameB' "模型命名" pos:[184,4] width:85 height:22 align:#left
	checkbutton 'FBXexportB' "模型导出" pos:[4,28] width:85 height:22 align:#left
		checkbutton 'ObjectaxisB' "物体轴心修改" pos:[94,28] width:85 height:22 align:#left
			checkbutton 'ObjectmoveB' "物体位移修改" pos:[184,28] width:85 height:22 align:#left	
	checkbutton 'TakeScreenB' "拍屏" pos:[4,52] width:85 height:22 align:#left
		checkbutton 'BakingAOB' "烘焙AO贴图" pos:[94,52] width:85 height:22 align:#left
			checkbutton 'B' "" pos:[184,52] width:85 height:22 align:#left
			
	fn Destroyfilter =
	(
		DestroyDialog ModelTools.ModelCheckTools
		DestroyDialog ModelTools.ModelToDealTools
		DestroyDialog ModelTools.RenameTools
		DestroyDialog ModelTools.FBXexportTools
		DestroyDialog ModelTools.ObjectaxisTools
		DestroyDialog ModelTools.ObjectmoveTools
		DestroyDialog ModelTools.TakeScreenTools
		DestroyDialog ModelTools.BakingAOTools
	)

------------模型检查
	fn ModelCheckToolson =
	(
		addrollout ModelTools.ModelCheckTools MR rolledUp:on		
	)
	fn ModelCheckToolsoff =
	(
		removeRollout ModelTools.ModelCheckTools MR
	)
			
	rollout ModelCheckTools "模型检查" 
	(
		groupBox 'ModelCheck' "模型检查" pos:[6,14] width:266 height:138 align:#left	
		button 'OverlaooingVertices' "重叠点检查" pos:[14,34] width:122 height:25 align:#left
		button 'OverlaooingFaces' "重叠面检查" pos:[140,34] width:122 height:25 align:#left	
		button 'IsolatedVertices' "孤立点检查" pos:[14,61] width:122 height:25 align:#left
		button 'MultipleEdges' "多重线检查" pos:[140,61] width:122 height:25 align:#left
		checkButton 'BackfaceCull' "开/关背面显示" pos:[14,88] width:122 height:25 align:#left
		button 'FacesOrientation' "面方向检查" pos:[140,88] width:122 height:25 align:#left	
		button 'FiveFaceC' "五边面检查" pos:[14,115] width:122 height:25 align:#left
		button 'OpenEdgesC' "开放线检查" pos:[140,115] width:122 height:25 align:#left
		
		
		
		-----------------------五边面检查--------------------------------------------------------	
		on FiveFaceC pressed  do
		(		
			if selection.count == 1 then
			(		
				getfc = #()
				for i = 1 to polyop.getnumfaces $ do
				(
					fcused = polyOp.getEdgesUsingFace $ i
					fcusedcon = (fcused as array).count

					if fcusedcon > 4 then
					(
						append getfc i
					)
			
				)
				if getfc.count != 0 then
				(	
					subobjectLevel = 4
					polyop.setfaceselection $ getfc
					tempitm =  InformationTools.Information.items
					SomeError ="有五边面" 
					Newitm = append tempitm SomeError 
					InformationTools.Information.items = Newitm			
				)
				else
				(
					subobjectLevel = 0
					tempitm =  InformationTools.Information.items
					SomeError ="无五边面" 
					Newitm = append tempitm SomeError 
					InformationTools.Information.items = Newitm
				)
			)
			else
				messagebox "请选择单个物体"
				
		)
		
		---------------------面方向检查----------------------------------------------------------		
		on FacesOrientation pressed  do
		(
			macros.run "xView" "xView_Face_Orientation_Checker"
			tempitm = InformationTools.Information.items
			SomeError ="面方向检查" 
			Newitm = append tempitm SomeError 
			InformationTools.Information.items= Newitm
		)
		---------------------重叠点检查----------------------------------------------------------		
		on OverlaooingVertices pressed  do
		(
				macros.run "xView" "xView_Overlapping_Vertices_Checker"
				tempitm =  InformationTools.Information.items
				SomeError ="重叠点检查" 
				Newitm = append tempitm SomeError 
				InformationTools.Information.items = Newitm
			)
		---------------------重叠面检查----------------------------------------------------------		
		on OverlaooingFaces pressed  do
		(
				macros.run "xView" "xView_Overlapping_Faces_Checker"
				
				tempitm =  InformationTools.Information.items
				SomeError ="重叠面检查" 
				Newitm = append tempitm SomeError 
				InformationTools.Information.items = Newitm
			)
		---------------------孤立点检查----------------------------------------------------------		
		on IsolatedVertices pressed  do
		(
			macros.run "xView" "xView_Isolated_Vertex_Checker"
				
			tempitm =  InformationTools.Information.items
			SomeError ="孤立点检查" 
			Newitm = append tempitm SomeError 
			InformationTools.Information.items = Newitm
		)
		-----------------------多重线检查--------------------------------------------------------		
		on MultipleEdges pressed  do
		(
			macros.run "xView" "xView_Multiple_Edges_Checker"
				
			tempitm =  InformationTools.Information.items
			SomeError ="多重线检查" 
			Newitm = append tempitm SomeError 
			InformationTools.Information.items = Newitm
		)
			
		-----------------------开放边检查--------------------------------------------------------	
		on OpenEdgesC pressed  do
		(
				macros.run "xView" "xView_Open_Edges_Checker"
				tempitm =  InformationTools.Information.items
				SomeError ="开放边检查" 
				Newitm = append tempitm SomeError 
				InformationTools.Information.items = Newitm
				
		)

		-----------------------开/关背面显示--------------------------------------------------------			
		on BackfaceCull changed state do
		(
			for i in geometry do
			(
				if state then i.backfacecull = on
				else i.backfacecull = off	
			)
		)
		
	)

	on ModelCheckB changed state do
	(
		try
			Destroyfilter()
		catch()
		if ModelCheckB.checked == true then
		(
			ModelCheckToolson()
		)
		else
		(
			ModelCheckToolsoff()
		)
	)
	
	on ModelCheckB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog ModelCheckTools pos:mouse.screenpos
	)
	
	
------------模型处理
	fn ModelToDealToolson =
	(
		addrollout ModelTools.ModelToDealTools MR rolledUp:on		
	)
	fn ModelToDealToolsoff =
	(
		removeRollout ModelTools.ModelToDealTools MR
	)
	
	rollout ModelToDealTools "模型处理" width:541 height:575
	(
		
		groupBox 'ModelToDeal' "模型处理" pos:[6,14] width:266 height:193 align:#left
		button 'RemoveIsolatedVertices' "移除多余顶点" pos:[38,34] width:110 height:25 align:#left	
		button 'AutomaticSmoothingUnit' "自动光滑组" pos:[38,61] width:110 height:25 align:#left	
		button 'VertexWeld' "顶点焊接" pos:[38,88] width:110 height:25 align:#left	
		spinner 'WeldValue' "" pos:[152,92] width:70 height:16 range:[0,100,0.01] scale:0.01 align:#left	
		button 'ResetXfrom' "Xfrom" pos:[38,115] width:110 height:25 align:#left	
		button 'CondenseMaterial' "去除未调用材质球" pos:[38,142] width:110 height:25 align:#left
		button 'DelPV' "删ParticleView" pos:[38,169] width:110 height:25 align:#left		
		button 'BatchProcessing' "一键批处理" pos:[152,169] width:110 height:25 align:#left
		
		checkbox 'chkRemove' "Checkbox" pos:[16,41] width:14 height:10 align:#left
		checkbox 'chkAuto' "Checkbox" pos:[16,68] width:14 height:10 align:#left
		checkbox 'chkVertexWeld' "Checkbox" pos:[16,95] width:14 height:10 align:#left
		checkbox 'chkXfrom' "Checkbox" pos:[16,122] width:14 height:10 align:#left
		
		
		
		-----------------------移除多余顶点--------------------------------------------------------		
		fn RemoveIV =
		(
			if selection.count > 0 do
				(
				try 
				(
				   
				   for i in selection do i.EditablePoly.deleteIsoVerts ()
				   tempitm = InformationTools.Information.items
				   SomeError ="去除顶点成功" 
					Newitm = append tempitm SomeError 
					InformationTools.Information.items= Newitm
				   
				) 
				catch
				(
				   tempitm = InformationTools.Information.items
				   SomeError ="去除顶点-\没有成功,可能有不可编辑的物体" 
					Newitm = append tempitm SomeError 
					InformationTools.Information.items= Newitm
				)
				)
		)

		----------------------顶点焊接---------------------------------------------------------	
		fn VWeld = 
		(
			for i in selection do
				(
					try
					(
						i.weldThreshold = ModelToDealTools.WeldValue.value
						polyOp.weldVertsByThreshold i #{1..(i.GetNumVertices())};
				
						tempitm = InformationTools.Information.items
						SomeError ="焊接顶点成功" 
						Newitm = append tempitm SomeError 
						InformationTools.Information.items= Newitm
				
					)
					catch 
					(
						select i
						tempitm =  InformationTools.Information.items
						 SomeError =i.name+"焊接顶点没有成功" 
						   Newitm = append tempitm SomeError 
						   InformationTools.Information.items = Newitm
					)
				)

		)
		---------------------自动光滑组----------------------------------------------------------	
		fn AutomaticSmooth = 
		(	
			
			for i in selection do with undo on
			(
				try 
				(
				   selnone = polyOp.getFaceSelection i
				   facenum = polyOp.getNumFaces i
				   polyOp.setFaceSelection i #{1..facenum}
				   i.EditablePoly.autosmooth ()
				   polyOp.setFaceSelection i selnone	
			
				   tempitm = InformationTools.Information.items
					SomeError ="自动成功" 
					  Newitm = append tempitm SomeError 
					  InformationTools.Information.items = Newitm
				)
				catch
				(
					tempitm = InformationTools.Information.items
					SomeError =i.name+"自动光滑=\没有成功" 
					  Newitm = append tempitm SomeError 
					  InformationTools.Information.items = Newitm
				 )
			)
		)


		----------------------xform---------------------------------------------------------		
		fn Rexform =
		(
			if selection.count > 0 do
			(
			try
			(
			   for i in geometry do  	
			   (
				  ResetXForm i
				  convertTopoly i
			
			   )
			   tempitm =  InformationTools.Information.items
			   SomeError ="xform成功" 
				Newitm = append tempitm SomeError 
				InformationTools.Information.items = Newitm
			)		
			catch
			(
				tempitm =  InformationTools.Information.items
				SomeError ="xform没有成功" 
				Newitm = append tempitm SomeError 
				 InformationTools.Information.items = Newitm
			)
			)
		)



		-----------------------一键批处理--------------------------------------------------------		
			on BatchProcessing pressed do
		(
			if chkRemove.checked do RemoveIV()
			if chkAuto.checked do AutomaticSmooth()
			if chkVertexWeld.checked do VWeld()
			if chkXfrom.checked do Rexform()
		)
			
			
		-----------------------点击移除多余顶点--------------------------------------------------------	
			on RemoveIsolatedVertices pressed  do
			(
				RemoveIV()
				
			)
		----------------------去除未调用材质球---------------------------------------------------------	
			on CondenseMaterial pressed  do
		(
				MatEditor.Open()
				macros.run "Medit Tools" "condense_medit_slots"
				tempitm =  InformationTools.Information.items
				SomeError ="已精简材质球" 
				 Newitm = append tempitm SomeError 
				  InformationTools.Information.items = Newitm
			)
		----------------------点击顶点焊接---------------------------------------------------------		
			on VertexWeld pressed  do
			(
			
			 VWeld()
			 
			)
		----------------------点击xform---------------------------------------------------------		
			on ResetXfrom pressed  do
		(
			Rexform()
			
		)
	---------------------点击自动光滑组----------------------------------------------------------		
		on AutomaticSmoothingUnit pressed  do
		(
			AutomaticSmooth()
		)
		-----------------------删除ParticleView--------------------------------------------------------		
		on DelPV pressed do
		(
			delete $'particle view*' 
		)	
	)
	
	on ModelToDealB changed state do
	(
		try
			Destroyfilter()
		catch()
		if ModelToDealB.checked == true then
		(
			ModelToDealToolson()
		)
		else
		(
			ModelToDealToolsoff()
		)
	)
	
	on ModelToDealB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog ModelToDealTools pos:mouse.screenpos
	)

------------模型命名
	fn RenameToolson =
	(
		addrollout ModelTools.RenameTools MR rolledUp:on		
	)
	fn RenameToolsoff =
	(
		removeRollout ModelTools.RenameTools MR
	)
	
	rollout RenameTools "模型命名" width:541 height:575
	(
		groupBox 'grp17' "" pos:[2,2] width:270 height:350 align:#left
		--UI起始位置 
		radiobuttons objORmat "选择重命名物体:" labels:#("物体", "材质球") pos:[160,15] offsets:#([0,0], [0,0])
		label 'lbl1' "(使用右键选择物体)" pos:[10,15] --width:115 height:41 align:#left
		multilistbox ObjNames "Scene Objects" pos:[10,34] width:250 height:11
					
		checkbox 'CKBname' pos:[10,210] checked:true
		editText 'ETBname' "命名名称" pos:[35,210] width:150 height:15 align:#left
		
		checkbox 'CKNumbered' "  序号" pos:[10,235]		
		editText 'ETBaseNumber' ":" text:"000" pos:[70,235] width:85 height:15 align:#left
		
		button 'BTrename' "命名" pos:[200,210] width:60 height:50 align:#left
					
		groupBox 'GBreplace' "替换字符" pos:[5,260] Width:260 height:80 align:#left
		editText 'ETfind' "被替换字符:" pos:[15,285] width:180 height:15 align:#left
		editText 'ETreplace' "替换字符:    " pos:[15,310] width:180 height:15 align:#left
		button 'BTreplace' "替换" pos:[200,280] width:60 height:50 align:#left
		--UI完成
		--variables defining starts
		local sceneObjNames = #()
		local sceneObjs = #()
						
		local sceneMats = #()
		local sceneMatNames = #()
					 
		--variables defining ends	
						
		on mltRenamer open do
		(
			sceneObjNames = for i in objects where superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt collect i.name
			ObjNames.items = sceneObjNames
		)
						
		--Useful function defining starts here
						
		-- function for updating object names in list starts
		fn updateObjList =
		(	
			sceneObjNames = for i in objects where superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt collect i.name
			ObjNames.items = sceneObjNames
		)								
		-- function for updating object names in list ends
								
		fn updateMatList =
		(	
			sceneMatNames = for i in scenematerials collect i.name
			ObjNames.items = sceneMatNames
		)
							
		fn NumPlease str = ((trimLeft str "0123456789").count == 0) -- function for accepting only numbers...Number please
							
		fn selectObjects = 
		(
			if objORmat.state==1 
			do
			(
				local templist=ObjNames.selection as array 
				clearselection()
				local sceneObjsNames=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i.name
				for i in templist do (selectmore (getNodeByName sceneObjsNames[i]))
				updateObjList()
			)
			if objORmat.state==2  do
			(
				local sceneMats = for i in scenematerials collect i
				local templist = ObjNames.selection as array
				local selMat=for i in templist collect sceneMats[i]
				clearselection()
				for mat in selMat do 
				(
					selectmore (for o in objects where mat==o.material collect o)
				)
				updateMatList()
			)
		)
						
		--Useful function defining ends here
							
		on ObjNames rightClick do (selectObjects())
							
		--Changing cpation of multilistbox start
		on objORmat changed state do 
		(
			if objORmat.state==1
			then (ObjNames.caption="Scene Objects"
				updateObjList())
			else (ObjNames.caption="Scene Materials"
				updateMatList())
		)
		--Changing cpation of multilistbox ends		
									
		on ETBaseNumber changed txt do
		(
			if not NumPlease txt do
				(messagebox "You can type only numbers!"
					ETBaseNumber.text="000")
		)--- for accepting only numbers in base number field
							
							
		On BTrename pressed do
		(
			if objORmat.state==1 do
			(
				sceneObjs=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i
				local templist = ObjNames.selection as array				
				if CKBname.state==true do  
				(  
					if ETBname.text!="" 
					then
					(
						if templist.count==0
						then
						(
							(for i in sceneObjs do i.name=ETBname.text
							updateObjList())
						)
						else
						(
							(for i in templist do sceneObjs[i].name=ETBname.text
							updateObjList())
						)
					)
					else (messagebox "Enter text in Base Name field!!!")	
				)
				if CKNumbered.state==true do
				(	
					if CKBname.state==true and ETBname.text=="" 	then updateObjList()																		
					else
					(	
						if templist.count==0
						then
						(
							local baseNum=ETBaseNumber.text as integer
							for i in sceneObjs do 
							(  
								i.name=i.name + formattedPrint baseNum format:"3.3d"
								baseNum=baseNum as integer + 1
							)
							updateObjList()	
						)
						else
						(
							local baseNum=ETBaseNumber.text as integer
							for i in templist do 
							(  
								sceneObjs[i].name=sceneObjs[i].name + formattedPrint baseNum format:"3.3d"
								baseNum=baseNum as integer + 1
							)
							updateObjList()	
						)
					)	
				)
														
		)			
			if objORmat.state == 2 do
			(
				updateMatList()
				local sceneMats = for i in scenematerials collect i
				local templist = ObjNames.selection as array
												
				if CKBname.state==true do  
				(  
					if ETBname.text!="" 
					then
					(
						if templist.count==0
						then
						(
							for i in sceneMats do i.name=ETBname.text
							updateMatList()
						)
						else
						(
							for i in templist do sceneMats[i].name=ETBname.text
							updateMatList()
						)
					)
					else (messagebox "Enter valid text.")	
				)
				if CKNumbered.state==true do
				(	
					if CKBname.state==true and ETBname.text=="" then updateMatList()
					else
					(
						if templist.count==0
						then
						(	local baseNum=ETBaseNumber.text as integer
							for i in sceneMats do 
							(  
								i.name=i.name + formattedPrint baseNum format:"3.3d"
								baseNum=baseNum as integer + 1
							)
							updateMatList()
						)
						else
						(	local baseNum=ETBaseNumber.text as integer
							for i in templist do 
							(  
								sceneMats[i].name=sceneMats[i].name + formattedPrint baseNum format:"3.3d"
								baseNum=baseNum as integer + 1
							)
							updateMatList()
						)
					)
				)																
			)												
		)

		On BTreplace pressed do
		(
			if objORmat.state==1 do
			(
				updateObjList()
				sceneObjs=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i
														
				local FString = ETfind.text
				local RString = ETreplace.text
				local listSelObj=#()
				if FString !="" 
					do
					( 
						local templist = ObjNames.selection as array
						if templist.count == 0 
						then
						(
							for i in sceneObjs do (i.name=substituteString i.name FString RString)						
							updateObjList()
						)
						else
						(
							for i in templist do (sceneObjs[i].name=substituteString sceneObjs[i].name FString RString)						
							updateObjList()
						)
					)		
			)
			if objORmat.state==2 do
			(
				updateMatList()
				local sceneMats = for i in scenematerials collect i
				local FString = ETfind.text
				local RString = ETreplace.text
				if FString !="" 
				do
				(
					local templist = ObjNames.selection as array
					if templist.count == 0 
					then
					(
						for i in sceneMats do (i.name =substituteString i.name FString RString)
						updateMatList()
					)	
					else
					(
						for i in ObjNames.selection do (sceneMats[i].name =substituteString sceneMats[i].name FString RString)
						updateMatList()
					)
				)		
			)
		)
		
		
	----button 'RenameButton' "命名" pos:[13,38] width:41 height:24 align:#left
	----editText 'Modle_nametext' "" pos:[56,36] width:169 height:27 align:#left
	--------------------命名-----------------------------------------------------------		
	----on RenameButton pressed  do
	----(
	----	for i in selection do
	----	(
	----		i.name = uniquename Modle_nametext.text
	----		InformationTools.Information.items = #("重命名完成") 
	----	)
	----)
		
		
	)

	on RenameB changed state do
	(
		try
			Destroyfilter()
		catch()
		if RenameB.checked == true then
		(
			RenameToolson()
		)
		else
		(
			RenameToolsoff()
		)
	)
	
	on RenameB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog RenameTools pos:mouse.screenpos
	)

------------模型导出
	fn FBXexportToolson =
	(
		addrollout ModelTools.FBXexportTools MR rolledUp:on		
	)
	fn FBXexportToolsoff =
	(
		removeRollout ModelTools.FBXexportTools MR
	)	
	rollout FBXexportTools "模型导出" width:541 height:575
	(

		groupBox 'ModleExport' "模型导出" pos:[6,14] width:266 height:59 align:#left	
		button 'ModleExportFBX' "导出FBX" pos:[45,35] width:154 height:27 align:#left
		
		--------------------导出FBX-----------------------------------------------------------		
		on ModleExportFBX pressed  do
		if selection.count > 0 do
		(
			global tempOBJ = $
			global judgeOBJorSEL = undefined
			global judgeOBJorSEL_Num = undefined
		
			fn Function_Judge =
			(
				global tempOBJ = $
				global tempNum = 1
		
				for i in tempOBJ do 
				(
					if classOf tempOBJ[tempNum] as string != "Dummy" then
					(
						tempNum = tempNum + 1
					 )
					 else
					(
						judgeOBJorSEL = "yes"
						judgeOBJorSEL_Num = tempNum
					 )		 
				 )
			 )
		
		
			if maxfilepath != undefined do
			(
				Function_Judge()
				
				if tempOBJ[2] as string != "SubAnim:Space_Warps" and judgeOBJorSEL == undefined then
				(
					global exportArr = #()
					global countNum = 1
					for i in 1 to tempOBJ.count do
					(			
						global tempCopyOBJ = copy tempOBJ[countNum]
						tempCopyOBJ.name = tempOBJ[countNum].name
						resetXform tempCopyOBJ
						ConverttoPoly tempCopyOBJ
						tempCopyOBJ.rotation = quat -0.707107 0 0 0.707107
						WorldAlignPivot tempCopyOBJ
						tempCopyOBJ.rotation = quat 0.707107 0 0 0.707107
						append exportArr tempCopyOBJ
						countNum = countNum + 1		
					 )
					countNum = 1
					 
					for i in 1 to tempOBJ.count do
					(
						
						select exportArr[countNum]
						checkPath = maxfilepath
						export_op = exporterPlugin.classes
						export_fbx = export_op[9]
						FBXExporterSetParam "Animation" false 
						FBXExporterSetParam "BakeAnimation" true 
						FBXExporterSetParam "UseSceneName" true
						FBXExporterSetParam "FileVersion" #FBX201500
						exportfile (checkPath + exportArr[countNum].name +".FBX") #noprompt selectedonly:true using:export_fbx
						delete exportArr[countNum]
						countNum = countNum + 1
					 )
				 )
				 else()
				 
				 if judgeOBJorSEL != undefined then
				(
					Function_Judge()
					global selectBaseGroup = tempOBJ[judgeOBJorSEL_Num]
					maxOps.cloneNodes selectBaseGroup cloneType:#copy newNodes:&tempCopyOBJ
					global selectExpGroup = tempCopyOBJ
					select selectExpGroup
					Function_Judge()
					selectExpGroup[judgeOBJorSEL_Num].name = selectBaseGroup.name
		
					resetXform selectExpGroup[judgeOBJorSEL_Num]
					ConverttoPoly selectExpGroup[judgeOBJorSEL_Num]
					selectExpGroup[judgeOBJorSEL_Num].rotation = quat -0.707107 0 0 0.707107
					WorldAlignPivot selectExpGroup[judgeOBJorSEL_Num]
					selectExpGroup[judgeOBJorSEL_Num].rotation = quat 0.707107 0 0 0.707107
					select selectExpGroup[judgeOBJorSEL_Num]
						
					checkPath = maxfilepath
					export_op = exporterPlugin.classes
					export_fbx = export_op[9]
					FBXExporterSetParam "Animation" false 
					FBXExporterSetParam "BakeAnimation" true 
					FBXExporterSetParam "UseSceneName" true
					FBXExporterSetParam "FileVersion" #FBX201500
					exportfile (checkPath + selectExpGroup[judgeOBJorSEL_Num].name +".FBX") #noprompt selectedonly:true using:export_fbx
					delete selectExpGroup[judgeOBJorSEL_Num]	 		
				 )
				 else()
				 
				if tempOBJ[2] as string == "SubAnim:Space_Warps" then
				(
					global tempCopyOBJ = copy tempOBJ
					tempCopyOBJ.name = tempOBJ.name
					resetXform tempCopyOBJ
					ConverttoPoly tempCopyOBJ
					tempCopyOBJ.rotation = quat -0.707107 0 0 0.707107
					WorldAlignPivot tempCopyOBJ
					tempCopyOBJ.rotation = quat 0.707107 0 0 0.707107
					select tempCopyOBJ
						
					checkPath = maxfilepath
					export_op = exporterPlugin.classes
					export_fbx = export_op[9]
					FBXExporterSetParam "Animation" false 
					FBXExporterSetParam "BakeAnimation" true 
					FBXExporterSetParam "UseSceneName" true
					FBXExporterSetParam "FileVersion" #FBX201500
					exportfile (checkPath + tempCopyOBJ.name +".FBX") #noprompt selectedonly:true using:export_fbx
					delete tempCopyOBJ 
				 )
				 else() 	 
			 )
		
		tempitm =  InformationTools.Information.items
		SomeError ="导出完成" 
		Newitm = append tempitm SomeError 
		InformationTools.Information.items = Newitm
		)
	)

	on FBXexportB changed state do
	(
		try
			Destroyfilter()
		catch()
		if FBXexportB.checked == true then
		(
			FBXexportToolson()
		)
		else
		(
			FBXexportToolsoff()
		)
	)
	
	on FBXexportB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog FBXexportTools pos:mouse.screenpos
	)
	
------------物体轴心修改
	fn ObjectaxisToolson =
	(
		addrollout ModelTools.ObjectaxisTools MR rolledUp:on		
	)
	fn ObjectaxisToolsoff =
	(
		removeRollout ModelTools.ObjectaxisTools MR
	)	
	rollout ObjectaxisTools "物体轴心修改" width:541 height:575
	(
		
		groupBox 'grp18' "物体轴心修改" pos:[6,14] width:266 height:138 align:#left
		checkButton 'ModifyPivot' "轴心修改" pos:[14,34] width:122 height:25 align:#left
		button 'Mod' "" pos:[140,34] width:122 height:25 align:#left
		button 'ModifyPivotZero' "轴心归零" pos:[14,61] width:122 height:25 align:#left
		button 'ModifyPivotZ' "轴心Z轴归最低位置" pos:[14,88] width:122 height:25 align:#left
		button 'ModifyPivotZRotation' "沿Z轴旋转90度" pos:[140,88] width:122 height:25 align:#left
		button 'ModifyPivotCenter' "轴心重置到物体中心" pos:[140,61] width:122 height:25 align:#left
		
		---------------------轴心归零----------------------------------------------------------		
		on ModifyPivotZero pressed  do
		with undo on
		(
			for i in selection do
			(
				i.pivot.x = 0
				i.pivot.y = 0
				i.pivot.z = 0
			 )
		tempitm = InformationTools.Information.items
		SomeError ="轴心归零" 
		Newitm = append tempitm SomeError 
		InformationTools.Information.items= Newitm
		)
	---------------------轴心Z轴归最低位置----------------------------------------------------------		
		on ModifyPivotZ pressed  do
		with undo on
		(
			for i in selection do
			(
		
				i.pivot.z = i.min.z
		
			 )
		tempitm = InformationTools.Information.items
		SomeError ="轴心Z轴归最低位置" 
		Newitm = append tempitm SomeError 
		InformationTools.Information.items= Newitm
		)
	--------------------沿Z轴旋转90度-----------------------------------------------------------		
		on ModifyPivotZRotation pressed  do
		with undo on
		(
			fn RotatePivotOnly obj rotation = (local rotValInv=inverse (rotation as quat)
			animate off in coordsys local obj.rotation*=RotValInv
			obj.objectoffsetpos*=RotValInv
			obj.objectoffsetrot*=RotValInv
			)
		
			for i in selection do
			(
				RotatePivotOnly i (EulerAngles 90 0 0)
			 )
		
		tempitm = InformationTools.Information.items
		SomeError ="沿Z轴旋转90度" 
		Newitm = append tempitm SomeError 
		InformationTools.Information.items= Newitm
		)
	--------------------轴心重置到物体中心-----------------------------------------------------------		
		on ModifyPivotCenter pressed  do
		with undo on
		(
			for i in selection do
			(
				
				CenterPivot i		
			)
		tempitm = InformationTools.Information.items
		SomeError ="轴心重置中心" 
		Newitm = append tempitm SomeError 
		InformationTools.Information.items= Newitm
		)

	-----------------------轴心归零--------------------------------------------------------		
		on ModifyPivot changed state do
		(
			if maxops.pivotmode != #pivotonly
			then maxops.pivotmode = #pivotonly
			else maxops.pivotmode = #none
		)
	)

	on ObjectaxisB changed state do
	(
		try
			Destroyfilter()
		catch()
		if ObjectaxisB.checked == true then
		(
			ObjectaxisToolson()
		)
		else
		(
			ObjectaxisToolsoff()
		)
	)
	
	on ObjectaxisB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog ObjectaxisTools pos:mouse.screenpos
	)
	
------------物体位移修改
	fn ObjectmoveToolson =
	(
		addrollout ModelTools.ObjectmoveTools MR rolledUp:on		
	)
	fn ObjectmoveToolsoff =
	(
		removeRollout ModelTools.ObjectmoveTools MR
	)	
	rollout ObjectmoveTools "物体位移修改" width:541 height:575
	(

		groupBox 'Displacement' "物体位移" pos:[6,14] width:266 height:63 align:#left
		button 'MoveOrigin' "位移到零点" pos:[14,34] width:122 height:25 align:#left
		button 'MoveZzzOrigin' "位移到Z轴下方" pos:[140,34] width:122 height:25 align:#left
		---------------------位移到零点----------------------------------------------------------		
		on MoveOrigin pressed  do
		with undo on
		(
			for i in selection do
			(
				i.pos.x = 0
				i.pos.y = 0
				i.pos.z = 0
			 )
		)
	--------------------位移到Z轴下方----------------------------------------------------------		
		on MoveZzzOrigin pressed  do
		with undo on
		(
			for i in selection do
			(
				i.pos.z = 0
			 )
		)
	)

	on ObjectmoveB changed state do
	(
		try
			Destroyfilter()
		catch()
		if ObjectmoveB.checked == true then
		(
			ObjectmoveToolson()
		)
		else
		(
			ObjectmoveToolsoff()
		)
	)
	
	on ObjectmoveB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog ObjectmoveTools pos:mouse.screenpos
	)

------------拍屏
	fn TakeScreenToolson =
	(
		addrollout ModelTools.TakeScreenTools MR rolledUp:on		
	)
	fn TakeScreenToolsoff =
	(
		removeRollout ModelTools.TakeScreenTools MR
	)		
	rollout TakeScreenTools "拍屏" width:541 height:575
	(
		groupBox 'grp8' "拍屏" pos:[6,14] width:266 height:51 align:#left
		button 'TakeScreen' "拍屏" pos:[55,35] width:174 height:24 align:#left
		-----------------------拍屏--------------------------------------------------------	
		---------渲染设置（Default Scanline Renderer）
		fn RenterSet = 
		(
			try renderers.current = RendererClass.classes[1]() catch()
			rendTimeType = 1
			renderWidth = 1280
			renderHeight  = 720	
			if maxfilepath != undefined do
			(
				submaxfilename =substitutestring maxfilename ".max" ""
				rendOutputFilename =  maxfilepath +submaxfilename +"_截图"+".jpg"
			)
			
			rendSaveFile = true
		)
		---------材质设置
		fn materialsSet =
		(
			for i=1 to scenematerials.count do
			(
				--scenematerials[i] =	Standardmaterial()
				k = scenematerials[i] as string
				if k.count>18 then
				(
					kk = substring k  1 18    --获得材质属性子字符串，用于判断是否是“多维材质”
				)
					
				if kk == "#Multi/Sub-Object:" then
				(	
					for j=1 to  scenematerials[i].MaterialList.count do
					(	
						--Mname = scenematerials[i].materialList[j] as string
						
						scenematerials[i].materialList[j].selfIllumAmount = 100   ----自发光100
						scenematerials[i].materialList[j].twoSided  = true   ----双面
							
					)
				)
				else
				(
					scenematerials[i].selfIllumAmount = 100    ----自发光100
					scenematerials[i].twoSided  = true       ----双面
				)
			)
		)


		on TakeScreen pressed  do
		(	
			materialsSet()
			RenterSet()

			backgroundColor = color 56 56 56
			max quick render

		)
	)

	on TakeScreenB changed state do
	(
		try
			Destroyfilter()
		catch()
		if TakeScreenB.checked == true then
		(
			TakeScreenToolson()
		)
		else
		(
			TakeScreenToolsoff()
		)
	)
	
	on TakeScreenB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog TakeScreenTools pos:mouse.screenpos
	)

------------烘焙AO贴图
	fn BakingAOToolson =
	(
		addrollout ModelTools.BakingAOTools MR rolledUp:on		
	)
	fn BakingAOToolsoff =
	(
		removeRollout ModelTools.BakingAOTools MR
	)		
	rollout BakingAOTools "烘焙AO贴图" width:541 height:575
	(
		groupBox 'grp9' "烘焙AO贴图" pos:[4,5] width:266 height:300 align:#left	
		
		groupBox 'AOgrp2' "RenderToTexture设置" pos:[9,29] width:257 height:107 align:#left
		spinner 'ChannelSpinner' "" pos:[199,52] width:50 height:16 range:[0,5,2] type:#integer scale:1 align:#left
		label 'Channellabe' "Channel：" pos:[150,53] width:51 height:14 align:#left
		spinner 'PaddingSpinner' "" pos:[71,52] width:50 height:16 range:[0,20,4] type:#integer scale:1 align:#left
		label 'Paddinglabel' "Padding：" pos:[22,53] width:51 height:14 align:#left	
		spinner 'MapSizeSpn' "" pos:[15,97] width:53 height:16 enabled:true range:[1,2048,512] type:#integer scale:1 align:#left
		label 'MapSizelabel' "Map Size" pos:[18,79] width:47 height:14 align:#left
		button 'MapSize128' "128x128" pos:[70,77] width:60 height:20 align:#left
		button 'MapSize512' "512x512" pos:[135,77] width:60 height:20 align:#left
		button 'MapSize1024' "1024x1024" pos:[200,77] width:60 height:20 align:#left
		button 'MapSize256' "256x256" pos:[70,103] width:60 height:20 align:#left
		button 'MapSize768' "768x768" pos:[135,103] width:60 height:20 align:#left
		button 'MapSize2048' "2048x2048" pos:[200,103] width:60 height:20 align:#left
		
		groupBox 'AOgrp3' "AO材质设置" pos:[10,144] width:257 height:113 align:#left
		label 'Sampleslbl2' "Samples.........................." pos:[30,167] width:147 height:20 align:#left
		spinner 'Samplesspn' "" pos:[182,167] width:64 height:16 range:[0,200,100] type:#integer scale:1 align:#left
		label 'Spreadlbl3' "Spread..........................." pos:[29,193] width:147 height:20 align:#left
		spinner 'Spreadspn' "" pos:[182,194] width:64 height:16 range:[0,20,0.75] scale:1 align:#left
		label 'Max distancelbl4' "Max distance...................." pos:[30,220] width:147 height:20 align:#left
		spinner 'Maxdistancespn' "" pos:[182,221] width:64 height:16 range:[0,1000,100] scale:0 align:#left
		
		
		groupBox 'AOButton' "" pos:[10,252] width:257 height:50 align:#left
		button 'BakingAO' "烘焙" pos:[55,270] width:174 height:24 align:#left
		
		
		on MapSize128 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 128
		)
		on MapSize256 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 256
		)
		on MapSize512 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 512
		)
		on MapSize768 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 768
		)
		on MapSize1024 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 1024
		)
		on MapSize2048 pressed  do
		(
			BakingAOTools.MapSizeSpn.value = 2048
		)
		
		---------渲染设置（mental_ray_renderer）
		fn mentalrayRenterSet = 
		(	
			---macros.run "Render" "BakeDialog"
			try renderers.current = mental_ray_renderer () catch()
			try macros.run "Render" "RenderButtonMenu_Switch_To_Production_Mode" catch()
			try renderers.current.UnifiedEnable = false catch()
			try renderers.current.FinalGatherEnable2  = false catch()
			--try 
			--(
			--	if renderers.current.UnifiedEnable == true  
			--	then
			--	(
					try renderers.current.Minimum = 16 catch()
					try renderers.current.Maximum  = 256 catch()
			--	)
			--)	
			--catch()
			
		)
		
		---Render To texture设置
		fn RenderToTextureSet obj size= 
		(
			--清除所有渲染元素
			obj.iNodeBakeProperties.removeAllBakeElements() 
			--烘焙模型的准备:
			bakeSet = CompleteMap() --bake元素类的实例
			bakeSet.outputSzX = bakeSet.outputSzY = size 
			bakeSet.ElementName = "_AO"
			bakeSet.fileType = ".png"  ----文件类型
			bakeSet.fileName = maxfilepath +obj.name --贴图路径
			bakeSet.filterOn = true --enable filtering
			bakeSet.shadowsOn = true --disable shadows
			bakeSet.enabled = true --enable baking
	
			obj.INodeBakeProperties.addBakeElement bakeSet --add first element
			obj.INodeBakeProperties.bakeEnabled = true --enabling baking
			obj.INodeBakeProperties.bakeChannel = BakingAOTools.ChannelSpinner.value     --channel to bake
			obj.INodeBakeProperties.nDilations = BakingAOTools.PaddingSpinner.value     --expand the texturea bit
			
		)
		---AO材质设置
		fn AOmaterial obj = 
		(
			bakedMat = Standardmaterial()
			bakedMat.Ambient = color 255 255 255
			bakedMat.Diffuse = color 255 255 255
			bakedMat.diffuseMap  = Ambient_Reflective_Occlusion__3dsmax()
			bakedMat.selfIllumAmount = 100
			bakedMat.diffuseMap.Samples = BakingAOTools.Samplesspn.value  
			bakedMat.diffuseMap.spread = BakingAOTools.Spreadspn.value
			bakedMat.diffuseMap.max_distance = BakingAOTools.Maxdistancespn.value
			obj.material = bakedMat
		)
				
		on BakingAO pressed  do
		(	
			--materialsSet()
			mentalrayRenterSet()

			if selection.count > 0 do
			(	
				global theObject = selection
				for i in 1 to theObject.count do
				(
					RenderToTextureSet theObject[i] BakingAOTools.MapSizeSpn.value
					AOmaterial theObject[i]
				)
				
			)

			backgroundColor = color 255 255 255
			ambientColor = color 255 255 255
			macros.run "Render" "BakeDialog"
		)
	
	)
	on BakingAOB changed state do
	(
		try
			Destroyfilter()
		catch()
		if BakingAOB.checked == true then
		(
			BakingAOToolson()
		)
		else
		(
			BakingAOToolsoff()
		)
	)
	
	on BakingAOB rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog BakingAOTools pos:mouse.screenpos
	)
	
)

--################################################################################################################################################################################################END--
addrollout ReleaseNotes MR
addrollout InformationTools MR
addrollout ModelTools MR

