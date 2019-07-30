
rollout ModleCheckTools "模型检查工具2.0" width:541 height:575
(
	groupBox 'ModelCheck' "模型检查" pos:[14,44] width:232 height:138 align:#left
	groupBox 'ModelToDeal' "模型处理" pos:[14,189] width:233 height:193 align:#left
	groupBox 'grp12' "信息反馈" pos:[264,44] width:266 height:306 align:#left
	groupBox 'Displacement' "物体位移" pos:[265,493] width:266 height:63 align:#left
	groupBox 'grp17' "模型顺序命名" pos:[13,389] width:235 height:72 align:#left
	groupBox 'grp18' "物体轴心修改" pos:[264,363] width:266 height:117 align:#left
	groupBox 'ModleExport' "模型导出" pos:[14,470] width:235 height:86 align:#left
	button 'RemoveIsolatedVertices' "移除多余顶点" pos:[46,210] width:93 height:24 align:#left
	button 'CondenseMaterial' "去除未调用材质球" pos:[44,322] width:112 height:24 align:#left
	button 'VertexWeld' "顶点焊接" pos:[46,265] width:93 height:24 align:#left
	button 'ResetXfrom' "Xfrom" pos:[45,293] width:93 height:24 align:#left
	button 'AutomaticSmoothingUnit' "自动光滑组" pos:[45,237] width:93 height:24 align:#left
	button 'FacesOrientation' "面方向检查" pos:[134,121] width:98 height:24 align:#left
	button 'ModifyPivotZero' "轴心归零" pos:[271,413] width:113 height:24 align:#left
	button 'ModifyPivotZ' "轴心Z轴归最低位置" pos:[271,449] width:113 height:24 align:#left
	button 'ModifyPivotZRotation' "沿Z轴旋转90度" pos:[397,448] width:121 height:24 align:#left
	button 'ModifyPivotCenter' "轴心重置到物体中心" pos:[397,413] width:121 height:24 align:#left
	button 'RenameButton' "命名" pos:[21,417] width:41 height:24 align:#left
	button 'MoveOrigin' "位移到零点" pos:[271,517] width:85 height:24 align:#left
	button 'MoveZzzOrigin' "位移到Z轴下方" pos:[369,517] width:113 height:24 align:#left
	button 'ModleExportFBX' "导出FBX" pos:[53,497] width:154 height:44 align:#left
	button 'OverlaooingVertices' "重叠点检查" pos:[22,64] width:98 height:24 align:#left
	button 'OverlaooingFaces' "重叠面检查" pos:[134,64] width:98 height:24 align:#left
	button 'IsolatedVertices' "孤立点检查" pos:[21,91] width:98 height:24 align:#left
	button 'MultipleEdges' "多重线检查" pos:[134,91] width:98 height:24 align:#left
	button 'ClearInformation' "清除信息" pos:[424,60] width:96 height:24 toolTip:"" align:#left
	button 'BatchProcessing' "一键批处理" pos:[160,226] width:77 height:24 align:#left
	checkbox 'chkRemove' "Checkbox" pos:[26,216] width:14 height:10 align:#left
	checkbox 'chkAuto' "Checkbox" pos:[26,243] width:14 height:10 align:#left
	checkbox 'chkVertexWeld' "Checkbox" pos:[26,272] width:14 height:10 align:#left
	checkbox 'chkXfrom' "Checkbox" pos:[26,300] width:14 height:10 align:#left
	editText 'Modle_nametext' "" pos:[65,410] width:169 height:40 align:#left
	label 'lbl1' "模型制作流程工具，有问题跟需求联系X_F" pos:[19,10] width:259 height:20 align:#left
	checkButton 'BackfaceCull' "开/关背面显示" pos:[22,121] width:98 height:24 align:#left
	listBox 'Information' "单击选择模型" pos:[277,84] width:244 height:16 selection:1 align:#left
	checkButton 'ModifyPivot' "轴心修改" pos:[336,384] width:113 height:24 align:#left
	spinner 'WeldValue' "" pos:[145,269] width:70 height:16 range:[0,100,0.01] scale:0.01 align:#left
	button 'OpenEdgesC' "开放线检查" pos:[134,149] width:98 height:24 align:#left
	button 'FiveFaceC' "五边面检查" pos:[22,150] width:98 height:24 align:#left
	button 'DelPV' "删ParticleView" pos:[45,351] width:93 height:24 align:#left



	
-----------------------移除多余顶点--------------------------------------------------------		
	fn RemoveIV =
(
	if selection.count > 0 do
		(
		try 
		(
		   
		   for i in selection do i.EditablePoly.deleteIsoVerts ()
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="去除顶点成功" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
		   
		) 
		catch
		(
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="去除顶点-\没有成功,可能有不可编辑的物体" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
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
				i.weldThreshold = ModleCheckTools.WeldValue.value
				polyOp.weldVertsByThreshold i #{1..(i.GetNumVertices())};
		
				tempitm = ModleCheckTools.Information.items
				SomeError ="焊接顶点成功" 
				Newitm = append tempitm SomeError 
				ModleCheckTools.Information.items= Newitm
		
			)
			catch 
			(
				select i
				tempitm =  ModleCheckTools.Information.items
				 SomeError =i.name+"焊接顶点没有成功" 
				   Newitm = append tempitm SomeError 
				   ModleCheckTools.Information.items = Newitm
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
	
		   tempitm = ModleCheckTools.Information.items
	        SomeError ="自动成功" 
	          Newitm = append tempitm SomeError 
	          ModleCheckTools.Information.items = Newitm
		)
		catch
		(
		    tempitm = ModleCheckTools.Information.items
	        SomeError =i.name+"自动光滑=\没有成功" 
	          Newitm = append tempitm SomeError 
	          ModleCheckTools.Information.items = Newitm
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
	   tempitm =  ModleCheckTools.Information.items
	   SomeError ="xform成功" 
	    Newitm = append tempitm SomeError 
	    ModleCheckTools.Information.items = Newitm
	)		
	catch
	(
	    tempitm =  ModleCheckTools.Information.items
	    SomeError ="xform没有成功" 
	    Newitm = append tempitm SomeError 
	     ModleCheckTools.Information.items = Newitm
	)
	)
)

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
			tempitm =  ModleCheckTools.Information.items
			SomeError ="有五边面" 
			Newitm = append tempitm SomeError 
			ModleCheckTools.Information.items = Newitm			
		)
		else
		(
			subobjectLevel = 0
			tempitm =  ModleCheckTools.Information.items
			SomeError ="无五边面" 
			Newitm = append tempitm SomeError 
			ModleCheckTools.Information.items = Newitm
		)
	)
	else
		messagebox "请选择单个物体"
		
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
		tempitm =  ModleCheckTools.Information.items
		SomeError ="已精简材质球" 
		 Newitm = append tempitm SomeError 
		  ModleCheckTools.Information.items = Newitm
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
	
---------------------面方向检查----------------------------------------------------------		
	on FacesOrientation pressed  do
(
		macros.run "xView" "xView_Face_Orientation_Checker"
		tempitm = ModleCheckTools.Information.items
		SomeError ="面方向检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items= Newitm
	)
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
	tempitm = ModleCheckTools.Information.items
	SomeError ="轴心归零" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
---------------------轴心Z轴归最低位置----------------------------------------------------------		
	on ModifyPivotZ pressed  do
	with undo on
	(
		for i in selection do
		(
	
			i.pivot.z = i.min.z
	
		 )
	tempitm = ModleCheckTools.Information.items
	SomeError ="轴心Z轴归最低位置" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
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
	
	tempitm = ModleCheckTools.Information.items
	SomeError ="沿Z轴旋转90度" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
--------------------轴心重置到物体中心-----------------------------------------------------------		
	on ModifyPivotCenter pressed  do
	with undo on
	(
		for i in selection do
		(
			
			CenterPivot i		
		)
	tempitm = ModleCheckTools.Information.items
	SomeError ="轴心重置中心" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
--------------------命名-----------------------------------------------------------		
	on RenameButton pressed  do
(
		for i in selection do
		(
			i.name = uniquename Modle_nametext.text
			ModleCheckTools.Information.items = #("重命名完成") 
		)
	)
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
	
	tempitm =  ModleCheckTools.Information.items
	SomeError ="导出完成" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items = Newitm
	)
---------------------重叠点检查----------------------------------------------------------		
	on OverlaooingVertices pressed  do
(
		macros.run "xView" "xView_Overlapping_Vertices_Checker"
		tempitm =  ModleCheckTools.Information.items
		SomeError ="重叠点检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
---------------------重叠面检查----------------------------------------------------------		
	on OverlaooingFaces pressed  do
(
		macros.run "xView" "xView_Overlapping_Faces_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="重叠面检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
---------------------孤立点检查----------------------------------------------------------		
	on IsolatedVertices pressed  do
(
		macros.run "xView" "xView_Isolated_Vertex_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="孤立点检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
-----------------------多重线检查--------------------------------------------------------		
	on MultipleEdges pressed  do
(
		macros.run "xView" "xView_Multiple_Edges_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="多重线检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
	
-----------------------开放边检查--------------------------------------------------------	
on OpenEdgesC pressed  do
(
		macros.run "xView" "xView_Open_Edges_Checker"
		tempitm =  ModleCheckTools.Information.items
		SomeError ="开放边检查" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
		
)
		
-----------------------清除信息--------------------------------------------------------		
	on ClearInformation pressed  do
		ModleCheckTools.Information.items = #("")
-----------------------开/关背面显示--------------------------------------------------------			
	on BackfaceCull changed state do
(
		for i in geometry do
		(
			if state then i.backfacecull = on
		   	else i.backfacecull = off	
		)
	)
-----------------------轴心归零--------------------------------------------------------		
	on ModifyPivot changed state do
(
		if maxops.pivotmode != #pivotonly
		then maxops.pivotmode = #pivotonly
		else maxops.pivotmode = #none
	)
	
-----------------------删除ParticleView--------------------------------------------------------		
	on DelPV pressed do
(
	delete $'particle view*' 
)	
)
createdialog ModleCheckTools