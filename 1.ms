rollout ModleCheckTools "ģ�ͼ�鹤��" width:541 height:575
(
	groupBox 'ModelCheck' "ģ�ͼ��" pos:[14,44] width:232 height:138 align:#left
	groupBox 'ModelToDeal' "ģ�ʹ���" pos:[14,189] width:233 height:193 align:#left
	groupBox 'grp12' "��Ϣ����" pos:[264,44] width:266 height:306 align:#left
	groupBox 'Displacement' "����λ��" pos:[265,493] width:266 height:63 align:#left
	groupBox 'grp17' "ģ��˳������" pos:[13,389] width:235 height:72 align:#left
	groupBox 'grp18' "���������޸�" pos:[264,363] width:266 height:117 align:#left
	groupBox 'ModleExport' "ģ�͵���" pos:[14,470] width:235 height:86 align:#left
	button 'RemoveIsolatedVertices' "�Ƴ����ඥ��" pos:[46,210] width:93 height:24 align:#left
	button 'CondenseMaterial' "ȥ��δ���ò�����" pos:[44,333] width:112 height:24 align:#left
	button 'VertexWeld' "���㺸��" pos:[46,271] width:93 height:24 align:#left
	button 'ResetXfrom' "Xfrom" pos:[45,302] width:93 height:24 align:#left
	button 'AutomaticSmoothingUnit' "�Զ��⻬��" pos:[46,240] width:93 height:24 align:#left
	button 'FacesOrientation' "�淽����" pos:[134,121] width:98 height:24 align:#left
	button 'ModifyPivotZero' "���Ĺ���" pos:[271,413] width:113 height:24 align:#left
	button 'ModifyPivotZ' "����Z������λ��" pos:[271,449] width:113 height:24 align:#left
	button 'ModifyPivotZRotation' "��Z����ת90��" pos:[397,448] width:121 height:24 align:#left
	button 'ModifyPivotCenter' "�������õ���������" pos:[397,413] width:121 height:24 align:#left
	button 'RenameButton' "����" pos:[21,417] width:41 height:24 align:#left
	button 'MoveOrigin' "λ�Ƶ����" pos:[271,517] width:85 height:24 align:#left
	button 'MoveZzzOrigin' "λ�Ƶ�Z���·�" pos:[369,517] width:113 height:24 align:#left
	button 'ModleExportFBX' "����FBX" pos:[53,497] width:154 height:44 align:#left
	button 'OverlaooingVertices' "�ص�����" pos:[22,64] width:98 height:24 align:#left
	button 'OverlaooingFaces' "�ص�����" pos:[134,64] width:98 height:24 align:#left
	button 'IsolatedVertices' "��������" pos:[21,91] width:98 height:24 align:#left
	button 'MultipleEdges' "�����߼��" pos:[134,91] width:98 height:24 align:#left
	button 'ClearInformation' "�����Ϣ" pos:[424,60] width:96 height:24 toolTip:"" align:#left
	checkbox 'chk12' "Checkbox" pos:[26,216] width:14 height:10 align:#left
	checkbox 'chk13' "Checkbox" pos:[26,246] width:14 height:10 align:#left
	checkbox 'chk14' "Checkbox" pos:[26,277] width:14 height:10 align:#left
	checkbox 'chk15' "Checkbox" pos:[26,307] width:14 height:10 align:#left
	editText 'Modle_nametext' "" pos:[65,410] width:169 height:40 align:#left
	label 'lbl1' "ģ���������̹��ߣ��������������ϵX_F" pos:[19,10] width:259 height:20 align:#left
	checkButton 'BackfaceCull' "��/�ر�����ʾ" pos:[22,121] width:98 height:24 align:#left
	listBox 'Information' "����ѡ��ģ��" pos:[277,84] width:244 height:16 selection:1 align:#left
	checkButton 'ModifyPivot' "�����޸�" pos:[336,384] width:113 height:24 align:#left
	spinner 'WeldValue' "" pos:[145,275] width:70 height:16 range:[0,100,0.01] scale:0.01 align:#left
	button 'BatchProcessing' "һ��������" pos:[160,226] width:77 height:24 align:#left
	on RemoveIsolatedVertices pressed  do
(
		if selection.count > 0 do
		(
		try 
		(
		   
		   for i in selection do i.EditablePoly.deleteIsoVerts ()
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="ȥ������ɹ�" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
		   
		) 
		catch
		(
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="ȥ������-\û�гɹ�,�����в��ɱ༭������" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
		)
		)
	)
	on CondenseMaterial pressed  do
(
		MatEditor.Open()
		macros.run "Medit Tools" "condense_medit_slots"
		tempitm =  ModleCheckTools.Information.items
		SomeError ="�Ѿ��������" 
		 Newitm = append tempitm SomeError 
		  ModleCheckTools.Information.items = Newitm
	)
	on VertexWeld pressed  do
	for i in selection do
	(
	    try
		(
	        i.weldThreshold = ModleCheckTools.WeldValue.value
		    polyOp.weldVertsByThreshold i #{1..(i.GetNumVertices())};
	
	        tempitm = ModleCheckTools.Information.items
	        SomeError ="���Ӷ���ɹ�" 
	        Newitm = append tempitm SomeError 
	        ModleCheckTools.Information.items= Newitm
	
		)
		catch 
		(
			select i
			tempitm =  ModleCheckTools.Information.items
	         SomeError =i.name+"���Ӷ���û�гɹ�" 
	           Newitm = append tempitm SomeError 
	           ModleCheckTools.Information.items = Newitm
		)
	)
	on ResetXfrom pressed  do
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
	   SomeError ="xform�ɹ�" 
	    Newitm = append tempitm SomeError 
	    ModleCheckTools.Information.items = Newitm
	)		
	catch
	(
	    tempitm =  ModleCheckTools.Information.items
	    SomeError ="xformû�гɹ�" 
	    Newitm = append tempitm SomeError 
	     ModleCheckTools.Information.items = Newitm
	)
	)
	on AutomaticSmoothingUnit pressed  do
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
	        SomeError ="�Զ��ɹ�" 
	          Newitm = append tempitm SomeError 
	          ModleCheckTools.Information.items = Newitm
		)
		catch
		(
		    tempitm = ModleCheckTools.Information.items
	        SomeError =i.name+"�Զ��⻬=\û�гɹ�" 
	          Newitm = append tempitm SomeError 
	          ModleCheckTools.Information.items = Newitm
		 )
	)
	on FacesOrientation pressed  do
(
		macros.run "xView" "xView_Face_Orientation_Checker"
		tempitm = ModleCheckTools.Information.items
		SomeError ="�淽����" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items= Newitm
	)
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
	SomeError ="���Ĺ���" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
	on ModifyPivotZ pressed  do
	with undo on
	(
		for i in selection do
		(
	
			i.pivot.z = i.min.z
	
		 )
	tempitm = ModleCheckTools.Information.items
	SomeError ="����Z������λ��" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
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
	SomeError ="��Z����ת90��" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
	on ModifyPivotCenter pressed  do
	with undo on
	(
		for i in selection do
		(
			
			CenterPivot i		
		)
	tempitm = ModleCheckTools.Information.items
	SomeError ="������������" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items= Newitm
	)
	on RenameButton pressed  do
(
		for i in selection do
		(
			i.name = uniquename Modle_nametext.text
			ModleCheckTools.Information.items = #("���������") 
		)
	)
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
	on MoveZzzOrigin pressed  do
	with undo on
	(
		for i in selection do
		(
			i.pos.z = 0
		 )
	)
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
	SomeError ="�������" 
	Newitm = append tempitm SomeError 
	ModleCheckTools.Information.items = Newitm
	)
	on OverlaooingVertices pressed  do
(
		macros.run "xView" "xView_Overlapping_Vertices_Checker"
		tempitm =  ModleCheckTools.Information.items
		SomeError ="�ص�����" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
	on OverlaooingFaces pressed  do
(
		macros.run "xView" "xView_Overlapping_Faces_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="�ص�����" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
	on IsolatedVertices pressed  do
(
		macros.run "xView" "xView_Isolated_Vertex_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="��������" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
	on MultipleEdges pressed  do
(
		macros.run "xView" "xView_Multiple_Edges_Checker"
		
		tempitm =  ModleCheckTools.Information.items
		SomeError ="�����߼��" 
		Newitm = append tempitm SomeError 
		ModleCheckTools.Information.items = Newitm
	)
	on ClearInformation pressed  do
		ModleCheckTools.Information.items = #("")
	on BackfaceCull changed state do
(
		for i in geometry do
		(
			if state then i.backfacecull = on
		   	else i.backfacecull = off	
		)
	)
	on ModifyPivot changed state do
(
		if maxops.pivotmode != #pivotonly
		then maxops.pivotmode = #pivotonly
		else maxops.pivotmode = #none
	)
	on BatchProcessing pressed  do
(
		if selection.count > 0 do
		(
		try 
		(
		   
		   for i in selection do i.EditablePoly.deleteIsoVerts ()
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="ȥ������ɹ�" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
		   
		) 
		catch
		(
		   tempitm = ModleCheckTools.Information.items
		   SomeError ="ȥ������-\û�гɹ�,�����в��ɱ༭������" 
		    Newitm = append tempitm SomeError 
		    ModleCheckTools.Information.items= Newitm
		)
		)
	)
)